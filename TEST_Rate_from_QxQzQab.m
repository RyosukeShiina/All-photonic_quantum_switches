% TEST_Rate_from_QxQzQab.m
%
% Abstract:
%   This file tests the Rate_from_QxQzQab function, which computes
%   the secret key rate R from Qx, Qz, and Qab according to Eq.(23).
%
% Run with:
%   results = runtests('TEST_Rate_from_QxQzQab.m');

tol = 1e-12;

%% Test 1: Ideal case Qx = 0, Qz = 0, Qab = 0
% Eq.(23):
%   R = 1 
%       + (1)*log2(1)
%       + (0)*log2(0)
%       + (1)*(1 - log2(1))
%       - h(0)
%
% log2(1) = 0, h(0) = 0
% → R_expected = 1

Qx  = 0;
Qz  = 0;
Qab = 0;

R = Rate_from_QxQzQab(Qx, Qz, Qab);
R_expected = 1;

assert(abs(R - R_expected) < tol, ...
    sprintf("Test 1 failed: R = %.15f, expected %.15f", R, R_expected));


%% Test 2: Small symmetric errors
% Qx = 0.01, Qz = 0.02, Qab = 0.01
% Only check numerical stability: R should be finite and not NaN

Qx  = 0.01;
Qz  = 0.02;
Qab = 0.01;

R = Rate_from_QxQzQab(Qx, Qz, Qab);

assert(~isnan(R), "Test 2 failed: R is NaN.");
assert(isfinite(R), "Test 2 failed: R is infinite.");


%% Test 3: Monotonicity in Qab
% For fixed Qx, Qz:
%   Qab_small < Qab_large → R_small > R_large
%
% Note: we must choose Qx, Qz such that
%   p1 = 1 - Qz/2 - Qx > 0
%   p2 = Qx - Qz/2       > 0

Qx = 0.10;
Qz = 0.10;

Qab_small = 0.01;
Qab_large = 0.20;

R_small = Rate_from_QxQzQab(Qx, Qz, Qab_small);
R_large = Rate_from_QxQzQab(Qx, Qz, Qab_large);

assert(R_small > R_large, ...
    sprintf("Test 3 failed: expected R_small > R_large, got %.6f <= %.6f", ...
    R_small, R_large));


%% Test 4: Check domain edge but valid (arguments of log must be > 0)
% Example: Qx = 0.2, Qz = 0.3, Qab = 0.05

Qx  = 0.2;
Qz  = 0.3;
Qab = 0.05;

R = Rate_from_QxQzQab(Qx, Qz, Qab);

assert(~isnan(R), "Test 4 failed: R is NaN.");
assert(isfinite(R), "Test 4 failed: R is infinite.");