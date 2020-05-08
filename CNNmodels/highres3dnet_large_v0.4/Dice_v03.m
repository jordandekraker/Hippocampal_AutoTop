addpath(genpath('tools'));

%% postprocessing

subs = ls('CNNmodels/highres3dnet_large_v0.4/parcellation_output/*.nii.gz');
subs = strsplit(subs)';
subs(end) = [];

for s = 1:length(subs)
	in = subs{s};
	outdir = subs{s}(1:end-21);
    if ~exist([outdir '/labelmap-postProcess.nii.gz'],'file')
	try
	postprocess_labelmap(in,outdir);
    end
    end
end

%% scores without postprocessing

subs_ground = ls('trainingdata_v0.4/*_lbl.nii.gz');
subs_ground = strsplit(subs_ground)';
subs_ground(end) = [];
sub_match = strrep(subs_ground,'-','');

for s = 1:length(subs)
    lbl_inference = load_untouch_nii(subs{s});
    i = strfind(subs{s}(1:end-21),'/');
    idx = find(contains(sub_match,subs{s}(i(end)+1:end-21)));
    lbl_ground = load_untouch_nii(subs_ground{idx});
    
	dice_niftynet(:,s) = dice(double(lbl_inference.img),double(lbl_ground.img));
    
    try % in case postprocessing failed
    lbl_postprocessed = load_untouch_nii([subs{s}(1:end-21) '/labelmap-postProcess.nii.gz']);
	dice_postprocessed(:,s) = dice(double(lbl_postprocessed.img),double(lbl_ground.img));
    end
end

save('diceScores');

%% plot
close all;
load('misc/itkColours.mat');

x = [1:8 11:18];
y = [nanmean(dice_niftynet') nanmean(dice_postprocessed')];
s = [nanstd(dice_niftynet') nanstd(dice_postprocessed')];
c = [itkColours' itkColours']/255;
figure; hold on;
b = bar(x,y,'FaceColor','flat');
errorbar(x,y,s,'k','lineStyle','none');
b.CData = c';
xticklabels({'' '' 'Dice scores CNN only' '' '' '' '' 'Dice score after postprocessing'});
ylim([0 1]);

savefig('Dice_v04');