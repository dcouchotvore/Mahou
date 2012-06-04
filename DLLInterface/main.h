#ifndef __MAIN_H__
#define __MAIN_H__

#include <windows.h>

/*  To use this exported function of dll, include this header
 *  in your project.
 */

#ifdef BUILD_DLL
    #define DLL_EXPORT __declspec(dllexport)
#else
    #define DLL_EXPORT __declspec(dllimport)
#endif


#ifdef __cplusplus
extern "C"
{
#endif

void DLL_EXPORT Initialize(HINSTANCE hinst);
void DLL_EXPORT AddLibraryPath(const char *const path);
void DLL_EXPORT LoadLibraries();
int DLL_EXPORT GetLibraryCount();
int DLL_EXPORT GetLibraryName(char *buffer);

int DLL_EXPORT GetDeviceName(const char *const libname, char *value);

int DLL_EXPORT GetParameterCount(const char *const libname);
int DLL_EXPORT GetParameterData(const char *const libname, char *name, int *type, int *is_read_only);
int DLL_EXPORT SetParameter(const char *const libname, const char *name, const char *value);
int DLL_EXPORT GetParameter(const char *const libname, const char *name, char *value);

int DLL_EXPORT GoTo(const char *const libname, double pos);
double DLL_EXPORT Poll(const char *const libname);
int DLL_EXPORT SetData(const char *const libname, const double *data);
int DLL_EXPORT GetData(const char *const libname, double *data);

int DLL_EXPORT IoCtrl(const char *const libname, const int method, void *data);
int DLL_EXPORT SendMsg(const char *const libname, const char *msg, const unsigned int len);
int DLL_EXPORT RecvMsg(const char *const libname, char *msg, const unsigned int max_len);

#ifdef __cplusplus
}
#endif

#endif // __MAIN_H__
