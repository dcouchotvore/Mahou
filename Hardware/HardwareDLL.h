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

template <class T> class HardwareDLL {
    public:

        enum {  ERR_DLL_NONE            =    0,
                ERR_DLL_UNKNOWN         =   -1,
                ERR_DLL_NOSUCHPARAMETER =   -4,
                ERR_DLL_DATATRUNCATED   =   -8,
                ERR_DLL_MALFORMEDCLASS  =  -32
                } ErrorCode;

        HardwareDLL<T>(const char *const deviceName): m_deviceName(deviceName), m_container(0), m_parameter_index(0) { }
        virtual ~HardwareDLL() { };

        /* Global access methods */

        virtual int Create()=0;
        virtual int Destroy()=0;

        virtual int Initialize() {
			if ( !m_container )
				return ERR_DLL_MALFORMEDCLASS;
			try {
				dynamic_cast<T *>(m_container)->InitializeHardware();
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
			return 0;
		}

        virtual int Terminate() {
			if ( !m_container )
				return ERR_DLL_MALFORMEDCLASS;
			try {
				dynamic_cast<T *>(m_container)->TerminateHardware();
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
			return 0;
		}

        virtual int Connect() {
			if ( !m_container )
				return ERR_DLL_MALFORMEDCLASS;
			try {
				dynamic_cast<T *>(m_container)->Connect();
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
			return 0;
		}

        virtual int Disconnect() {
			if ( !m_container )
				return ERR_DLL_MALFORMEDCLASS;
			try {
				dynamic_cast<T *>(m_container)->Disconnect();
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
			return 0;
		}

        int GetDeviceName(char *value) {
			if ( !m_container )
				return ERR_DLL_MALFORMEDCLASS;
			std::string name;
			try {
				name = m_container->GetDeviceName();
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
			if ( value!=0 )
				strcpy(value, name.c_str());
			return name.size();
		}


        int GetParameterCount() {
			if ( !m_container )
				return ERR_DLL_MALFORMEDCLASS;
			try {
				m_parameter_index = 0;
				unsigned int count = m_container->GetParameterCount();
				ParameterData parameters[count];
				m_container->GetParameters(parameters);
				for ( unsigned int ii=0; ii<count; ii++ )
					m_parameter_data.push_back(parameters[ii]);
				return static_cast<int>(count);
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
		}

        int GetParameterData(char *name, int *type, int *is_read_only) {
			if ( !m_container )
				return ERR_DLL_MALFORMEDCLASS;
			if ( m_parameter_index<m_parameter_data.size() ){
				ParameterData data = m_parameter_data[m_parameter_index++];
				strcpy(name, data.Name);
				if ( type )         *type = data.Type;
				if ( is_read_only ) *is_read_only = data.IsReadOnly ? 1 : 0;
				return 1;
				}
			else return 0;
		}

        int SetParameter(const char *name, const char *value, bool force=false) {
			if ( !m_container )
				return ERR_DLL_MALFORMEDCLASS;
			try {
				if ( !m_container->ValidateParameterName(name) )
					return ERR_DLL_NOSUCHPARAMETER;
				return m_container->SetParameter<std::string>(name, value, force);                                // @@@ NOTE: beware of type conversions in parameters not being correct.
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
		}

        int GetParameter(const char *name, char *value) {    // If called with value=0 return size of required buffer
			if ( !m_container )
				return ERR_DLL_MALFORMEDCLASS;
			std::string result;
			try {
				if ( !m_container->ValidateParameterName(name) )
					return ERR_DLL_NOSUCHPARAMETER;
				result = static_cast<const char *>(*m_container->GetParameter(name));
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
			int string_size = result.size();
			if ( value )
				strcpy(value, result.c_str());
			return string_size;
		}

        /* Device hardware access methods */

        virtual int GoTo(double pos, int async) {
			T *funct = dynamic_cast<T *>(m_container);
			if ( !funct )
				return ERR_DLL_MALFORMEDCLASS;
			try {
				funct->GoTo(pos, async!=0);
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
			return 0;
		}

        virtual double Poll() const	{
			const T *funct = dynamic_cast<const T *>(m_container);
			if ( !funct )
				return ERR_DLL_MALFORMEDCLASS;
			try {
				return funct->Poll();
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
		}

        virtual int SetData(const double *data) {
			T *funct = dynamic_cast<T *>(m_container);
			if ( !funct )
				return ERR_DLL_MALFORMEDCLASS;
			try {
				funct->SetData(data);
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
			return 0;
		}

        virtual int GetData(double *data) {
			T *funct = dynamic_cast<T *>(m_container);
			if ( !funct )
				return ERR_DLL_MALFORMEDCLASS;
			try {
				funct->GetData(data);
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
			return 0;
		}

        /* Communications method access methods */

        virtual int IoCtrl(const int method, void *data) {
			T *comm = dynamic_cast<T *>(m_container);
			if ( !comm )
				return ERR_DLL_MALFORMEDCLASS;
			try {
				comm->IoCtrl(method, data);
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
			return 0;
		}

        virtual int SendMsg(const char *msg, const unsigned int len) {
			T *comm = dynamic_cast<T *>(m_container);
			if ( !comm )
				return ERR_DLL_MALFORMEDCLASS;
			std::string buf(msg, len);
			try {
				comm->SendMsg(buf);
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
			return 0;
		}

        virtual int RecvMsg(char *msg, const unsigned int max_len) {
			T *comm = dynamic_cast<T *>(m_container);
			if ( !comm )
				return ERR_DLL_MALFORMEDCLASS;
			std::string buf;
			try {
				comm->RecvMsg(buf);
				}
			catch (Exception E) {
				return resolve_exception(E);
				}
			strncpy(msg, buf.c_str(), max_len-1);
			if ( buf.size()>max_len-1 )
				return ERR_DLL_DATATRUNCATED;
			return 0;
		}

    protected:
        int resolve_exception(Exception &E) const {
			return ERR_DLL_UNKNOWN;
		}

        std::string m_deviceName;
        ParameteredContainer *m_container;
        std::vector<ParameterData> m_parameter_data;
        unsigned int m_parameter_index;
};

}

#endif // __HARDWAREDLL_H__
