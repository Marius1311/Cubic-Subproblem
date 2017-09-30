function [ s ] = Solve_Hard2( B, g, sigma, varargin )
%Solves the cubic subproblem in the hard case. Alternative approach.
%This is the recommended way to solve the hard case, it is numerically much
%more stable than the alternative. This function is designed for the case
%of a 1D eigenspace E_1.
%
%   Uses an eigendecomposition of B and explicit expressions for the
%   coefficients of vector y in thsi cases, to guarantee orthogonality of y
%   with v_1, and additionally to guarantee that y solves the system. As in
%   teh other hard case solver, it also sets s = y + alpha v_1
% 
%   Input -
%   B: Hessian matrix
%   g: Gradient vector
%   sigma: Regularisation parameter
%   lambda: Must equal -lambda_1
% 
%   Output -
%   s: A Matrix whose columns are the two hard case solutions

%% Check input

switch nargin
    case 3
        print_level = 0;
    case 4
        print_level = varargin{1};
end

% Check the input is a column vector
g = g(:);

%% Initialise

if print_level == 1
    disp('----------Solve hard case--------------' );
end

% Determine the size
[n, ~] = size(B);

% We start with an eigendecomposition
[V, D] = eig(B);

%% Calculate y

% Project g on the eigenbasis of B
g_V = V'*g;

% Construct a vector for the demoninator
e_vals = diag(D);
e_vals_shifted = e_vals - e_vals(1);

% Construct a vector of betas
betas = -g_V(2:end) ./ e_vals_shifted(2:end);

% This gives y
y = V(:, 2:end)*betas;
 
%% Calculate the residual
 r = norm( (B - e_vals(1)*eye(n))*y + g );
 if print_level == 1
 if r > 1e-4
     fprintf('Solve_Hard: Warning, solved matrix system quite badly. Residual ||r|| =  %1.4e. \n ', r);
 end
 end
 
%% Check orthogonality
 ort = norm(y'*V(:, 1));
 if print_level == 1
     if ort > 1e-4
         fprintf('Solve_Hard: Warning, orthogonality condition violated. It holds ||u^T*v1|| = %1.4e. \n', ort);
     end
 end
 
%% Calculate alpha and s

% Calculate alpha
alpha = sqrt( e_vals(1)^2/sigma^2 - norm(y)^2  );

% Compose the solution
s = zeros(n, 2);
s(:, 1) = y + alpha*V(:, 1);
s(:, 2) = y - alpha*V(:, 1);

%% Give feedback
 
if print_level == 1
    fprintf('Solve_hard: Sucess! Solved the hard case exactly. \n');
end


end

