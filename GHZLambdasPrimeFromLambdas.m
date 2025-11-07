function [Lambdas3prime, Pkeep] = GHZLambdasPrimeFromLambdas(Lambdas3)

%GHZLambdasPrimeFromLambdas
%Lambdas3: λ = (λ1,...,λ8)
%Lambdas3prime: λ' = (λ'1,...,λ'8) after AD
%Pkeep: success probability of AD

persistent T keepMask %T is a tensor of 8*8*8 (out(8)*input(8*8))
if isempty(T)
    [T, keepMask] = build_AD_transition_tensor();
end


n = size(Lambdas3, 1);
Lambdas3prime = zeros(n, 8);
Pkeep = zeros(n, 1);

for idx = 1:n
    lambda = Lambdas3(idx, :).'; % 8x1 vector
    out_unnorm = zeros(8, 1);

    for i = 1:8
        if lambda(i) == 0, continue; end
        for j = 1:8
            if lambda(j) == 0, continue; end
            if ~keepMask(i,j), continue; end
            w = lambda(i)*lambda(j);
            out_unnorm = out_unnorm + w * T(:, i, j);
        end
    end

    Pkeep(idx) = sum(out_unnorm);

    if Pkeep(idx) > 0
        Lambdas3prime(idx, :) = (out_unnorm / Pkeep(idx)).';
    else
        Lambdas3prime(idx, :) = Lambdas3(idx, :);
    end
end

end