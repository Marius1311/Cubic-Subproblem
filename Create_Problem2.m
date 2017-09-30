function [ A, b, f0, Sigma, x0, Epsilon, kappa ] = Create_Problem2(n, kappa, varargin)
%Create_Problem creates a problem instance of the cubic Subproblem
%
%   Input -
%   n: required problem dimension
%   kappa: Condition number
%   
%   Optional -
%   Hard: 0 corresponds to normal case, 1 corresponds to hard case 
%   Sigma: regularisation parameter
%   Definit: Positive definite (pd), positive semi definite (psd) indefinite (id), negative
%       definite (nd) or negative semi definite (nsd)? Standart setting is id
%   Epsilon: output precision
%   Print_Level: Specifies how much is printed to the console
%   bNorm: Defines the norm of the gradient. Standart setting is 0.5*n
%
%   Output -
%   A: A symmetric hessian matrix
%   b: A vector
%   Sigma: regularisation parameter
%   x0: starting guess
%   n: problem dimension
%   f0: constant term in the cubic subproblem
%   m: function handle to the cubic subproblem
%   Epsilon: output precision
%
%   Usage -
%   [A, b] = Create_Problem(n, kappa);
%   [ A, b, f0, Sigma, x0, Epsilon, kappa ] = Create_Problem2(n, kappa,
%       options);
%   ... where options is a struct containing any of the above fields


%% Process the input
 
% Process user defined options, set standart values
if nargin == 2
    Hard = 0; Sigma = 1; Definit = 'id'; Epsilon = 1e-4; Print_Level = 1; bNorm = 0.5*n;
else
    options = varargin{1};
    [ Hard, Sigma, Definit, Epsilon, Print_Level, bNorm ] = Create_Problem_Input( options );
end

% Display stuff
if Print_Level == 1
    disp('--------------------------------------------');
    disp('--------------Define Problem----------------');
    disp('--------------------------------------------');
end

%% Check input parameters

if Hard == 1 && (strcmp(Definit, 'pd') || strcmp(Definit, 'psd'))
    fprintf('Error in Create_Problem: Cannot have a hard case with a pd or psd Hessian. Assume no hard case wanted (hard = 0). \n');
    Hard = 0;
end

%% Define a Hessian matrix A

% Create a range of eigenvalues
switch Definit
    case 'id'
        dMin = 0.1;
        dMax = kappa*dMin;
        dPos = dMin + (dMax-dMin).*rand(floor(n/2) - 1,1);
        dNeg = -(dMin + (dMax-dMin).*rand(ceil(n/2) - 1,1));
        dComplete = [-dMin; dMax; dPos; dNeg];
    case 'pd'
        dMin = 0.1;
        dMax = kappa*dMin;
        dPos = dMin + (dMax-dMin).*rand(n-2,1);
        dComplete = [dMin; dMax; dPos];
    case 'nd'
        dMin = 0.1;
        dMax = kappa*dMin;
        dNeg = -(dMin + abs((dMax-dMin)).*rand(n-2,1));
        dComplete = [-dMin; -dMax; dNeg];
    case 'psd'
        dMin = 0;
        dMax = kappa;
        dPos = dMin + (dMax-dMin).*rand(n-2,1);
        dComplete = [dMin; dMax; dPos];
        fprintf('Warning: This matrix will be singular, the condition number is therefore not defined. \n ');
    case 'nsd'
        dMin = 0;
        dMax = kappa;
        dNeg = -(dMin + (dMax-dMin).*rand(n-2,1));
        dComplete = [-dMin; -dMax; dNeg];
        fprintf('Warning: This matrix will be singular, the condition number is therefore not defined. \n ');
end

if n == 2 && strcmp(Definit, 'id')
    dMin = -1;
    dMax = 2;
    dComplete = [dMin; dMax;];
    kappa = abs(max(abs([dMax, dMin]))/min(abs([dMax, dMin])));
    fprintf('Warning: Ignored the condition number. \n ');
end

% Use those eigenvalues to create a real symmetric A with given condition
% number
D = diag(dComplete);
Q = orth(randn(n,n));
A = Q*D*Q';

% In order to avoid numerical errors
A = (A + A.')/2;

%% Define a gradient vector b
P = rand(n, 1);
[VA, ~] = eigs(A, 1, 'sa');

if Hard == 1
    % Create a hard case
    t = (P'*VA)/norm(VA)^2;
    b = P - t*VA;
else
    b = P;
end

% This is not quite correct as it also depends on the regularisation
if abs(b'*VA) <= 1e-14
    Hard = 1;
end

% Normalise b
b = b/norm(b)*bNorm;

%% Rest

% Constant term
f0 = 0;

% Define a starting guess
x0 = zeros(1, n);

%% Information
if Print_Level == 1
    fprintf('Created the following cubic subproblem: \n');
    fprintf('n \t \t \t cond \t \t \t hard_case \t Sigma \t \t f0 \t \t Epsilon \t \t Definiteness \n');
    fprintf('%1.2e \t %1.2e \t \t %1.2e \t %1.2e \t %1.2e \t %1.2e \t \t %s \n', n, kappa, Hard, Sigma, f0, Epsilon, Definit);
end
end

