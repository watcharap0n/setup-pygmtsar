# Use an official Ubuntu runtime as a parent image
FROM ubuntu:22.04

# Set the working directory in the container
WORKDIR /usr/src/app

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
        git wget \
        csh autoconf gfortran \
        libtiff5-dev libhdf5-dev liblapack-dev libgmt-dev gmt-dcw gmt-gshhg gmt \
        gcc-9 g++ \
        make \
        xvfb \
        python3 \
        python3-pip

# Clone GMTSAR repository and set up
RUN git clone --branch master https://github.com/gmtsar/gmtsar /usr/local/GMTSAR && \
    cd /usr/local/GMTSAR && \
    git checkout e98ebc0f4164939a4780b1534bac186924d7c998 && \
    autoconf && \
    ./configure --with-orbits-dir=/tmp && \
    sed -i 's/CFLAGS[[:space:]]*=[[:space:]]*.*$/CFLAGS = -O2 -Wall -fPIC -fno-strict-aliasing -std=c99 -z muldefs/' config.mk && \
    cat config.mk && \
    make && \
    make install

RUN echo '#!/bin/sh' > /usr/local/GMTSAR/bin/gmtsar_sharedir.csh && \
    echo 'echo /usr/local/GMTSAR/share/gmtsar' >> /usr/local/GMTSAR/bin/gmtsar_sharedir.csh && \
    chmod a+x /usr/local/GMTSAR/bin/gmtsar_sharedir.csh && \
    /usr/local/GMTSAR/bin/gmtsar_sharedir.csh

RUN /usr/local/GMTSAR/bin/make_s1a_tops 2>&1 | head -n 2

ENV PATH="/usr/local/GMTSAR/bin:${PATH}"

ENV PYTHONPATH="/usr/local/GMTSAR/lib/python:${PYTHONPATH}"

RUN apt-get install -y xvfb
RUN pip install pyvista xvfbwrapper matplotlib seaborn bokeh

RUN pip install git+https://github.com/mobigroup/gmtsar.git@pygmtsar2#subdirectory=pygmtsar


# Write script to run GMTSAR
# Example:
# CMD ["python3", "/usr/src/app/run_gmtsar.py"]