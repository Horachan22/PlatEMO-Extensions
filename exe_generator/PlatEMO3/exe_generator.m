function exe_generator()
    % 設定
    outpath = './exe'; % path to executable file
    file_name = 'CLUSTER01';

    % exeファイル生成
    compiler.build.standaloneApplication('seed_stabilizer.m','OutputDir',outpath,'ExecutableName',file_name);
    fprintf('%s.exe generated \n',file_name);
end
