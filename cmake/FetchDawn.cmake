include(FetchContent)

FetchContent_Declare(
	dawn
	GIT_REPOSITORY https://dawn.googlesource.com/dawn
	GIT_TAG        df9d1b5c1e53e15eab337b55ee5797602d3e3f9e # 'chromium-gpu-experimental' branch at the time of writing this
	GIT_SUBMODULES
)

function(make_dawn_available)
	execute_process(
		COMMAND python "${CMAKE_CURRENT_SOURCE_DIR}/tools/fetch_dawn_dependencies.py"
		WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/_deps/dawn-src"
		OUTPUT_VARIABLE OUT
		ERROR_VARIABLE OUT
	)
	message(STATUS "${OUT}")

	set(DAWN_BUILD_SAMPLES OFF)
	set(TINT_BUILD_TINT OFF) # TODO
	set(TINT_BUILD_SAMPLES OFF)
	set(TINT_BUILD_DOCS OFF)
	set(TINT_BUILD_TESTS OFF)

	set(DAWN_ENABLE_D3D12 OFF)
	set(DAWN_ENABLE_METAL OFF)
	set(DAWN_ENABLE_NULL OFF)
	set(DAWN_ENABLE_DESKTOP_GL OFF)
	set(DAWN_ENABLE_OPENGLES OFF)
	set(DAWN_ENABLE_VULKAN ON)

	set(TINT_BUILD_SPV_READER OFF)
	set(TINT_BUILD_WGSL_READER ON)
	set(TINT_BUILD_GLSL_WRITER OFF)
	set(TINT_BUILD_HLSL_WRITER OFF)
	set(TINT_BUILD_MSL_WRITER OFF)
	set(TINT_BUILD_SPV_WRITER ON)
	set(TINT_BUILD_WGSL_WRITER OFF)
	set(TINT_BUILD_FUZZERS OFF)
	set(TINT_BUILD_SPIRV_TOOLS_FUZZER OFF)
	set(TINT_BUILD_AST_FUZZER OFF)
	set(TINT_BUILD_REGEX_FUZZER OFF)
	set(TINT_BUILD_BENCHMARKS OFF)
	set(TINT_BUILD_TESTS OFF)
	set(TINT_BUILD_AS_OTHER_OS OFF)
	set(TINT_BUILD_REMOTE_COMPILE OFF)
	FetchContent_MakeAvailable(dawn)

	set(AllDawnTargets
		core_tables
		dawn_common
		dawn_glfw
		dawn_headers
		dawn_native
		dawn_platform
		dawn_proc
		dawn_utils
		dawn_wire
		dawncpp
		dawncpp_headers
		emscripten_bits_gen
		enum_string_mapping
		extinst_tables
		webgpu_dawn
		webgpu_headers_gen
	)
	
	foreach (Target ${AllDawnTargets})
		set_property(TARGET ${Target} PROPERTY FOLDER "Dawn")
	endforeach()
	set_property(TARGET glfw PROPERTY FOLDER "External/GLFW3")
	set_property(TARGET update_mappings PROPERTY FOLDER "External/GLFW3")

	# This is likely needed for other targets as well
	target_include_directories(dawn_utils PUBLIC "${CMAKE_BINARY_DIR}/_deps/dawn-src/src")
endfunction()
