/************************************************************************
* Project:
* Create Date: 20 March 2012
* Originator:  Duane A. Couchot-Vore
* $Rev: 1 $
* $Date: $
*************************************************************************
*
* Function: To encapsulate the interface to a specific hardware DLL
*
*************************************************************************
*
* Copyright 2012 Garrett-Roe Lab, University of Pittsburgh
*
************************************************************************/

#ifndef __DLLWRAPPER_H__
#define __DLLWRAPPER_H__

#include <windows.h>

namespace Mahou {

class DLLWrapper {
    public:
        DLLWrapper(const char *const file_path);
        virtual ~DLLWrapper();

        int Create();
        int Destroy();
        int Initialize();
        int Terminate();
        int GetDeviceName(char *value);

        int GetParameterCount();
        int GetParameterData(char *name, int *type, int *is_read_only);
        int SetParameter(const char *name, const char *value);
        int SetParameterAlways(const char *name, const char *value);
        int GetParameter(const char *name, char *value);                                           // If called with value=0 return size of required buffer.

        /* Dardware access methods */

        int GoTo(double pos, bool async);
        double Poll() const;
        int SetData(const double *data);
        int GetData(double *data);

        /* Communications method access methods */

        int IoCtrl(const int method, void *data);
        int SendMsg(const char *msg, const unsigned int len);
        int RecvMsg(char *msg, const unsigned int max_len);
    private:
        HMODULE m_module_handle;
        void load_proc_address(const char *const name, void **fcall);

        int _cdecl (*f_create)();
        int _cdecl (*f_destroy)();
        int _cdecl (*f_initialize)();
        int _cdecl (*f_terminate)();
        int _cdecl (*f_getDeviceName)(char *value);

        int _cdecl (*f_getParameterCount)();
        int _cdecl (*f_getParameterData)(char *name, int *type, int *is_read_only);
        int _cdecl (*f_setParameter)(const char *name, const char *value);
        int _cdecl (*f_setParameterAlways)(const char *name, const char *value);
        int _cdecl (*f_getParameter)(const char *name, char *value);                                           // If called with value=0 return size of required buffer.
        int _cdecl (*f_goTo)(double pos, int async);
        double _cdecl (*f_poll)();
        int _cdecl (*f_setData)(const double *data);
        int _cdecl (*f_getData)(double *data);
        int _cdecl (*f_ioCtrl)(const int method, void *data);
        int _cdecl (*f_sendMsg)(const char *msg, const unsigned int len);
        int _cdecl (*f_recvMsg)(char *msg, const unsigned int max_len);

};

}

#endif //  __DLLWRAPPER_H__
