# /**
#   *@file         mrcmake.cmake
#   *@brief        基本设置与使用
#   *@author       jimsmorong
#   *@version      V1.7.1
# */

#[[
cmake_minimum_required(VERSION 3.5)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}")
include(mrcmake)
mr_cmake_base_set()
mr_using_mrcmake()
]]

# + mr_cmake_base_set　　　　　 基本设置 (只有debug与release)
# + mr_using_mrcmake            加入mrcmake project
# + mr_get_check_env            获取检查环境变量

# + mr_get_compiler             编译器名称 mrcmex_cplname vc6 vc7 vc7.1 vc8 vc9 vc10 vc11 vc12 vc14 mingw
# + mr_get_is64xorx86           是否64位   mrcmex_isx64   x64 or ""

# + mr_source_group_by_name     放到根目录下
# + mr_source_fix_path          修正文件路径引用 使用/形式
# + mr_source_group_by_dir      使用虚拟文件夹
# + mr_source_group_by_target   使用虚拟文件夹

# + mr_use_pchhd                预编译头
# + mr_list_filterout           正则移除列表项

# + mr_add_delayload_dll        推迟加载dll

# + mr_out_target_bin_path      执行文件生成输出方式
# + mr_out_target_dll_path      动态库生成输出方式
# + mr_out_target_lib_path      静态库生成输出方式

# + mr_use_dlllib               使用其他库的宏
# + mr_copy_res_to_target       复制资源到目录


# + mr_build_status             查看编译的信息
# + mr_target_link_lib_dir      设置连接库的地址

# + mr_get_updir                得到上一层目录路径
# + mr_get_folder               得到最后文件夹名称

# + mr_get_cur_file_dir         得到当前目录
# + mr_get_cur_folder           得到当前文件夹名称

# + mr_build_mt_global          使用mt
# + mr_build_md_global          使用md
# + mr_build_pdb_global         使用pdb

# + mr_build_unicode            使用unicode
# + mr_build_unicode_win        使用unicode

# + mr_safe_copy_file           安全复制文件

# 防止重复引用  ------------------------------------------------------------
if (__MRCMAKE_CMAKE_INCLUDED__279A09AE_52A3_4063_947F_EEFF7DD73A68__)
    return()
endif()
set(__MRCMAKE_CMAKE_INCLUDED__279A09AE_52A3_4063_947F_EEFF7DD73A68__ TRUE)

#[[
    Title:        mrcmake
    Command:      E:\Runnel\Cmake3.6.2\bin\cmake.exe
    Arguments:    -G"Visual Studio 12"  ../../
    Initial dir:  $(SolutionDir)
    Click Use Output windows
]]

