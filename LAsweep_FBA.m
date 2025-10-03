r = 3;
k_total = 30;
N = 1000;

LA_values = 1:0.5:9;
num_LA = numel(LA_values);

Best_Allocations = zeros(num_LA, 1);
MaxRates = zeros(num_LA, 1);

parfor idx = 1:num_r
    LA = LA_values(idx);
    try
        [Best_Allocation, MaxRate] = Find_Best_Allocation(k_total, LA, r, N);

        Best_Allocations(idx) = Best_Allocation;
        MaxRates(idx) = MaxRate;

        fprintf('LA=%.2f → Best=%.3f, MaxRate=%.3e\n', LA, Best_Allocation, MaxRate);
    catch ME
        % エラーを出したrの情報を表示
        fprintf('⚠️ Error at r=%.2f: %s\n', LA, ME.message);
        Best_Allocations(idx) = NaN;
        MaxRates(idx) = 0;
    end
end


Result_Table = table(LA_values', Best_Allocations, MaxRates, ...
    'VariableNames', {'LA', 'Best_Allocation', 'MaxRate'});
disp(Result_Table);
writetable(Result_Table, 'LAsweep_r=3.csv');

