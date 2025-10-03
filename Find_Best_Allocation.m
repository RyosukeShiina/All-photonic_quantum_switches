function [Best_Allocation, MaxRate] = Find_Best_Allocation(k_total, LA, r, N)

%{
[Example]
[Best_Allocation, MaxRate] = Find_Best_Allocation(50, 4, 1.5, 100000)
%}

LB = r * LA;

sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
k = 1;
v = 0.3;
leaves = 1; %%CHECK%%

k_Alice = (1:k_total-1)';
k_Bob = k_total - k_Alice;
k_pair = [k_Alice, k_Bob];

All_Zerr = cell(size(k_pair,1),1);
All_Xerr = cell(size(k_pair,1),1);
SecretKeyRate = zeros(size(k_pair,1),1);


for i = 1:size(k_pair,1)
    kA = k_pair(i,1);
    kB = k_pair(i,2);

    k_min = min(kA, kB);

    [Zerr, Xerr] = UW3_OuterAndInnerAndOuterLeaves(LA, LB, sigGKP, etas, etam, etad, etac, Lcavity, k_min, v, leaves, N);

    All_Zerr{i} = Zerr;
    All_Xerr{i} = Xerr;

    SecretKeyRate(i) = R_SecretKey6State_total(Zerr, Xerr);

    %fprintf('(%d/%d) k_A=%d, k_B=%d SKR=%.3e\n', i, size(k_pair,1), kA, kB, SecretKeyRate(i));
end

Result_Table = table(k_Alice, k_Bob, SecretKeyRate);
disp(Result_Table);
%writematrix(SecretKeyRate', 'SecretKeyRate.csv');

[MaxRate, idxMax] = max(SecretKeyRate);
Best_Allocation = k_Bob(idxMax) / k_total;
