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

//@@@ To do: exception handlers around calls.

#include "HardwareDLL.h"
#include "DeviceContainer.h"

namespace Mahou {

HardwareDLL::HardwareDLL(const char *deviceName) : m_deviceName(deviceName), m_container(0), m_parameter_index(0) {
}

HardwareDLL::~HardwareDLL() { }


int HardwareDLL::GetDeviceName(char *value){
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

// Returns tab delimited <name><tab><type><lf>... .  If called with buffer=0 just return size of required buffer.

int HardwareDLL::GetParameterCount() {
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

int HardwareDLL::GetParameterData(char *name, int *type, int *is_read_only) {
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

int HardwareDLL::SetParameter(const char *name, const char *value) {
    if ( !m_container )
        return ERR_DLL_MALFORMEDCLASS;
    try {
        if ( !m_container->ValidateParameterName(name) )
            return ERR_DLL_NOSUCHPARAMETER;
        return m_container->SetParameter<std::string>(name, value);                                // @@@ NOTE: beware of type conversions in parameters not being correct.
        }
    catch (Exception E) {
        return resolve_exception(E);
        }
}

int HardwareDLL::GetParameter(const char *name, char *value) {    // If called with value=0 return size of required buffer
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

int HardwareDLL::GoTo(double pos) {
    DeviceFunction *funct = dynamic_cast<DeviceFunction *>(m_container);
    if ( !funct )
        return ERR_DLL_MALFORMEDCLASS;
    try {
        funct->GoTo(pos);
        }
    catch (Exception E) {
        return resolve_exception(E);
        }
    return 0;
}

double HardwareDLL::Poll() const {
    const DeviceFunction *funct = dynamic_cast<const DeviceFunction *>(m_container);
    if ( !funct )
        return ERR_DLL_MALFORMEDCLASS;
    try {
        return funct->Poll();
        }
    catch (Exception E) {
        return resolve_exception(E);
        }
}

int HardwareDLL::SetData(const double *data) {
    DeviceFunction *funct = dynamic_cast<DeviceFunction *>(m_container);
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

int HardwareDLL::GetData(double *data) {
    DeviceFunction *funct = dynamic_cast<DeviceFunction *>(m_container);
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

int HardwareDLL::IoCtrl(const int method, void *data) {
    CommunicationsMethod *comm = dynamic_cast<CommunicationsMethod *>(m_container);
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

int HardwareDLL::SendMsg(const char *msg, const unsigned int len) {
    CommunicationsMethod *comm = dynamic_cast<CommunicationsMethod *>(m_container);
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

int HardwareDLL::RecvMsg(char *msg, const unsigned int max_len) {
    CommunicationsMethod *comm = dynamic_cast<CommunicationsMethod *>(m_container);
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

int HardwareDLL::resolve_exception(Exception &E) const {

    return ERR_DLL_UNKNOWN;
}
}
