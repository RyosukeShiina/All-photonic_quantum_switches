function GHZindex = GHZindex_from_Pauli(a, b, c)
% a, b, c: "I","X","Y","Z" 


bx = ismember(a, ["X","Y"]); %a is a member of ["X","Y"]?
by = ismember(b, ["X","Y"]);
bz = ismember(c, ["X","Y"]);
bvec = [bx, by, bz];


b_dec = bvec(1)*4 + bvec(2)*2 + bvec(3)*1;
% b and 7-b belong the same GHZ index
b_red = min(b_dec, 7 - b_dec);


% ============================================
cz1 = ismember(a, ["Z","Y"]);
cz2 = ismember(b, ["Z","Y"]);
cz3 = ismember(c, ["Z","Y"]);
c_parity = mod(cz1 + cz2 + cz3, 2);


% ============================================
switch b_red
    case 0   % {000,111}
        base = 1;  % 1(+) or 2(-)
    case 1   % {001,110}
        base = 3;  % 3(+) or 4(-)
    case 2   % {010,101}
        base = 5;  % 5(+) or 6(-)
    case 3   % {011,100}
        base = 7;  % 7(+) or 8(-)
    otherwise
        error('b_red must be 0,1,2,3');
end


% ============================================
if c_parity == 0
        GHZindex = base;      % "+"
    else
        GHZindex = base + 1;  % "-"
end

end