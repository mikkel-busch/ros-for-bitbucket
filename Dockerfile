FROM ubuntu:xenial

COPY . /app/

WORKDIR /app

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

RUN apt-get update

RUN apt-get install ros-kinetic-desktop-full python-rosinstall wget automake bison flex g++ git libboost-all-dev libevent-dev libssl-dev libtool make pkg-config -y

RUN rosdep init

#  GeographicLib

RUN wget https://netix.dl.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.49.tar.gz && tar xfpz GeographicLib-1.49.tar.gz && cd GeographicLib-1.49 && mkdir BUILD && cd BUILD &&  cmake .. &&  make -j$(nproc) &&  make test &&  make install

#  thrift

WORKDIR /app

RUN  wget http://archive.apache.org/dist/thrift/0.10.0/thrift-0.10.0.tar.gz && tar -xvzf thrift-0.10.0.tar.gz && cd thrift-0.10.0 && ./configure --without-java --without-qt4 --without-qt5 && make && make install && ldconfig

# dji sdk

WORKDIR /app

RUN git clone https://github.com/dji-sdk/Onboard-SDK.git dji-sdk && cd dji-sdk && git checkout 3.3.2 && mkdir build && cd build && cmake .. && make djiosdk-core && make install djiosdk-core

# mosquitto

WORKDIR /app

RUN  wget http://mosquitto.org/files/source/mosquitto-1.4.14.tar.gz && tar -xvzf mosquitto-1.4.14.tar.gz && cd mosquitto-1.4.14 && mkdir build && cd build && cmake .. && make && make install