FROM docker.io/library/ubuntu:20.04

RUN apt-get update \
&& apt-get install -y curl \
&& rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "uname", "-a" ]
