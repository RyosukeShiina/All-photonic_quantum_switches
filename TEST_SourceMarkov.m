% TEST_SourceMarkov.m
%
% Abstract:
%   This file tests the 64-dimensional Markov-chain–based Pauli error
%   propagation implemented using the probability vector P and bitxor masks.
%
% Run the test by executing:
%   results = runtests('TEST_SourceMarkov.m');

tol = 1e-12;

%% Test 1: 初期状態が III (state 0) で、確率分布の合計が 1 になっているか

P = zeros(64,1);
P(1) = 1.0;   % state 0: III

assert(abs(sum(P) - 1) < tol, "Test 1 failed: total probability is not 1.");
assert(P(1) == 1, "Test 1 failed: initial state is not III (state 0).");

%% Test 2: 任意の非ゼロマスク ms を p = 0.01 で 1 回適用したとき、
%          P(III) = 1-p で、他のどこか1箇所に p が乗るか

% ★ Test2 の中でもう一度 P を定義し直す必要がある
P = zeros(64,1);
P(1) = 1.0;   % state 0: III

p  = 0.01;
ms = uint8(5);    % 0でなければ何でもOK（エンコードには依存しない）

Pnew = zeros(64,1);
for i = 0:63
    prob_i = P(i+1);
    if prob_i == 0
        continue;
    end

    % 発火しない: 状態 i に残る
    Pnew(i+1) = Pnew(i+1) + (1-p) * prob_i;

    % 発火する: XOR で状態 j に移る
    j = bitxor(uint8(i), ms);
    Pnew(double(j)+1) = Pnew(double(j)+1) + p * prob_i;
end

% 1. III の確率が 1-p か？
assert(abs(Pnew(1) - (1-p)) < tol, "Test 2 failed: P(III) should be 1-p.");

% 2. 他のどこか1箇所に p が乗っていて、それ以外は 0 か？
idx = find(Pnew > tol);  % 有意な確率が乗っているインデックス
assert(numel(idx) == 2, "Test 2 failed: there should be exactly 2 non-zero entries.");
assert(idx(1) == 1, "Test 2 failed: first non-zero entry must be III (index 1).");
k = idx(2);              % III 以外のインデックス
assert(abs(Pnew(k) - p) < tol, "Test 2 failed: the non-III state should have probability p.");

%% Test 3: XOR の自己反転性の確認 (ms ⊕ ms = III)

ms = uint8(5);                 % Test2 と同じ ms を再定義
i_state = ms;                  % ある error-state を仮定
j_state = bitxor(i_state, ms); % 同じ ms をもう一度かける

assert(j_state == 0, "Test 3 failed: ms ⊕ ms should return to III (state 0).");

%% Test 4: 更新後も確率の合計が 1 になっているか

% Test2 で計算した Pnew は、そのセクション内のローカル変数なので、
% Test4 ではもう一度計算をやり直す必要がある

P = zeros(64,1);
P(1) = 1.0;
p  = 0.01;
ms = uint8(5);

Pnew = zeros(64,1);
for i = 0:63
    prob_i = P(i+1);
    if prob_i == 0
        continue;
    end

    Pnew(i+1) = Pnew(i+1) + (1-p) * prob_i;
    j = bitxor(uint8(i), ms);
    Pnew(double(j)+1) = Pnew(double(j)+1) + p * prob_i;
end

assert(abs(sum(Pnew) - 1) < tol, "Test 4 failed: total probability is not 1 after update.");