%Rate vs Distance

L = 9;
sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;

v = 0.3; 
leaves = 1;
N = 100000000;

xdata = [];
y0 = [];
y1 = [];
y2 = [];

y4 = [];
y5 = [];

tic;
disp("*******This simulation starts*******");

disp("*******1*******");

%CC14L-method
[ZerrCC14N8, XerrCC14N8] = CC14LAST_InnerAndOuterLeaves(8, sigGKP, etas, etam, etad, etac, Lcavity, 15, v, leaves, N);

disp("*******2*******");


[ZerrCC14N9, XerrCC14N9] = CC14LAST_InnerAndOuterLeaves(9, sigGKP, etas, etam, etad, etac, Lcavity, 15, v, leaves, N);

disp("*******3*******");

[ZerrCC14N10, XerrCC14N10] = CC14LAST_InnerAndOuterLeaves(10, sigGKP, etas, etam, etad, etac, Lcavity, 15, v, leaves, N);


disp("*******4*******");

[ZerrCC14N9_10, XerrCC14N9_10] = CC14LAST_InnerAndOuterLeaves(9, sigGKP, etas, etam, etad, etac, Lcavity, 10, v, leaves, N);

disp("*******5*******");

[ZerrCC14N9_5, XerrCC14N9_5] = CC14LAST_InnerAndOuterLeaves(9, sigGKP, etas, etam, etad, etac, Lcavity, 5, v, leaves, N);

disp("**************");


for i = 9:9:3006
    outCC14L9 = R_SecretKeyRate_per(9, i, ZerrCC14N9, XerrCC14N9);
    outCC14L9_10 = R_SecretKeyRate_per(9, i, ZerrCC14N9_10, XerrCC14N9_10);
    outCC14L9_5 = R_SecretKeyRate_per(9, i, ZerrCC14N9_5, XerrCC14N9_5);

    y1 = [y1, outCC14L9];
    y4 = [y4, outCC14L9_10];
    y5 = [y5, outCC14L9_5];

end

for i = 8:8:3000
    outCC14L8 = R_SecretKeyRate_per(9, i, ZerrCC14N8, XerrCC14N8);
    y0 = [y0, outCC14L8];
end

for i = 10:10:3000
    outCC14L10 = R_SecretKeyRate_per(9, i, ZerrCC14N10, XerrCC14N10);
    y2 = [y2, outCC14L10];
end

disp('this')
writematrix(y0, 'Rate_CC14L_k=15_8km_multipleof8.csv');
writematrix(y1, 'Rate_CC14L_k=15_9km_multipleof9.csv');
writematrix(y2, 'Rate_CC14L_k=15_10km_multipleof10.csv');
writematrix(y4, 'Rate_CC14L_k=10_9km_multipleof9.csv');
writematrix(y5, 'Rate_CC14L_k=5_9km_multipleof9.csv');
disp("******This simulation was finished*****")
elapsedTime = toc;
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);