function [ r ] = LiesInRange( x, xMin, xMax )
% Simply checks whether a number lies in a given range

r = (x >= xMin && x <= xMax);

end

