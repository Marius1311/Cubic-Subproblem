function [ p, r, Type, N, Save_Figure, Filename, Plot_Legend, Plot_Vectors, Plot_Iterates, Iterates, Plot_Solution, Solution ] = SubproblemPlot_Input( options )
%Processes the input options for the function SubproblemPlot

% Range
if isfield(options, 'Range')
    p = options.Range;
else
    p = [-10, 10, -10, 10];
end


% Resolution
if isfield(options, 'Resolution')
    r = options.Resolution;
else
    r = [50 50];
end

% Type
if isfield(options, 'Type')
    Type = options.Type;
else
    Type = 'c';
end

% Number of Lines
if isfield(options, 'Number_Lines')
    N = options.Number_Lines;
else
    N = 50;
end

% Filename
if isfield(options, 'Filename')
    Save_Figure = 1;
    Filename = {options(1).Filename, options(2).Filename};
else
    Save_Figure = 0;
    Filename = 0;
end

% Legend
if isfield(options, 'Legend')
    Plot_Legend = options.Legend;
else
    Plot_Legend = 0;
end

% Eigenvectors
if isfield(options, 'Eigenvectors')
    Plot_Vectors = options.Eigenvectors;
else
    Plot_Vectors = 0;
end

% Iterates
if isfield(options, 'Iterates')
    Plot_Iterates = 1;
    Iterates = options.Iterates;
else
    Plot_Iterates = 0;
    Iterates = 0;
end

% Solution
if isfield(options, 'Solution')
    Plot_Solution = 1;
    Solution = options.Solution;
else
    Plot_Solution = 0;
    Solution = 0;
end


end

