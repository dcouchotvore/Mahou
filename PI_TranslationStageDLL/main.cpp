#include "main.h"
#include "Hardware/NamedParameterList.h"

Mahou::PI_TranslationStageDLL dll("PI_TranslationStage1");

// a sample exported function
int _cdecl DLL_EXPORT Initialize()
{
    return dll.Initialize();
}

int _cdecl DLL_EXPORT GetDeviceName(char *name) {
    return dll.GetDeviceName(name);
}

int _cdecl DLL_EXPORT GetParameterCount() {
    return dll.GetParameterCount();
}

int _cdecl DLL_EXPORT GetParameterData(char *name, int *type, int *is_read_only) {
    return dll.GetParameterData(name, type, is_read_only);
}

int _cdecl DLL_EXPORT GetParameter(const char *const parameterName, char *data) {
    return dll.GetParameter(parameterName, data);
}

int _cdecl DLL_EXPORT SetParameter(const char *const parameterName, const char *const data) {
    return dll.SetParameter(parameterName, data);
}

int _cdecl DLL_EXPORT Terminate() {
    return dll.Terminate();
}

int _cdecl DLL_EXPORT GoTo(double pos) {
    return dll.GoTo(pos);
}

double _cdecl DLL_EXPORT Poll() {
    return dll.Poll();
}

int _cdecl DLL_EXPORT SetData(const double *data) {
    return dll.SetData(data);
}

int _cdecl DLL_EXPORT GetData(double *data) {
    return dll.GetData(data);
}

int _cdecl DLL_EXPORT IoCtrl(const int method, void *data) {
    return dll.IoCtrl(method, data);
}

int _cdecl DLL_EXPORT SendMsg(const char *msg, const unsigned int len) {
    return dll.SendMsg(msg, len);
}

int _cdecl DLL_EXPORT RecvMsg(char *msg, const unsigned int max_len) {
    return dll.RecvMsg(msg, max_len);
}

int Mahou::PI_TranslationStageDLL::Initialize() {
    try {
        m_container = new Mahou::PI_TranslationStage(m_deviceName.c_str());
        }
    catch ( Mahou::Exception E) {
        return resolve_exception(E);
        }
    return 0;
}

int Mahou::PI_TranslationStageDLL::Terminate() {
    if ( m_container ) {
        try {
            delete m_container;
            m_container = 0;
            }
        catch ( Mahou::Exception E ) {
            return resolve_exception(E);
            }
        }
    return 0;
}

