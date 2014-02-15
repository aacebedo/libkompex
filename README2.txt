This project contains the SQLite C++ wrapper named Kompex.
To compile it you need SQLite3 headers.

Then follow those instructions:
1. ./waf configure --prefix=<install path> --mode=[debug|release] [--with-sqlite3=<path to sqlite3>]   
2. ./waf build install

Note by Alexandre ACEBEDO:
I am only the packager of the library.