# 基本的设置 ------------------------------------------------------------
macro(mr_cmake_base_set)
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)
  set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER "CMakeTargets")

  set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configs" FORCE)
  if(DEFINED CMAKE_BUILD_TYPE AND CMAKE_VERSION VERSION_GREATER "2.8")
	set_property( CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${CMAKE_CONFIGURATION_TYPES} )
  endif()


  if(CMAKE_VERSION VERSION_GREATER "2.8.6")
    include(ProcessorCount)
    ProcessorCount(N)
    if(NOT MINGW)
        if(NOT N EQUAL 0)
            SET(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   /MP${N} ")
            SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP${N} ")
        endif()
    endif()
  endif()
endmacro()

# mr_using_mrcmake ------------------------------------------------------------
get_filename_component(mrcmake_file_name "${CMAKE_CURRENT_LIST_FILE}" PATH)
macro(mr_using_mrcmake)
    if (NOT _mr_using_mrcmake_have_include)
        set(allfiles "${mrcmake_file_name}/mrcmake.cmake")
        add_custom_target(mrcmake ALL SOURCES ${allfiles})
        mr_source_group_by_dir(allfiles ${mrcmake_file_name})
        set_target_properties(mrcmake PROPERTIES FOLDER "CMakeTargets")
    endif()
    set(_mr_using_mrcmake_have_include TRUE)
endmacro()


# 检查并设置环境变量 ------------------------------------------------------------
macro(mr_get_check_env RESULT)
  if(DEFINED ENV{${RESULT}})
    #message("...using ${RESULT} found in $ENV{${RESULT}}")
  else()
    message("${RESULT} is not defined.  You must tell CMake where to find ${RESULT}")
    return()
  endif()
  set(${RESULT} "$ENV{${RESULT}}")
  string(REPLACE "\\" "/"  ${RESULT} ${${RESULT}})
endmacro()


# 编译器名称 ------------------------------------------------------------
enable_language(CXX)
macro(mr_get_compiler RESULT)
  if (MSVC60)
    set(${RESULT} "vc6")
  elseif (MSVC70)
    set(${RESULT} "vc7")
  elseif (MSVC71)
    set(${RESULT} "vc71")
  elseif(MSVC_VERSION EQUAL 1400)
    set(${RESULT} "vc8")
  elseif(MSVC_VERSION EQUAL 1500)
    set(${RESULT} "vc9")
  elseif(MSVC_VERSION EQUAL 1600)
    set(${RESULT} "vc10")
  elseif(MSVC_VERSION EQUAL 1700)
    set(${RESULT} "vc11")
  elseif(MSVC_VERSION EQUAL 1800)
    set(${RESULT} "vc12")
  elseif(MSVC_VERSION EQUAL 1900)
    set(${RESULT} "vc14")
  endif()

  if(MINGW)
    set(${RESULT} "mingw")
  endif()
endmacro()
mr_get_compiler(mrcmex_cplname)

# 是否64位 ------------------------------------------------------------
macro(mr_get_is64xorx86 RESULT)
    if(CMAKE_CL_64)
      set(${RESULT} "x64")
    else()
      set(${RESULT} "")
    endif()

    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(${RESULT} "x64")
    else()
        set(${RESULT} "")
    endif()
endmacro()
mr_get_is64xorx86(mrcmex_isx64)

# 使用虚拟文件夹 ------------------------------------------------------------
macro(mr_source_group_by_name source_files)
    set(_ARG_LIST "${ARGN}")
    list(LENGTH _ARG_LIST argLength)
    set(vir_path "")
    if(argLength EQUAL 0)
        set(vir_path "\\")
    else()
        set(ncount 0)
        foreach(_ARG_ITEM ${_ARG_LIST})
            set(vir_path_item ${_ARG_ITEM})
            if(ncount EQUAL 0)
                set(vir_path ${vir_path_item})
            else()
                set(vir_path ${vir_path}\\${vir_path_item})
            endif()
            math(EXPR ncount ${ncount}+1)
        endforeach()
    endif()
    foreach(sgbd_file ${${source_files}})
        source_group(${vir_path} FILES ${sgbd_file})
    endforeach()
endmacro()

# 修正路径 使用/形式 ------------------------------------------------------------
macro(mr_source_fix_path source_files)
   set(source_files_2 "")
   foreach(src_file ${${source_files}})
      string(REPLACE "\\" "/"  src_file ${src_file})
       list(APPEND source_files_2 ${src_file})
   endforeach(src_file)
  set(${source_files} ${source_files_2})
endmacro()


# 使用虚拟文件夹 ------------------------------------------------------------
macro(mr_source_group_by_dir source_files where_filestart )
    if(MSVC_IDE OR CMAKE_GENERATOR STREQUAL Xcode)
        set(sgbd_cur_dir ${where_filestart})
        get_filename_component(sgbd_cur_dir_full ${sgbd_cur_dir} ABSOLUTE)
        foreach(sgbd_file ${source_files})
            get_filename_component(sgbd_file_full ${sgbd_file} ABSOLUTE)
            string(REGEX REPLACE ${sgbd_cur_dir_full}/\(.*\) \\1 sgbd_fpath ${sgbd_file_full})
            string(REGEX REPLACE "\(.*\)/.*" \\1 sgbd_group_name ${sgbd_fpath})
            string(COMPARE EQUAL ${sgbd_fpath} ${sgbd_group_name} sgbd_nogroup)
            if(sgbd_nogroup)
                set(sgbd_group_name "\\")
            endif(sgbd_nogroup)
            string(REPLACE "/" "\\" sgbd_group_name ${sgbd_group_name})
            source_group(${sgbd_group_name} FILES ${sgbd_file_full})
        endforeach(sgbd_file)
    endif()
endmacro()

# 使用虚拟文件夹 ------------------------------------------------------------
macro(mr_source_group_by_target target where_filestart )
    if(MSVC_IDE OR CMAKE_GENERATOR STREQUAL Xcode)
        GET_TARGET_PROPERTY(source_files ${target} SOURCES)
        set(sgbd_cur_dir ${where_filestart})
        get_filename_component(sgbd_cur_dir_full ${sgbd_cur_dir} ABSOLUTE)
        foreach(sgbd_file ${source_files})
            get_filename_component(sgbd_file_full ${sgbd_file} ABSOLUTE)
            string(REGEX REPLACE ${sgbd_cur_dir_full}/\(.*\) \\1 sgbd_fpath ${sgbd_file_full})
            string(REGEX REPLACE "\(.*\)/.*" \\1 sgbd_group_name ${sgbd_fpath})
            string(COMPARE EQUAL ${sgbd_fpath} ${sgbd_group_name} sgbd_nogroup)
            if(sgbd_nogroup)
                set(sgbd_group_name "\\")
            endif(sgbd_nogroup)
            string(REPLACE "/" "\\" sgbd_group_name ${sgbd_group_name})
            source_group(${sgbd_group_name} FILES ${sgbd_file_full})
        endforeach(sgbd_file)
    endif()
endmacro()


# 预编译头
#----------------------------------------------------------------------------------
# Support macro to use a precompiled header
# Usage:
#   mr_use_pchhd(
#                  TARGET
#                  PCH_HEADER_FILE
#                  PCH_SRC_FILE
#                  SOURCE_FILES
#                  [PCH_FOLDER ;PCH_FOLDER_NAME;]
#                  [EXCLUDING  ;FILES_TO_EXCLUDE;])
# set(mr_use_pchhd_debug ON) 查看调试信息
#----------------------------------------------------------------------------------
macro(mr_use_pchhd_debug_log)
    if(mr_use_pchhd_debug)
        message(STATUS ${ARGN})
    endif()
endmacro()
macro(mr_use_pchhd TARGET PCH_HEADER PCH_SOURCE)
  get_filename_component(HEADER ${PCH_HEADER} NAME)
  set(_PCH_FOLDER "")
  set(SOURCE_FILES "")
  set(EXCLUDED_FILES "")
  set(_EXCLUDE FALSE)
  set(PREV_VAL "")
  # 1. 获取参数
  foreach(_FILE ${ARGN})
    if ("${PREV_VAL}" STREQUAL "PCH_FOLDER")
        set(_PCH_FOLDER "${_FILE}")
    elseif ("${_FILE}" STREQUAL "EXCLUDING")
        set(_EXCLUDE TRUE)
    elseif (_EXCLUDE)
        list(APPEND EXCLUDED_FILES ${_FILE})
    else()
        list(APPEND SOURCE_FILES ${_FILE})
    endif()
    set(PREV_VAL ${_FILE})
  endforeach()
  # 2. 删除排除文件
  if (NOT "${EXCLUDED_FILES}" STREQUAL "")
    foreach(EX_FILE ${EXCLUDED_FILES})
        list(REMOVE_ITEM SOURCE_FILES ${EX_FILE})
    endforeach()
  else()
    #message("NO FILES EXCLUDED FROM PCH")
  endif()
  # 3. 设置预编译目录
  if (NOT "${_PCH_FOLDER}" STREQUAL "")
    set(HEADER "${_PCH_FOLDER}/${HEADER}")
  endif()
  # 4. 设置预编译编译选项
  if (MSVC_IDE)
    set_source_files_properties(${SOURCE_FILES} PROPERTIES COMPILE_FLAGS /Yu"${HEADER}" )
    set_source_files_properties(${PCH_SOURCE}   PROPERTIES COMPILE_FLAGS /Yc"${HEADER}" )
  endif()
endmacro()




# 正则移除列表项 ------------------------------------------------------------
macro(mr_list_filterout lst regex)
  foreach(item ${${lst}})
    if(item MATCHES "${regex}")
      list(REMOVE_ITEM ${lst} "${item}")
    endif()
  endforeach()
endmacro()


#迟加载 dll ------------------------------------------------------------
# 使用示例
#mr_add_delayload_dll(${_target_name} LINK_FLAGS_DEBUG "opencv_core.dll" "opencv_imgproc.dll")
#mr_add_delayload_dll(${_target_name} LINK_FLAGS_DEBUG "opencv_highgui.dll")
macro(mr_add_delayload_dll _target_name buildtype) #deloaydlls
  set(_ARG_LIST "${ARGN}")

  foreach(_ARG_ITEM ${_ARG_LIST})
    list(FIND mr_delayload_list_${_target_name}_${buildtype} ${_ARG_ITEM} fdIndex)
    if( fdIndex EQUAL -1)
        list(APPEND mr_delayload_list_${_target_name}_${buildtype} ${_ARG_ITEM})
    endif()
  endforeach()

  set(mr_flagsVar_delayload_${_target_name}_${buildtype} "")
  foreach(delayloaditem ${mr_delayload_list_${_target_name}_${buildtype}})
    set(mr_flagsVar_delayload_${_target_name}_${buildtype} "${mr_flagsVar_delayload_${_target_name}_${buildtype}} /DELAYLOAD:${delayloaditem}")
  endforeach()

  set_target_properties(${_target_name} PROPERTIES ${buildtype} "${mr_flagsVar_delayload_${_target_name}_${buildtype}}")
endmacro()





# ---------------------------------------------------------------------------------------------
#
#
#
# 工程设置相关
#
#
#
# ---------------------------------------------------------------------------------------------


# 执行文件生成输出方式 ------------------------------------------------------------
macro(mr_out_target_bin_path TARGET PATH)
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY             "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}")
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG       "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug")
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE     "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/release")

    set_target_properties(${TARGET} PROPERTIES COMPILE_PDB_OUTPUT_DIRECTORY_DEBUG   "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug")
    set_target_properties(${TARGET} PROPERTIES COMPILE_PDB_OUTPUT_DIRECTORY_RELEASE "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/release")

    set_target_properties(${TARGET} PROPERTIES PDB_OUTPUT_DIRECTORY_DEBUG           "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug")
    set_target_properties(${TARGET} PROPERTIES PDB_OUTPUT_DIRECTORY_RELEASE         "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/release")
    
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_NAME         ${TARGET})
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_NAME_DEBUG   ${TARGET})
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_NAME_RELEASE ${TARGET})
    
    set_target_properties(${TARGET} PROPERTIES PREFIX "")
    set_target_properties(${TARGET} PROPERTIES SUFFIX ".exe")  

    set_target_properties(${TARGET} PROPERTIES IMPORT_PREFIX "")
    set_target_properties(${TARGET} PROPERTIES IMPORT_SUFFIX ".lib")  
