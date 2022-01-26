%{
===================================================================
Project Name    : PlatEMO
File Name       : average_getter.m
Encoding        : UTF-8
Creation Date   : 2022/01/21
===================================================================
%}

function ave_log = average_getter(data, N, max_trial, FEs)
    %% 平均値
    ave_list = zeros(FEs - N, max_trial);
    for trial = 1 : max_trial
        for FE = N + 1 : FEs
            ave_list(FE - N, trial) = data(FE, trial);
        end
    end
    ave_log = mean(ave_list); % 試行別平均値を取る場合ここまで
    ave_log = mean(ave_log);  % 全体平均値を取る場合ここまで
end
