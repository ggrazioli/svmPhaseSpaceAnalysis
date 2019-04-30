# This code was written by Gianmarc Grazioli, Ph.D. 
# 30APR2019

getProductStateOneTraj<-function(dfIN, trajIDin, p1=-1, p2=1){
  mySubset<-dfIN[dfIN$trajID==trajIDin,]
  finalPoint<-mySubset[which.max(mySubset$t),]$x
  p1Check<-(finalPoint - p1)^2
  p2Check<-(finalPoint - p2)^2
  if(p1Check <= p2Check) {
    finalState<-"P1"
  }else finalState<-"P2"
  rep(finalState, nrow(mySubset))
}
  
getProductStates<-function(dfIN, p1=-1, p2=1){
  trajIDvec<-unique(dfIN$trajID)
  stateVec<-vector()
  for (i in 1:length(trajIDvec)) {
    myStates<-getProductStateOneTraj(dfIN, trajIDvec[i])
    stateVec<-c(stateVec, myStates)
  }
  myNames<-c(names(dfIN), "stateFinal")
  out<-cbind(dfIN, stateVec)
  names(out)<-myNames
  out
}
