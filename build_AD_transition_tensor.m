function [T, keepMask] = build_AD_transition_tensor()
%build_AD_transition_tensor for the GHZ labeling
%output:
%T(k,i,j): from (i,j) -> k with probability 1 if kept
%keepMask(i,j): true if accepted

dim = 8;
T = zeros(dim, dim, dim);
keepMask = false(dim, dim);

for i = 1:dim
    keepMask(i,i) = true;  % success if i=j
    T(i,i,i) = 1;          % output is also i
end

end
