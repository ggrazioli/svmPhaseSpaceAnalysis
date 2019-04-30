# This code was written by Gianmarc Grazioli, Ph.D. 
# 30APR2019

# force function for 1D bistable potential
getForce<-function(p, dxcoef=c(1,0.5,0.75),dycoef=c(1,0.5,0.75),dxycoef=0.01, dyxcoef=-0.01,len=3e-2,arrow.col=1,...){
    dx<--2*(-1 + p[1])^2*(1 + p[1]) - 2*(-1 + p[1])*(1 + p[1])^2
    dx
}

makeVelset<-function(n, low, hi){
  output<-list()
  ctr=1
  stepSize<-(hi-low)/n
  for(i in seq(low, (hi-stepSize), stepSize)){
    output[[ctr]]<-i
    ctr<-ctr+1
  }
  output
}

runTrajectory<-function(velInit, steps=1000, pInit=.3, dt=.05, outFreq=1, damp=.5){
  #initialize things:
  traj<-data.frame(cbind(0, pInit, velInit))
  names(traj)<-c("t","x", "vel")
  vel<-velInit
  p<-pInit
  pOld<-p
  acc<-getForce(p)
  ctr<-1
  
  #run velocity Verlet:
  for(i in 1:(steps-1)){
    pNew<-pOld + vel*dt + .5*acc*dt*dt
    if((i %% outFreq)==0){
      traj<-rbind(traj, c(i, pNew, vel))
      ctr<-ctr+1
    }
    oldAcc<-acc
    acc<-getForce(pNew) - damp*vel
    vel<-vel + .5*(oldAcc + acc)*dt
    pOld<-pNew
  }
  traj
}

sampleTrajectories<-function(sCount, steps, pInit=.3, dt=.1, velMin=-3.5, velMax=3.5){
  velList<-makeVelset(sCount, velMin, velMax)
  output<-lapply(velList, runTrajectory, steps=steps, pInit=pInit, dt=dt)
  output<-do.call(rbind, output)
  trajIDs<-vector()
  for (i in 1:length(velList)) {
    trajIDs<-c(trajIDs, rep(i, steps))
  }
  outNames<-c(names(output),"trajID")
  output<-cbind(output, trajIDs)
  names(output)<-outNames
  output
}