endmacro()

macro(mr_out_target_dll_path TARGET PATH)
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY          "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}")
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG    "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug")
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE  "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/release")

    set_target_properties(${TARGET} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY          "${PATH}/lib/${mrcmex_cplname}${mrcmex_isx64}")
    set_target_properties(${TARGET} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG    "${PATH}/lib/${mrcmex_cplname}${mrcmex_isx64}/debug")
    set_target_properties(${TARGET} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE  "${PATH}/lib/${mrcmex_cplname}${mrcmex_isx64}/release")

    set_target_properties(${TARGET} PROPERTIES COMPILE_PDB_OUTPUT_DIRECTORY_DEBUG   "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug")
    set_target_properties(${TARGET} PROPERTIES COMPILE_PDB_OUTPUT_DIRECTORY_RELEASE "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/release")

    set_target_properties(${TARGET} PROPERTIES PDB_OUTPUT_DIRECTORY_DEBUG           "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug")
    set_target_properties(${TARGET} PROPERTIES PDB_OUTPUT_DIRECTORY_RELEASE         "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/release")
    
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_NAME         ${TARGET})
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_NAME_DEBUG   ${TARGET})
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_NAME_RELEASE ${TARGET})
    
    #set_target_properties(${TARGET} PROPERTIES PREFIX "")
    #set_target_properties(${TARGET} PROPERTIES SUFFIX ".dll")  

    set_target_properties(${TARGET} PROPERTIES IMPORT_PREFIX "")
    set_target_properties(${TARGET} PROPERTIES IMPORT_SUFFIX ".lib")
