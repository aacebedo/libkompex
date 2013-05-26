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
set(CMAKE_DOC_OUTPUT_DIRECTORY "doc")

set(PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..)
set(CMAKE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../src)

set(SRC_DIR ${CMAKE_SOURCE_DIR})

#set(SQLITE_FIND_REQUIRED true)

find_package(Sqlite3 REQUIRED)

include_directories(${SQLITE3_INCLUDE_DIR})

get_filename_component(libPath ${SQLITE3_LIBRARY} PATH)

link_directories(${libPath})

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

install(DIRECTORY ${PROJECT_DIR}/docs/ DESTINATION ${CMAKE_DOC_OUTPUT_DIRECTORY}/libkompex)
install(FILES ${PROJECT_DIR}/LICENSE.txt DESTINATION ${CMAKE_DOC_OUTPUT_DIRECTORY}/libkompex)
install(FILES ${PROJECT_DIR}/LICENSE2.txt DESTINATION ${CMAKE_DOC_OUTPUT_DIRECTORY}/libkompex)
install(FILES ${PROJECT_DIR}/README.txt DESTINATION ${CMAKE_DOC_OUTPUT_DIRECTORY}/libkompex)
install(FILES ${PROJECT_DIR}/README2.txt DESTINATION ${CMAKE_DOC_OUTPUT_DIRECTORY}/libkompex)

