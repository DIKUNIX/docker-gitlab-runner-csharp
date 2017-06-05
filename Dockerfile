FROM ruby:2.1

MAINTAINER Oleks <oleks@oleks.info>

USER root

RUN perl -pi -e 's/jessie/testing/g' /etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
  && rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xorg \
    monodevelop \
    nuget \
    libgtk-3-0 \
    gtk-sharp3 \
  && rm -rf /var/lib/apt/lists/*

RUN nuget update -self

RUN useradd --create-home --uid 1000 docker
RUN chown -R docker:docker /home/docker
USER docker

WORKDIR /home/docker/

CMD ["irb"]
