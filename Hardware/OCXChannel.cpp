/************************************************************************
* Project:
* Create Date: 8 June 2012
* Originator:  Duane A. Couchot-Vore
* $Rev: 1 $
* $Date: $
*************************************************************************
*
* Copyright 2012 Garrett-Roe Lab, University of Pittsburgh
*
*************************************************************************
*
* Function:  Implement generic OCX Interface
*
*************************************************************************/

#include "DeviceContainer.h"

namespace Mahou {

OCXChannel::OCXChannel(const char *const deviceName, const char *const class_name) : ParameteredContainer(deviceName), CommunicationsMethod(deviceName), m_class_name(class_name) {
	::CoInitialize(NULL);
	WCHAR clsname[100];
	Tools::C2W(clsname, m_class_name.c_str());
	if ( ::CLSIDFromProgID(clsname, &m_class_id)!=S_OK )
		throw ExceptionCOMCreateObject(m_class_name.c_str());
	if ( ::CoCreateInstance(m_class_id, NULL, CLSCTX_ALL, IID_IUnknown, reinterpret_cast<void **>(&m_p_iunknown)) )
		throw ExceptionCOMCreateObject(m_class_name.c_str());
	m_p_iunknown->QueryInterface(IID_IDispatch, reinterpret_cast<void **>(&m_p_idispatch));
}

OCXChannel::~OCXChannel() { }

int OCXChannel::InvokeMethod(const char *const method_name, ...) {
/*	va_list argList;
	va_start(argList, method_name);
	VARIANT *res = m_dispatch.InvokeMethod(method_name, argList);
	va_end(argList);
	return res;*/
	return 0;
}

}
