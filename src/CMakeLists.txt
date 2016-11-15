

set (_target_name MrClock)

# 源码
file(GLOB project_headers *.h)
file(GLOB project_cpps *.cpp *.cc)
file(GLOB project_rc *.rc res/*.*)
set(all_files ${project_headers} ${project_cpps} ${project_rc})

# 目标文件生成
set(CMAKE_MFC_FLAG "2")
add_executable(${_target_name} WIN32 ${all_files})
mr_out_target_bin_path(${_target_name} "${CMAKE_SOURCE_DIR}")
set_target_properties( ${_target_name}  PROPERTIES LINK_FLAGS "/ENTRY:\"wWinMainCRTStartup\"")
target_compile_definitions(${_target_name} PUBLIC _AFXDLL UNICODE _UNICODE)
mr_use_pchhd(${_target_name} "stdafx.h" "stdafx.cpp")
    

mrlib_use_mrui(${_target_name} DigitNumWnd)
mrlib_use_ResizableLib(${_target_name} source)

get_target_property(rtoutpath ${_target_name} RUNTIME_OUTPUT_DIRECTORY_RELEASE)
install(FILES ${rtoutpath}/${_target_name}.exe DESTINATION ${CMAKE_SOURCE_DIR}/bindist)