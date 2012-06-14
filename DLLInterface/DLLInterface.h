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

#ifndef __DLLINTERFACE_H__
#define __DLLINTERFACE_H__

#include "DLLWrapper.h"
#include <vector>
#include <map>
#include <string>

namespace Mahou {

class DLLInterface {
    public:
        DLLInterface();
        ~DLLInterface();
        void Initialize(const char *const db_path);
        void AddLibraryPath(const char *const path);
        void LoadLibraries();
        int GetLibraryCount() const;
        int GetLibraryName(char *buffer) const;

        int GetDeviceName(const char *const libname, char *value);

        int GetParameterCount(const char *const libname);
        int GetParameterData(const char *const libname, char *name, int *type, int *is_read_only);
        int SetParameter(const char *const libname, const char *name, const char *value);
        int GetParameter(const char *const libname, const char *name, char *value);

        /* Device hardware access methods */

        int GoTo(const char *const libname, double pos, bool async);
        double Poll(const char *const libname) const;
        int SetData(const char *const libname, const double *data);
        int GetData(const char *const libname, double *data);

        /* Communications method access methods */

        int IoCtrl(const char *const libname, const int method, void *data);
        int SendMsg(const char *const libname, const char *msg, const unsigned int len);
        int RecvMsg(const char *const libname, char *msg, const unsigned int max_len);
    private:
        DLLWrapper &library(const char *const libname) const;
        std::vector<std::string> m_library_paths;
        mutable std::map<std::string, DLLWrapper*> m_library_list;
        mutable std::map<std::string, DLLWrapper*>::iterator m_iterator;
        std::string m_root_path;
};


}
#endif // __DLLINTERFACE_H__
