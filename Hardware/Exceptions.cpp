/************************************************************************
* Project:
* Create Date: 20 March 2012
* Originator:  Duane A. Couchot-Vore
* $Rev: 1 $
* $Date: $
*************************************************************************
*
* Function: T
*
*************************************************************************
*
* Copyright 2012 Garrett-Roe Lab, University of Pittsburgh
*
************************************************************************/

static const char id[] = "$Id: Exceptions.cpp 122 2011-12-28 17:32:09Z dcouchotvore $";

#include "Exceptions.h"
#include <windows.h>

namespace Mahou {

int Exception::show() {
	std::string msg = Why();
#ifdef __SHOW_STACK__
	msg += "\r\n\r\n";
	for ( std::vector<std::string>::const_iterator ii = m_stackTrace.begin(); ii!=m_stackTrace.end(); ii++ )
		msg += *ii;
#endif
	return ::MessageBoxA(0, msg.c_str(), "Error", MB_OK);
}

std::string ExceptionEnumeratedSystem::prepareError(const std::string &msg, const int err) {
	std::string retval(msg);
	if ( err!=0 ) {
		m_message += " (";
		m_message += err;
		m_message += ": ";
		m_message += strerror(err);
		m_message += ")";
		}
	return retval;
}

}
