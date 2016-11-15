

cmake_minimum_required(VERSION 2.8)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}")
include(mrcmake)
mr_cmake_base_set()


include(ResizableLib/config.cmake)
include(mruiconfig.cmake)

project(MrClock)

add_subdirectory(src)

