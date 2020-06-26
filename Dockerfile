FROM scilus/singularity-base-tractoflow:latest AS dependencies
FROM scilus/docker-vtk-8.2.0:latest

ENV PYTHONPATH=/usr/lib/x86_64-linux-gnu/python3.6/site-packages/:/usr/bin/:$PYTHONPATH
ENV LD_LIBRARY_PATH=/usr/bin/:LD_LIBRARY_PATH
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apt-get update && apt-get install -y language-pack-en
RUN apt-get install -y libblas-dev liblapack-dev gfortran

WORKDIR /
RUN apt-get update
RUN apt-get -y install libeigen3-dev
RUN apt-get -y install libqt4-opengl-dev
RUN apt-get -y install libgl1-mesa-dev
RUN apt-get -y install libfftw3-dev
RUN apt-get -y install libtiff5-dev
RUN apt-get -y install clang
RUN apt-get -y install libblas-dev liblapack-dev
COPY --from=dependencies /mrtrix3 ./mrtrix3
ENV PATH=/mrtrix3/bin:$PATH

RUN apt-get -y install fonts-freefont-ttf

WORKDIR /
RUN git clone https://github.com/GuillaumeTh/dmriqcpy.git
WORKDIR /dmriqcpy
RUN pip3 install git+https://github.com/scilus/scilpy.git#egg=scilpy
RUN pip3 install git+https://github.com/GuillaumeTh/dmriqcpy.git
RUN pip3 uninstall -y vtk

# Use offscreen backend
RUN echo "backend : Agg" > /usr/local/lib/python3.6/dist-packages/matplotlib/mpl-data/matplotlibrc
