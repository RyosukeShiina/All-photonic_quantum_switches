function Rate = Rate_from_QxQzQab(Qx, Qz, Qab)

% Compute secret key rate from Qx, Qz, and Q_AB
%
% Input:
%       Qx  : X-basis error rate (scalar)
%       Qz  : Z-basis error rate (scalar)
%       Qab : error rate (scalar)
%
% Output:
%       Rate : secret key rate (scalar)
%

    % --- precompute probabilities that go into log2 ---
    p1 = 1 - (Qz/2) - Qx;
    p2 = Qx - (Qz/2);

    % domain check (log の中身が負になるのは NG)
    if p1 < 0 || p2 < 0 || (1 - Qz) <= 0
        error('Invalid parameters: argument of log2 must be > 0.');
    end

    % ------------- main terms -------------
    % 0*log2(0) = 0 とみなすために helper を使う
    term1 = safe_p_log2(p1);                   % (1 - Qz/2 - Qx) log2(1 - Qz/2 - Qx)
    term2 = safe_p_log2(p2);                   % (Qx - Qz/2)     log2(Qx - Qz/2)
    term3 = (1 - Qz) * ( 1 - log2(1 - Qz));    % (1 - Qz)(1 - log2(1 - Qz))
    term4 = -h_binary(Qab);                    % - h(Qab)

    % ★ 式(23) には外側の 1+ は無いので、そのまま和を取る
    Rate = max(0, term1 + term2 + term3 + term4);
end

% ===== helper: p*log2(p), with 0*log2(0) := 0 =====
function val = safe_p_log2(p)
    if p == 0
        val = 0;
    else
        val = p .* log2(p);
    end
end

% ===== binary entropy =====
function h = h_binary(p)
    if p < 0 || p > 1
        error('h_binary: p must be in [0,1].');
    end
    if p == 0 || p == 1
        h = 0;
    else
        h = -p .* log2(p) - (1-p) .* log2(1-p);
    end
end