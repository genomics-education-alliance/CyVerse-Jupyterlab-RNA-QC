# CyVerse-Jupyterlab-RNA-QC
Files for docker container with fastqc tools for GEA Intro-RNA-Seq example tutorial

## Info for CyVerse VICE Discovery Environment deployment

 - Docker port: **8888/tcp** (docker inspect genomicseducationalliance/cyverse-jupyterlab-rnaseq-qc:dev_1.0 -f '{{range $port, $val := .ContainerConfig.ExposedPorts}}{{$port}} {{end}}')
 - User: **joyvan** (docker inspect genomicseducationalliance/cyverse-jupyterlab-rnaseq-qc:dev_1.0 -f '{{.ContainerConfig.User}}')
 - UID: **1000** (docker run --rm -it --entrypoint "id" genomicseducationalliance/cyverse-jupyterlab-rnaseq-qc:dev_1.0 -u jovyan)
 - Working directory: **/home/joyvan** (genomicseducationalliance/cyverse-jupyterlab-rnaseq-qc:dev_1.0 -f '{{.ContainerConfig.WorkingDir}}')
