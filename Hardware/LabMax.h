/************************************************************************
* Project:
* Create Date: 7 June 2012
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

#ifndef __LABMAX_H__
#define __LABMAX_H__

#include "DeviceContainer.h"
#include <string>

namespace Mahou {

#define DISP_OBJID_CLabMaxLowLevCtl         (100)
#define DISP_ID_CLabMaxLowLevCtl            (101)
#define DISP_ID_SendCommandOrQuery         	(102)
#define DISP_ID_GetNextString              	(103)
#define DISP_ID_ConnectToMeter             	(104)
#define DISP_ID_DisconnectFromMeter        	(105)
#define DISP_ID_CommunicationMode          	(106)
#define DISP_ID_RS232Settings              	(107)
#define DISP_ID_SerialNumber               	(108)
#define DISP_ID_Initialize                 	(109)
#define DISP_ID_DeInitialize               	(110)
#define DISP_ID_GPIBSettings               	(111)
#define DISP_ID_MeterAdded                 	(112)
#define DISP_ID_MeterRemoved               	(113)
#define DISP_ID_AsynchronousNotification 	(114)
#define DISP_ID_USBStreamingPacket 			(115)

class LabMax : public TranslationStage, public SerialChannel {

public:
    LabMax(const char *const deviceName);
    virtual ~LabMax();
    virtual void InitializeHardware();
    virtual void TerminateHardware();
    virtual void GoTo(double pos, bool async);
    virtual double Poll() const;
    virtual void SetData(const double *);
    virtual void GetData(double *);

    virtual void Connect() { }
    virtual void Disconnect() { }
    virtual void IoCtrl(const int method, void *data);
    virtual void SendMsg(const std::string &msg);
    virtual void RecvMsg(std::string &msg);
protected:

};

}

#endif // __LABMAX_H__