endmacro()

macro(mr_out_target_lib_path TARGET PATH)
    set_target_properties(${TARGET} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY          "${PATH}/lib/${mrcmex_cplname}${mrcmex_isx64}")
    set_target_properties(${TARGET} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG    "${PATH}/lib/${mrcmex_cplname}${mrcmex_isx64}/debug")
    set_target_properties(${TARGET} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE  "${PATH}/lib/${mrcmex_cplname}${mrcmex_isx64}/release")

    set_target_properties(${TARGET} PROPERTIES COMPILE_PDB_OUTPUT_DIRECTORY_DEBUG   "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug")
    set_target_properties(${TARGET} PROPERTIES COMPILE_PDB_OUTPUT_DIRECTORY_RELEASE "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/release")

    set_target_properties(${TARGET} PROPERTIES PDB_OUTPUT_DIRECTORY_DEBUG           "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug")
    set_target_properties(${TARGET} PROPERTIES PDB_OUTPUT_DIRECTORY_RELEASE         "${PATH}/bin/${mrcmex_cplname}${mrcmex_isx64}/release")
    
    set_target_properties(${TARGET} PROPERTIES IMPORT_PREFIX "")
    set_target_properties(${TARGET} PROPERTIES IMPORT_SUFFIX ".lib")      
endmacro()

#----------------------------------------------------------------------------------
# 方便使用dll与lib的宏
# mr_use_dlllib(
#      dlllib_name          -库名
#      dlllib_ver           -版本
#      dlllib_path          -路径
#      dlllib_dllexportdef  -链接dll时宏定义
#      use_target_name      -使用库的目标
#      use_target_type      -使用的方式
#                static   outside prject static use
#                static2  inside prject static use
#                share    outside prject share use  <copy file when first cmake run> 
#                share2   outside prject share use  <copy file each exe run build> 
#                share3   inside prject share use   <copy file each exe run build> 
#  )
# 例子
# macro(mrlib_use_thedll target_name use_type)
#     mr_use_dlllib(thedll 1.1.0 ${THEDLL_CONFIG_PATH} THEDLL_DLL ${target_name} ${use_type})
# endmacro()
# 调试:set(mr_use_dlllib_debug ON) 查看调试信息
#----------------------------------------------------------------------------------
set(mr_use_dlllib_debug OFF)
macro(mr_use_dlllib_debug_log)
    if(mr_use_dlllib_debug)
        message(STATUS ${ARGN})
    endif()
endmacro()

