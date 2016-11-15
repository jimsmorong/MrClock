



set (_target_name ResizableLib)
string(TOUPPER ${_target_name} _target_name_toupper)

file (GLOB_RECURSE headers ../${_target_name}/*.h)
file (GLOB_RECURSE cpps    *.cpp  *.rc *.def *.h)
set(all_files ${headers} ${cpps})


set(CMAKE_MFC_FLAG "2")

if(${RESIZABLELIB_BUILD_STATIC_LIB})
    add_library(${_target_name}Static STATIC ${all_files})
    mr_out_target_lib_path(${_target_name}Static  ${CMAKE_SOURCE_DIR})
    target_include_directories(${_target_name}Static PUBLIC ../${_target_name})
    target_compile_definitions(${_target_name}Static PUBLIC UNICODE _UNICODE _AFXDLL _AFXEXT)
    mr_use_pchhd(${_target_name}Static stdafx.h stdafx.cpp)
endif()

if(${RESIZABLELIB_BUILD_SHARE_LIB})
    add_library(${_target_name} SHARED ${all_files})
    mr_out_target_dll_path(${_target_name}  ${CMAKE_SOURCE_DIR})
    target_include_directories(${_target_name} PUBLIC ../${_target_name})
    target_compile_definitions(${_target_name} PUBLIC UNICODE _UNICODE _AFXDLL _AFXEXT)
    target_compile_definitions(${_target_name} PUBLIC ${_target_name_toupper}_DLL ${_target_name_toupper}_EXPORTS)
    mr_use_pchhd(${_target_name} stdafx.h stdafx.cpp)
endif()




