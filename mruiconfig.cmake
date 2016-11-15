
get_filename_component(MRUI_LIB_PATH "${CMAKE_CURRENT_LIST_FILE}" PATH)

#
# mrlib_use_mrui(target_name "all")使用全部组件
# mrlib_use_mrui(target_name "xxx")使用某组件
# 现有组件 
#    CountDownWnd DigitNumWnd TrayNotify
#    
macro(mrlib_use_mrui target_name party)
    message(${target_name} " using mrui lib version: 1.0.0 party: " ${party})
    if (${party} STREQUAL "all")
        target_include_directories(${target_name} PUBLIC ${MRUI_LIB_PATH})
        file (GLOB_RECURSE mruif1 ${MRUI_LIB_PATH}/mrui/*.h)
        file (GLOB_RECURSE mruif2 ${MRUI_LIB_PATH}/mrui/*.hpp)
        file (GLOB_RECURSE mruif3 ${MRUI_LIB_PATH}/mrui/*.cxx)
        file (GLOB_RECURSE mruif4 ${MRUI_LIB_PATH}/mrui/*.cpp)
        set(mruifs ${mruif1} ${mruif2} ${mruif3} ${mruif4})
        target_sources(${target_name} PUBLIC ${mruifs})
        mr_source_group_by_name(mruifs mrui)
    endif()
    
    if (NOT ${party} STREQUAL "all")
        target_include_directories(${target_name} PUBLIC ${MRUI_LIB_PATH})
        if(EXISTS ${MRUI_LIB_PATH}/mrui/${party}.h)
            set(mruif1 ${MRUI_LIB_PATH}/mrui/${party}.h)
        endif()
        if(EXISTS ${MRUI_LIB_PATH}/mrui/${party}.cpp)
            set(mruif2 ${mruifs} ${MRUI_LIB_PATH}/mrui/${party}.cpp)
        endif()
        if(EXISTS ${MRUI_LIB_PATH}/mrui/${party}.hpp)
            set(mruif3 ${mruifs} ${MRUI_LIB_PATH}/mrui/${party}.hpp)
        endif()       
        if(EXISTS ${MRUI_LIB_PATH}/mrui/${party}.cxx)
            set(mruif4 ${mruifs} ${MRUI_LIB_PATH}/mrui/${party}.cxx)
        endif()   
        set(mruifs ${mruif1} ${mruif2} ${mruif3} ${mruif4})        
        target_sources(${target_name} PUBLIC ${mruifs})
        mr_source_group_by_name(mruifs mrui)
    endif()
endmacro()