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

set(SQLITE3_FOUND 0)

include(FindPackageHandleStandardArgs)
                                  
FIND_PATH(SQLITE3_INCLUDE_DIR sqlite3.h  )

FIND_LIBRARY(SQLITE3_LIBRARY NAMES sqlite3 )            

IF( SQLITE3_LIBRARY AND SQLITE_INCLUDE_DIR )
        SET( SQLITE3_FOUND 1)
ENDIF()

find_package_handle_standard_args(Sqlite3  DEFAULT_MSG
                                  SQLITE3_LIBRARY SQLITE3_INCLUDE_DIR)                      