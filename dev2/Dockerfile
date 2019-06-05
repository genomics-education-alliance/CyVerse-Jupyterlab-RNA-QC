
FROM jupyter/scipy-notebook
# Maintained by
LABEL maintainer="Genomics Education Alliance"
LABEL maintainer_email="genomicseducationalliance@gmail.com"
LABEL version="1.0"
#
#
#
USER root
#
#
# Un-minimize the image to get back Ubuntu
# goodies for teaching Linux/bash (e.g. man files, etc)
# this makes the container big
RUN apt-get update && apt-get upgrade -y --fix-missing && \
(echo y | DEBIAN_FRONTEND=noninteractive sh -x /usr/local/sbin/unminimize)
RUN apt update -y && apt upgrade -y && apt-get install -y --fix-missing\
 bzip2\
 curl\
 git\
 gnupg2\
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
    && rm -rf /usr/lib/apt/lists/*h
#
#
#
# Use python to install packages bash kernel
RUN sudo apt-get install -y python3-pip
RUN python3 -m pip install\
 bash_kernel
RUN python3 -m bash_kernel.install
#
#
#
# Add the GEA user
RUN useradd -p $(openssl passwd -1 -salt xyz 'gea_user') -m -d /home/gea_user -s /bin/bash gea_user
RUN usermod -a -G sudo,root gea_user
RUN echo "gea_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#
#
#
# Install jupyter lab and extra doodads
RUN pip3 install jupyterlab==0.35.6
RUN jupyter-labextension install @jupyterlab/hub-extension@0.12.0 \
                                    @jupyter-widgets/jupyterlab-manager@0.38.1 \
                                    jupyterlab_bokeh@0.6.3 \
                                    @mflevine/jupyterlab_html \
                                    @jupyterlab/fasta-extension \
                                    jupyterlab-spreadsheet
#
#
# Install the irods plugin for jupyter lab
#RUN pip3 install jupyterlab_irods==2.0.1 \
#     && jupyter-serverextension enable --py jupyterlab_irods \
#     && jupyter-labextension install ijab@2.0.1 \
#     && jupyter-labextension enable jupyterlab_html
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
# Configure shell
RUN rm /bin/sh && ln -s /bin/bash /bin/sh && echo "SHELL=/bin/bash" >> /etc/environment
#
#
# Switch to GEA user
COPY ./jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json
COPY ./jupyter_notebook_config.py /home/gea_user/.jupyter/jupyter_notebook_config.py
COPY ./.bashrc /home/gea_user/.bashrc
RUN chown -R gea_user:gea_user /home/gea_user/.jupyter
RUN chmod -R 777 /home/jovyan
RUN chown gea_user:gea_user /home/gea_user/.bashrc
USER gea_user
#
#
# Link conda executables to /bin and /usr/lib
RUN ln -s /opt/conda/pkgs/*/bin/* /bin; exit 0
RUN ln -s /opt/conda/pkgs/*/lib/* /usr/lib; exit 0
#
# Define entry point and startup commands
ENTRYPOINT ["jupyter"]
CMD ["lab", "--no-browser", "--ip=0.0.0.0", "--NotebookApp.token=''", "--NotebookApp.password=''", "--notebook-dir='/home/gea_user'", "--Session.username='gea_user'"]