macro(mr_use_dlllib dlllib_name dlllib_ver dlllib_path dlllib_dllexportdef use_target_name use_target_type)
    message(${use_target_name}  "使用:" ${use_target_type} "方式连接"  ${dlllib_name}  "库 version: "  ${dlllib_ver} )
    mr_use_dlllib_debug_log("mr_use_dlllib start :----")
    if(${use_target_type} STREQUAL "static")
        mr_use_dlllib_debug_log("mr_use_dlllib static use")
        target_include_directories(${use_target_name} PUBLIC ${dlllib_path})

        set(dlllib_ar_outpath_d  ${dlllib_path}/lib/${mrcmex_cplname}${mrcmex_isx64}/debug)
        set(dlllib_ar_outpath_r  ${dlllib_path}/lib/${mrcmex_cplname}${mrcmex_isx64}/release)

        target_link_libraries(${use_target_name} debug     "${dlllib_ar_outpath_d}/${dlllib_name}Static.lib")
        target_link_libraries(${use_target_name} optimized "${dlllib_ar_outpath_r}/${dlllib_name}Static.lib")
    endif()

    if(${use_target_type} STREQUAL "static2")
        mr_use_dlllib_debug_log("mr_use_dlllib static2 use")
        target_include_directories(${use_target_name} PUBLIC ${dlllib_path})

        get_target_property(dlllib_ar_outpath_d  ${dlllib_name}Static ARCHIVE_OUTPUT_DIRECTORY_DEBUG)
        get_target_property(dlllib_ar_outpath_r  ${dlllib_name}Static ARCHIVE_OUTPUT_DIRECTORY_RELEASE)

        target_link_libraries(${use_target_name} debug     "${dlllib_ar_outpath_d}/${dlllib_name}Static.lib")
        target_link_libraries(${use_target_name} optimized "${dlllib_ar_outpath_r}/${dlllib_name}Static.lib")

        add_dependencies(${use_target_name} ${dlllib_name}Static)
    endif()

    if(${use_target_type} STREQUAL "share")
        mr_use_dlllib_debug_log("mr_use_dlllib share copy the dlllib to target path")
        target_include_directories(${use_target_name} PUBLIC ${dlllib_path})
        target_compile_definitions(${use_target_name} PUBLIC ${dlllib_dllexportdef})

        set(dlllib_ar_outpath_d  ${dlllib_path}/lib/${mrcmex_cplname}${mrcmex_isx64}/debug)
        set(dlllib_ar_outpath_r  ${dlllib_path}/lib/${mrcmex_cplname}${mrcmex_isx64}/release)

        target_link_libraries(${use_target_name} debug     "${dlllib_ar_outpath_d}/${dlllib_name}.lib")
        target_link_libraries(${use_target_name} optimized "${dlllib_ar_outpath_r}/${dlllib_name}.lib")

        set(dlllib_rt_outpath_d  ${dlllib_path}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug)
        set(dlllib_rt_outpath_r  ${dlllib_path}/bin/${mrcmex_cplname}${mrcmex_isx64}/release)
        set(dlllib_rt_outpath    ${dlllib_path}/bin/${mrcmex_cplname}${mrcmex_isx64})

        get_target_property(target_rt_outpath_d ${use_target_name} RUNTIME_OUTPUT_DIRECTORY_DEBUG)
        get_target_property(target_rt_outpath_r ${use_target_name} RUNTIME_OUTPUT_DIRECTORY_RELEASE)
        get_target_property(target_rt_outpath   ${use_target_name} RUNTIME_OUTPUT_DIRECTORY)

        string(COMPARE NOTEQUAL ${dlllib_rt_outpath} ${target_rt_outpath} is_diff_dir)
        if(${is_diff_dir})
            if(EXISTS ${dlllib_rt_outpath_d}/${dlllib_name}.dll)
                file(COPY ${dlllib_rt_outpath_d}/${dlllib_name}.dll   DESTINATION ${target_rt_outpath_d})
            endif()
            
            if(EXISTS ${dlllib_rt_outpath_d}/${dlllib_name}.pdb )
                file(COPY ${dlllib_rt_outpath_d}/${dlllib_name}.pdb   DESTINATION ${target_rt_outpath_d})
            endif()
            
            if(EXISTS ${dlllib_rt_outpath_r}/${dlllib_name}.dll)
                file(COPY ${dlllib_rt_outpath_r}/${dlllib_name}.dll   DESTINATION ${target_rt_outpath_r})
            endif()
            
            if(EXISTS ${dlllib_rt_outpath_r}/${dlllib_name}.pdb)
                file(COPY ${dlllib_rt_outpath_r}/${dlllib_name}.pdb   DESTINATION ${target_rt_outpath_r})
            endif()            
        endif()
    endif()

    if(${use_target_type} STREQUAL "share2")
        mr_use_dlllib_debug_log("mr_use_dlllib share2 copy the dlllib to target path")
        target_include_directories(${use_target_name} PUBLIC ${dlllib_path})
        target_compile_definitions(${use_target_name} PUBLIC ${dlllib_dllexportdef})

        set(dlllib_ar_outpath_d  ${dlllib_path}/lib/${mrcmex_cplname}${mrcmex_isx64}/debug)
        set(dlllib_ar_outpath_r  ${dlllib_path}/lib/${mrcmex_cplname}${mrcmex_isx64}/release)

        target_link_libraries(${use_target_name} debug     "${dlllib_ar_outpath_d}/${dlllib_name}.lib")
        target_link_libraries(${use_target_name} optimized "${dlllib_ar_outpath_r}/${dlllib_name}.lib")

        set(dlllib_rt_outpath_d  ${dlllib_path}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug)
        set(dlllib_rt_outpath_r  ${dlllib_path}/bin/${mrcmex_cplname}${mrcmex_isx64}/release)
        set(dlllib_rt_outpath    ${dlllib_path}/bin/${mrcmex_cplname}${mrcmex_isx64})

        get_target_property(target_rt_outpath_d ${use_target_name} RUNTIME_OUTPUT_DIRECTORY_DEBUG)
        get_target_property(target_rt_outpath_r ${use_target_name} RUNTIME_OUTPUT_DIRECTORY_RELEASE)
        get_target_property(target_rt_outpath   ${use_target_name} RUNTIME_OUTPUT_DIRECTORY)

        string(COMPARE NOTEQUAL ${dlllib_rt_outpath} ${target_rt_outpath} is_diff_dir)
        if(${is_diff_dir})
             add_custom_command(TARGET ${use_target_name} PRE_BUILD
                 COMMAND ${CMAKE_COMMAND} -E copy_if_different \"${dlllib_rt_outpath}/$<CONFIG>/${dlllib_name}.dll\" \"${target_rt_outpath}/$<CONFIG>/${dlllib_name}.dll\"
                 COMMAND if exist \"${dlllib_rt_outpath}/$<CONFIG>/${dlllib_name}.pdb\"
                   (${CMAKE_COMMAND} -E copy_if_different \"${dlllib_rt_outpath}/$<CONFIG>/${dlllib_name}.pdb\" \"${target_rt_outpath}/$<CONFIG>/${dlllib_name}.pdb\")
                 WORKING_DIRECTORY ${dlllib_path}
                 COMMENT "Copy ${dlllib_name}.dll and ${dlllib_name}.pdb(if exist) Files To RunBin"
             )
         endif()
    endif()

    if(${use_target_type} STREQUAL "share3")
        mr_use_dlllib_debug_log("mr_use_dlllib share2 copy the dlllib to target path")
        target_include_directories(${use_target_name} PUBLIC ${dlllib_path})
        target_compile_definitions(${use_target_name} PUBLIC ${dlllib_dllexportdef})

        #set(dlllib_ar_outpath_d  ${dlllib_path}/lib/${mrcmex_cplname}${mrcmex_isx64}/debug)
        #set(dlllib_ar_outpath_r  ${dlllib_path}/lib/${mrcmex_cplname}${mrcmex_isx64}/release)
        get_target_property(dlllib_ar_outpath_d  ${dlllib_name} ARCHIVE_OUTPUT_DIRECTORY_DEBUG)
        get_target_property(dlllib_ar_outpath_r  ${dlllib_name} ARCHIVE_OUTPUT_DIRECTORY_RELEASE)

        target_link_libraries(${use_target_name} debug     "${dlllib_ar_outpath_d}/${dlllib_name}.lib")
        target_link_libraries(${use_target_name} optimized "${dlllib_ar_outpath_r}/${dlllib_name}.lib")

        #set(dlllib_rt_outpath_d  ${dlllib_path}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug)
        #set(dlllib_rt_outpath_r  ${dlllib_path}/bin/${mrcmex_cplname}${mrcmex_isx64}/release)
        #set(dlllib_rt_outpath    ${dlllib_path}/bin/${mrcmex_cplname}${mrcmex_isx64})
        get_target_property(dlllib_rt_outpath_d  ${dlllib_name} RUNTIME_OUTPUT_DIRECTORY_DEBUG)
        get_target_property(dlllib_rt_outpath_r  ${dlllib_name} RUNTIME_OUTPUT_DIRECTORY_RELEASE)
        get_target_property(dlllib_rt_outpath    ${dlllib_name} RUNTIME_OUTPUT_DIRECTORY)

        get_target_property(target_rt_outpath_d ${use_target_name} RUNTIME_OUTPUT_DIRECTORY_DEBUG)
        get_target_property(target_rt_outpath_r ${use_target_name} RUNTIME_OUTPUT_DIRECTORY_RELEASE)
        get_target_property(target_rt_outpath   ${use_target_name} RUNTIME_OUTPUT_DIRECTORY)

        string(COMPARE NOTEQUAL ${dlllib_rt_outpath} ${target_rt_outpath} is_diff_dir)
        if(${is_diff_dir})
             add_custom_command(TARGET ${use_target_name} PRE_BUILD
                 COMMAND ${CMAKE_COMMAND} -E copy_if_different \"${dlllib_rt_outpath}/$<CONFIG>/${dlllib_name}.dll\" \"${target_rt_outpath}/$<CONFIG>/${dlllib_name}.dll\"
                 COMMAND if exist \"${dlllib_rt_outpath}/$<CONFIG>/${dlllib_name}.pdb\"
                   (${CMAKE_COMMAND} -E copy_if_different \"${dlllib_rt_outpath}/$<CONFIG>/${dlllib_name}.pdb\" \"${target_rt_outpath}/$<CONFIG>/${dlllib_name}.pdb\")
                 WORKING_DIRECTORY ${dlllib_path}
                 COMMENT "Copy ${dlllib_name}.dll and ${dlllib_name}.pdb(if exist) Files To RunBin"
             )
         endif()

         add_dependencies(${use_target_name} ${dlllib_name})
    endif()
endmacro(mr_use_dlllib)



# 复制资源到目录  ------------------------------------------------------------
macro(mr_copy_res_to_target target_name res otherpath)

      get_target_property(rtoutpath_d ${target_name} RUNTIME_OUTPUT_DIRECTORY_DEBUG)
      string(FIND "${rtoutpath_d}" "-NOTFOUND" notfound_pos)
      if (notfound_pos EQUAL -1)
		 file(COPY ${res}     DESTINATION ${rtoutpath_d})
      endif()

	  get_target_property(rtoutpath_r ${target_name} RUNTIME_OUTPUT_DIRECTORY_RELEASE)
      string(FIND "${rtoutpath_r}" "-NOTFOUND" notfound_pos)
      if (notfound_pos EQUAL -1)
		 file(COPY ${res}  DESTINATION ${rtoutpath_r})
      endif()

      file(COPY ${res}  DESTINATION ${otherpath})
endmacro()


#----------------------------------------------------------------------------------
# 查看编译的信息
# mr_build_status
#----------------------------------------------------------------------------------
macro(mr_build_status)
    message(STATUS "--------------------------------------------------------------------------------")
    message(STATUS "CMAKE_GENERATOR  : " ${CMAKE_GENERATOR})
    message(STATUS "CMAKE_VERSION    : " ${CMAKE_VERSION})
    message(STATUS "MSVC_IDE : "         ${MSVC_IDE})
    message(STATUS "  C/C++:"                      )
    message(STATUS "      C++ Compiler:"           ${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ARG1} (ver ${CMAKE_CXX_COMPILER_VERSION}))
    message(STATUS "      C++ flags (Release):"    ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE})
    message(STATUS "      C++ flags (Debug):"      ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG})
    message(STATUS "      C Compiler:"             ${CMAKE_C_COMPILER} ${CMAKE_C_COMPILER_ARG1})
    message(STATUS "      C flags (Release):"      ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_RELEASE})
    message(STATUS "      C flags (Debug):"        ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_DEBUG})
    if(WIN32)
      message(STATUS "    EXE_Linker flags (Release):"    ${CMAKE_EXE_LINKER_FLAGS}    "  "  ${CMAKE_EXE_LINKER_FLAGS_RELEASE})
      message(STATUS "    EXE_Linker flags (Debug):"      ${CMAKE_EXE_LINKER_FLAGS}    "  "  ${CMAKE_EXE_LINKER_FLAGS_DEBUG})
      message(STATUS "    SHARED_Linker flags (Release):" ${CMAKE_SHARED_LINKER_FLAGS} "  "  ${CMAKE_SHARED_LINKER_FLAGS_RELEASE})
      message(STATUS "    SHARED_Linker flags (Debug):"   ${CMAKE_SHARED_LINKER_FLAGS} "  "  ${CMAKE_SHARED_LINKER_FLAGS_DEBUG})
    else()
      message(STATUS "    SHARED_Linker flags (Release):" ${CMAKE_SHARED_LINKER_FLAGS} "  "  ${CMAKE_SHARED_LINKER_FLAGS_RELEASE})
      message(STATUS "    SHARED_Linker flags (Debug):"   ${CMAKE_SHARED_LINKER_FLAGS} "  "  ${CMAKE_SHARED_LINKER_FLAGS_DEBUG})
    endif()
    message(STATUS "")
    message(STATUS "--------------------------------------------------------------------------------")
