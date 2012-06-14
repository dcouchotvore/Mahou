#include "main.h"
#include "DLLInterface.h"

Mahou::DLLInterface dll;

void DLL_EXPORT Initialize(const char *const db_path) {
    dll.Initialize(db_path);
}

void DLL_EXPORT AddLibraryPath(const char *const path) {
    dll.AddLibraryPath(path);
}

void DLL_EXPORT LoadLibraries() {
    dll.LoadLibraries();
}

int DLL_EXPORT GetLibraryCount() {
    return dll.GetLibraryCount();
}

int DLL_EXPORT GetLibraryName(char *buffer) {
    return dll.GetLibraryName(buffer);
}

int DLL_EXPORT GetDeviceName(const char *const libname, char *value) {
    return dll.GetDeviceName(libname, value);
}

int DLL_EXPORT GetParameterCount(const char *const libname) {
    return dll.GetParameterCount(libname);
}

int DLL_EXPORT GetParameterData(const char *const libname, char *name, int *type, int *is_read_only) {
    return dll.GetParameterData(libname, name, type, is_read_only);
}

int DLL_EXPORT SetParameter(const char *const libname, const char *name, const char *value) {
    return dll.SetParameter(libname, name, value);
}

int DLL_EXPORT GetParameter(const char *const libname, const char *name, char *value) {
    return dll.GetParameter(libname, name, value);
}

int DLL_EXPORT GoTo(const char *const libname, double pos, int async) {
    return dll.GoTo(libname, pos, async!=0);
}

double DLL_EXPORT Poll(const char *const libname) {
	return dll.Poll(libname);
}

int DLL_EXPORT SetData(const char *const libname, const double *data) {
    return dll.SetData(libname, data);
}

int DLL_EXPORT GetData(const char *const libname, double *data) {
    return dll.GetData(libname, data);
}

int DLL_EXPORT IoCtrl(const char *const libname, const int method, void *data) {
    return dll.IoCtrl(libname, method, data);
}

int DLL_EXPORT SendMsg(const char *const libname, const char *msg, const unsigned int len) {
    return dll.SendMsg(libname, msg, len);
}

int DLL_EXPORT RecvMsg(const char *const libname, char *msg, const unsigned int max_len) {
    return dll.RecvMsg(libname, msg, max_len);
}

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
    ::MessageBoxA(0, "Here", "HERE", MB_OK);
    switch (fdwReason)
    {
        case DLL_PROCESS_ATTACH:
            // attach to process
            // return FALSE to fail DLL load
            break;

        case DLL_PROCESS_DETACH:
            // detach from process
            break;

        case DLL_THREAD_ATTACH:
            // attach to thread
            break;

        case DLL_THREAD_DETACH:
            // detach from thread
            break;
    }
    return TRUE; // succesful
}
