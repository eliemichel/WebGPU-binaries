include(FetchContent)

FetchContent_Declare(
	glm
	GIT_REPOSITORY https://github.com/g-truc/glm
	GIT_TAG        0.9.9.8
)

function(make_glm_available)
	FetchContent_MakeAvailable(glm)
	set_property(TARGET uninstall PROPERTY FOLDER "External/glm")
endfunction()

if (MAKE_ALL_DEPENDENCIES_AVAILABLE)
	make_glm_available()
endif()