endmacro(mr_build_status)


#------------------------------------------------------------------------------------------------------------------------
# mr_target_link_lib_dir 设置连接库的地址
#     target_name     : the target
#     the_link_flags  : LINK_FLAGS or LINK_FLAGS_DEBUG or LINK_FLAGS_RELEASE
#     link_path       : thepath
#
macro(mr_target_link_lib_dir target_name the_link_flags link_path)
    get_target_property(LINK_FLAGS_${target_name} ${target_name} ${the_link_flags} )
    string(FIND ${LINK_FLAGS_${target_name}} "-NOTFOUND" notfound_pos)
    if (NOT notfound_pos EQUAL -1)
        set(LINK_FLAGS_${target_name} " ")#没有设置,则清空,一定是空格
    endif()

    set(TheAddVal "/LIBPATH:\"${link_path}\"")

    string(FIND ${LINK_FLAGS_${target_name}} ${TheAddVal} notfound_pos)
    if (notfound_pos EQUAL -1) #没找到
      set(LINK_FLAGS_${target_name}  "${LINK_FLAGS_${target_name}} ${TheAddVal}")
    endif()
    set_target_properties(${target_name} PROPERTIES ${the_link_flags} ${LINK_FLAGS_${target_name}} )
endmacro()

# E:/Mote/XXX ==> E:/Mote
macro(mr_get_updir path updirpath)
    get_filename_component(pathfull ${path} ABSOLUTE)
    string(FIND ${pathfull} / strpos REVERSE)
    string(SUBSTRING ${pathfull} 0 ${strpos} ${updirpath})
