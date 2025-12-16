% TEST_SourceMarkov.m
%
% Abstract:
%   This file tests the Markov-chain–based Pauli error propagation
%   implemented via the 64-dimensional probability vector P and bitxor masks.
%
% Run the test by executing:
%   results = runtests('TEST_SourceMarkov.m');

%% Test 1: Single ZII error with p = 0.01 from the III initial state
P = zeros(64,1);
P(1) = 1.0;         % state 0: III

p  = 0.01;          % firing probability
ms = uint8(32);     % example: ZII corresponds to bitmask 32 (100000_2)

Pnew = zeros(64,1);
for i = 0:63
    prob_i = P(i+1);
    if prob_i == 0
        continue;
    end

    % no firing: stay in i
    Pnew(i+1) = Pnew(i+1) + (1-p) * prob_i;

    % firing: XOR with mask
    j = bitxor(uint8(i), ms);
    Pnew(double(j)+1) = Pnew(double(j)+1) + p * prob_i;
end

% Check: P(III) = 0.99, P(ZII) = 0.01
assert(abs(Pnew(1)  - 0.99) < 1e-12, "III prob should be 0.99");
assert(abs(Pnew(33) - 0.01) < 1e-12, "ZII prob should be 0.01");

%% Test 2: Probability must always sum to 1
assert(abs(sum(Pnew) - 1) < 1e-12, "Total probability must remain 1");

%% Test 3: ZII XOR ZII = III (self-inverse)
i  = uint8(32);         % ZII
j  = bitxor(i, ms);     % apply ZII again
assert(j == 0, "ZII ⊕ ZII should return to III (state 0)");