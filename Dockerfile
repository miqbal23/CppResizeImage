FROM ubuntu:18.04 AS build

# install essentials
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get -y autoremove && \
    apt-get install -y build-essential gdb wget git libssl-dev && \
	mkdir ~/temp && cd ~/temp && \
    wget  https://cmake.org/files/v3.14/cmake-3.14.5.tar.gz && \
    tar -zxvf cmake-3.14.5.tar.gz && \
    cd cmake-3.14.5 && \
    ./bootstrap && make -j4 && make install && \
    rm -rf ~/temp/*

# install boost
RUN cd ~/temp &&  \
	wget https://sourceforge.net/projects/boost/files/boost/1.73.0/boost_1_73_0.tar.gz && \
    tar -zxvf boost_1_73_0.tar.gz && cd boost_1_73_0 && \
	./bootstrap.sh && ./b2 cxxflags="-std=c++17" --reconfigure --with-fiber --with-date_time install

RUN apt-get -y update && \
    apt-get install -y libpq-dev libsqlite3-dev unzip && \
    cd ~/temp && \
    git clone https://github.com/jtv/libpqxx.git && cd libpqxx && \
    git checkout 7.1.1 && \
    mkdir build && cd build && \
    cmake .. -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/postgresql/libpq && \
    make -j6 && make install && \
    cd ~/temp && \
    wget https://github.com/SOCI/soci/archive/release/4.0.zip && \
    unzip 4.0.zip && \
    cd soci-release-4.0 && \
    mkdir build && cd build && \
    cmake .. -DWITH_BOOST=ON -DWITH_POSTGRESQL=ON -DWITH_SQLITE3=ON -DCMAKE_CXX_STANDARD=14 -DSOCI_CXX11=ON && \
    make -j6 && make install && \
    cp /usr/local/cmake/SOCI.cmake /usr/local/cmake/SOCIConfig.cmake && \
    ln -s /usr/local/lib64/libsoci_* /usr/local/lib && ldconfig && \
    rm -rf ~/temp/*

# install Libasyik
RUN cd ~/temp && \
	git clone https://github.com/okyfirmansyah/libasyik.git && cd libasyik && \
	git submodule update --init --recursive && \
	mkdir build && cd build && \
	cmake ../ && make -j4 && make install && \
	rm -rf ~/temp/*

# These commands copy your files into the specified directory in the image
# and set that as the working location
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

# Build the app
RUN mkdir build && cd build && \
    cmake ../ && make -j4 && make 

FROM ubuntu:18.04

COPY --from=build /usr/src/myapp/build/test_asyik /app/

# This command runs your application, comment out this line to compile only
EXPOSE 4004
ENTRYPOINT [ "/app/test_asyik" ]

# LABEL Name=cppresizeimage Version=0.0.1