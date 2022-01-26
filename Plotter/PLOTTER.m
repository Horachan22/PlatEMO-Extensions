%{
===================================================================
Project Name    : PlatEMO
File Name       : PLOTTER.m
Encoding        : UTF-8
Creation Date   : 2022/01/26
===================================================================
%}

classdef PLOTTER
    properties
        inpath        % Dataフォルダへのパス
        method        % プロットする手法
        problem       % 問題
        N             % 個体数
        M             % 目的数
        D             % 次元数
        max_trial     % 試行回数
        FEs           % 評価回数
    end

    methods
        %% コンストラクタ
        function obj = PLOTTER(inpath, method, problem, M, D, max_trial, FEs)
            obj.inpath    = inpath;
            obj.method    = method;
            obj.problem   = problem;
            obj.M         = M;
            obj.D         = D;
            obj.max_trial = max_trial;
            obj.FEs       = FEs;
        end

        %% 結果データの読み込み
        function archive = read_archive(obj, trial)
            format    = '/%s/%s_%s_M%d_D%d_%d.mat';
            file_name = sprintf(format, obj.method, obj.method, obj.problem, obj.M, obj.D, trial);
            file_name = strcat(obj.inpath, file_name);
            archive   = load(file_name).result{end, 2};
            return
        end

        %% 目的関数値の取得
        function objs = get_objs(obj, archive)
            objs = [];
            for FE = 1 : obj.FEs
                solution = archive(FE);
                objs = [objs; solution.obj];
            end
            not_dominated = NDSort(objs, 1) == 1;
            onjs          = archive(not_dominated).objs;
            return
        end

        %% プロットと画像ファイルの保存
        function save_pareto(obj, objs)
            % 画像保存先
            formatSpec = './Pareto/%s';
            outpath    = sprintf(formatSpec, obj.method);
            if exist(outpath) ~= 7
                mkdir(outpath);
            end

            % 描画
            f_1 = transpose(objs(:, 1));
            f_2 = transpose(objs(:, 2));
            f_3 = transpose(objs(:, 3));
            figure('Visible', 'off');
            plot3(f_1, f_2, f_3,'o', 'MarkerFaceColor', '#D9FFFF');
            title_format = '%s M3 D%d FE%d';
            fig_title    = sprintf(title_format, obj.problem, obj.D, obj.FEs);
            title(fig_title);
            xlabel('f_1(x)');
            ylabel('f_2(x)');
            zlabel('f_3(x)');
            grid on;

            % 画像出力
            format    = './Pareto/%s/%s_M3_D%d_FE%d.png';
            file_name = sprintf(format, obj.method, obj.problem, obj.D, obj.FEs);
            saveas(gcf, file_name);
            fprintf('%s generated \n', file_name);
        end
    end
end