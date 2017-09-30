function [  ] = phi1_plot( H, g, sigma, varargin )
%Produces a plot of \phi_1 versus \lambda
%
%   Input -
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
%   phi1_plot(H, g, sigma);
%   phi1_plot(H, g, sigma, options);
%   ... where options is a struct containing any of the above fields

%% Create functions for the norm of s

% Get function handle
[psi, xMin, xMax, evals, n] = GetPsi(H, g);

% Compose the desired function
phi1 = @(x) 1./sqrt(psi(x)) - sigma./x;

%% Set Ranges

% Define y Limits
yMin = -10;
x = linspace(xMin, xMax, 100);
yMax = min([10, max(phi1(x))*1.3]);

%% Process input

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

%% Plot phi_1

% Make new figure window
figure('Name', '\phi_1-plot', 'Position', [100, 100, 300, 250]);

% Produce a plot of phi
pS = fplot(phi1, [xMin, xMax], 'DisplayName', '\phi_1(\lambda)', 'LineWidth', 2); ylim([yMin, yMax]), ...
    xlabel('\lambda'), grid;

%% Plot Vertical Lines

% Sort the eigenvalues and control Line plotting
evalsS = sort(evals);
lambda_1 = evalsS(1);
lambda_2 = evalsS(2);

if -lambda_2 >= xMin
    % Add lines for the asymptotes
    [pE, pBD] = AddLines(evals, xMin, xMax, n, yMin, yMax);
    
    % Add a legend
    if Plot_Legend == 1
        legend([pS, pBD, pE],'\phi_1(\lambda)', '-\lambda_1', 'e-val' );
    end
end

if -lambda_2 < xMin && -lambda_1 >= xMin
    [pBD] = AddLines2(lambda_1, yMin, yMax);
    
    % Add a legend
    if Plot_Legend == 1
        legend([pS, pBD],'\phi_1(\lambda)', '-\lambda_1' );
    end
end

%% Save this figure

if Save_Figure == 1
    [~, n] = size(H);
    kappa = cond(H);
    name = [Filename,  '_n_', num2str(n), '_kappa_', num2str(kappa), '_sigma_', num2str(100*sigma),'.eps' ];
    print(name,'-depsc');
    name = [Filename,  '_n_', num2str(n), '_kappa_', num2str(kappa), '_sigma_', num2str(100*sigma) ];
    savefig(name);
end


end

