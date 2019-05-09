FROM jupyter/datascience-notebook

COPY ./jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

USER root

# Install the icommands, curl, and wget
RUN apt-get update \
    && apt-get install -y lsb wget gnupg apt-transport-https python3.6 python-requests curl \
    && apt-get clean \
    && rm -rf /usr/lib/apt/lists/* \
    && fix-permissions $CONDA_DIR

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.irods.org/apt/ xenial main" > /etc/apt/sources.list.d/renci-irods.list \
    && apt-get update \
    && apt-get install -y irods-icommands \
    && apt-get clean \
    && rm -rf /usr/lib/apt/lists/* \
    && fix-permissions $CONDA_DIR

RUN apt-get install -y\
 npm nodejs\
 wget\
 unzip\
 zip\
 bzip2


# Use python to install hub and related hub items and nice packages
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


USER jovyan

# install foundational jupyter lab
RUN conda update -n base conda \
    && conda install jupyterlab \
    && conda clean -tipsy \
    && fix-permissions $CONDA_DIR

# Configure conda
RUN /opt/conda/bin/conda config --add channels defaults
RUN /opt/conda/bin/conda config --add channels bioconda
RUN /opt/conda/bin/conda config --add channels conda-forge
#
#
# Install bioconda packages
RUN /opt/conda/bin/conda install -y -q fastqc=0.11.7=5
RUN /opt/conda/bin/conda install -y -q fastp
RUN /opt/conda/bin/conda install -y -q trimmomatic=0.38=0
#
#
# Link conda executables to /bin and /usr/lib
RUN ln -s /opt/conda/pkgs/*/bin/* /bin; exit 0
RUN ln -s /opt/conda/pkgs/*/lib/* /usr/lib; exit 0
#
#
#


# install jupyter hub and extra doodads
RUN jupyter lab --version \
    && jupyter labextension install @jupyterlab/hub-extension@0.12.0 \
                                    @jupyter-widgets/jupyterlab-manager@0.38.1 \
                                    jupyterlab_bokeh@0.6.3 \
                                    @mflevine/jupyterlab_html \
                                    @jupyterlab/fasta-extension \
                                    jupyterlab-spreadsheet

# Install the irods plugin for jupyter lab
RUN pip install jupyterlab_irods==2.0.1 \
    && jupyter serverextension enable --py jupyterlab_irods \
    && jupyter labextension install ijab@2.0.1 \
    && jupyter labextension enable jupyterlab_html

ENTRYPOINT ["jupyter"]
CMD ["lab", "--no-browser"]
