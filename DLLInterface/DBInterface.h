/************************************************************************
* Project:
* Create Date: 20 March 2012
* Originator:  Duane A. Couchot-Vore
* $Rev: 1 $
* $Date: $
*************************************************************************
*
* Function: To locate commonly used constants in a common place.
*
*************************************************************************
*
* Copyright 2012 Garrett-Roe Lab, University of Pittsburgh
*
************************************************************************/

#ifndef __DBINTERFACE_H__
#define __DBINTERFACE_H__

#include "DLLWrapper.h"
#include <string>
#include <vector>

namespace Mahou {

class DBInterface {
    public:
        void SetFilePath(const char * const filePath);
        static DBInterface &Instance();
        ~DBInterface();
        void SaveAll();
        void LoadAll();
        void RegisterHardwareDLL(DLLWrapper &dll);
    protected:
        static std::string m_file_path;
        std::vector<DLLWrapper *> m_dlls;
    private:
        DBInterface() { }
        static DBInterface *m_instance;
};

}

#endif // __DBINTERFACE_H__
