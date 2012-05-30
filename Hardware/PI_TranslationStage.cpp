/************************************************************************
* Project:
* Create Date: 8 May 2012
* Originator:  Duane A. Couchot-Vore
* $Rev: 1 $
* $Date: $
*************************************************************************
*
* Function: Common interface DLL for PI translation stage.  Wraps the DLL
*           provided by PI.
*
*************************************************************************
*
* Copyright 2012 Garrett-Roe Lab, University of Pittsburgh
*
************************************************************************/

#include "PI_TranslationStage.h"
#include "..\PI\PI_GCS2_DLL.h"

namespace Mahou {

PI_TranslationStage::PI_TranslationStage(const char *const deviceName) : ParameteredContainer(deviceName), TranslationStage(deviceName), DLLChannel(deviceName),
        m_id("ID", -1, true), m_idName("IDName", "", true), m_axis("Axis", "A", true),
         m_idStage("Stage ID", "M-505.4PD", true) {
    m_parameter_list.Add(&m_id);
    m_parameter_list.Add(&m_idName);
    m_parameter_list.Add(&m_axis);
    m_parameter_list.Add(&m_idStage);
/*
    // Connect to the device.

    m_id = PI_ConnectUSB(deviceName);
    if ( m_id<0 )
        throw ExceptionNoDevice(deviceName);

    char buffer[255];
    if ( !PI_qIDN(m_id, buffer, 255) )
		throw ExceptionCannotOpen("Could not read *IDN?");

    if ( !PI_qSAI_ALL(m_id, buffer, 255) )
        throw ExceptionCannotOpen("Could not read SAI? ALL");

    // Init stage

	if ( !PI_CST(m_id, m_axis, (const char *)m_idStage) )
        throw ExceptionCannotOpen("CST failed");

	if ( !PI_INI(m_id, m_axis) )
        throw ExceptionCannotOpen("INI failed");

    //  Verify that reference exists if it is needed.  Not 100% sure yet what this is all about

    do {
        BOOL bFlag = TRUE;
        if ( !PI_SVO(m_id, m_axis, &bFlag) )
            throw ExceptionCannotOpen("SVO failed");
        if ( !PI_qFRF(m_id, m_axis, &bFlag) )
            throw ExceptionCannotOpen("qFRF failed");
        if ( bFlag )
            break;

        if ( !PI_qTRS(m_id, m_axis, &bFlag) )
            throw ExceptionCannotOpen("qTRS failed");
        if ( bFlag ) { // stage has reference switch
            if ( !PI_FRF(m_id, m_axis) )
                throw ExceptionCannotOpen("REF failed");
            }
        else {
            if ( !PI_qLIM(m_id, m_axis, &bFlag) )
                throw ExceptionCannotOpen("qLIM failed");
            if ( bFlag ) {
                if ( !PI_FNL(m_id, m_axis) )
                    throw ExceptionCannotOpen("MNL failed");
                }
            else break;
            }

        do {
            Sleep(500);
            if ( !PI_IsControllerReady(m_id, &bFlag) )
                throw ExceptionCannotOpen("IsControllerReady failed");
            } while ( !bFlag );

        if ( !PI_qFRF(m_id, m_axis, &bFlag) )
            throw ExceptionCannotOpen("qFRF failed");
        if ( bFlag )
            break;
        else break;
    } while ( false );

    // Get the limits

    double value;
    if ( !PI_qTMN(m_id, m_axis, &value) )
        throw ExceptionCannotOpen("qTMN failed");
    m_minimum = value;
	if ( !PI_qTMX(m_id, m_axis, &value) )
        throw ExceptionCannotOpen("qTMX failed");
    m_maximum = value;
*/
}

PI_TranslationStage::~PI_TranslationStage() {
    PI_CloseConnection(m_id);
}

void PI_TranslationStage::GoTo(double target) {
	if ( !PI_MOV(m_id, m_axis, &target) )
        throw ExceptionMovement("MOV failed");
	BOOL bFlag = TRUE;
	double position;
	do {
		Sleep(500);
		if ( !PI_IsMoving(m_id, m_axis, &bFlag))
            throw ExceptionMovement("IsMoving failed");
		if ( !PI_qPOS(m_id, m_axis, &position))
            throw ExceptionMovement("qPOS failed");
        } while ( bFlag );
}

double PI_TranslationStage::Poll() const {
    return 0.0;
}

void PI_TranslationStage::SetData(const double *) { }

void PI_TranslationStage::GetData(double *) { }

void PI_TranslationStage::throw_exception_no_device(const char *const msg) {
    char buffer[1024];
    format_error_message(buffer, msg);
    throw ExceptionNoDevice(buffer);
}

void PI_TranslationStage::throw_exception_cannot_open(const char *const msg) {
    char buffer[1024];
    format_error_message(buffer, msg);
    throw ExceptionCannotOpen(buffer);
}

void PI_TranslationStage::format_error_message(char *buf, const char *const msg) {
	int error_num = PI_GetError(m_id);
	char error_str[1024];
	PI_TranslateError(error_num, error_str, 1024);
	printf("%s - error %d, %s\n", buf, error_num, error_str);
}

}


