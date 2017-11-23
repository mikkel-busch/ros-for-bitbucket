FROM ubuntu:xenial

COPY . /app/

WORKDIR /app

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

RUN apt-get update

RUN apt-get install ros-kinetic-desktop-full -y

RUN apt-get install python-rosinstall -y

RUN rosdep init

RUN rosdep update

RUN apt-get install wget

RUN wget https://netix.dl.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.49.tar.gz

RUN tar xfpz GeographicLib-1.49.tar.gz

WORKDIR GeographicLib-1.49

RUN mkdir BUILD

WORKDIR BUILD

RUN cmake ..

RUN make -j$(nproc)

RUN make test

RUN make install

