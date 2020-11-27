### Summary

This tool aims to automatically model the topological folding structure of the human hippocampus. This can then be used to apply the hippocampal unfolding methods presented in [DeKraker et al., 2019](https://www.sciencedirect.com/science/article/pii/S1053811917309977), and ex-vivo subfield boundaries can be topologically applied from [DeKraker et al., 2020](https://www.sciencedirect.com/science/article/pii/S105381191930919X?via%3Dihub).

Currently optimized for 0.7mm isotropic T2w data from the HCP1200 dataset, but options for T1w and DWI data also exist. 

This repo supports end-end processing of data that is registered to MNI152, runs on single images, and is intended for testing purposes. For BIDSapp that support multiple images, preprocessing, alignment, and more, see https://github.com/khanlab/hippunfold.

### Installation

The preferred method to run the code is through Docker or Singularity, using the container provided. 
`singularity pull docker://jordandekraker/hippocampal_autotop:latest hippocampal_autotop_latest.sif`

### Usage
`singularity run --nv hippocampal_autotop_latest.sif <input image> <output directory> <(optional) modality \['HCP1200-T2', 'HCP1200-T1', or 'HCP1200-b1000'\]> <(optional) manual segmentation image>`

For example:
```
singularity run --nv hippocampal_autotop_latest.sif \
example/HCP_100206/sub-100206_acq-procHCP_T2w.nii.gz \
test/HCP_100206/
```
Can also be run directly from MATLAB (clone repo and place `hippocampal_autotop_latest.sif` in `containers/`). See `help singleSubject` or, if data is already cropped & coronal oblique `help AutoTops_TransformAndRollOut`

### Pipeline Overview

![Pipeline Overview](https://github.com/jordandekraker/Hippocampal_AutoTop/blob/master/misc/pipeline_overview.png)

The overall workflow can be summarized in the following steps:

0) Resampling to a 0.3mm isotropic, coronal oblique, cropped hippocampal block

1) Automatic segmentation of hippocampal tissues and surrounding structures via deep convolutional neural network U-net ([Li _et al_., 2017](https://arxiv.org/abs/1707.01992)) _OR_ Manual segmentation of hippocampal tissues and surrounding structures using [this](https://ars.els-cdn.com/content/image/1-s2.0-S1053811917309977-mmc1.pdf) protocol

2) Post-processing via fluid label-label registration to a high resolution, topoligically correct averaged template

3) Imposing of coordinates across the anterior-posterior, proximal-distal, and laminar dimensions of hippocampal grey matter via solving the Laplace equation

4) Extraction of a grey matter mid-surface and morpholigical features (thickness, curvature, gyrification index, and, if available, quantitative MRI values sampled along the mid-surface for reduced partial-voluming)

5) Quality assurance via inspection of Laplace gradients, grey matter mid-surface, and flatmapped features

6) Application of subfield boundaries according to predifined topological coordinates

#### Processing time for a single subject:

With GPU: 15 minutes (8-core, 32gb memory, Tesla T4)
Wihout GPU: ~30 minutes (8-core, 32gb memory) 

Note: the same container has both GPU and CPU versions, will run using CPU if a GPU is not found.
