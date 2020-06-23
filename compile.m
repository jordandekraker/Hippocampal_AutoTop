% compile hippocampal autotop

%ensure your path is cleared before doing this..
addpath(genpath('tools'));

%mcr_v97 for R2019b
mkdir('mcr_v97')
mcc -m -d mcr_v97 singleSubject.m