endmacro()

# E:/Mote/XXX ==> XXX
macro(mr_get_folder path folder)
    get_filename_component(pathfull ${path} ABSOLUTE)
    string(FIND ${pathfull} / strpos REVERSE)
    math(EXPR strpos2 ${strpos}+1)
    string(SUBSTRING ${pathfull} ${strpos2} -1 ${folder})
endmacro()


macro(mr_get_cur_file_dir path)
    get_filename_component(mr_get_cur_dir_path "${CMAKE_CURRENT_LIST_FILE}" PATH ABSOLUTE)
    set(${path} ${mr_get_cur_dir_path})
endmacro()

macro(mr_get_cur_folder folder)
    mr_get_cur_file_dir(mr_get_cur_folder_path)
    mr_get_folder(${mr_get_cur_folder_path}  ${folder})
endmacro()



# ------------------------------------------------------------
macro(mr_build_mt_global)
  foreach(flag_var
          CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE
          CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO
          CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
          CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
    if(${flag_var} MATCHES "/MD")
      string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
    endif()
    if(${flag_var} MATCHES "/MDd")
      string(REGEX REPLACE "/MDd" "/MTd" ${flag_var} "${${flag_var}}")
    endif()
  endforeach(flag_var)

  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:atlthunk.lib /NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:msvcrtd.lib")
  set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /NODEFAULTLIB:libcmt.lib")
  set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /NODEFAULTLIB:libcmtd.lib")
endmacro()

# ------------------------------------------------------------
macro(mr_build_md_global)
  foreach(flag_var
          CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE
          CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO
          CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
          CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
    if(${flag_var} MATCHES "/MT")
      string(REGEX REPLACE "/MT" "/MD" ${flag_var} "${${flag_var}}")
    endif()
    if(${flag_var} MATCHES "/MTd")
      string(REGEX REPLACE "/MTd" "/MDd" ${flag_var} "${${flag_var}}")
    endif()
  endforeach(flag_var)
endmacro()

# ------------------------------------------------------------
macro(mr_build_pdb_global)
  string(REPLACE "/Zi" "" CMAKE_C_FLAGS_RELEASE      "${CMAKE_C_FLAGS_RELEASE}")
  string(REPLACE "/Zi" "" CMAKE_CXX_FLAGS_RELEASE    "${CMAKE_CXX_FLAGS_RELEASE}")
  set(CMAKE_C_FLAGS_RELEASE   "${CMAKE_C_FLAGS_RELEASE}   /Zi")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Zi")

  string(REPLACE "/DEBUG" "" CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
  string(REPLACE "/debug" "" CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
  set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG")

  string(REPLACE "/DEBUG" "" CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
  string(REPLACE "/debug" "" CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
  set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /DEBUG")

  string(REPLACE "/DEBUG" "" CMAKE_MODULE_LINKER_FLAGS_RELEASE "${CMAKE_MODULE_LINKER_FLAGS_RELEASE}")
  string(REPLACE "/debug" "" CMAKE_MODULE_LINKER_FLAGS_RELEASE "${CMAKE_MODULE_LINKER_FLAGS_RELEASE}")
  set(CMAKE_MODULE_LINKER_FLAGS_RELEASE "${CMAKE_MODULE_LINKER_FLAGS_RELEASE} /DEBUG")
endmacro()

# ------------------------------------------------------------
macro(mr_build_mfc _target_name)
    target_compile_definitions(${_target_name} PUBLIC _AFXDLL)
endmacro()

# ------------------------------------------------------------
macro(mr_build_unicode _target_name)
  target_compile_definitions(${_target_name} PUBLIC UNICODE _UNICODE)
  set_target_properties(${_target_name} PROPERTIES LINK_FLAGS "/ENTRY:wmainCRTStartup")
endmacro()

# ------------------------------------------------------------
macro(mr_build_unicode_win _target_name)
  target_compile_definitions(${_target_name} PUBLIC UNICODE _UNICODE)
  set_target_properties( ${_target_name} PROPERTIES LINK_FLAGS "/ENTRY:wWinMainCRTStartup")
endmacro()

macro(mr_safe_copy_file _target_file _target_path)
    if(EXISTS ${_target_file})    
        file(COPY ${_target_file} DESTINATION ${_target_path})
    endif()
endmacro()

macro(mr_out_path_global)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG    ${CMAKE_SOURCE_DIR}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE  ${CMAKE_SOURCE_DIR}/bin/${mrcmex_cplname}${mrcmex_isx64}/release)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG    ${CMAKE_SOURCE_DIR}/bin/${mrcmex_cplname}${mrcmex_isx64}/debug)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE  ${CMAKE_SOURCE_DIR}/bin/${mrcmex_cplname}${mrcmex_isx64}/release)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG    ${CMAKE_SOURCE_DIR}/lib/${mrcmex_cplname}${mrcmex_isx64}/debug)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE  ${CMAKE_SOURCE_DIR}/lib/${mrcmex_cplname}${mrcmex_isx64}/release)
endmacro()
