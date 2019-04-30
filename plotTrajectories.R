# This code was written by Gianmarc Grazioli, Ph.D. 
# 30APR2019

plotTrajectories<-function(trajDF, fresh=TRUE){
  xmin=min(trajDF$x)
  xmax=max(trajDF$x)
  vmin=min(trajDF$vel)
  vmax=max(trajDF$vel)
  p1color<-rgb(.9,.3,0)
  p2color<-rgb(0,.3,.9)
  if(trajDF[trajDF$trajID==1,][1,"stateFinal"]=="P1"){
    myColor<-p1color
  }else myColor<-p2color
  if(fresh) plot(trajDF[trajDF$trajID==1,2:3], type = 'l', col=myColor, xlim = c(xmin,xmax), ylim = c(vmin, vmax))
  idVec<-unique(trajDF$trajID)
  for (i in 1:length(idVec)) {
    if(trajDF[trajDF$trajID==idVec[i],][1,"stateFinal"]=="P1"){
      myColor<-p1color
    }else myColor<-p2color
    lines(trajDF[trajDF$trajID==idVec[i],2:3], col=myColor)
  }
}