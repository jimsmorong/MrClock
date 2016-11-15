

get_filename_component(RESIZABLELIB_LIB_PATH "${CMAKE_CURRENT_LIST_FILE}" PATH)

macro(mrlib_use_ResizableLib target_name use_type)
    if (${use_type} STREQUAL "source")
        target_include_directories(${target_name} PUBLIC ${RESIZABLELIB_LIB_PATH})
        target_include_directories(${target_name} PUBLIC ${RESIZABLELIB_LIB_PATH}/ResizableLib)
        file (GLOB_RECURSE f1 ${RESIZABLELIB_LIB_PATH}/ResizableLib/*)
        target_sources(${target_name} PUBLIC  ${f1})
        mr_source_group_by_name(f1 ResizableLib)  
        file (GLOB_RECURSE f2 ${RESIZABLELIB_LIB_PATH}/src/*)
        list(REMOVE_ITEM f2 ${RESIZABLELIB_LIB_PATH}/src/CMakeLists.txt)
        target_sources(${target_name} PUBLIC  ${f2}) 
        mr_source_group_by_name(f2 ResizableLib)  
    endif()
endmacro()
