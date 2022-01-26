%{
===================================================================
Project Name    : PlatEMO
File Name       : main_plotter.m
Encoding        : UTF-8
Creation Date   : 2022/01/26
===================================================================
%}

% このプログラムは目的数Mが3の場合のパレート解をプロットします。

function main_plotter()
    inpath       = './Data';         % データが保存されているフォルダ
    method_list  = ["DSEADv2_1"];    % 対象手法
    problem_list = ["MaF1","MaF2","MaF3","MaF4","MaF5","MaF6","MaF7","MaF10","MaF11","MaF12","MaF13"];        % 対象問題
    constant_M   = 3;                % 目的数(変更不可)
    D_list       = [20, 150];             % 次元数
    FEs_list     = [300, 500, 1000];            % パレート解表示評価回数
    max_trial    = 1;                % 試行回数

    %% 画像保存
    for method = method_list
        for FEs = FEs_list
            for D = D_list
                for problem = problem_list
                    for trial = 1 : max_trial
                        plotter = PLOTTER(inpath, method, problem, constant_M, D, max_trial, FEs);
                        archive = plotter.read_archive(trial);
                        objs    = plotter.get_objs(archive);
                        plotter.save_pareto(objs);
                    end
                end
            end
        end
    end
end