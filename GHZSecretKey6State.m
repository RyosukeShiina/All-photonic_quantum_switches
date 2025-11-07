function out = GHZSecretKey6State(QerrZ, QerrX)


QerrZ = QerrZ(:);
QerrX = QerrX(:);
n = numel(QerrZ);
Lambdas3 = GHZLambdasFromQBER(QerrZ, QerrX);

[Lambdas3prime, Pkeep] = GHZLambdasPrimeFromLambdas(Lambdas3);

out1 = zeros(n,1);
out2 = zeros(n,1);

for i = 1:n
    out1(i,1) = 1 - ShannonEnt(Lambdas3(i,:));
    out2(i,1) = (Pkeep(i)/2) * (1 - ShannonEnt(Lambdas3prime(i,:)));
end

out_modes = max([out1, out2, zeros(n,1)], [], 2);

out = sum(out_modes);

end