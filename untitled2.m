
p = zeros(24,1);

p(1)  = 0.01;   % Type1
p(2)  = 0.02;   % Type2
p(5)  = 0.03;   % Type5
p(10) = 0.01;   % Type10
p(24) = 0.02;   % Type24

SingleResults.Probs = p;
CombinedResults = CombinedResults_from_SingleResults(SingleResults);