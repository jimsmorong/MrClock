/** 
   *@file         ResizablelibExport.h
   *@brief        ResizablelibExport
   *@author       jimsmorong
   *@date         2015/07/28 10:36:42
 */
#ifndef RESIZABLELIBEXPORT_H_
#define RESIZABLELIBEXPORT_H_
#pragma once


#if defined(_WIN32) && defined(RESIZABLELIB_DLL)
#if defined(RESIZABLELIB_EXPORTS)
#define RESIZABLELIB_API          __declspec(dllexport)
#else
#define RESIZABLELIB_API          __declspec(dllimport)	
#endif
#else
#define RESIZABLELIB_API 
#endif


#endif //RESIZABLELIBEXPORT_H_
