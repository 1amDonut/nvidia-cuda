FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        cmake\
        git\
        python3.6 \
        python-dev \
        python-pip \
        python-setuptools \
        && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update

RUN pip install --upgrade pip==9.0.3 && \
    pip --no-cache-dir install --upgrade torch==1.1.0 && \
    pip --no-cache-dir install --upgrade torchvision==0.3.0

RUN git clone --depth 1 -b 4.5.3 https://github.com/opencv/opencv.git /opencv && \
    mkdir /opencv/build && cd /opencv/build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON \
          -DWITH_CUDA=ON -DWITH_CUFFT=OFF -DCUDA_ARCH_BIN="${CUDA_ARCH_BIN}" -DCUDA_ARCH_PTX="${CUDA_ARCH_PTX}" \
          -DWITH_JPEG=ON -DBUILD_JPEG=ON -DWITH_PNG=ON -DBUILD_PNG=ON \
          -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF -DWITH_FFMPEG=OFF -DWITH_GTK=OFF \
          -DWITH_OPENCL=OFF -DWITH_QT=OFF -DWITH_V4L=OFF -DWITH_JASPER=OFF \
          -DWITH_1394=OFF -DWITH_TIFF=OFF -DWITH_OPENEXR=OFF -DWITH_IPP=OFF -DWITH_WEBP=OFF \
          -DBUILD_opencv_superres=OFF -DBUILD_opencv_java=OFF -DBUILD_opencv_python2=OFF \
          -DBUILD_opencv_videostab=OFF -DBUILD_opencv_apps=OFF -DBUILD_opencv_flann=OFF \
          -DBUILD_opencv_ml=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_shape=OFF \
          -DBUILD_opencv_cudabgsegm=OFF -DBUILD_opencv_cudaoptflow=OFF -DBUILD_opencv_cudalegacy=OFF \
          -DCUDA_NVCC_FLAGS="-O3" -DCUDA_FAST_MATH=ON .. && \
    make -j"$(nproc)" install && \
    ldconfig && \
    rm -rf /opencv