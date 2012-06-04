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

#include "DLLWrapper.h"
#include "Hardware/Exceptions.h"

namespace Mahou {

DLLWrapper::DLLWrapper(const char *const file_path) : m_module_handle(0), f_initialize(0), f_terminate(0), f_getDeviceName(0),
        f_getParameterCount(0), f_getParameterData(0), f_setParameter(0), f_getParameter(0), f_goTo(0), f_poll(0),
        f_setData(0), f_getData(0), f_ioCtrl(), f_sendMsg(), f_recvMsg(0) {
    m_module_handle = ::LoadLibrary(file_path);
    if ( !m_module_handle ){
        LPVOID lpMsgBuf;
        int err = ::GetLastError();
        ::FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_IGNORE_INSERTS|FORMAT_MESSAGE_FROM_SYSTEM, NULL, err,
                    MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPTSTR)&lpMsgBuf, 0, NULL);
        std::string msg(file_path);
        msg += ": ";
        msg += (LPCSTR)lpMsgBuf;
        LocalFree(lpMsgBuf);
        throw ExceptionLoadLibrary(msg.c_str());
        }
    load_proc_address("Initialize", reinterpret_cast<void **>(&f_initialize));
    load_proc_address("Terminate", reinterpret_cast<void **>(&f_terminate));
    load_proc_address("GetDeviceName", reinterpret_cast<void **>(&f_getDeviceName));

    load_proc_address("GetParameterCount", reinterpret_cast<void **>(&f_getParameterCount));
    load_proc_address("GetParameterData", reinterpret_cast<void **>(&f_getParameterData));
    load_proc_address("SetParameter", reinterpret_cast<void **>(&f_setParameter));
    load_proc_address("SetParameterAlways", reinterpret_cast<void **>(&f_setParameterAlways));
    load_proc_address("GetParameter", reinterpret_cast<void **>(&f_getParameter));
    load_proc_address("GoTo", reinterpret_cast<void **>(&f_goTo));
    load_proc_address("Poll", reinterpret_cast<void **>(&f_poll));
    load_proc_address("SetData", reinterpret_cast<void **>(&f_setData));
    load_proc_address("GetData", reinterpret_cast<void **>(&f_getData));
    load_proc_address("IoCtrl", reinterpret_cast<void **>(&f_ioCtrl));
    load_proc_address("SendMsg", reinterpret_cast<void **>(&f_sendMsg));
    load_proc_address("RecvMsg", reinterpret_cast<void **>(&f_recvMsg));
}

DLLWrapper::~DLLWrapper() {
    if ( m_module_handle )
        ::FreeLibrary(m_module_handle);
}

int DLLWrapper::Initialize() {
    return (*f_initialize)();
};

int DLLWrapper::Terminate() {
    return (*f_terminate)();
}

int DLLWrapper::GetDeviceName(char *value) {
    return (*f_getDeviceName)(value);
}

int DLLWrapper::GetParameterCount() {
    return (*f_getParameterCount)();
}

int DLLWrapper::GetParameterData(char *name, int *type, int *is_read_only) {
    return (*f_getParameterData)(name, type, is_read_only);
}

int DLLWrapper::SetParameter(const char *name, const char *value) {
    return (*f_setParameter)(name, value);
}

int DLLWrapper::SetParameterAlways(const char *name, const char *value) {
    return (*f_setParameterAlways)(name, value);
}

int DLLWrapper::GetParameter(const char *name, char *value) {
    return (*f_getParameter)(name, value);
}

int DLLWrapper::GoTo(double pos) {
    return (*f_goTo)(pos);
}

double DLLWrapper::Poll() const {
    return (*f_poll)();
}

int DLLWrapper::SetData(const double *data) {
    return (*f_setData)(data);
}

int DLLWrapper::GetData(double *data) {
    return (*f_getData)(data);
}

int DLLWrapper::IoCtrl(const int method, void *data) {
    return (*f_ioCtrl)(method, data);
}

int DLLWrapper::SendMsg(const char *msg, const unsigned int len) {
    return (*f_sendMsg)(msg, len);
}

int DLLWrapper::RecvMsg(char *msg, const unsigned int max_len) {
    return (*f_recvMsg)(msg, max_len);
}

void DLLWrapper::load_proc_address(const char *const name, void **fcall) {
    void *addr = reinterpret_cast<void *>(::GetProcAddress(m_module_handle, name));
    if ( !addr )
        throw ExceptionLibraryCallNotFound(name);
    *fcall = addr;
    }

}

