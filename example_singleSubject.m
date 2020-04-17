% submit this script on ComputeCanada using Neuroglia-helpers with the
% following line (assuming you are in your Hippocampal_AutoTop directory):
% 
% regularSubmit matlab -r example_singleSubject

addpath(genpath('tools'));

inimg = '../Roy_MTLatlas/img.nii.gz';
inlbl = '../Roy_MTLatlas/manual_lbl.nii.gz';
outdir = '../Roy_MTLatlas/';

AutoTops_TransformAndRollOut(inimg,outdir,inlbl)
