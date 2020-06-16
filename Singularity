Bootstrap: docker
From: continuumio/miniconda3:4.5.4 

#updates:

# 2019-08-21
# remove: conda update conda
# downgrade: opencv==3.3.1

# 2019-06-05
# pytorch 1.1.0
#-----------------------

%setup
mkdir -p $SINGULARITY_ROOTFS/src
cp -Rv . $SINGULARITY_ROOTFS/src

%post

#get CIT atlases from AK dropbox
curl -s -L --retry 6  https://www.dropbox.com/s/40xtlok0ns4bo7j/atlases_CITI.tar | tar x -C /src
#make sure they are all readable
chmod a+rX -R /src

export PATH=/opt/conda/bin:$PATH

#update
apt-get update
apt-get install -y tree unzip default-jre #jre required for MCR
conda update conda
conda update --all
pip install --upgrade pip

#tensorflow
conda install tensorflow-gpu==1.12.0

#pytorch
conda install -c pytorch pytorch==1.1.0 torchvision==0.3.0 cudatoolkit=9.0

#opencv
conda install -c anaconda opencv==3.3.1

#scikit-learn
conda install -c anaconda scikit-learn==0.20.3

#simpleitk
conda install -c simpleitk simpleitk==1.2.0

#niftynet
#need skimage, installed with anaconda3 by default.
conda install -c anaconda pyyaml==3.13
pip install niftynet==0.5.0

#niwidgets
pip install niwidgets==0.1.3

#clean up extra conda tarballs
#conda clean --tarballs

#install ants
mkdir -p /opt/ants-2.3.1
curl -fsSL --retry 5 https://dl.dropbox.com/s/1xfhydsf4t4qoxg/ants-Linux-centos6_x86_64-v2.3.1.tar.gz \
| tar -xz -C /opt/ants-2.3.1 --strip-components 1

#install fsl
mkdir -p /opt/fsl-5.0.11
curl -fsSL --retry 5 https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.11-centos6_64.tar.gz \
| tar -xz -C /opt/fsl-5.0.11 --strip-components 1 

#install mcr
TMP_DIR=/opt/mcr-install
mkdir -p $TMP_DIR
MCR_DIR=/opt/mcr
URL=https://ssd.mathworks.com/supportfiles/downloads/R2019b/Release/5/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2019b_Update_5_glnxa64.zip
curl -L --retry 5 $URL > $TMP_DIR/install.zip
unzip $TMP_DIR/install.zip -d $TMP_DIR
$TMP_DIR/install -mode silent -agreeToLicense yes -destinationFolder $MCR_DIR
rm -rf $TMP_DIR

#install c3d ( c3d_affine_tool)
C3D_VERSION=c3d-1.1.0-Linux-x86_64
C3D_DIR=/opt/c3d
mkdir -p $C3D_DIR
curl -s -L --retry 6 http://downloads.sourceforge.net/project/c3d/c3d/Experimental/c3d-1.1.0-Linux-gcc64.tar.gz  | tar zx -C $C3D_DIR --strip-components=1



%environment

#ants
export ANTSPATH="/opt/ants-2.3.1"
export PATH="/opt/ants-2.3.1:$PATH"

#c3d
export PATH="/opt/c3d/bin:$PATH"

#fsl
export FSLDIR="/opt/fsl-5.0.11"
export PATH="/opt/fsl-5.0.11/bin:$PATH"

#fsl env
export FSLOUTPUTTYPE=NIFTI_GZ
export FSLMULTIFILEQUIT=TRUE


export AUTOTOP_DIR=/src

%runscript
exec /src/mcr_v97/run_singleSubject_mcr.sh /opt/mcr/v97 $@
