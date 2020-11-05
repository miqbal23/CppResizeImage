FROM ubuntu:18.04

# basic tools
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get -y autoremove && \
    apt-get install -y build-essential gdb wget git libssl-dev

# CMake
RUN mkdir ~/temp && cd ~/temp && \
    wget  https://cmake.org/files/v3.14/cmake-3.14.5.tar.gz && \
    tar -zxvf cmake-3.14.5.tar.gz && \
    cd cmake-3.14.5 && \
    ./bootstrap && make -j4 && make install && \
    rm -rf ~/temp/* 
    
# Boost
RUN cd ~/temp &&  wget https://sourceforge.net/projects/boost/files/boost/1.73.0/boost_1_73_0.tar.gz && \
    tar -zxvf boost_1_73_0.tar.gz && cd boost_1_73_0 && ./bootstrap.sh && ./b2 cxxflags="-std=c++17" --reconfigure --with-fiber --with-date_time install && \
    cd ~/temp && git clone https://github.com/linux-test-project/lcov.git && cd lcov && make install && cd .. && \
    apt-get install -y libperlio-gzip-perl libjson-perl && \
    rm -rf ~/temp/* && \
    apt-get autoremove -y &&\
    apt-get clean -y &&\
    rm -rf /var/lib/apt/lists/*

# SOCI
RUN apt-get -y update && \
    apt-get install -y libpq-dev libsqlite3-dev unzip

RUN cd ~/temp && \
    git clone https://github.com/jtv/libpqxx.git && cd libpqxx && \
    git checkout 7.1.1 && \
    mkdir build && cd build && \
    cmake .. -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/postgresql/libpq && \
    make -j6 && make install

RUN cd ~/temp && \
    wget https://github.com/SOCI/soci/archive/release/4.0.zip && \
    unzip 4.0.zip && \
    cd soci-release-4.0 && \
    mkdir build && cd build && \
    cmake .. -DWITH_BOOST=ON -DWITH_POSTGRESQL=ON -DWITH_SQLITE3=ON -DCMAKE_CXX_STANDARD=14 -DSOCI_CXX11=ON && \
    make -j6 && make install && \
    cp /usr/local/cmake/SOCI.cmake /usr/local/cmake/SOCIConfig.cmake && \
    ln -s /usr/local/lib64/libsoci_* /usr/local/lib && ldconfig && \
    rm -rf ~/temp/* && \
    apt-get autoremove -y &&\
    apt-get clean -y &&\
    rm -rf /var/lib/apt/lists/*

# Libasyik
RUN cd ~/temp \
	&& git clone https://github.com/okyfirmansyah/libasyik.git && cd libasyik \
	&& git submodule update --init --recursive \
	&& mkdir build && cd build \
	&& cmake ../ && make -j4 && make install

WORKDIR /src
COPY hello_server.cpp CMakeLists.txt ./
RUN cmake . && make 

EXPOSE 8080

ENTRYPOINT [ "./helloserver" ]