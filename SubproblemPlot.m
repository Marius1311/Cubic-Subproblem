function [ ] = SubproblemPlot2( g, H, sigma, varargin)
%Plots the contours of the cubic subproblem
%
%   Input - 
%   g: Vector (gradient)
%   H: Matrix (Hessian)
%   sigma: Regularisation parameter
%
%   Input optional -
%   Range: Vector containing [xMin, xMax, yMin, yMax]
%   Resolution: Vector containing [xN, yN] 
%   Type: c(normal contour), t(3D contour) or f(filled contour)
%   Number_Lines: Number of contour levels
%   Filename: cell array consiting of {'path', 'filename'}. 
%   Legend: 0 (no legend) or 1 (legend)
%   Eigenvectors: 0 (no eigenvectors) or 1 (eigenvectors). v1 is blue, v2
%       is red and the grad in green
%   Iterates: A matrix containing the iterates row-wise
%   Solution: A vector containing the exact solution to be plotted. Can be
%       a matrix, in case we are in the hard case and two solutions exist.
%
%   Output -
%   A contour plot with the two eigenvectors. Blue is the first eigenvector,
%   red is the second, green is the gradient. Optionally, the function can
%   also plot the iterates.
%
%   Usage -
%   SubproblemPlot( g, H, sigma);
%   SubproblemPlot( g, H, sigma, options);
%   ... where options is a struct with the above fields.

%% Input 

% Make sure g is a column vector
g = g(:);

% Check Input
[n, ~] = size(H);
if n ~= 2
    fprintf('Error in SubproblemPlot: Faulty dimensions');
    return
end

% Process the user input
if nargin == 3
    p = [-10, 10, -10, 10]; r = [50 50]; Type = 'c'; N = 50; Save_Figure = 0; Plot_Legend = 0; Plot_Vectors = 0; Plot_Iterates = 0; Plot_Solution = 0;
else
    options = varargin{1};
    [ p, r, Type, N, Save_Figure, Filename, Plot_Legend, Plot_Vectors, Plot_Iterates, Iterates, Plot_Solution, Solution ] = SubproblemPlot_Input( options );
end
    
% Check the size of the solution
if Plot_Solution == 1
[sm, sn] = size(Solution);
if sm ~= 2
    fprintf('Error: Solution has faulty dimensions. \n');
   return;
end
end

%% Extract the range and resultion
xMin = p(1); xMax = p(2); yMin = p(3); yMax = p(4); 
xN = r(1); yN = r(2);

% Make sure the solution is on the plot
if Plot_Solution == 1
    if sn == 2
        sol1 = Solution(:, 1);
        sol2 = Solution(:, 2);
        s_x_min = min([sol1(1), sol2(1)]);
        s_x_max = max([sol1(1), sol2(1)]);
        s_y_min = min([sol1(2), sol2(2)]);
        s_y_max = max([sol1(2), sol2(2)]);
    else
        s_x_min = Solution(1);
        s_x_max = Solution(1);
        s_y_min = Solution(2);
        s_y_max = Solution(2);
    end
    
    if xMin >= s_x_min
        if s_x_min >= 0
            xMin = s_x_min *0.8;
        elseif s_x_min < 0
            xMin = s_x_min *1.2; 
        else
            xMin = s_x_min - 2;
        end
    end
    
    if xMax <= s_x_max
        xMax = s_x_max * 1.2;
    end
    
    if yMin >= s_y_min
        if s_y_min >= 0
            yMin = s_y_min *0.8;
        elseif s_y_min < 0
            yMin = s_y_min *1.2;
        else
            yMin = s_y_min - 2;
        end        
    end
    
    if yMax <= s_y_max
        yMax = s_y_max *1.2;
    end
    
end

% Make sure all the iterates are on the plot
if Plot_Iterates == 1
    l = min(Iterates(:, 1));
    r = max(Iterates(:, 1));
    o = max(Iterates(:, 2));
    u = min(Iterates(:, 2));
    
    if xMin >= l
        xMin = l - 2;
    end
    if xMax <= r
        xMax = r + 2;
    end
    if yMin >= u
        yMin = u - 2;
    end
    if yMax <= o
        yMax = o + 2;
    end
end

%% Prepare the Contours

