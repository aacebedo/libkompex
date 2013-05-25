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
include(CMakeParseArguments)	

##
# Function checkArgs
# This function checks that a variable named with a prefix and an argument name exists.  
# prefix The prefix added to the each argument name.
# arguments The argument names to check.
##
function(checkArgs prefix arguments)
  foreach(arg ${arguments})
	 if(NOT ${prefix}_${arg})
	   message(FATAL_ERROR "Missing ${arg} argument")
	 endif()
  endforeach()
endfunction()

##
# Function retrieveFiles
# This functions parses a given path searching all the files with a specific extension.
# TARGET The prefix to give to each argument of the function.
# RECURSIVE The option to activate a recursive search.
# EXTENSIONS The extensions to search for. This argument is mandatory.
##
function(retrieveFiles result path)

  set(prefix TARGET)
  set(optionArgs RECURSIVE)
  set(oneValueArgs "")
  set(multiValueArgs EXTENSIONS)
  set(mandatory EXTENSIONS)

  cmake_parse_arguments(${prefix} "${optionArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  checkArgs(${prefix} "${mandatory}")
  set(foundFiles "")
  
  foreach(ext ${TARGET_EXTENSIONS})
    if(TARGET_RECURSIVE)
	   file(GLOB_RECURSE files "${path}/*.${ext}") 
    else()
	   file(GLOB files "${path}/*.${ext}") 
    endif()
    
    set(foundFiles ${foundFiles} ${files})
  endforeach()
  
  set(${result} ${foundFiles} PARENT_SCOPE)
endfunction()

##
# Function buildElement
# This functions compiles the given files into a library or an executable depending on the passed arguments.
# TARGET The prefix to give to each argument of the function.
# EXECUTABLE | LIBRARY The type of the generated binary.
# NAME The name of the target. This argument is mandatory.
# VERSION The version of the library (will impact the name).
# FILES The files to compile. This argument is mandatory.
# DEPENDS The dependencies of the binary.
##
function(buildElement)
  
  set(prefix TARGET)
  set(optionArgs EXECUTABLE LIBRARY)
  set(oneValueArgs NAME VERSION)
  set(multiValueArgs FILES DEPENDS)
  set(mandatory NAME FILES)

  cmake_parse_arguments(${prefix} "${optionArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  checkArgs(${prefix} "${mandatory}")

  set(cppFiles "")
  set(hdrFiles "")

  # Filter the files according to their extension.
  foreach(f ${TARGET_FILES})
    
    get_filename_component(fileExt ${f} EXT)
    if(${fileExt} STREQUAL ".cpp" )
	   set(cppFiles ${cppFiles} ${f})
    elseif(${fileExt} STREQUAL ".c" )
	   set(cppFiles ${cppFiles} ${f})
    elseif(${fileExt} STREQUAL ".hpp" )
	   set(hdrFiles ${hdrFiles} ${f})
    elseif(${fileExt} STREQUAL ".h" )
	   set(hdrFiles ${hdrFiles} ${f})
    else ()
	   set(otherFiles ${otherFiles} ${f})
    endif()

  endforeach()

  list(LENGTH cppFiles numCpp)
  list(LENGTH hdrFiles numHdr)

  # If we shall create a library.
  if(TARGET_LIBRARY AND numCpp GREATER 0)
    add_library(
      "${TARGET_NAME}"
  	  SHARED
      ${cppFiles}
    )

    # install the target.
    install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})

	
    # Generating the name of with the version.
    if(NOT ${TARGET_VERSION} STREQUAL "")

      set(soext  ".so.${TARGET_VERSION}")
      set_target_properties(${TARGET_NAME} PROPERTIES SUFFIX ${soext})
    # Install a symbolic link for the version.
    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ./lib${TARGET_NAME}${soext} ${CMAKE_INSTALL_PREFIX}/${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${TARGET_NAME}.so)")
 		endif()

  # Add link.
  foreach(dep ${TARGET_DEPENDS})
	  target_link_libraries(${TARGET_NAME} ${dep})
  endforeach()

	# If it is an executable.
	elseif(TARGET_EXECUTABLE AND numCpp GREATER 0)

		add_executable(
			${TARGET_NAME}
			${cppFiles}
		)
		# Add link.
		foreach(dep ${TARGET_DEPENDS})
			target_link_libraries(${TARGET_NAME} ${dep})	
		endforeach()

		# Install the file the binary output.
		install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_BINARY_OUTPUT_DIRECTORY})

	# If binary type is not supported.
	else ()
		message(FATAL_ERROR "Missing target type")
	endif()

	foreach(dep ${TARGET_DEPENDS})
		add_dependencies(${TARGET_NAME} ${dep})
	endforeach()

	# Install header files.
	foreach(f ${hdrFiles})
		get_filename_component(filePath ${f} PATH)
		string(REPLACE ${CMAKE_SOURCE_DIR} "" filePath ${filePath} )
		install(FILES ${f} DESTINATION ${CMAKE_INCLUDE_OUTPUT_DIRECTORY}/${filePath})
	endforeach()
endfunction()