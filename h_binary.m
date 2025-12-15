function h = h_binary(p)
% h_binary(p) = -p log2 p - (1-p) log2(1-p)
% (with safe handling of p = 0 or 1)
    if any(p < 0 | p > 1)
        error('h_binary: p must be in [0,1].');
    end

    % 数値的不安定対策：0や1のとき log2 を無理に取らない
    if p == 0 || p == 1
        h = 0;
        return;
    end

    h = -p .* log2(p) - (1-p) .* log2(1-p);
end