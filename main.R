# The purpose of this code is to demonstrate the utility of support vector machines (SVMs)
# in performing phase space analysis for molecular dynamics trajectories. For the sake of
# clarity, the analysis is demonstrated here on a heuristic 1D model, a bistable potential
# with dissipation (see first plot). A set of trajectories are run, all initiated from
# x = -1, with different initial "kicks" via assignment of initial velocities (in both
# postive and negative x directions). The trajectories in phase space (x, velocity) are then
# plotted with color indicating whether they end their trajectories as product "P1" (left well,
# orange) or "P2" (right well, blue). Next an SVM classifier is trained to predict the final
# product class from a given phase space point. Finally, and analysis of the support vectors
# themselves is used to identify the phase space points that serve as support vectors of 
# opposite class, which in turn bound the first transition state between rightward trajectories
# that are "destined" for reaction products P1 vs. P2.
#
# This code is being shared in support of a journal article entitled:
# "Predicting Reaction Products and Automating Reactive Trajectory Characterization 
# in Molecular Simulations with Support Vector Machines"
# written by Gianmarc Grazioli, Saswata Roy, and Carter T. Butts
# and published by the Journal of Chemical Information and Modeling 
#
# This code was written by Gianmarc Grazioli, Ph.D. 
# 30APR2019

library(e1071)
source("simulateTrajectories.R")
source("getProductStates.R")
source("plotTrajectories.R")
set.seed(11)

begin=proc.time()[[3]]

# Before we carry out the analysis, we'll plot the 1D potential:
myPotential<-function(x){matrix(c(x,(x-1)^2*(x+1)^2), ncol = 2)}
plot(myPotential(seq(from=-1.5, to=1.5, by=.05)), type = 'l', xlab = "x", ylab = "V(x)")

# First we create a trajectory in phase space:
trajCount<-50 #how many trajectories
stepCount<-500 #how many timesteps for each trajectory
myTrajectory<-sampleTrajectories(trajCount, stepCount, pInit =-1)
trajWithStates<-getProductStates(myTrajectory)

# Now we plot the trajectories colored by final product state:
plotTrajectories(trajWithStates)

# Take 80% of our data for training and leave out 20% as a test set:
trainRows<-sample(nrow(trajWithStates), round(.8*nrow(trajWithStates)))
testRows<-setdiff(1:nrow(trajWithStates), trainRows)
trainingSet<-trajWithStates[trainRows,]
testingSet<-trajWithStates[testRows,]

# Next, we train an SVM classifier to classify phase space points as belonging 
# to either a trajectory "destined" for a final product state of "P1" or "P2."
cat("Training SVM model...\n")
svmModel<-svm(stateFinal ~., data = trainingSet[,c(2,3,5)], kernel="radial", cost=25, scale = FALSE)

# Test the SVM model on the testing set:
testDF<-cbind(testingSet, predict(svmModel, testingSet))
names(testDF)<-c(names(testingSet), "predicted")
accTotal<-0
for (i in 1:nrow(testDF)) {
  if(testDF$stateFinal[i] == testDF$predicted[i]){
    accTotal <- accTotal + 1
  }
}
cat("Model accuracy =", accTotal/nrow(testDF)*100,"%\n")

# Plot the support vectors:
plotTrajectories(trajWithStates)
points(svmModel$SV, pch=19)

# Now suppose we want to search for the phase space trajectory that came nearest
# to the first "tipping point" in giving our system a "kick" in the positive x direction.
# In other words, of the trajectories we kicked to the right, which P1 trajectory came 
# closest to traversing over the barrier to become a P2? This of course is relevant to
# using support vectors to search for transition states in phase space; the rationale 
# being that, in principle, a pair of support vectors of opposite final product class 
# will bound the transition state. R data frames make it very convenient for us to find 
# such pairs of support vectors of opposite class, which we will extract and plot below:
suppVecDF<-trainingSet[svmModel$index,]
suppVecsNearTippingP1<-suppVecDF[(suppVecDF$x > -1.1 & suppVecDF$x < -.9 & suppVecDF$vel < 2 & suppVecDF$vel > 1 & suppVecDF$stateFinal=="P1"),]
suppVecsNearTippingP2<-suppVecDF[(suppVecDF$x > -1.1 & suppVecDF$x < -.9 & suppVecDF$vel < 2 & suppVecDF$vel > 1 & suppVecDF$stateFinal=="P2"),]
points(suppVecsNearTippingP1[c(2,3)], col=rgb(.9,.3,0, alpha = .75), pch=1, cex=1.5, lwd=2)
points(suppVecsNearTippingP2[c(2,3)], col=rgb(0,.3,.9, alpha = .75), pch=1, cex=1.5, lwd=2)

# Note that the support vectors of opposite class that bound the first transition state 
# describing kicks in the postive x direction are now circled with the appropriate color. 

end=proc.time()[[3]]
cat("runtime = ",(end-begin)/60," min\n")
