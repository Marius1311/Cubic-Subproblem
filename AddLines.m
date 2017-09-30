function [pE, pBD] = AddLines(evals, xMin, xMax, n, yMin, yMax)
% Add lines for the asymptotes 

for i = 1:n
    if LiesInRange(-evals(i), xMin, xMax)
        if -evals(i) ~= max(-evals)
            pE = line([-evals(i), -evals(i)], [yMin, yMax],...
                'LineStyle', '--', 'LineWidth', 3, 'Color', 'blue');
        else
            pBD = line([-evals(i), -evals(i)], [yMin, yMax],...
                'LineStyle', '--', 'LineWidth', 3, 'Color', 'red');
        end
    end
end

end

