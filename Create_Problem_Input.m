function [ Hard, Sigma, Definit, Epsilon, Print_Level, bNorm ] = Create_Problem_Input( options )
%Input handeling for the subproblem creater

% Hard Case
if isfield(options, 'Hard')
    Hard = options.Hard;
else
    Hard = 0;
end

%Regularisation
if isfield(options, 'Sigma')
    Sigma = options.Sigma;
else
    Sigma = 1;
end

% Definitness
if isfield(options, 'Definit')
    Definit = options.Definit;
else
    Definit = 'id';
end

% Epsilon
if isfield(options, 'Epsilon')
    Epsilon = options.Epsilon;
else
    Epsilon = 1e-6;
end

% Print level
if isfield(options, 'Print_Level')
    Print_Level = options.Print_Level;
else
    Print_Level = 1;
end

% Gradient Norm
if isfield(options, 'bNorm')
    bNorm = options.bNorm;
else
    bNorm = n * 0.5;
end

end

