function CombinedResults = CombinedResults_from_SingleResults(SingleResults, k)

% ============================================
persistent PauliTable sourceMasks patternLabels Ns

if isempty(PauliTable)
    PauliTable = sourcePaulis();
    [Ns, nQ] = size(PauliTable);
    if nQ ~= 3
            error('error');
    end


    %Each error type (row) is mapped to a specific value expressed in an octal-like encoding.
    %For example, “XXI” is mapped into "000011".
    sourceMasks = zeros(Ns, 1, 'uint8'); 
    for s = 1:Ns % s indicates the error type.
        x = zeros(1,3); 
        z = zeros(1,3);
        for q = 1:3 % q is a user number
            P = upper(string(PauliTable(s,q))); % P is one out of "X", "Z", "I"
            switch P
                case "I", x(q)=0; z(q)=0;
                case "X", x(q)=1; z(q)=0;
                case "Z", x(q)=0; z(q)=1;
                otherwise
                    error('error2');
            end
        end
        sourceMasks(s) = uint8(x(1)*1 + x(2)*2 + x(3)*4 + z(1)*8 + z(2)*16 + z(3)*32 );
    end



    %patternLabels is a look-up table (integers(0-63) to "XXZ" and so on)
    patternLabels = strings(64,1);
    for i = 0:63
        label = "";
        for q = 1:3 % q is a user number
            xq = bitget(i,q); %(xq1, xq2, xq3, zq1, zq2, zq3) 
            zq = bitget(i,q+3); %(xq1, xq2, xq3, zq1, zq2, zq3) 
            if xq==0 && zq==0
                ch="I";
            elseif xq==1 && zq==0
                ch="X";
            elseif xq==0 && zq==1
                ch="Z";
            else                   
                ch="Y";
            end
            label = label + ch;
        end
        patternLabels(i+1) = label;
    end
end


% ============================================
sourceProbs = SingleResults.Probs(:);
if length(sourceProbs) ~= Ns
        error('error3');
end


% ============================================
P = zeros(64,1);
P(1) = 1.0;   %Initial states, III=1.0

for s = 1:Ns %for each row
    p  = sourceProbs{s}; %probability (very small)
    ms = sourceMasks(s); %the row

    Pnew = zeros(64,1); %The distribution which will replace the old one.

    for i = 0:63
        prob_i = P(i+1); %the probability (very small) for the row

        if prob_i == 0
            continue; 
        end

        %the case the transition doesn't happen
        Pnew(i+1) = Pnew(i+1) + (1-p) * prob_i;

        %the case the transition does happen
        j = bitxor(uint8(i), ms); %calculate i(decimal) XOR ms(unit8), j is the destination.

        Pnew(double(j)+1) = Pnew(double(j)+1) + p * prob_i; %unit8 can't be the index.
    end

    P = Pnew;
end



% ============================================
CombinedResults.patternLabels = patternLabels;
CombinedResults.patternProbs  = P;

end
