/************************************************************************
* Project:
* Create Date: 20 March 2012
* Originator:  Duane A. Couchot-Vore
* $Rev: 1 $
* $Date: $
*************************************************************************
*
* Copyright 2012 Garrett-Roe Lab, University of Pittsburgh
*
*************************************************************************
*
* Function:
*
*************************************************************************/

#include "DeviceContainer.h"

namespace Mahou {

void DLLChannel::IoCtrl(const int method, void *data) { }
void DLLChannel::SendMsg(const std::string &msg) { }
void DLLChannel::RecvMsg(std::string &msg) { }

}
