# Subproblem Solutions in Cubic Regularisation Methods
 This repository provides some code I used in my master's dissertation at Oxford, which, in short, can be described as follows:
 
"This dissertation is set in the ﬁeld of smooth, unconstrained and nonconvex optimisation. Motivated by the needs and requirements of applications such as neural network training, we explore cubic regularisation as a means of incorporating curvature information into ﬁrst-order methods in an eﬃcient, Hessian-free manner, with the ultimate goal of accelerating convergence of these algorithms to approximate local minima of an objective function. Our focus lies on the Adaptive Regularisation Algorithm using Cubics (ARC), and in particular on its subroutine GLRT, which is an iterative, Lanczos-type algorithm. GLRT solves the cubic subproblem, which consists of minimising a quadratic approximation to the objective function, regularised by a cubic power of the step length. The cubic subproblem appears in every cubic regularisation-type algorithm and accounts for the largest part of the computational eﬀort of such algorithms. In this dissertation, we reﬁne the current complexity bound for GLRT, we introduce an accelerated version of GLRT, and we compare both methods numerically to another recent proposal for solving the cubic subproblem fast and eﬃciently, which employs a perturbed version of gradient descent. We show that GLRT exhibits superior performance to perturbed gradient descent on the cubic subproblem in terms of both iterations and computational time, and that our accelerated version further improves upon this performance."

If you are interested in the full document then please do not hesitate to contact me via E-Mail: marius.lange@t-online.de

The MATLAB implementation provided here, considers the subproblem which is typicially encountered in a Cubic Regularisation-type algortihm. It contains MATLAB functions to create, solve and visualise the cubic subproblem (CSP). The main functions are:

## Create_Problem.m
Creates a CSP of given dimension and condition number. More options are possible, such as positive definiteness, hard-case, etc.

## SubproblemPlot.m
Plots the contours of a given two-dimensional CSP. Optionally, the exact solution can be plotted, as well as the iterates produced by some method and the eigenvectors of the Hessian B.

## Solve_Exactly.m
Calls the function Check_Hard.m to check whether the given CSP is a hard-case. If the latter doesn not hold, then the same function solves the CSP. Otherwise, the function Solve_Hard is evoked. 

## norm_s_plot.m and phi1_plot.m
Plot the norm of the solution s as a function of the multiplier lambda as well as the function phi1(lambda), respectively.






