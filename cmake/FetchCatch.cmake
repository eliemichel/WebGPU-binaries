include(FetchContent)

FetchContent_Declare(
	Catch2
	GIT_REPOSITORY https://github.com/catchorg/Catch2.git
	GIT_TAG        v3.1.0
)

function(make_catch_available)
	FetchContent_MakeAvailable(Catch2)
	set_property(TARGET Catch2 PROPERTY FOLDER "External")
	set_property(TARGET Catch2WithMain PROPERTY FOLDER "External")
	list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/External/Catch2/extras)
	include(Catch)
endfunction()

if (MAKE_ALL_DEPENDENCIES_AVAILABLE)
	make_catch_available()
endif()
