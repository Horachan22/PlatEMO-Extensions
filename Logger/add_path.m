%{
===================================================================
Project Name    : PlatEMO
File Name       : add_path.m
Encoding        : UTF-8
Creation Date   : 2022/01/11
===================================================================
%}


function add_path()
    if ~isdeployed()
        cd(fileparts(mfilename('fullpath')));
        addpath(genpath(cd));
    end
end