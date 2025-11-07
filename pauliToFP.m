function [f, p] = pauliToFP(PT)
% PT : 0=I,1=X,2=Y,3=Z
% f : bit flip (0 or 1)
% p : phase flip (0 or 1)
switch PT
    case 0  % I
        f = 0; p = 0;
    case 1  % X
        f = 1; p = 0;
    case 2  % Y
        f = 1; p = 1;
    case 3  % Z
        f = 0; p = 1;
    otherwise
    error('error');
end

end
