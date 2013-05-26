This project contains the SQLite C++ wrapper named Kompex.
To compile it you need CMake >= 2.8 and the SQLite3 headers.

Then follow those instructions:
1. mkdir build && cd build
2. cmake ../cmake -DCMAKE_INSTALL_PREFIX=<install path> -DCMAKE_BUILD_TYPE=Debug|Release
3. make
4. make install

Note by Alexandre ACEBEDO:
I am only the packager of the library.