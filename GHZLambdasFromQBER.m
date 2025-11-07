function Lambdas3 = GHZLambdasFromQBER(QerrZ, QerrX)

QerrZ = QerrZ(:);
QerrX = QerrX(:);
n = numel(QerrZ);

Lambdas3 = zeros(n, 8); %list of probabilities (Λ'_1 to Λ'_8)

for i = 1:n
    qZ = QerrZ(i) * (1 - QerrX(i));
    qX = QerrX(i) * (1 - QerrZ(i));
    qY = QerrZ(i) * QerrX(i);
    pI = 1 - qX - qY - qZ;
    p_single = [pI, qX, qY, qZ];

    for a = 0:3
        for b = 0:3
            for c = 0:3

                p_err = p_single(a+1) * p_single(b+1) * p_single(c+1);
                if p_err == 0
                    continue;
                end

                idx = mapPauliToGHZIndex(a, b, c);
                Lambdas3(i, idx) = Lambdas3(i, idx) + p_err;
            end
        end
    end
end
end