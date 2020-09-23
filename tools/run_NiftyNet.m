function run_NiftyNet(img,outdir,CNNmodel)

% runs niftynet inference on a single image. Edit this file to specify a
% new config file.

% don't overwrite existing files
if ~exist('CNNmodel','var')
    CNNmodel = 'highres3dnet_large_v0.4';
end

if ~exist([outdir '/niftynet_lbl.nii.gz'],'file')

tmpdir = [outdir '/tmp/'];
mkdir(tmpdir);
% make absolute dir
tmp = dir(tmpdir);
tmpdir = tmp.folder;

%copy model to local folder since niftynet requires write access to folder (i.e. cannot be in the container)
cp_cmd = ['cp -Rv ' getenv('AUTOTOP_DIR') '/CNNmodels/' CNNmodel ' ' tmpdir];
system(cp_cmd);

% get config and model dir
configfile = [tmpdir '/' CNNmodel '/config.ini'];
tmp = dir(configfile);
modeldir = tmp.folder;
% get output name without dir or extension
tmp = dir(img);
outname = tmp.name(1:strfind(tmp.name,'.nii')-1);

%% make and format new config file
%NOTE: dataset_split.csv must not be in the model directory

[k,~,~] = inifile(configfile,'readall');
c = size(k,1);
i = strfind(k,'save_seg_dir');
Index = find(not(cellfun('isempty',i)));
k{Index+c} = [tmpdir '/'];
i = strfind(k,'model_dir');
Index = find(not(cellfun('isempty',i)));
k{Index+c} = modeldir;
i = strfind(k,'image');
Index = find(not(cellfun('isempty',i)));
k{Index+c} = 'INFERENCEDATA';    
% make new inference dataset by copying t2-like
i = strfind(k,'t2-like');
Index = find(not(cellfun('isempty',i)));
inf = k(Index,:);
d = size(inf,1);
inf(:,1) = {'INFERENCEDATA'};
i = strfind(inf,'path_to_search');
Index = find(not(cellfun('isempty',i)));
inf{Index} = 'csv_file';
inf{Index+d} = [tmpdir '/fn.csv']; % this should cause other inputs to be ignored
k = [k; inf];
for i = 1:size(k,1)
    k{i,1} = upper(k{i,1}); % is this causing problems with lbl and T2-like?
end
inifile([tmpdir '/CNNinference_config.ini'],'new');
inifile([tmpdir '/CNNinference_config.ini'],'write',k);

%% write a fn.csv file containing the one input subject file

fid = fopen([tmpdir '/fn.csv'], 'wt' );
fprintf(fid,[outname ',' img]);
fclose(fid);

%% now run through the network
disp(['net_segment -c ' tmpdir '/CNNinference_config.ini inference']);
t = system(['net_segment -c ' tmpdir '/CNNinference_config.ini inference']);
if t~=0
    warning('Could not find NiftyNet, checking for local container');
    tt = system(['singularity exec '...
    '--nv ' getenv('AUTOTOP_DIR') '/containers/deeplearning_gpu.simg net_segment '...
    '-c ' tmpdir '/CNNinference_config.ini inference']);
    if tt~=0
        error('Could not run NiftyNet on local container');
    end
end

% niftynet output filename seems to have changed in niftynet 0.6.0 (req'd for singularity build)
% so we get the filename from the inferred.csv file instead of hard-coding it..
csv = readtable([tmpdir '/inferred.csv'],'HeaderLines',0,'Delimiter',',','ReadVariableNames',false);
nifty_out = csv.Var2{1};

system(['mv ' nifty_out  ' ' outdir '/niftynet_lbl.nii.gz']);
end

if ~exist([outdir '/niftynet_lbl.nii.gz'],'file')
    error('NiftyNet output not found')
end

