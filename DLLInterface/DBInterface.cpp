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
    m_parameter_lists.clear();
}

void DBInterface::RegisterParameterList(const std::string &name, NamedParameterList &parameterList) {
    m_parameter_lists[name] = &parameterList;
}

void DBInterface::SaveAll() {
    std::map<std::string, NamedParameterList*>::iterator ii;
    for ( ii = m_parameter_lists.begin(); ii!=m_parameter_lists.end(); ii++ ){
        const char *sectionname = ii->first.c_str();
        const std::vector<ParameterGeneric *> &parms = ii->second->getParameters();
        std::vector<ParameterGeneric *>::const_iterator jj;
        for ( jj = parms.begin(); jj!=parms.end(); jj++ ) {
            const char *key = (*jj)->Name();
            const int MAX_BUF = 1024;
            char value[MAX_BUF];
            ParameterGeneric *parm = (*jj);
            if ( dynamic_cast<Parameter<int>*>(parm) ){
                long val = (int)*(dynamic_cast<Parameter<int>*>(parm));
                sprintf(value, "%.*ld", MAX_BUF-1, val);
                }
            else if ( dynamic_cast<Parameter<float>*>(parm) ){
                float val = static_cast<double>(*(dynamic_cast<Parameter<float>*>(parm)));
                sprintf(value, "%.*G", MAX_BUF-1, val);
                }
            else if ( dynamic_cast<Parameter<double>*>(parm) ){
                double val = *(dynamic_cast<Parameter<double>*>(parm));
                sprintf(value, "%.*G", MAX_BUF-1, val);
                }
            else if ( dynamic_cast<Parameter<std::string>*>(parm) ){
                std::string val = (*(dynamic_cast<Parameter<std::string>*>(parm)));
                strncpy(value, val.c_str(), MAX_BUF-1);
                }
            else throw ExceptionSystem("Unknown parameter type in DBInterface.");
            ::WritePrivateProfileString(sectionname, key, value, m_file_path.c_str());
            }
        }
}

void DBInterface::LoadAll() {
    std::map<std::string, NamedParameterList*>::iterator ii;
    for ( ii = m_parameter_lists.begin(); ii!=m_parameter_lists.end(); ii++ ){
        const char *sectionname = ii->first.c_str();
        const std::vector<ParameterGeneric *> &parms = ii->second->getParameters();
        std::vector<ParameterGeneric *>::const_iterator jj;
        for ( jj = parms.begin(); jj!=parms.end(); jj++ ) {
            const char *key = (*jj)->Name();
            const int MAX_BUF = 1024;
            char value[MAX_BUF];
            ::GetPrivateProfileString(sectionname, key, "", value, MAX_BUF-1, m_file_path.c_str());        //@@@ Should get default from object.
            ParameterGeneric *parm = (*jj);
            if ( !parm->isReadOnly() ){
                if ( dynamic_cast<Parameter<int>*>(parm) ){
                    Parameter<int> &param = *(dynamic_cast<Parameter<int>*>(parm));
                    param = static_cast<int>(atol(value));
                    }
                else if ( dynamic_cast<Parameter<float>*>(parm) ){
                    Parameter<float> &param = *(dynamic_cast<Parameter<float>*>(parm));
                    param = atof(value);
                    }
                else if ( dynamic_cast<Parameter<double>*>(parm) ){
                    Parameter<double> &param = *(dynamic_cast<Parameter<double>*>(parm));
                    param = atof(value);
                    }
                else if ( dynamic_cast<Parameter<std::string>*>(parm) ){
                    Parameter<std::string> &param = *(dynamic_cast<Parameter<std::string>*>(parm));
                    param = std::string(value);
                    }
                else throw ExceptionSystem("Unknown parameter type in DBInterface.");
                }
            }
        }
}

}
