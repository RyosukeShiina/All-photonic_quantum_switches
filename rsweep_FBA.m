LA = 3;
k_total = 30;
N = 1000;

r_values = 1:0.5:5;
num_r = numel(r_values);

Best_Allocations = zeros(num_r, 1);
MaxRates = zeros(num_r, 1);

parfor idx = 1:num_r
    r = r_values(idx);
    try
        [Best_Allocation, MaxRate] = Find_Best_Allocation(k_total, LA, r, N);

        Best_Allocations(idx) = Best_Allocation;
        MaxRates(idx) = MaxRate;

        fprintf('r=%.2f → Best=%.3f, MaxRate=%.3e\n', r, Best_Allocation, MaxRate);
    catch ME
        % エラーを出したrの情報を表示
        fprintf('⚠️ Error at r=%.2f: %s\n', r, ME.message);
        Best_Allocations(idx) = NaN;
        MaxRates(idx) = 0;
    end
end


Result_Table = table(r_values', Best_Allocations, MaxRates, ...
    'VariableNames', {'r', 'Best_Allocation', 'MaxRate'});
disp(Result_Table);
writetable(Result_Table, 'k_sweep_LA=3.csv');

