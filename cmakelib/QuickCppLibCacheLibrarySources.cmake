# Write interface, headers, sources and tests file system scan cache files

# Write a file caching the scanned files along with timestamps to check
function(write_cached_scan_file mode path var)
  indented_message(STATUS "Writing filesystem scan cache file ${path} ...")
  set(contents "# DO NOT EDIT, GENERATED BY SCRIPT\nset(${var}\n")
  set(contents2 "# DO NOT EDIT, GENERATED BY SCRIPT\nset(${var}_DIRECTORIES\n")
  set(dirs)
  foreach(arg ${ARGN})
    set(contents "${contents}  \"${arg}\"\n")
    get_filename_component(dir "${arg}" DIRECTORY)
    if(NOT dir STREQUAL prevdir)
      list(APPEND dirs "${dir}")
      set(prevdir "${dir}")
    endif()
  endforeach()
  set(contents "${contents})\n")
  list(REMOVE_DUPLICATES dirs)
  foreach(dir ${dirs})
    file(TIMESTAMP "${CMAKE_CURRENT_SOURCE_DIR}/${dir}" dirts)
    set(contents2 "${contents2}  \"${dirts}\" \"${dir}\"\n")
  endforeach()
  set(contents2 "${contents2})\n")
  file(${mode} "${path}" "${contents}")
  file(${mode} "${path}.cache" "${contents2}")
endfunction()

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/cmake/headers.cmake")
  write_cached_scan_file(WRITE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/interface.cmake" "${PROJECT_NAME}_INTERFACE" ${${PROJECT_NAME}_INTERFACE})
  write_cached_scan_file(WRITE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/headers.cmake" "${PROJECT_NAME}_HEADERS" ${${PROJECT_NAME}_HEADERS})
endif()
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src")
  if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/cmake/sources.cmake")
    write_cached_scan_file(WRITE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/sources.cmake" "${PROJECT_NAME}_SOURCES" ${${PROJECT_NAME}_SOURCES})
  endif()
endif()
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/test")
  if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/cmake/tests.cmake")
    write_cached_scan_file(WRITE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/tests.cmake" "${PROJECT_NAME}_TESTS" ${${PROJECT_NAME}_TESTS})
    write_cached_scan_file(APPEND "${CMAKE_CURRENT_SOURCE_DIR}/cmake/tests.cmake" "${PROJECT_NAME}_COMPILE_TESTS" ${${PROJECT_NAME}_COMPILE_TESTS})
    write_cached_scan_file(APPEND "${CMAKE_CURRENT_SOURCE_DIR}/cmake/tests.cmake" "${PROJECT_NAME}_COMPILE_FAIL_TESTS" ${${PROJECT_NAME}_COMPILE_FAIL_TESTS})
  endif()
endif()
