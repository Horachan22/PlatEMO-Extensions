%{
===================================================================
Project Name    : PlatEMO
File Name       : value_reader.m
Encoding        : UTF-8
Creation Date   : 2022/01/21
===================================================================
%}

function val_log = value_reader(data, max_trial, FEs)
    %% 値の読み取り
    val_list = [];
    for trial = 1 : max_trial
        val_trial = data(FEs, trial);
        val_list = [val_list; val_trial];
    end
    val_log = mean(val_list);
end