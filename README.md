# Cubic Regularisation - Subproblem

This MATLAB implementation, originally written for my master's dissertation, considers the subproblem which is typicially encountered in a Cubic Regularisation-type algortihm. It contains MATLAB functions to create, solve and visualise the cubic subproblem (CSP). The main functions are:

Create_Problem.m
Creates a CSP of given dimension and condition number. More options are possible, such as positive definiteness, hard-case, etc.

SubproblemPlot.m
Plots the contours of a given two-dimensional CSP. Optionally, the exact solution can be plotted, as well as the iterates produced by some method and the eigenvectors of the Hessian B.

Solve_Exactly.m
Calls the function Check_Hard.m to check whether the given CSP is a hard-case. If the latter doesn not hold, then the same function solves the CSP. Otherwise, the function Solve_Hard is evoked. 

norm_s_plot.m and phi1_plot.m
Plots the norm of the solution $s$ as a function of the multiplier 




