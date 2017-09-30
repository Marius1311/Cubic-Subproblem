function [phi, xMin, xMax, evals, n] = GetPsi(H, g)
% Returns a function ahndle and appropriate limits for phi = norm(s)^2

% Decompose
[U, D] = eig(H);
evals = diag(D);

% Find dimensions
[~, n] = size(H);

% Just make it the same as in the ARC paper
U = U';

% Produce the vector gamma
gamma = U*g;

% define the function phi = ||s||
phi = @(x) sum(gamma.^2./(diag(D) + x).^2);

% Define x Limits
xMin = max([0, min(-diag(D))]) - 3;
xMax = max(3, max(-diag(D))) + 3;
end
