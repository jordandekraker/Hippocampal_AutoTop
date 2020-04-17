### Summary

This tool aims to automatically model the topological folding structure of the human hippocampus. It is currently set up to use sub-millimetric T2w MRI data, but may be adapted for other data types. This can then be used to apply the hippocampal unfolding methods presented in [this paper](https://www.sciencedirect.com/science/article/pii/S1053811917309977), and ex-vivo subfield boundaries can be topologically applied from [this paper](https://www.sciencedirect.com/science/article/pii/S105381191930919X?via%3Dihub).

The overall workflow can be summarized in the following steps:

0) Resampling to a 0.3mm isotropic, coronal oblique, cropped hippocampal block

1) Automatic segmentation of hippocampal tissues and surrounding structures via deep convolutional neural network U-net ([Li _et al_., 2017](https://arxiv.org/abs/1707.01992)) _OR_ Manual segmentation of hippocampal tissues and surrounding structures using [this](https://ars.els-cdn.com/content/image/1-s2.0-S1053811917309977-mmc1.pdf) protocol

2) Post-processing via fluid label-label registration to a high resolution, topoligically correct averaged template

3) Imposing of coordinates across the anterior-posterior, proximal-distal, and laminar dimensions of hippocampal grey matter via solving the Laplace equation

4) Extraction of a grey matter mid-surface and morpholigical features (thickness, curvature, gyrification index, and, if available, quantitative MRI values sampled along the mid-surface)

5) Quality assurance via inspection of Laplace gradients, grey matter mid-surface, and flatmapped features

6) Application of subfield boundaries according to predifined topological coordinates

### Installation

_under development_

Currently, Matlab code is provided for steps 2-6, with [these dependencies](https://github.com/khanlab/neuroglia-core)

Coming soon: fully containerized BIDSapp with MCR compiled Matlab code and all dependencies.

### Examples

Simple example Matlab scripts are provided showing batching of subjects that are already resampled, or running a new subject starting from a whole-brain T2w image.

If you are using ComputeCanada, you can adapt one of the example scripts for your file names & directories and then submit it using:
```
regularSubmit matlab -r example_batchScript_manualSeg
```
_Note:_ you must have neuroglia-core, neuroglia-helpers, and matlab (license + module loaded). See the Khan lab ComputeCanada wiki (or request access) at https://osf.io/4u5jr.

### Fully automated version

_under development_

This section breaks down the step 1) above into more detail. Note that all fully-automated segmentation and unfolding should be inspected prior to drawing conclusions! Useful tools are included for visualization.



