function idx = mapPauliToGHZIndex(a, b, c)

%   1: (|000> + |111>)/sqrt(2)
%   2: (|000> - |111>)/sqrt(2)
%   3: (|001> + |110>)/sqrt(2)
%   4: (|001> - |110>)/sqrt(2)
%   5: (|010> + |101>)/sqrt(2)
%   6: (|010> - |101>)/sqrt(2)
%   7: (|011> + |100>)/sqrt(2)
%   8: (|011> - |100>)/sqrt(2)

[f1, p1] = pauliToFP(a);
[f2, p2] = pauliToFP(b);
[f3, p3] = pauliToFP(c);

val = f1*4 + f2*2 + f3; %convert binary to decimal (idx)

switch val %(idx)
    case {0, 7} 
        s = 0;
    case {1, 6}
        s = 1; 
    case {2, 5}
        s = 2;
    case {3, 4}
        s = 3;
    otherwise
        error('Unexpected bit pattern');
end

phaseParity = mod(p1 + p2 + p3, 2);

if phaseParity == 0
    idx = 2*s + 1; % odd index
else
    idx = 2*s + 2; % even index
end

end