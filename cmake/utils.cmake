# Copyright (c) 2017 - 2022 -- Élie Michel <elie.michel@exppad.com>
# This is private research work, DO NOT SHARE without the explicit
# consent of the authors.

# Copy dll in output directory
function(target_link_libraries_and_dll target public_or_private lib)
	target_link_libraries(${target} ${public_or_private} ${lib})
	add_custom_command(
		TARGET ${target} POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy_if_different
			$<TARGET_FILE:${lib}>
			$<TARGET_FILE_DIR:${target}>
	)
endfunction()

# Reproduce the original folder layout in IDE
function(group_source_by_folder)
	foreach(file ${ARGV}) 
		# Get the directory of the source file
		get_filename_component(parent_dir "${file}" DIRECTORY)

		# Remove common directory prefix to make the group
		string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}" "" group "${parent_dir}")

		# Make sure we are using windows slashes
		string(REPLACE "/" "\\" group "${group}")

		# Group into "Source Files" and "Header Files"
		if ("${file}" MATCHES ".*\\.cpp")
			set(group "Source Files\\${group}")
		elseif("${file}" MATCHES ".*\\.h")
			set(group "Header Files\\${group}")
		endif()

		source_group("${group}" FILES "${file}")
	endforeach()
endfunction()

macro(enable_multiprocessor_compilation)
	if(MSVC)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP")
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /MP")
	endif(MSVC)
endmacro()

macro(enable_cpp17)
	set(CMAKE_CXX_STANDARD 17)
endmacro()

macro(enable_cpp20)
	if(MSVC)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /std:c++latest")
	else()
		set(CMAKE_CXX_STANDARD 20)
	endif()
endmacro()

function(target_treat_warnings_as_errors target)
	#if(MSVC)
	#	target_compile_options(${target} PRIVATE /W4 /WX)
	#else()
	#	target_compile_options(${target} PRIVATE -Wall -Wextra -pedantic -Werror)
	#endif()
	set_target_properties(${Target} PROPERTIES COMPILE_WARNING_AS_ERROR ON)
endfunction()

function(enable_ide_folders)
	set_property(GLOBAL PROPERTY USE_FOLDERS ON)
endfunction()

macro(set_default_install_dir DEFAULT_INSTALL_DIR)
	if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
		get_filename_component(DEFAULT_INSTALL_DIR "${DEFAULT_INSTALL_DIR}" ABSOLUTE)
		set(CMAKE_INSTALL_PREFIX "${DEFAULT_INSTALL_DIR}" CACHE PATH "default install path" FORCE)
	endif()
endmacro()

# Also create the parent dir of destination file
function(copy_file SRC DST)
	#message(STATUS "copying file '${SRC}' to '${DST}'")
	file(REAL_PATH "${DST}/.." PARENT)
	file(MAKE_DIRECTORY "${PARENT}")
	file(COPY_FILE "${SRC}" "${DST}")
endfunction()

# List all targets defined in the project
function(get_all_targets ROOT_DIR OUT_VAR)
	get_directory_property(target_list DIRECTORY ${ROOT_DIR} BUILDSYSTEM_TARGETS)
	list(APPEND ${OUT_VAR} ${target_list})
	get_directory_property(subdir_list DIRECTORY ${ROOT_DIR} SUBDIRECTORIES)
	foreach(subdir ${subdir_list})
		get_all_targets(${subdir} ${OUT_VAR})
	endforeach()
	set(${OUT_VAR} ${${OUT_VAR}} PARENT_SCOPE)
endfunction()
