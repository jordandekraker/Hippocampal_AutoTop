FROM continuumio/anaconda3:2019.03

MAINTAINER <jordandekraker@gmail.com>

# base directory for Hippocampal_AutoTop
RUN mkdir -p /src/ 
ENV AUTOTOP_DIR=/src

ENV ANTSPATH="/opt/ants-2.3.1"
ENV PATH="/opt/ants-2.3.1:$PATH"
ENV PATH="/opt/c3d/bin:$PATH"
ENV FSLDIR="/opt/fsl-5.0.11"
ENV PATH="/opt/fsl-5.0.11/bin:$PATH"
ENV FSLOUTPUTTYPE=NIFTI_GZ
ENV FSLMULTIFILEQUIT=TRUE

# software dependencies
RUN export PATH=/opt/conda/bin:$PATH
RUN apt-get update
RUN apt-get install -y git
RUN git clone https://github.com/jordandekraker/Hippocampal_AutoTop.git /src/
RUN apt-get install -y tree unzip default-jre #jre required for MCR
RUN conda update conda
RUN conda update --all
RUN pip install --upgrade pip
RUN conda install tensorflow-gpu==1.14
RUN conda install -c anaconda opencv
RUN conda install -c anaconda scikit-learn
RUN conda install -c simpleitk simpleitk
RUN conda install -c anaconda pyyaml
RUN pip install niftynet==0.6.0
RUN pip install niwidgets==0.1.3
RUN mkdir -p /opt/ants-2.3.1
RUN curl -fsSL --retry 5 https://dl.dropbox.com/s/1xfhydsf4t4qoxg/ants-Linux-centos6_x86_64-v2.3.1.tar.gz \
| tar -xz -C /opt/ants-2.3.1 --strip-components 1
RUN mkdir -p /opt/fsl-5.0.11
RUN curl -fsSL --retry 5 https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.11-centos6_64.tar.gz \
| tar -xz -C /opt/fsl-5.0.11 --strip-components 1
RUN mkdir -p /opt/mcr-install
RUN curl -L --retry 5 https://ssd.mathworks.com/supportfiles/downloads/R2019b/Release/5/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2019b_Update_5_glnxa64.zip > /opt/mcr-install/install.zip
RUN unzip /opt/mcr-install/install.zip -d /opt/mcr-install
RUN /opt/mcr-install/install -mode silent -agreeToLicense yes -destinationFolder /opt/mcr
RUN rm -rf /opt/mcr-install
RUN mkdir -p /opt/c3d
RUN curl -s -L --retry 6 http://downloads.sourceforge.net/project/c3d/c3d/Experimental/c3d-1.1.0-Linux-gcc64.tar.gz  | tar zx -C /opt/c3d --strip-components=1

# download reference atlases
RUN curl -s -L --retry 6  https://www.dropbox.com/s/40xtlok0ns4bo7j/atlases_CITI.tar | tar x -C /src
RUN curl -s -L --retry 6  https://www.dropbox.com/s/g3jjqbrx62m9roo/atlases_UPenn_ExVivo.tar | tar x -C /src
RUN chmod a+rX -R /src


# Note: this line currently causes the Docker build to fail.
# In the singularity recipe, this line is used to run singleSubject.sh on the input+output. 
# In Docker, the input+output will instead have to be mounted, and its not clear whether a 
# this code can be called in such an elegant manner. May make sense to create a python wrapper
# that is BIDS-compliant FIRST and then call that inside the Docker container...
# ENTRYPOINT /src/mcr_v97/run_singleSubject.sh /opt/mcr/v97 $@
