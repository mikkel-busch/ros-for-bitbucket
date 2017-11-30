FROM ubuntu:xenial

COPY . /app/

WORKDIR /app

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

RUN apt-get update

RUN apt-get install ros-kinetic-desktop-full python-rosinstall wget automake bison flex g++ git libboost-all-dev libevent-dev libssl-dev libtool make pkg-config -y

RUN rosdep init

RUN wget https://netix.dl.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.49.tar.gz

RUN tar xfpz GeographicLib-1.49.tar.gz

WORKDIR /app/GeographicLib-1.49

RUN mkdir BUILD

WORKDIR BUILD

RUN cmake ..

RUN make -j$(nproc)

RUN make test

RUN make install

WORKDIR /app

RUN  wget http://archive.apache.org/dist/thrift/0.10.0/thrift-0.10.0.tar.gz

RUN tar -xvzf thrift-0.10.0.tar.gz

WORKDIR /app/thrift-0.10.0

RUN ./configure --without-java --without-qt4 --without-qt5 && make && make install