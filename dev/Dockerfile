# GEA Jupyterlab Dockerfile
#
# Based on Ubuntu
FROM ubuntu:bionic-20181112
#
#
#
# Maintained by
LABEL maintainer="Genomics Education Alliance"
LABEL maintainer_email="genomicseducationalliance@gmail.com"
LABEL version="1.0"
#
USER root
#
# Un-minimize the image to get back Ubuntu
# goodies for teaching Linux/bash (e.g. man files, etc)
# this makes the container big
RUN apt-get update && apt-get upgrade -y --fix-missing && \
(echo y | DEBIAN_FRONTEND=noninteractive sh -x /usr/local/sbin/unminimize)
RUN apt update -y && apt upgrade -y && apt-get install -y --fix-missing\
 software-properties-common\
 apparmor-profiles\
 apt-transport-https\
 build-essential\
 build-essential gcc\
 bzip2\
 curl\
 dialog\
 git\
 gnupg\
 htop\
 libedit2\
 libfreetype6-dev\
 libglib2.0-0\
 libhdf5-dev\
 libncurses5-dev\
 libncursesw5-dev\
 libsm6\
 libssl1.0-dev\
 libsm6\
 libxml2-dev\
 libxrender1\
 libxt-dev\
 libzmq3-dev\
 lsb\
 lsb-release\
 ncurses-term\
 nodejs\
 npm nodejs\
 openssh-server\
 openssl\
 pkg-config\
 python3.6\
 python-requests\
 psmisc\
 sudo\
 zip\
 unzip\
 wget
#
#
#Install iCommands
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.irods.org/apt/ xenial main" > /etc/apt/sources.list.d/renci-irods.list \
    && apt-get update \
    && apt-get install -y irods-icommands \
    && apt-get clean \
    && rm -rf /usr/lib/apt/lists/*
#
#
# Use python to install packages to be used later
RUN sudo apt-get install -y python3-pip
RUN python3 -m pip install\
 numpy\
 scipy\
 matplotlib\
 pandas\
 biopython\
 'plotnine[all]'\
 ipywidgets\
 bash_kernel
RUN python3 -m bash_kernel.install
#
#
# Add the GEA user
RUN useradd -p $(openssl passwd -1 -salt xyz 'gea_user') -m -d /home/gea_user -s /bin/bash gea_user
RUN usermod -a -G sudo root gea_user
RUN echo "gea_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#
#
# Install Conda
RUN wget --quiet\
 https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh\
  -O Anaconda3-2019.03-Linux-x86_64.sh &&\
  /bin/bash Anaconda3-2019.03-Linux-x86_64.sh -b -p /opt/conda &&\
  rm Anaconda3-2019.03-Linux-x86_64.sh &&\
  ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh &&\
  echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
#
#
# Configure conda
RUN /opt/conda/bin/conda config --add channels defaults
RUN /opt/conda/bin/conda config --add channels bioconda
RUN /opt/conda/bin/conda config --add channels conda-forge
#
#
# Install bioconda packages
RUN /opt/conda/bin/conda install -y -q fastqc=0.11.7=5
RUN /opt/conda/bin/conda install -y -q trimmomatic=0.38=0
RUN /opt/conda/bin/conda install -y -q fastp
#
#
# Link conda executables to /bin and /usr/lib
RUN ln -s /opt/conda/pkgs/*/bin/* /bin; exit 0
RUN ln -s /opt/conda/pkgs/*/lib/* /usr/lib; exit 0
#
# Install jupyter lab and extra doodads
RUN pip3 install jupyterlab==0.35.6
#
#
#
RUN jupyter-labextension install @jupyterlab/hub-extension@0.12.0 \
                                    @jupyter-widgets/jupyterlab-manager@0.38.1 \
#                                    jupyterlab_bokeh@0.6.3 \
                                    @mflevine/jupyterlab_html
#                                    @jupyterlab/fasta-extension \
#                                    jupyterlab-spreadsheet
#
#
# Install the irods plugin for jupyter lab
RUN pip3 install jupyterlab_irods==2.0.1 \
     && jupyter-serverextension enable --py jupyterlab_irods \
     && jupyter-labextension install ijab@2.0.1 \
     && jupyter-labextension enable jupyterlab_html
#
#
#more config stuff
RUN npm cache clean && npm init -y && sudo npm install -g npm
RUN npm install --save core-js@^3 && jupyter lab build
# Configure shell
#
RUN rm /bin/sh && ln -s /bin/bash /bin/sh && echo "SHELL=/bin/bash" >> /etc/environment
#
#
# Switch to GEA user
COPY ./jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json
COPY ./jupyter_notebook_config.py /home/gea_user/.jupyter/jupyter_notebook_config.py
COPY ./.bashrc /home/gea_user/.bashrc
RUN chown -R gea_user:gea_user /home/gea_user/.jupyter
RUN chown gea_user:gea_user /home/gea_user/.bashrc
USER gea_user
#
# Define entry point and startup commands
ENTRYPOINT ["jupyter"]
CMD ["lab", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
