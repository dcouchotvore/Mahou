/************************************************************************
* Project:
* Create Date: 20 March 2012
* Originator:  Duane A. Couchot-Vore
* $Rev: 1 $
* $Date: $
*************************************************************************
*
* Function: This is the common interface to hardware DLL's from MATLAB.
*           This layer was found necessary to there would be a common
*           database for all pieces of hardware and to speed up the
*           MATLAB interface, which seems to be sluggish.
*
*************************************************************************
*
* Copyright 2012 Garrett-Roe Lab, University of Pittsburgh
*
************************************************************************/

#include "DLLInterface.h"
#include "Hardware/Exceptions.h"
#include <strings.h>
#include "DBInterface.h"

namespace Mahou {

DLLInterface::DLLInterface() : m_instance_handle(0) {
    m_library_paths.push_back(std::string(""));
    DBInterface::Instance().SetFilePath("experiment.cfg");
}

DLLInterface::~DLLInterface() {
    DBInterface::Instance().SaveAll();
    std::map<std::string, DLLWrapper*>::iterator ii;
    for ( ii=m_library_list.begin(); ii!=m_library_list.end(); ii++ ){
        ii->second->Terminate();
        ii->second->Disconnect();
        ii->second->Destroy();
        delete ii->second;
        }
}

void DLLInterface::Initialize(HINSTANCE hinst) {
    m_instance_handle = hinst;
    char fbuf[MAX_PATH];
    ::GetModuleFileName(hinst, fbuf, sizeof(fbuf));
    char *pos = strrchr(fbuf, '\\');
    if ( pos ) pos[1]=0;
    m_root_path = fbuf;
}

void DLLInterface::AddLibraryPath(const char *const path) {
    std::vector<std::string>::const_iterator ii;
    bool add_it = true;
    for ( ii=m_library_paths.begin(); ii!=m_library_paths.end(); ii++ ){
        if ( stricmp(ii->c_str(), path)==0 ){
            add_it = true;
            break;
            }
        }
    if ( add_it )
        m_library_paths.push_back(std::string(path));
}

void DLLInterface::LoadLibraries() {
    std::vector<std::string>::const_iterator ii;
    std::string path;
    for ( ii=m_library_paths.begin(); ii!=m_library_paths.end(); ii++ ){
        path = m_root_path+(*ii);
        WIN32_FIND_DATA fd;
        path += "*.dll";
        HANDLE handle = ::FindFirstFile(path.c_str(), &fd);
        if ( handle==INVALID_HANDLE_VALUE )
            continue;
        do {
            if ( stricmp(fd.cFileName, "DLLInterface-32.dll")!=0 && stricmp(fd.cFileName, "DLLInterface-64.dll")!=0 ){
                std::string dllpath = m_root_path+(*ii)+fd.cFileName;
                DLLWrapper *wrapper = new DLLWrapper(dllpath.c_str());
                wrapper->Create();
                char dname[100];
                wrapper->GetDeviceName(dname);
                m_library_list[dname] = wrapper;
                DBInterface::Instance().RegisterHardwareDLL(*wrapper);
                }
            } while ( ::FindNextFile(handle, &fd) );
        }
    DBInterface::Instance().LoadAll();

    // Must hold off initialization until after saved parameters are read in.

    std::map<std::string, DLLWrapper*>::iterator jj;
    for ( jj=m_library_list.begin(); jj!=m_library_list.end(); jj++ ){
        jj->second->Connect();
        jj->second->Initialize();
        }
}

int DLLInterface::GetLibraryCount() const {
    m_iterator = m_library_list.begin();
    return m_library_list.size();
}

int DLLInterface::GetLibraryName(char *buffer) const {
    if ( m_iterator==m_library_list.end() )
        return 0;
    strcpy(buffer, m_iterator++->first.c_str());
    return 1;
}

int DLLInterface::GetDeviceName(const char *const libname, char *value) {
    return library(libname).GetDeviceName(value);
};

int DLLInterface::GetParameterCount(const char *const libname) {
    return library(libname).GetParameterCount();
}

int DLLInterface::GetParameterData(const char *const libname, char *name, int *type, int *is_read_only) {
    return library(libname).GetParameterData(name, type, is_read_only);
}

int DLLInterface::SetParameter(const char *const libname, const char *name, const char *value) {
    return library(libname).SetParameter(name, value);
}

int DLLInterface::GetParameter(const char *const libname, const char *name, char *value) {
    return library(libname).GetParameter(name, value);
}

int DLLInterface::GoTo(const char *const libname, double pos, bool async) {
    return library(libname).GoTo(pos, async);
}

double DLLInterface::Poll(const char *const libname) const {
    return library(libname).Poll();
}

int DLLInterface::SetData(const char *const libname, const double *data) {
    return library(libname).SetData(data);
}

int DLLInterface::GetData(const char *const libname, double *data) {
    return library(libname).GetData(data);
}

int DLLInterface::IoCtrl(const char *const libname, const int method, void *data) {
    return library(libname).IoCtrl(method, data);
}

int DLLInterface::SendMsg(const char *const libname, const char *msg, const unsigned int len) {
    return library(libname).SendMsg(msg, len);
}

int DLLInterface::RecvMsg(const char *const libname, char *msg, const unsigned int max_len) {
    return library(libname).RecvMsg(msg, max_len);
}

DLLWrapper &DLLInterface::library(const char *const libname) const {
    if ( m_library_list.count(libname)==0 )
        throw ExceptionLoadLibrary(libname);
    return *m_library_list[std::string(libname)];
}

}
