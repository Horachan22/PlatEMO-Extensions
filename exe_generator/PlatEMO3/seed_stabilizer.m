function seed_stabilizer()
    cd './..';

    problems = {@MaF1, @MaF2, @MaF3, @MaF4, @MaF5, @MaF6, @MaF7, @MaF10, @MaF11, @MaF12, @MaF13};

    M_list = [3, 7];
    D_list = [20, 50];
    FEs = 1000;
    N = 100;
    methods = {@MCEAD, @DSEAD};

    trial = 1;
    trial_start = trial;
    trial_end   = trial;
    result_num  = 1;

    loop = false; % if true, loop until successful execution

    %% experiment
    for i = trial_start : trial_end
        rng(i);
        for D = D_list
            for M = M_list
                for problem = problems
                    for method = methods
                        if loop
                            err = true;
                            while err
                                try
                                    platemoEX('problem', problem, 'algorithm', method,'N', N, 'M', M, 'D', D, 'run', i, 'maxFE', FEs, 'save', result_num);
                                    err = false;
                                catch
                                    message = sprintf('D%d_M%d_%s %s trial %d is failed to run.', D,M,func2str(cell2mat(problem)),func2str(cell2mat(method)),i);
                                    disp(message);
                                end
                            end
                        else
                            platemoEX('problem', problem, 'algorithm', method,'N', N, 'M', M, 'D', D, 'run', i, 'maxFE', FEs, 'save', result_num);
                        end
                    end
                end
            end
        end
    end
end
