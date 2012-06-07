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

#include "Hardware/NamedParameterList.h"

#ifdef __cplusplus
extern "C"
{
#endif

int _cdecl DLL_EXPORT Create();
int _cdecl DLL_EXPORT Destroy();
int _cdecl DLL_EXPORT Initialize();
int _cdecl DLL_EXPORT Terminate();
int _cdecl DLL_EXPORT GetDeviceName(char *name);
int _cdecl DLL_EXPORT GetParameterCount();
int _cdecl DLL_EXPORT GetParameterData(char *name, int *type, int *is_read_only);
int _cdecl DLL_EXPORT GetParameter(const char *const parameterName, char *data);
int _cdecl DLL_EXPORT SetParameter(const char *const parameterName, const char *const data);
int _cdecl DLL_EXPORT SetParameterAlways(const char *const parameterName, const char *const data);
int _cdecl DLL_EXPORT GoTo(double pos, int async);
double _cdecl DLL_EXPORT Poll();
int _cdecl DLL_EXPORT SetData(const double *data);
int _cdecl DLL_EXPORT GetData(double *data);
int _cdecl DLL_EXPORT IoCtrl(const int method, void *data);
int _cdecl DLL_EXPORT SendMsg(const char *msg, const unsigned int len);
int _cdecl DLL_EXPORT RecvMsg(char *msg, const unsigned int max_len);

#ifdef __cplusplus
}
#endif

#include "Hardware/PI_TranslationStage.h"
#include "Hardware/HardwareDLL.h"

namespace Mahou {

class PI_TranslationStageDLL : public HardwareDLL {
    public:

        enum {  ERR_DLL_NONE            =    0,
                ERR_DLL_UNKNOWN         =   -1,
                ERR_DLL_NOSUCHPARAMETER =   -4,
                ERR_DLL_DATATRUNCATED   =   -8,
                ERR_DLL_MALFORMEDCLASS  =  -32
                } ErrorCode;

        PI_TranslationStageDLL(const char *deviceName) : HardwareDLL(deviceName) { }
        virtual ~PI_TranslationStageDLL() { }

        virtual int Create();
        virtual int Destroy();
        virtual int Initialize();
        virtual int Terminate();
};

}

#endif // __MAIN_H__
