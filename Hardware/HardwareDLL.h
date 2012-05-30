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

#ifndef __HARDWAREDLL_H__
#define __HARDWAREDLL_H__

#include "NamedParameterList.h"

namespace Mahou {

class HardwareDLL {
    public:

        enum {  ERR_DLL_NONE            =    0,
                ERR_DLL_UNKNOWN         =   -1,
                ERR_DLL_NOSUCHPARAMETER =   -4,
                ERR_DLL_DATATRUNCATED   =   -8,
                ERR_DLL_MALFORMEDCLASS  =  -32
                } ErrorCode;

        HardwareDLL(const char *const deviceName);
        virtual ~HardwareDLL();

        /* Global access methods */

        virtual int Initialize() = 0;
        virtual int Terminate() = 0;
        int GetDeviceName(char *value);

        int GetParameterCount();
        int GetParameterData(char *name, int *type, int *is_read_only);
        int SetParameter(const char *name, const char *value);
        int GetParameter(const char *name, char *value);                                           // If called with value=0 return size of required buffer.

        /* Device hardware access methods */

        virtual int GoTo(double pos);
        virtual double Poll() const;
        virtual int SetData(const double *data);
        virtual int GetData(double *data);

        /* Communications method access methods */

        virtual int IoCtrl(const int method, void *data);
        virtual int SendMsg(const char *msg, const unsigned int len);
        virtual int RecvMsg(char *msg, const unsigned int max_len);
    protected:
        int resolve_exception(Exception &E) const;
        std::string m_deviceName;
        ParameteredContainer *m_container;
        std::vector<ParameterData> m_parameter_data;
        unsigned int m_parameter_index;
};

}

#endif // __HARDWAREDLL_H__
