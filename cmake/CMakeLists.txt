##
# Copyright (c) 2013 ACEBEDO Alexandre.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the GNU Public License v3.0
# which accompanies this distribution, and is available at
# http://www.gnu.org/licenses/gpl.html
#
# Contributors:
#   ACEBEDO Alexandre - Initial creation
##

cmake_minimum_required(VERSION 2.8)
project(libkompex)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

find_package(BuildFunctions)

##
# Setting globals
##

set(EXECUTABLE_OUTPUT_PATH ${libkompex_SOURCE_DIR})

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "lib")
set(CMAKE_BINARY_OUTPUT_DIRECTORY "bin")
set(CMAKE_INCLUDE_OUTPUT_DIRECTORY "include")

set(CMAKE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../src)

set(SRC_DIR ${CMAKE_SOURCE_DIR})

##
# Compilation
##

set(TargetName kompex) 

retrieveFiles(files ${SRC_DIR} EXTENSIONS cpp h RECURSIVE)

buildElement(
	LIBRARY
	NAME kompex
	VERSION 1.9.11
	FILES ${files}
)

