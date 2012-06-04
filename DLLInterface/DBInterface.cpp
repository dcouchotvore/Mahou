/************************************************************************
* Project:
* Create Date: 20 March 2012
* Originator:  Duane A. Couchot-Vore
* $Rev: 1 $
* $Date: $
*************************************************************************
*
* Function:
*
*************************************************************************
*
* Copyright 2012 Garrett-Roe Lab, University of Pittsburgh
*
************************************************************************/

#include "DBInterface.h"
#include "../Hardware/Exceptions.h"
#include <windows.h>
#include <string.h>
#include <stdio.h>
#include <tchar.h>

namespace Mahou {

DBInterface *DBInterface::m_instance = 0;
std::string DBInterface::m_file_path = ".\\";

DBInterface &DBInterface::Instance() {
    if ( !m_instance ){
        if ( m_file_path=="" )
            throw ExceptionSystem("Path not assigned to settings database.");
        m_instance = new DBInterface;
        }
    return *m_instance;
}

DBInterface::~DBInterface() {
    m_dlls.clear();
}

void DBInterface::SetFilePath(const char * const filePath) {
    m_file_path = filePath;
}

void DBInterface::RegisterHardwareDLL(DLLWrapper &dll) {
    m_dlls.push_back(&dll);
}

void DBInterface::SaveAll() {
    std::vector<DLLWrapper*>::iterator ii;
    for ( ii = m_dlls.begin(); ii!=m_dlls.end(); ii++ ){
        char section_name[100];
        (*ii)->GetDeviceName(section_name);
        int pcount = (*ii)->GetParameterCount();
        for ( int jj=0; jj<pcount; jj++ ){
            char parameter_name[100];
            char parameter_data[100];
            (*ii)->GetParameterData(parameter_name, 0, 0);
            (*ii)->GetParameter(parameter_name, parameter_data);
            ::WritePrivateProfileString(section_name, parameter_name, parameter_data, m_file_path.c_str());
            }
        }
}

void DBInterface::LoadAll() {
    std::vector<DLLWrapper*>::iterator ii;
    for ( ii = m_dlls.begin(); ii!=m_dlls.end(); ii++ ){
        char section_name[100];
        (*ii)->GetDeviceName(section_name);
        int pcount = (*ii)->GetParameterCount();
        for ( int jj=0; jj<pcount; jj++ ) {
            char parameter_name[100];
            char parameter_data[100];
            (*ii)->GetParameterData(parameter_name, 0, 0);
            (*ii)->GetParameter(parameter_name, parameter_data);
            ::GetPrivateProfileString(section_name, parameter_name, "", parameter_data, sizeof(parameter_data)-1, m_file_path.c_str());
            (*ii)->SetParameterAlways(parameter_name, parameter_data);
            }
        }
}

}
