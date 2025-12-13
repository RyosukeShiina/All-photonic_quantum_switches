function [Qx, Qz, Qab, lambda] = QxQzQab_from_CombinedResults(CombinedResults)

% QxQzQab_from_CombinedResults
%   Input:
%       CombinedResults.patternLabels : 64x3 string array ("I","X","Y","Z")
%       CombinedResults.patternProbs  : 64x1 probability vector (sums to 1)
%
%   Output:
%       Qx, Qz, Qab : error rates
%       lambda : 8x1 vector of GHZ-basis weights (lambda(1) ... lambda(8))

patternLabels = CombinedResults.patternLabels;   % 64x3 (string)
P             = CombinedResults.patternProbs;    % 64x1 (double)

% ============================================
lambda = zeros(8,1);

for k = 1:numel(P) %k indicates an error type out of 64 exhaustive error types.

    lbl = patternLabels(k);       % 1x1 string
    chars = char(lbl);            % char vector

    a = string(chars(1));  % qubit 1: "I","X","Y","Z"
    b = string(chars(2));  % qubit 2: "I","X","Y","Z"
    c = string(chars(3));  % qubit 3: "I","X","Y","Z"

    s = GHZindex_from_Pauli(a, b, c);  % s is GHZindex, 1〜8

    lambda(s) = lambda(s) + P(k); %add its probability
end


% ============================================
% Qx = 1/2 - 1/2 (lambda0^+ - lambda0^-)
Qx = 0.5 - 0.5*(lambda(1) - lambda(2));

% Qz = 1 - lambda0^+ - lambda0^-
Qz = 1.0 - lambda(1) - lambda(2);

% Qab = max{Qab1, Qab2, Qab3}
Qab1 = lambda(3)+lambda(4);
Qab2 = lambda(5)+lambda(6);
Qab3 = lambda(7)+lambda(8);
Qab = max([Qab1, Qab2, Qab3]);

end