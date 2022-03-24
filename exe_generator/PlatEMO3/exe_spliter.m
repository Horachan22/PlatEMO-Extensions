function exe_spliter()
    % 書き込み用ファイルのリセット
    reset_stabilizer();
    
    % 実験設定
    outpath     = './exe';              % exe作成先
    base_name   = 'CLUSTER13';          % exe名(この下に番号が付加される)
    M_list      = {'3, 7', '11', '15'}; % 目的数
    D_list      = {'20, 50', '150'};    % 次元数
    trial_start = 1;                    % seed begin
    trial_end   = 21;                   % seed end
    FEs         = 1000;                 % 最大評価回数
    % ベンチマーク
    MaF         = {'@MaF1, @MaF2, @MaF3, @MaF4, @MaF5, @MaF6, @MaF7, @MaF10, @MaF11, @MaF12, @MaF13'};
    DTLZ        = {'@DTLZ1, @DTLZ2, @DTLZ3, @DTLZ4, @DTLZ5, @DTLZ6, @DTLZ7'};
    WFG         = {'@WFG1, @WFG2, @WFG3, @WFG4, @WFG5, @WFG6, @WFG7, @WFG8, @WFG9'};
    problems    = MaF;
    % 手法
    methods     = {'@MOEAD, @KRVEA', '@MCEAD'};

    sub_num   = 1;
    for trial = trial_start : trial_end
        for method = methods
            for M = M_list
                for D = D_list
                    for problem = problems
                        % 設定ファイルの読み込み
                        cmd_file  = fopen("seed_stabilizer.m", "r");
                        line      = 1;
                        text_data = fgets(cmd_file);
                        while ischar(text_data)
                            str(line) = cellstr(text_data);
                            text_data = fgets(cmd_file);
                            line      = line + 1; 
                        end
                        fclose(cmd_file);
                    
                        % 設定ファイルの編集
                        total_line  = length(str);
                        M_pat       = 'M_list = [';
                        D_pat       = 'D_list = [';
                        FE_pat      = 'FEs =';
                        method_pat  = 'methods = {';
                        problem_pat = 'problems = {';
                        trial_pat   = 'trial =';
                        cmd_file    = fopen("seed_stabilizer.m", "w");
                        for i = 1 : total_line
                            if contains(str{i}, M_pat)
                                fprintf(cmd_file, '    M_list = [%s];\n', M{:});
                            elseif contains(str{i}, D_pat)
                                fprintf(cmd_file, '    D_list = [%s];\n', D{:});
                            elseif contains(str{i}, FE_pat)
                                fprintf(cmd_file, '    FEs = %d;\n', FEs);
                            elseif contains(str{i}, trial_pat)
                                fprintf(cmd_file, '    trial = %d;\n', trial);
                            elseif contains(str{i}, method_pat)
                                fprintf(cmd_file, '    methods = {%s};\n', method{:});
                            elseif contains(str{i}, problem_pat)
                                fprintf(cmd_file, '    problems = {%s};\n', problem{:});
                            else
                                fprintf(cmd_file, '%s\n', str{i});
                            end
                        end
                        fclose(cmd_file);
                    
                        % exeファイル生成
                        if sub_num < 10
                            format    = base_name + "_0%d";
                        else
                            format    = base_name + "_%d";
                        end
                        file_name = sprintf(format, sub_num);
                        compiler.build.standaloneApplication('seed_stabilizer.m','OutputDir',outpath,'ExecutableName',file_name);
                        fprintf('%s.exe generated \n',file_name);
                        sub_num = sub_num + 1;
                    end
                end
            end
        end
    end
end