% Define a function for the model
m = @(s) s*g + 1/2*s*H*s' + 1/3*sigma*norm(s)^3;

% Create a mesh
x = linspace(xMin, xMax, xN);
y = linspace(yMin, yMax, yN);
[X, Y] = meshgrid(x, y);

% Reshape it
P = reshape(X, [xN * yN, 1]);
Q = reshape(Y, [xN * yN, 1]);

% Evaluate the local model on the mesh and reshape
RawZ = evalF(m, [P'; Q']);
Z = reshape(RawZ', [yN, xN]);

% create a title
CubicTitle = sprintf('Contours of the cubic subproblem with sigma = %1.1f', sigma);

%% Make a contour Plot
figure('Name', CubicTitle, 'Position', [100, 100, 300, 240]);
switch Type
    case 'c'
        contour(X, Y, Z, N), xlabel('s_1'), ylabel('s_2'), zlabel('z');     
    case 't'
        contour3(X, Y, Z, N), xlabel('x'), ylabel('y'), zlabel('z');
    case 'f'
        contourf(X, Y, Z, N), xlabel('s_1'), ylabel('s_2'), zlabel('z');
    case 's'
        surf(X, Y, Z) , xlabel('x'), ylabel('y'), zlabel('z');
end

%% Plot the two eigenvectors in there

if Plot_Vectors == 1
    
% Define a plotting function    
drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );   

hold on;

% Define the length
l = min(abs([xMax, xMin, yMax, yMin]) ) *0.9; 

% Get teh eigenvectors
[U, ~] = eigs(H);

% Plot the first eigenvector in blue
x1 = [0 U(1, 1)] * l; % start and end point in the x direction
y1 = [0 U(2, 1)] * l; % start and end point in the y direction   
drawArrow(x1,y1,'linewidth',2,'color','b')

% Plot the second eigenvector in red
x2 = [0 U(1, 2)] * l; % start and end point in the x direction
y2 = [0 U(2, 2)] * l; % start and end point in the y direction   
drawArrow(x2,y2,'linewidth',2,'color','r')

% Plot the gradient in green
x3 = [0 g(1)/norm(g)] * l; % start and end point in the x direction
y3 = [0 g(2)/norm(g)] * l; % start and end point in the y direction   
drawArrow(x3,y3,'linewidth',2,'color','g');

% % Plot the Cauchy point in yellow
% s_C = Cauchy_Point( H, g, sigma );
% x4 = [0 s_C(1)]; % start and end point in the x direction
% y4 = [0 s_C(2)]; % start and end point in the y direction   
% drawArrow(x4,y4,'linewidth',2,'color','y');
hold off;
end

%% Plot a legend
if Plot_Legend == 1
legend({'Contours', 'v_1', 'v_2', 'g'}, 'Location', 'northwest' );
end

%% Plot the solution

if Plot_Solution == 1
    hold on;
    if sn == 1
        plot3(Solution(1), Solution(2), evalF(m, Solution), 'bx', 'MarkerSize', 10, 'LineWidth', 2);
    else
        plot3(Solution(1, :), Solution(2, :), evalF(m, Solution), 'bx', 'MarkerSize', 10, 'LineWidth', 2);
    end
    hold off;
end

%% Plot iterates

if Plot_Iterates == 1 && Type == 'c'
k = 1;
[n, ~] = size(Iterates);

while k <= n
  B = waitforbuttonpress;
  hold on;
  if k == 1
    plot3(Iterates(k, 1), Iterates(k, 2), evalF(m, Iterates(k, :)')', 'r^', 'MarkerSize', 7, 'LineWidth', 1 );
  else
    plot3(Iterates(k, 1), Iterates(k, 2), evalF(m, Iterates(k, :)')', 'ro', 'MarkerSize', 7, 'LineWidth', 1 );
  end
  %Counter = sprintf('Iteration %1.0f/%1.0f', k, n);
  %title(Counter);
  hold off;
  k = k+1;
end
end

%% Save this figure
if Save_Figure == 1
    
   
    % Create the full path
    name = [Filename{1}, Filename{2}, '_type_', Type, '.eps' ];
    disp(name);
    % Save
    print(name,'-depsc');
    
    % Save as fig
    name = [Filename{1}, Filename{2}, '_type_', Type ];
    savefig(name);
end

end

