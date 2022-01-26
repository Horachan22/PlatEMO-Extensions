%{
===================================================================
Project Name    : PlatEMO
File Name       : main_logger.m
Encoding        : UTF-8
Creation Date   : 2022/01/11
===================================================================
%}

function main_logger()
    inpath           = './Data';                             % データが保存されているフォルダ
    method_list      = ["KRVEA"];                            % 対象手法
    MaF              = ["MaF1", "MaF2", "MaF3"];
    problem_list     = MaF;                                  % 対象問題
    log_name_list    = ["tau", "time", "flag"];              % ログの名前
    log_type_list    = ["AVE", "VAL", "CNT"];                % ログの処理タイプ
    %
    % ログ処理タイプ一覧
    %   "NAN"   処理スキップ
    %   "AVE"   平均値
    %   "MED"   中央値(未実装)
    %   "MAX"   最大値(未実装)
    %   "MIN"   最小値(未実装)
    %   "P25"   第１四分位数(未実装)
    %   "P75"   第３四分位数(未実装)
    %   "STD"   標準偏差(未実装)
    %   "SUM"   合計(未実装)
    %   "VAL"   指定評価回数のときのログ値
    %   "CNT"   整数フラグの回数カウント
    %
    cnt_list         = [1, 2, 3, 4, 5, 6];            % カウントする整数フラグ
    M_list           = [3, 7, 11];                    % 目的数
    D_list           = [150];                         % 次元数
    N                = 100;                           % 個体数
    max_FE           = 1000;                          % 最大評価回数
    FEs_list         = [300, 500, 1000];              % ログ取得評価回数
    max_trial        = 11;                            % 試行回数
    % two-layered approachを用いる手法(随時追加)
    two_layer_method = ["KRVEA", "MCEAD", "MOEADEGO"];

    %% ログ整理
    for log_num = 1 : length(log_name_list)
        if log_name_list(log_num) == "NAN"
            ...
        else
            for method = method_list
                for problem = problem_list
                    for M = M_list
                        for D = D_list
                            logger = LOGGER(inpath, method, problem, log_name_list, M, D, max_trial, max_FE);
                            logger.sort_log(log_num);
                        end
                    end
                end
            end
        end
    end

    %% 新規ログをパスに追加
    add_path();

    %% ログ処理
    for method = method_list
        for FEs = FEs_list
            for log_num = 1 : length(log_name_list)
                log_set = [];
                log_name = log_name_list(log_num);
                log_type = log_type_list(log_num);
                if log_type == "NAN"
                    ...
                else
                    for D = D_list
                        for problem = problem_list
                            for M = M_list
                                %% 初期個体数(two-layered approach)
                                if ismember(method, two_layer_method)
                                    switch M
                                        case 3
                                            N = 91;
                                        case 7
                                            N = 91;
                                        case 11
                                            N = 77;
                                    end
                                end
                                data = read_data(method, problem, log_name, M, D);
                                if log_type == "AVE"
                                    log = average_getter(data, N, max_trial, FEs);
                                elseif log_type == "MED"
                                    ...
                                elseif log_type == "MAX"
                                    ...
                                elseif log_type == "MIN"
                                    ...
                                elseif log_type == "P25"
                                    ...
                                elseif log_type == "P75"
                                    ...
                                elseif log_type == "STD"
                                    ...
                                elseif log_type == "VAL"
                                    log = value_reader(data, max_trial, FEs);
                                elseif log_type == "CNT"
                                    log = flag_counter(data, cnt_list, N, max_trial, FEs);
                                end
                                add     = [problem, M, D, log];
                                log_set = [log_set; add];
                            end
                        end
                    end

                    %% ログ出力
                    write_log(log_name, log_set, method, FEs)
                end
            end
        end
    end
end

%% ログの読み込み
function data = read_data(method, problem, log_name, M, D)
    in_path   = './Log';
    format    = '/%s/%s_%s_M%d_D%d.mat';
    file_name = sprintf(format, method, log_name, problem, M, D);
    file_name = strcat(in_path, file_name);
    data  = load(file_name).log_list;
end

%% ログの出力(excelファイル出力)
function write_log(log_name, log_set, method, FEs)
    out_path  = "./Log";
    if exist(out_path) ~= 7
        mkdir(out_path);
    end
    format    = "/%s_%s_%d.xlsx";
    file_name = sprintf(format, log_name, method, FEs);
    writematrix(log_set, out_path + file_name);
    fprintf('%s generated \n', file_name);
end
