function seed_stabilizer()
    cd './..';

    problems = {};
    
    M_list = [];
    D_list = [];
    FEs = 1000;
    N = 100;
    methods = {};
   
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