
@echo off
set PATH=%~dp0Cmake3.6.2\bin;%PATH%

if not exist _build\vc12 mkdir _build\vc12
cd _build\vc12

cmake -G"Visual Studio 12"  ../../ 

pause

cmake --build  ./ --config debug
cmake --build  ./ --config release

pause