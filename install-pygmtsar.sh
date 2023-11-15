#!/bin/bash

# Check the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux installation steps
    echo "Linux detected"
    sudo apt-get update
    sudo apt-get install -y \
        git wget \
        csh autoconf gfortran \
        libtiff5-dev libhdf5-dev liblapack-dev libgmt-dev gmt-dcw gmt-gshhg gmt \
        gcc-9 g++ \
        make \
        xvfb \
        python3 \
        python3-pip
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS installation steps
    echo "macOS detected"
    # Add macOS installation steps here
    # For example: brew install git ...
elif [[ "$OSTYPE" == "msys" ]]; then
    # Windows installation steps
    echo "Windows detected"
    # Add Windows installation steps here
else
    echo "Unsupported operating system"
    exit 1
fi

# Clone GMTSAR repository and set up
git clone --branch master https://github.com/gmtsar/gmtsar /usr/local/GMTSAR
cd /usr/local/GMTSAR
git checkout e98ebc0f4164939a4780b1534bac186924d7c998
autoconf
./configure --with-orbits-dir=/tmp
sed -i 's/CFLAGS[[:space:]]*=[[:space:]]*.*$/CFLAGS = -O2 -Wall -fPIC -fno-strict-aliasing -std=c99 -z muldefs/' config.mk
cat config.mk
make
make install

echo '#!/bin/sh' > /usr/local/GMTSAR/bin/gmtsar_sharedir.csh
echo 'echo /usr/local/GMTSAR/share/gmtsar' >> /usr/local/GMTSAR/bin/gmtsar_sharedir.csh
chmod a+x /usr/local/GMTSAR/bin/gmtsar_sharedir.csh
/usr/local/GMTSAR/bin/gmtsar_sharedir.csh

/usr/local/GMTSAR/bin/make_s1a_tops 2>&1 | head -n 2

# Install Python dependencies
pip install pyvista xvfbwrapper matplotlib seaborn bokeh

# Install pygmtsar
pip install git+https://github.com/mobigroup/gmtsar.git@pygmtsar2#subdirectory=pygmtsar
