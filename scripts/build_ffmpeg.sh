mkdir -p ~/x265_build && cd ~/x265_build
git clone https://bitbucket.org/multicoreware/x265_git
cd x265_git/build/linux

cmake -DHIGH_BIT_DEPTH=ON \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DEXPORT_C_API=ON \
      -DENABLE_ASSEMBLY=OFF \
      ../../source
    
make -j$(nproc)