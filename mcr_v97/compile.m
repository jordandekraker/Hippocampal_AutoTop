% compile hippocampal autotop
% NOTE: move up one directory before running

%ensure your path is cleared before doing this..
addpath(genpath('tools'));

%mcr_v97 for R2019b
mkdir('mcr_v97')
mcc -m -d mcr_v97 AutoTops_TransformAndRollOut.m
mcc -m -d mcr_v97 singleSubject.m

% NOTE: when building dockerfile, ensure everything is chmod a+rwx, no matlab addpath() is called, and no extra example or simg files are present.
