function [  ] = norm_s_plot( H, g, sigma, varargin )
%Produces a plot of ||s(\lambda)|| and \lambda / \sigma versus \lambda
%
%   Input:
%   H: Symmetric Matrix (Hessian)
%   g: Vector (Gradient)
%   sigma: regularisation parameter
%
%   Optional Input - 
%   Limits = [xMin, xMax, yMin, yMax]: A Vector of specified plotting ranges
%   Plot_Legend: (0) or (1), depending on whether a legend is desired or not
%   Filename: A string containing a path and a filename to save the figure
%
%   Output - 
%   Plots a figure
%
%   Usage - 
%   norm_s_plot(H, g, sigma);
%   norm_s_plot(H, g, sigma, options);
%   ... where options is a struct containing any of the above fields

%% Create function handles

% Make sure g in a col vector
g = g(:);

% Get function handle
[psi, xMin, xMax, evals, n] = GetPsi(H, g);

% Calculate the norm of S
normS = @(x) sqrt(psi(x));

%% Set ranges
yMin = 0;
x = linspace(xMin, xMax, 100);
yMax = min([10, max(normS(x))*1.3]);

%% Process Input

if nargin == 3
    Plot_Legend = 1; Save_Figure = 0;
else
    options = varargin{1};
    
    % Limits
    if isfield(options, 'Limits')
        p = options.Limits;
        xMin = p(1); xMax = p(2); yMin = p(3); yMax = p(4);
    end
    
    % Legend
    if isfield(options, 'Plot_Legend')
        Plot_Legend = options.Plot_Legend;
    end
    
    % Save Figure
    if isfield(options, 'Filename')
        Save_Figure = 1;
        Filename = options.Filename;
    else
        Save_Figure = 0;
    end
    
end

%% Produce the plot
    
% Make new figure window
figure('Name', '||s|| - plot', 'Position', [100, 100, 300, 250]);

% produce a plot of phi
pS = fplot(normS, [xMin, xMax], 'LineWidth', 2); ylim([yMin, yMax]), ...
    xlabel('\lambda');
grid;

% Add the other line
hold on;
pLine = fplot(@(x) x/sigma, [xMin, xMax], 'Color', 'green', 'LineWidth', 3);
hold off;

% Sort the eigenvalues and control Line plotting
evalsS = sort(evals);
lambda_1 = evalsS(1);
lambda_2 = evalsS(2);

if -lambda_2 >= xMin
    % Add lines for the asymptotes
    [pE, pBD] = AddLines(evals, xMin, xMax, n, yMin, yMax);
    
    % Add a legend
    if Plot_Legend == 1
        legend([pS, pBD, pLine, pE],'||s(\lambda)||','-\lambda_1', '\lambda / \sigma', 'e-val', 'Location', 'southwest' );
    end
end

if -lambda_2 < xMin && -lambda_1 >= xMin
    [pBD] = AddLines2(lambda_1, yMin, yMax);
    
    % Add a legen
    if Plot_Legend == 1
        legend([pS, pBD, pLine],'||s(\lambda)||','-\lambda_1', '\lambda / \sigma', 'Location', 'best' );
    end
end

%% Save figure

if Save_Figure == 1
    [~, n] = size(H);
    kappa = cond(H);
    name = [Filename,  '_n_', num2str(n), '_kappa_', num2str(kappa), '_sigma_', num2str(100*sigma),'.eps' ];
    print(name,'-depsc');
    name = [Filename,  '_n_', num2str(n), '_kappa_', num2str(kappa), '_sigma_', num2str(100*sigma) ];
    savefig(name);
end

end















