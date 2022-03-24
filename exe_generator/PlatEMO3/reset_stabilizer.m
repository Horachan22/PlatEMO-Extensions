function reset_stabilizer()
    % リセットファイルの読み込み
    cmd_file  = fopen("true_command.m", "r");
    line      = 1;
    text_data = fgets(cmd_file);
    while ischar(text_data)
        str(line) = cellstr(text_data);
        text_data = fgets(cmd_file);
        line      = line + 1; 
    end
    fclose(cmd_file);

    % seed_stabilizerの初期化
    total_line  = length(str);
    cmd_file    = fopen("seed_stabilizer.m", "w");
    for i = 1 : total_line
        fprintf(cmd_file, '%s\n', str{i});
    end
    fclose(cmd_file);
end
