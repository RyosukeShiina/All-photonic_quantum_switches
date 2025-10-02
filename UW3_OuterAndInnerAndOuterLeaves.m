function [Zerr,Xerr] = UW3_OuterAndInnerAndOuterLeaves(LA, LB, sigGKP, etas, etam, etad, etac, Lcavity, k, v, leaves, N)

%{

[Example]

[Zerr, Xerr] = UW3_OuterAndInnerAndOuterLeaves(9, 4, 0.12, 0.995, 0.999995, 0.9975, 0.99, 2, 15, 0.3, 1, 10000000)


%}


% Throughout the UW3 construction process of elementary entangled Bell pairs, there are 12 types of measurements. For each type, we compute the effective standard deviation of the noise just before the measurement occurs.
sigmasPostselect = zeros(1, 11);



sigmasPostselect(1) = sqrt(3*sigGKP^2 + (1-etad)/etad);
sigmasPostselect(2) = sqrt(3*sigGKP^2 + (1-etas*etad)/(etas*etad));
sigmasPostselect(3) = sqrt(3*sigGKP^2 + (1-etas^2*etad)/(etas^2*etad));
sigmasPostselect(4) = sqrt(2*sigGKP^2 + (1-etas*etad)/(etas*etad));
sigmasPostselect(5) = sqrt(2*sigGKP^2 + (1-etas^2*etad)/(etas^2*etad));
sigmasPostselect(6) = sqrt(3*sigGKP^2 + 1 - etas^2 + (1-etad)/etad);
sigmasPostselect(7) = sqrt(3*sigGKP^2 + 1 - etas^3 + (1-etad)/etad);
sigmasPostselect(8) = sqrt(2*sigGKP^2 + 1 - etas^2 + (1-etad)/etad);
sigmasPostselect(9) = sqrt(2*sigGKP^2 + 1 - etas^3 + (1-etad)/etad);
sigmasPostselect(10) = sqrt(3*sigGKP^2 + 1 - etas + (1-etad)/etad);
sigmasPostselect(11) = sqrt(2*sigGKP^2 + 1 - etas + (1-etad)/etad);

% Measurement without postselection
sigmasNoPost = sqrt(2*sigGKP^2 + (1-etas*etad)/(etas*etad));




vVec = R_Find_v(sigmasPostselect, R_LogErrAfterPost(sigmasPostselect(7),v), v+0.1);




ErrProbVec = zeros(1,12);
pVec = zeros(1,12);



for i = 1:11
    [ErrProbVec(i), pVec(i)] = R_LogErrAfterPost(sigmasPostselect(i), vVec(i));
end
[ErrProbVec(12), pVec(12)] = R_LogErrAfterPost(sigmasNoPost, 0);




XerrOuterA = zeros(k,1);
ZerrOuterA = zeros(k,1);
XerrOuterB = zeros(k,1);
ZerrOuterB = zeros(k,1);



XerrInner = 0;
ZerrInner = 0;



%We simulate Outer-Leaves Swapping.
%When leaves == 2, Outer-Leaves Swapping is skipped.
if leaves == 2
    ZerrOuterA = zeros(k,1);
    XerrOuterA = zeros(k,1);
%When leaves ~= 2, we simulate Outer-Leaves Swapping using the UW2_OuterLeaves function. In this case, we record the average over N trials.
else
    parfor i = 1:N
        logErrOuterA = UW3_OuterLeaves(LA, sigGKP, etas, etad, etac, k, ErrProbVec);
        ZerrOuterA = ZerrOuterA + logErrOuterA(:,1);
        XerrOuterA = XerrOuterA + logErrOuterA(:,2);
    end
    ZerrOuterA = ZerrOuterA/N;
    XerrOuterA = XerrOuterA/N;
end



%We simulate Inner-Leaves Swapping.
%When leaves == 0, Inner-Leaves Swapping is skipped.
if leaves == 0
    ZerrInner = 0;
    XerrInner = 0;
%When leaves ~= 0, we simulate Inner-Leaves Swapping using the UW2_InnerLeaves function. In this case, we record the average over N trials.
else
    parfor i = 1:N
        logErrInner = UW3_InnerLeaves(max(LA, LB), sigGKP, etas, etam, etad, etac, Lcavity, ErrProbVec);
        ZerrInner = ZerrInner + logErrInner(1);
        XerrInner = XerrInner + logErrInner(2);
    end
    ZerrInner = ZerrInner/N;
    XerrInner = XerrInner/N;
end

%We copy the result above and convert it into column vectors, since we can assume that the Inner-Leaves are identical, since they do not pass through photon fibers but instead go to a mirror room or an optical cavity.
ZerrInnerVec = ZerrInner*ones(k,1);
XerrInnerVec = XerrInner*ones(k,1);




%We simulate Outer-Leaves Swapping.
%When leaves == 2, Outer-Leaves Swapping is skipped.
if leaves == 2
    ZerrOuterB = zeros(k,1);
    XerrOuterB = zeros(k,1);
%When leaves ~= 2, we simulate Outer-Leaves Swapping using the UW2_OuterLeaves function. In this case, we record the average over N trials.
else
    parfor i = 1:N
        logErrOuterB = UW3_OuterLeaves(LB, sigGKP, etas, etad, etac, k, ErrProbVec);
        ZerrOuterB = ZerrOuterB + logErrOuterB(:,1);
        XerrOuterB = XerrOuterB + logErrOuterB(:,2);
    end
    ZerrOuterB = ZerrOuterB/N;
    XerrOuterB = XerrOuterB/N;
end








Zerr = ZerrOuterA .* (ones(k,1) - ZerrInnerVec) .* (ones(k,1) - ZerrOuterB) + (ones(k,1) - ZerrOuterA) .* ZerrInnerVec .* (ones(k,1) - ZerrOuterB) + (ones(k,1) - ZerrOuterA) .* (ones(k,1) - ZerrInnerVec) .* ZerrOuterB + ZerrOuterA .* ZerrInnerVec .* ZerrOuterB;


Xerr = XerrOuterA .* (ones(k,1) - XerrInnerVec) .* (ones(k,1) - XerrOuterB) + (ones(k,1) - XerrOuterA) .* XerrInnerVec .* (ones(k,1) - XerrOuterB) + (ones(k,1) - XerrOuterA) .* (ones(k,1) - XerrInnerVec) .* XerrOuterB + XerrOuterA .* XerrInnerVec .* XerrOuterB;
