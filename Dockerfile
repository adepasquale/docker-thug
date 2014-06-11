# This is a Dockerfile for creating a Thug https://github.com/buffer/thug Container from the latest
# Ubuntu base image. This is known bo be working on Ubuntu 14.04. It should work on any later version
# This is a full installation of Thug including all optional packages used for distributed operation
FROM ubuntu:latest
MAINTAINER ali@ikinci.info
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y dist-upgrade
# Install packets for normal usage
RUN apt-get -y install --no-install-recommends graphviz librabbitmq1 nano python-chardet python-cssutils python-html5lib python-httplib2 libemu2 python-lxm\
l python-magic python-pika python-pip python-pydot python-pymongo python-pyparsing python-requests python-yara python-zope.interface vim
# Install packets needed for building thug
RUN apt-get -y install --no-install-recommends build-essential curl git gyp libboost-python-dev libboost-thread-dev libboost-system-dev python-dev subversi\
on libemu-dev
RUN pip install -q jsbeautifier rarfile beautifulsoup4 pefile
RUN svn checkout http://pyv8.googlecode.com/svn/trunk/ /usr/local/src/pyv8
RUN curl  -s https://raw.githubusercontent.com/buffer/thug/master/patches/PyV8-patch1.diff -o /usr/local/src/PyV8-patch1.diff
RUN patch -d /usr/local/src/ -p0 < /usr/local/src/PyV8-patch1.diff
RUN cd /usr/local/src/pyv8/ && python setup.py build
RUN cd /usr/local/src/pyv8/ && python setup.py install
RUN git clone https://github.com/buffer/pylibemu.git /usr/local/src/pylibemu
RUN cd /usr/local/src/pylibemu && python setup.py build
RUN cd /usr/local/src/pylibemu && python setup.py install
RUN git clone https://github.com/buffer/thug.git /thug
# Remove packets needed building thug and cleanup
RUN apt-get -y remove build-essential curl subversion git gyp python-dev
RUN apt-get -y autoremove
RUN apt-get clean && apt-get autoclean
RUN dpkg -l |grep ^rc |awk '{print $2}' |xargs dpkg --purge
RUN rm -rf /usr/local/src/pylibemu /usr/local/src/pyv8/ /usr/local/src/PyV8-patch1.diff
