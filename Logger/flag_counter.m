%{
===================================================================
Project Name    : PlatEMO
File Name       : flag_counter.m
Encoding        : UTF-8
Creation Date   : 2022/01/21
===================================================================
%}

function count_log = flag_counter(data, cnt_list, N, max_trial, FEs)    
    %% フラグカウンター
    tmp = cnt_list;
    for trial = 1 : max_trial
        cnt_trial = zeros(1, size(cnt_list, 2));
        for FE = N + 1 : FEs
            for i = 1 : size(tmp, 2)
                if data(FE, trial) == tmp(i)
                    cnt_trial(i) = cnt_trial(i) + 1;
                end
            end
        end
        if trial == 1
            cnt_list = cnt_trial;
        else
            cnt_list = [cnt_list; cnt_trial];
        end
    end
    count_log = mean(cnt_list);
end