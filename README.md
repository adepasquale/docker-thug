Thug
====

A dockerized Thug https://github.com/buffer/thug

Get it from the Docker Index https://registry.hub.docker.com/u/riker2000/thug/

Thug is installed in the root directory /thug . To run run it execute python /thug/src/thug.py

Example usage:

Download latest container

    docker pull riker2000/thug

This will mount your hosts /root/logs dir and enable to keep the logs on the host

    docker run -it -v /root/logs:/logs riker2000/thug  /bin/bash

inside the container run this to analyze 20 random samples from thug 

    for item in  $(find /thug/samples/ -type f  |xargs shuf -e |tail -n 20); do python /thug/src/thug.py -l  $item; done

	

