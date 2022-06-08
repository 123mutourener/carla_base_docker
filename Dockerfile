FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04
RUN rm /etc/apt/sources.list.d/cuda.list
RUN apt update && \
    apt install -y vim wget curl unzip libgl1-mesa-dev && \
    apt clean

USER root
WORKDIR /home/root

SHELL ["/bin/bash", "-c"] 

ENV PATH=/home/root/miniconda3/bin:$PATH
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.11.0-Linux-x86_64.sh
RUN bash ./Miniconda3-py38_4.11.0-Linux-x86_64.sh -b && rm ./Miniconda3-py38_4.11.0-Linux-x86_64.sh && \
    source $HOME/miniconda3/bin/activate &&\
    conda init bash &&\
    conda config --set auto_activate_base false && \
    echo "Running $(conda --version)" && \
    . $HOME/.bashrc && \
    conda update conda

RUN source $HOME/miniconda3/bin/activate &&\
    . $HOME/.bashrc && \
    conda create -n carla_ros python=3.8 && \
    conda activate carla_ros && \
    conda install -y numpy

RUN source $HOME/miniconda3/bin/activate &&\
    . $HOME/.bashrc && \
    conda activate carla_ros && \
    conda install -y -c conda-forge -c robostack ros-noetic-desktop-full ros-noetic-rosbridge-server && \
    conda install -c conda-forge catkin_tools && \
    conda clean -ay

RUN apt install -y libjpeg8 && \
    apt clean && \
    source $HOME/miniconda3/bin/activate &&\
    . $HOME/.bashrc && \
    conda activate carla_ros && \
    pip install --no-cache-dir pycrypto bce-python-sdk opencv-python opencv-python-headless dictor lmdb tqdm matplotlib moviepy imageio imageio-ffmpeg imgaug requests pyyaml py_trees==0.8.3 ray==1.1.0 shapely tabulate six xmlschema wandb ephem && \
    conda install -y pytorch torchvision torchaudio cudatoolkit=11.3 -c pytorch && \
    conda clean -ay

RUN source $HOME/miniconda3/bin/activate &&\
    . $HOME/.bashrc && \
    conda activate carla_ros && \
    pip install --no-cache-dir lxml mangodb xviz-avs&& \
    conda install -y -c robostack ros-noetic-ros-numpy && \
    conda clean -ay

# setup carla proxy backend
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y wget autoconf automake libtool curl make g++-7 unzip git build-essential gcc-7 cmake libpng-dev libtiff5-dev libjpeg-dev tzdata sed wget unzip autoconf libtool rsync && \
    apt clean
