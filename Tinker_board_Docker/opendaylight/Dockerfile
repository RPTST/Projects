FROM debian:8

# Schema: https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Int/Pack Debian Dockerfile" \
      version="5.2" \
      vendor="OpenDaylight" \
      summary="OpenDaylight Integration/Packaging example Debian Dockerfile" \
      vcs-url="https://git.opendaylight.org/gerrit/p/integration/packaging.git"
RUN apt-get update && apt-get install -y
    gdebi-core \
    gcc \
    g++ \
    nano \
    wget \
    git && \
    wget http://download.opensuse.org/repositories/home:/akshitajha/Debian_8.0/all/opendaylight_6.0.0-1_all.deb && \
    gdebi -n opendaylight_6.0.0-1_all.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Alt Install OpenDaylight
#RUN apt-get install -y http://download.opensuse.org/repositories/home:/akshitajha/xUbuntu_16.04/all/opendaylight_5.0.0-1_all.deb && apt-get clean
#RUN apt-get install -y http://download.opensuse.org/repositories/home:/akshitajha/xUbuntu_16.04/all/opendaylight_6.0.0-1_all.deb && apt-get clean
#RUN apt-get install -y http://download.opensuse.org/repositories/home:/akshitajha/Debian_8.0/all/opendaylight_6.0.0-1_all.deb && apt-get clean

# Ports
# 8101 - Karaf SSH
# Installing additional ODL features may require opening additional ports.
# https://wiki.opendaylight.org/view/Ports
EXPOSE 8101

# Start OpenDaylight
CMD ["/opt/opendaylight/bin/karaf"]
