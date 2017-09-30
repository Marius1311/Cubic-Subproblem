function [ h, lambda, Exact_s, time_exact ] = Solve_Exactly( A, b, sigma, varargin )
%Solve the cubic subproblem exactly

%   Solve the cubic subproblem exactly using a full eigenvalue
%   decomposition. Takes care of the hard case as well. 
% 
%   Input - 
%   A: Hessian
%   b: Gradient
%   sigma: Regularisation
%   print_level: How much output? 0 minimum output, 1 maximum output
% 
%   Optional Input - 
%   Print_Level: (0) or (1). Standart is 0.
% 
%   Output - 
%   h: Hard case, 0 or 1
%   lambda: parameter
%   Exact_s: the exact solution
%   time_exact: The time it took to solve this
% 
%   Usage
%   Solve_Exactly(A, b, sigma)
%   Solve_Exactly(A, b, sigma, options)
%   ... where options is a struct with any of the above fields


%% Process the input

if nargin == 3
    print_level = 0;
else
    options = varargin{1};
    if isfield(options, 'Print_Level')
        print_level = options.Print_Level;
    end
end

%% Check for hard case and find the solution

% time everything
tic

% Check for the hard case. Solve in case there is nor hard case
[ h, lambda, Exact_s ] = Check_Hard( A, b, sigma, print_level );

if h == 1
    
    % Define a function. Shall accept row vectors as input
    m = @(s) s*b + 1/2*s*A*s' + 1/3*sigma*norm(s)^3;
    
    % We are in the hard case. We know lambda, however, we have to find
    % alpha and compose s.
    s = Solve_Hard2( A, b, sigma, print_level ); 
    
    % There will be two solutions. They have in theory the same value, in
    % practice, numerical errors might make a difference.
    [~, index] = min(evalF(m, s));
    Exact_s = s(:, index);
end

time_exact = toc;

end

