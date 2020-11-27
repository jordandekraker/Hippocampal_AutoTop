nInf = 0.15;
nVal = 0.15;
nTrain = 0.7;

subs = ls('/scratch/jdekrake/training_data_b1000/*_lbl.nii.gz');
subs = strsplit(subs)';
subs(end) = [];
for s = 1:length(subs)
    i = strfind(subs{s},'/');
    ii = strfind(subs{s},'_hemi-');
    fID{s} = subs{s}(i(end)+1:ii);
end

fID = unique(fID);
fID = fID(randperm(numel(fID)))';


fn = fopen('dataset_split.csv','w');
n = round(length(fID)*nInf);
i = [1:n];
v = [n+1:n*2];
t = [(n*2)+1:length(fID)];

for s=i
    out = [fID{s} 'hemiR_'];
    fprintf(fn,['\n' out ',inference']);
    out = [fID{s} 'hemiL_'];
    fprintf(fn,['\n' out ',inference']);
end
for s=v
    out = [fID{s} 'hemiR_'];
    fprintf(fn,['\n' out ',validation']);
    out = [fID{s} 'hemiL_'];
    fprintf(fn,['\n' out ',validation']);
end
for s=t
    out = [fID{s} 'hemiR_'];
    fprintf(fn,['\n' out ',training']);
    out = [fID{s} 'hemiL_'];
    fprintf(fn,['\n' out ',training']);
end
fclose(fn);
