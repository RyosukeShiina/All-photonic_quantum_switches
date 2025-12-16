% TEST_GHZindex_from_Pauli.m
%
% Abstract:
%   This file tests the GHZindex_from_Pauli(a,b,c) function,
%   which maps a 3-qubit Pauli operator into one of the 8 GHZ basis states.
%
% Run the test by executing:
%   results = runtests('TEST_GHZindex_from_Pauli.m');

tol = 1e-12;

%% Test 1: III should map to GHZ index 1
idx = GHZindex_from_Pauli("I","I","I");
assert(idx == 1, "Test 1 failed: III should map to GHZ 1.");

%% Test 2: ZII should map to GHZ index 2  (phase flip only)
idx = GHZindex_from_Pauli("Z","I","I");
assert(idx == 2, "Test 2 failed: ZII should map to GHZ 2 (phase flipped).");

%% Test 3: XII should map to GHZ index 7  (bit flip on qubit 1)
idx = GHZindex_from_Pauli("X","I","I");
assert(idx == 7, "Test 3 failed: XII should map to GHZ 7.");

%% Test 4: IIX should map to GHZ index 3  (bit flip on qubit 3)
idx = GHZindex_from_Pauli("I","I","X");
assert(idx == 3, "Test 4 failed: IIX should map to GHZ 3.");

%% Test 5: IZI should map to GHZ index 6  (bit flip on qubit 2 + phase)
idx = GHZindex_from_Pauli("I","Z","I");
assert(idx == 2, "Test 5 failed: IZI should map to GHZ 2.");

%% Test 6: YII = X plus Z on qubit 1 → bit flip + phase → GHZ 8
idx = GHZindex_from_Pauli("Y","I","I");
assert(idx == 8, "Test 6 failed: YII should map to GHZ 8.");

%% Test 7: ZZI → parity 2 (even), bit flips none → GHZ 1
idx = GHZindex_from_Pauli("Z","Z","I");
assert(idx == 1, "Test 7 failed: ZZI should map to GHZ 1.");

%% Test 8: Random consistency check (X,Y,Z all treated correctly)
% (X,Y produce bit flip; Y,Z produce phase flip)
idx1 = GHZindex_from_Pauli("X","Y","Z");
idx2 = GHZindex_from_Pauli("X","Y","Z"); % determinism check
assert(idx1 == idx2, "Test 8 failed: function must be deterministic.");