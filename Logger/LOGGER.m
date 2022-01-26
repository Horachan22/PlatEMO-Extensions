%{
===================================================================
Project Name    : PlatEMO
File Name       : LOGGER.m
Encoding        : UTF-8
Creation Date   : 2022/01/18
===================================================================
%}

classdef LOGGER
    properties
        in_path       % Dataフォルダへのパス
        method        % ログをとる手法
        problem       % 問題
        log_name_list % ログの種類
        M             % 目的数
        D             % 次元数
        max_trial     % 試行回数
        FEs           % 評価回数
    end

    methods
        %% コンストラクタ
        function obj = LOGGER(inpath, method, problem, log_name_list, M, D, max_trial, FEs)
            obj.in_path       = inpath;
            obj.method        = method;  
            obj.problem       = problem;
            obj.log_name_list = log_name_list;
            obj.M             = M;   
            obj.D             = D;  
            obj.max_trial     = max_trial; 
            obj.FEs           = FEs;
        end

        %% 結果データの読み込み
        function archive = read_archive(obj, trial)
            format    = '/%s/%s_%s_M%d_D%d_%d.mat';
            file_name = sprintf(format, obj.method, obj.method, obj.problem, obj.M, obj.D, trial);
            file_name = strcat(obj.in_path, file_name); 
            archive   = load(file_name).result{end, 2};
            return
        end

        %% ログの取得
        function log = get_log(obj, log_num)
            log = [];
            for trial = 1 : obj.max_trial
                trial_log = [];
                archive   = obj.read_archive(trial);
                if length(archive) >= obj.FEs
                    for FE = 1 : obj.FEs
                        solution = archive(FE);
                        if isempty(solution.add)
                            % 初期個体のログ
                            trial_log = [trial_log; 0];
                        else
                            trial_log = [trial_log; solution.add(log_num)];
                        end
                    end
                else
                    format = 'Error: アーカイブの個体数が評価回数より少ないです。(%s_%s_M%d_D%d_%dtrial)';
                    msg = sprintf(format, obj.method, obj.problem, obj.M, obj.D, trial);
                    error(msg);
                end
                log = [log, trial_log];
            end
            return
        end

        %% ログの整理(matファイル出力)
        function sort_log(obj, log_num)
            % 手法フォルダの設定
            formatSpec = "./Log/%s";
            out_path   = sprintf(formatSpec, obj.method);
            if exist(out_path) ~= 7
                mkdir(out_path);
            end
            
            log        = obj.get_log(log_num);
            log_name   = obj.log_name_list(log_num);
            
            format = "./Log/%s/%s_%s_M%d_D%d.mat";
            file_name = sprintf(format, obj.method, log_name, obj.problem, obj.M, obj.D);
            LOG_summary.log_list = log;
            save(file_name, '-struct', 'LOG_summary');
            fprintf('%s generated \n', file_name);
        end
    end
end