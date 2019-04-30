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