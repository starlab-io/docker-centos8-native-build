FROM centos:8.2.2004
MAINTAINER Star Lab <info@starlab.io>

RUN mkdir /source

RUN yum install -y epel-release
# build dependencies
RUN yum install -y git kernel-devel wget bc openssl openssl-devel python2-setuptools \
        python2-pip python2-virtualenv check make bison flex diffutils rpm-build && \
    yum clean all && \
    rm -rf /var/cache/yum/* /tmp/* /var/tmp/*

VOLUME ["/source"]
WORKDIR /source
CMD ["/bin/bash"]

RUN yum update -y && yum install -y \
    # Install CONFIG_STACK_VALIDATION dependencies
    elfutils-libelf-devel gcc \
    libtool which \
    gcc \
    # Add ccache for development use
    ccache \
    # Add pigz for tarball gzipping in parallel
    pigz \
    sudo && \
    rm -rf /var/cache/yum/* /tmp/* /var/tmp/*

# Set digest algorithms to be NIAP compatible (SHA256)
RUN echo "%_source_filedigest_algorithm 8" >> /etc/rpm/macros && \
    echo "%_binary_filedigest_algorithm 8" >> /etc/rpm/macros && \
    echo "%_smp_ncpus_max 0" >> /etc/rpm/macros && \
    echo "%_source_payload  w6T0.xzdio" >> /etc/rpm/macros && \
    echo "%_binary_payload  w6T0.xzdio" >> /etc/rpm/macros && \
    echo "%_unpackaged_files_terminate_build 0" >> /etc/rpm/macros

RUN ln -s /usr/bin/python2 /usr/bin/python
###
### END intermediate multi-stage build layers
###

CMD ["/bin/bash"]
