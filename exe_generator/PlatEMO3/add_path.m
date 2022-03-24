function add_path()
    cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));
end