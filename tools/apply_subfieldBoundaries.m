function apply_subfieldBoundaries(outprefix)

% topologically apply manually-defined (and confirmed with unsupervised
% clustering) subfield boundaries from DeKraker et al. 2019 (NeuroImage)
% (Averaged across left and right hippocampus)

load([outprefix 'unfold.mat']);
load([outprefix 'surf.mat']);

% get BigBrain boundaries
load('misc/BigBrain_ManualSubfieldsUnfolded.mat');
subfields_avg = imresize(subfields_avg,0.5,'nearest');

Laplace_AP = ceil(Laplace_AP * APres);
Laplace_PD = ceil(Laplace_PD * PDres);

subfields = zeros(sz);
for AP = 1:APres
    for PD = 1:PDres
        idx = find(Laplace_AP==AP & Laplace_PD==PD);
        if ~isempty(idx)
            subfields(idxgm(idx)) = subfields_avg(AP,PD);
        end
    end
end
% also add DG
subfields(sinkPD) = 6;

origheader.img = subfields;
save_untouch_nii(origheader,[outprefix 'subfields-BigBrain.nii.gz']);
