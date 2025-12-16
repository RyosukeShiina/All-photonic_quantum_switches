% TEST_QxQzQab_from_CombinedResults.m
%
% Abstract:
%   This file tests the QxQzQab_from_CombinedResults function,
%   which converts a Pauli error distribution (in CombinedResults)
%   into GHZ-basis weights lambda(1..8) and error rates Qx, Qz, Qab.
%
% Run the test by executing:
%   results = runtests('TEST_QxQzQab_from_CombinedResults.m');

tol = 1e-12;

%% Test 1: No noise (only III with probability 1)
% Expected:
%   lambda = [1,0,0,0,0,0,0,0]
%   Qx = 0, Qz = 0, Qab = 0

CombinedResults = struct();
CombinedResults.patternLabels = strings(64,3);
CombinedResults.patternLabels(:,:) = "I";  % all "I I I"
CombinedResults.patternProbs = zeros(64,1);
CombinedResults.patternProbs(1) = 1.0;     % type 1: III with prob 1

[Qx, Qz, Qab, lambda] = QxQzQab_from_CombinedResults(CombinedResults);

assert(abs(sum(lambda) - 1) < tol, "Test 1: lambda must sum to 1.");
assert(abs(lambda(1) - 1.0) < tol, "Test 1: lambda(1) should be 1 for III.");
assert(all(abs(lambda(2:8)) < tol), "Test 1: lambda(2..8) should be 0 for no noise.");

assert(abs(Qx - 0.0) < tol, "Test 1: Qx should be 0 for no noise.");
assert(abs(Qz - 0.0) < tol, "Test 1: Qz should be 0 for no noise.");
assert(abs(Qab - 0.0) < tol, "Test 1: Qab should be 0 for no noise.");

%% Test 2: Pure phase flip ZII with probability 1
% Pauli: ZII maps GHZ1 -> GHZ2
% Expected:
%   lambda = [0,1,0,0,0,0,0,0]
%   Qx = 1/2 - 1/2*(0 - 1) = 1
%   Qz = 1 - 0 - 1 = 0
%   Qab = 0

CombinedResults = struct();
CombinedResults.patternLabels = strings(64,3);
CombinedResults.patternLabels(:,:) = "I";
CombinedResults.patternLabels(1,:) = ["Z","I","I"];  % only type1 is ZII
CombinedResults.patternProbs = zeros(64,1);
CombinedResults.patternProbs(1) = 1.0;

[Qx, Qz, Qab, lambda] = QxQzQab_from_CombinedResults(CombinedResults);

assert(abs(sum(lambda) - 1) < tol, "Test 2: lambda must sum to 1.");
assert(abs(lambda(2) - 1.0) < tol, "Test 2: lambda(2) should be 1 for pure ZII.");
assert(all(abs(lambda([1,3:8])) < tol), "Test 2: other lambda entries should be 0.");

assert(abs(Qx - 1.0) < tol, "Test 2: Qx should be 1 for pure phase flip.");
assert(abs(Qz - 0.0) < tol, "Test 2: Qz should be 0 for phase flip only.");
assert(abs(Qab - 0.0) < tol, "Test 2: Qab should be 0 (no off-diagonal GHZ sectors).");

%% Test 3: Pure bit-flip XII with probability 1
% Pauli: XII maps GHZ1 -> GHZ7 (bit-flip sector)
% Expected:
%   lambda(7) = 1, others 0
%   Qx = 1/2 - 1/2*(0 - 0) = 0.5
%   Qz = 1 - 0 - 0 = 1
%   Qab1 = lambda3+lambda4 = 0
%   Qab2 = lambda5+lambda6 = 0
%   Qab3 = lambda7+lambda8 = 1  => Qab = 1

CombinedResults = struct();
CombinedResults.patternLabels = strings(64,3);
CombinedResults.patternLabels(:,:) = "I";
CombinedResults.patternLabels(1,:) = ["X","I","I"];  % only type1 is XII
CombinedResults.patternProbs = zeros(64,1);
CombinedResults.patternProbs(1) = 1.0;

[Qx, Qz, Qab, lambda] = QxQzQab_from_CombinedResults(CombinedResults);

assert(abs(sum(lambda) - 1) < tol, "Test 3: lambda must sum to 1.");
assert(abs(lambda(7) - 1.0) < tol, "Test 3: lambda(7) should be 1 for pure XII.");
assert(all(abs(lambda([1:6,8])) < tol), "Test 3: other lambda entries should be 0.");

assert(abs(Qx - 0.5) < tol, "Test 3: Qx should be 0.5 for pure XII.");
assert(abs(Qz - 1.0) < tol, "Test 3: Qz should be 1 for pure bit flip.");
assert(abs(Qab - 1.0) < tol, "Test 3: Qab should be 1 (all weight in one bit-flip sector).");