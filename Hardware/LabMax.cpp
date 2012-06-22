/************************************************************************
* Project:
* Create Date: 8 May 2012
* Originator:  Duane A. Couchot-Vore
* $Rev: 1 $
* $Date: $
*************************************************************************
*
* Function: Common interface DLL for LabMax meter.  Wraps the OCX
*           provided by Coherent.
*
*************************************************************************
*
* Copyright 2012 Garrett-Roe Lab, University of Pittsburgh
*
************************************************************************/

#include "LabMax.h"

namespace Mahou {

LabMax::LabMax(const char *const deviceName) : ParameteredContainer(deviceName), TranslationStage(deviceName), SerialChannel(deviceName) { }

LabMax::~LabMax() { }

void LabMax::InitializeHardware() {
	SendCommand("Initialize");
};

void LabMax::TerminateHardware() {
	short int result;
	SendCommand("DeInitialize", &result);
}

void LabMax::GoTo(double pos, bool async) { }

double LabMax::Poll() const {
	return 0;
}

void LabMax::SetData(const double *) { }

void LabMax::GetData(double *) { }

void LabMax::IoCtrl(const int, void *) { }

void LabMax::SendMsg(const std::string &str) {
	BSTR bstr = Tools::ConvertMBSToBSTR(str);
	if ( InvokeMethod("SendCommandOrQuery", &bstr)!=S_OK )
		throw ExceptionCOMMethodFailed("SendCommandOrQuery");
}

void LabMax::RecvMsg(std::string &str) { }

}
