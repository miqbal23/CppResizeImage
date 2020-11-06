FROM schickling/opencv:latest

# basic tools
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get -y autoremove && \
    apt-get install -y build-essential gdb

RUN apt-get install -y wget

# CMake
RUN mkdir ~/temp && cd ~/temp && \
    wget https://cmake.org/files/v3.14/cmake-3.14.5.tar.gz && \
    tar -zxvf cmake-3.14.5.tar.gz && \
    cd cmake-3.14.5 && \
    ./bootstrap && make -j4 && make install && \
    rm -rf ~/temp/* 

WORKDIR /src
COPY . /src

RUN cmake . && make

RUN ln /dev/null /dev/raw1394

ENTRYPOINT [ "/src/resizeimg" ]