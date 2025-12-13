function [Xerr, Zerr] = InnerSwappingAndConstruction(L0, sigGKP, etas, etam, etad, etac, Lcavity, k, v, N)

%{

[Abstract]

This function outputs the error probabilities in the Z and X bases for a single segment.  
Specifically, it simulates the errors arising from a sequence of three processes within one segment:  
(1) Construction of Elementary Entangled Bell Pairs, (2) Outer-Leaves Swapping, and (3) Inner-Leaves Swapping.


[Inputs]

L0 — The distance between a repeater and its adjacent repeater, measured in kilometers [km]. Typically, we set L0 = 9.

sigGKP — The standard deviation of the Gaussian displacement noise applied to both the q and p quadratures of both qubits in the G0 states. Typically, we set sigGKP = 0.12.

etas — The efficiency of the optical switch applied to the remaining graph states after a measurement with discard windows. Typically, we set etas=0.995.

etam — The efficiency of mirror reflection per bounce. Typically, we set etam = 0.999995.

etad — The efficiency of a single homodyne detection. Typically, we set etad = 0.9975.

etac — The efficiency of a single connector between the photon fiber and the quantum chip. Typically, we set etac = 0.99.

Lcavity — The distance between successive bounces inside a mirror room or an optical cavity, measured in meters [m]. Typically, we set Lcavity = 2.

k — The number of multiplexing levels. For example, setting k = 15 results in the generation of 15 end-to-end entangled Bell pairs.

v — The window size of measurement type 7. This is the widest window among all types of measurements. 
    The window sizes for all other measurement types are determined relative to this, such that the bit-flip error probabilities are equal across all measurements. 
    Typically, we set v = 0.3. This choice is based on the observation that the bit-flip error probability saturates around v = 0.3.

leaves — An integer parameter that can take values 0, 1, or 2, specifying which processes to simulate.  
			- leaves = 0: Simulates only (1) Construction of Elementary Entangled Bell Pairs and (3) Outer-Leaf Swapping.
			- leaves = 1: Simulates all three processes —
				(1) Construction of Elementary Entangled Bell Pairs,  
				(2) Outer-Leaves Swapping, and  
				(3) Inner-Leaves Swapping.  
			- leaves = 2: Simulates only (1) Construction of Elementary Entangled Bell Pairs and (2) Inner-Leaf Swapping.

N — The number of trials. When N = 100, the simulation is repeated 100 times.


[Outputs]

Zerr — The bit-flip error probabilities in the Z basis. For example, setting k = 15 results in a column vector with 15 elements, ordered from the lowest to the highest value.

Xerr — The bit-flip error probabilities in the X basis. For example, setting k = 15 results in a column vector with 15 elements, ordered from the lowest to the highest value.


[Example]

[Zerr, Xerr] = UW2_InnerAndOuterLeaves(9, 0.12, 0.995, 0.999995, 0.9975, 0.99, 2, 15, 0.3, 1, 10000000)


%}


% Throughout the UW2 construction process of elementary entangled Bell pairs, there are 10 types of measurements. For each type, we compute the effective standard deviation of the noise just before the measurement occurs.
sigmasPostselect = zeros(1, 9);


% Measurements 1–5: Postselected homodyne measurements for XX-measurements.
sigmasPostselect(1) = sqrt(3*sigGKP^2 + (1-etad)/etad);
sigmasPostselect(2) = sqrt(3*sigGKP^2 + (1-etas*etad)/(etas*etad));
sigmasPostselect(3) = sqrt(3*sigGKP^2 + (1-etas^2*etad)/(etas^2*etad));

sigmasPostselect(4) = sqrt(2*sigGKP^2 + (1-etas*etad)/(etas*etad));
sigmasPostselect(5) = sqrt(2*sigGKP^2 + (1-etas^2*etad)/(etas^2*etad));

% Measurements 6–9: Postselected homodyne measurements for refreshment measurements.
sigmasPostselect(6) = sqrt(3*sigGKP^2 + 1 - etas^2 + (1-etad)/etad);
sigmasPostselect(7) = sqrt(3*sigGKP^2 + 1 - etas^3 + (1-etad)/etad);

sigmasPostselect(8) = sqrt(2*sigGKP^2 + 1 - etas^2 + (1-etad)/etad);
sigmasPostselect(9) = sqrt(2*sigGKP^2 + 1 - etas^3 + (1-etad)/etad);

% Measurement without postselection
sigmasNoPost = sqrt(2*sigGKP^2 + (1-etas*etad)/(etas*etad));

%The window size is determined for each of the 10 types of measurements.  Specifically, measurement type 7 — which has the largest standard deviation — is used as a reference. 
%The window sizes for all other measurement types are determined relative to this, such that the bit-flip error probabilities are equal across all measurements. We use the R_Find_v function.
vVec = R_Find_v(sigmasPostselect, R_LogErrAfterPost(sigmasPostselect(7),v), v+0.1);

%We prepare two blank row vectors to record:  
%(1) the bit-flip error probability (which should be close in value across all measurement types), and  
%(2) the survival probability after post-selection using the window sizes determined above.
ErrProbVec = zeros(1,10);
pVec = zeros(1,10);


%We calculate the bit-flip error probability and the survival probability after post-selection using the windows that correspond to each measurement, with the R_LogErrAfterPost function.
for i = 1:9
    [ErrProbVec(i), pVec(i)] = R_LogErrAfterPost(sigmasPostselect(i), vVec(i));
end
[ErrProbVec(10), pVec(10)] = R_LogErrAfterPost(sigmasNoPost, 0);


%We prepare two scalar variables to record the bit-flip error probabilities in the Z and X bases during Inner-Leaves Swapping.
%We can assume that the Inner-Leaves are identical, since they do not pass through photon fibers but instead go to a mirror room or an optical cavity.
XerrInner = 0;
ZerrInner = 0;

parfor i = 1:N
    logErrInner = UW2_InnerLeaves(L0, sigGKP, etas, etam, etad, etac, Lcavity, ErrProbVec);
    ZerrInner = ZerrInner + logErrInner(1);
    XerrInner = XerrInner + logErrInner(2);
end

ZerrInner = ZerrInner/N;
XerrInner = XerrInner/N;


%We copy the result above and convert it into column vectors, since we can assume that the Inner-Leaves are identical, since they do not pass through photon fibers but instead go to a mirror room or an optical cavity.
ZerrInnerVec = ZerrInner*ones(k,1);
XerrInnerVec = XerrInner*ones(k,1);


%We combine the two error probability column vectors of the Inner-Leaves Swapping and Outer-Leaves Swapping.
%An error occurs at the end only when an Inner-Leaves Swapping has an error and the corresponding Outer-Leaves Swapping does not, or vice versa. 
%Therefore, instead of simply summing the two error probability column vectors, we compute the probability that Inner-Leaves Swapping causes an error while Outer-Leaves Swapping does not, and vice versa, and then sum these two contributions.
Zerr = ZerrInnerVec;
Xerr = XerrInnerVec;
