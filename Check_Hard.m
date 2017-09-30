function [ h, lambda, s ] = Check_Hard( H, g, sigma, varargin )
%Function to check whether we are in the hard case
%
%Description -
% Basically, we need to figure out whether there is a root of phi_1 to the
% right of max(-lambda_1, 0). If so, then this is seeked value for lambda and we are in the normal case.
% If not, we set lambda = -lambda_1 and we are in the harde case.
%
%Input -
% H: Symmetric Hessian Matrix
% g: Gradient vector
% sigma: Regularisation parameter
%
%Optional input -
% print_level: 0 minimum output, 1 maximum output
%
%Output:
% h: 0 corresponds to no hard case, 1 coresponds to hard case
% lambda: scalar to be used when computing s. Either the rightmost root of
% phi_1 (normal case), or the absolute value of the leftmost eigenvalue of
% H

%% Parameters

switch nargin
    case 3
        print_level = 0;
    case 4
        print_level = varargin{1};
end

% Check the input
g = g(:);

%% Add Folders

addpath('ARC Subproblem');

if print_level == 1
    disp('----------Check for hard case--------------');
end

%% Create function handle

% Get function handle
[psi, xMin, xMax, evals, n] = GetPsi(H, g);

% Compose the desired function
phi1 = @(x) 1./sqrt(psi(x)) - sigma./x;

%% Check positive definiteness

if min(evals) >= 0
   % Matrix is positive semi definite, cannot be a hard case
   h = 0;
else
   h = 1;
end

%% Find starting guess

% Find the boundary of our domain of interest
lambda_S = max([0; -evals]);

% Initialise
delta = 0.1;

while phi1(lambda_S + delta) >= 0
    
    % Decrese delta
    delta = 0.1 * delta;
    
    % Check size of delta
    if delta < sqrt(eps)
        if h == 0
            fpintf('Error in Check_Hard: I found a hard case in a psd problem. \n');
        end
        s = 0;
        h = 1;
        lambda = lambda_S;
        if print_level == 1
            fprintf('Check_Hard: Hard case found. Returned lambda. \n');
        end
        return
    end
end

% No hard case, we can safely use this as a starting guess
h = 0;
lambda_0 = lambda_S + delta;

%% Newton iteration

% We know at this point that we are not in the hard case, so we can safely
% run a Newton iteration:
epsilon = 1e-8; IterMax = 5*n;
[ s, lambda, ~ ] = ARC_Newton(H, g, sigma, lambda_0, epsilon, IterMax, print_level);

%% Give out some information

if print_level == 1
    fprintf('Ceck_Hard: No hard case found. Solution for s and lambda found. \n');
end

end

