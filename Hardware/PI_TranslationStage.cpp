<<<<<<< HEAD
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

PI_TranslationStage::PI_TranslationStage(const char *const deviceName) : ParameteredContainer(deviceName), TranslationStage(deviceName), SerialChannel(deviceName),
        m_id("ID", -1, true), m_idName("IDName", "", true), m_axis("Axis", "1", true), m_idStage("Stage ID", "M-505.4PD", true) {
    m_parameter_list.Add(&m_id);
    m_parameter_list.Add(&m_idName);
    m_parameter_list.Add(&m_axis);
    m_parameter_list.Add(&m_idStage);

	m_baud = 38400;
    m_acceleration = 10.0;
    m_acceleration.SetAction(this, accelerationAction);
    m_deceleration = 10.0;
    m_deceleration.SetAction(this, decelerationAction);
    m_speed = 0.75;
    m_speed.SetAction(this, speedAction);
}

PI_TranslationStage::~PI_TranslationStage() {
    PI_CloseConnection(m_id);
}

void PI_TranslationStage::InitializeHardware() {

    // Connect to the device.
   m_id = PI_ConnectRS232(m_port, m_baud);
    if ( static_cast<int>(m_id)<0 )
        throw ExceptionNoDevice(prepare_message(m_device_name.c_str()));

    char buffer[255];
    if ( !PI_qIDN(m_id, buffer, 255) )
		throw ExceptionCannotOpen(prepare_message("Could not read *IDN?"));

    if ( !PI_qSAI_ALL(m_id, buffer, 255) )
        throw ExceptionCannotOpen(prepare_message("Could not read SAI? ALL"));

    // Init stage

	if ( !PI_CST(m_id, m_axis, (const char *)m_idStage) ){
        throw ExceptionCannotOpen(prepare_message("CST failed"));
        }
    m_alive = true;                                     // We can update hardware settings now.
    accelerationAction(this);
    decelerationAction(this);
    speedAction(this);

// INI not supported by Mercury Controller
//	if ( !PI_INI(m_id, m_axis) )
//        throw ExceptionCannotOpen(prepare_message("INI failed"));

    //  Verify that reference exists if it is needed.  Not 100% sure yet what this is all about

    do {
        BOOL bFlag = TRUE;
        if ( !PI_SVO(m_id, m_axis, &bFlag) )
            throw ExceptionCannotOpen(prepare_message("SVO failed"));
        if ( !PI_qFRF(m_id, m_axis, &bFlag) )
            throw ExceptionCannotOpen(prepare_message("qFRF failed"));
        if ( bFlag )
            break;

        if ( !PI_qTRS(m_id, m_axis, &bFlag) )
            throw ExceptionCannotOpen(prepare_message("qTRS failed"));
        if ( bFlag ) { // stage has reference switch
            if ( !PI_FRF(m_id, m_axis) )
                throw ExceptionCannotOpen(prepare_message("REF failed"));
            }
        else {
            if ( !PI_qLIM(m_id, m_axis, &bFlag) )
                throw ExceptionCannotOpen(prepare_message("qLIM failed"));
            if ( bFlag ) {
                if ( !PI_FNL(m_id, m_axis) )
                    throw ExceptionCannotOpen(prepare_message("MNL failed"));
                }
            else break;
            }

        do {
            Sleep(500);
            if ( !PI_IsControllerReady(m_id, &bFlag) )
                throw ExceptionCannotOpen(prepare_message("IsControllerReady failed"));
            } while ( !bFlag );

        if ( !PI_qFRF(m_id, m_axis, &bFlag) )
            throw ExceptionCannotOpen(prepare_message("qFRF failed"));
        if ( bFlag )
            break;
        else break;
    } while ( false );

    // Get the limits

    double value;
    if ( !PI_qTMN(m_id, m_axis, &value) )
        throw ExceptionCannotOpen(prepare_message("qTMN failed"));
    m_minimum = value;
	if ( !PI_qTMX(m_id, m_axis, &value) )
        throw ExceptionCannotOpen(prepare_message("qTMX failed"));
    m_maximum = value;

}

void PI_TranslationStage::TerminateHardware() { }

void PI_TranslationStage::GoTo(double target, bool async) {
	if ( !PI_MOV(m_id, m_axis, &target) )
        throw ExceptionMovement(prepare_message("MOV failed"));
	BOOL bFlag = TRUE;
	if ( !async ) do {
        double position;
		Sleep(500);
		if ( !PI_IsMoving(m_id, m_axis, &bFlag))
            throw ExceptionMovement(prepare_message("IsMoving failed"));
		if ( !PI_qPOS(m_id, m_axis, &position))
            throw ExceptionMovement(prepare_message("qPOS failed"));
        } while ( bFlag );
}

double PI_TranslationStage::Poll() const {
	double position;
	if ( !PI_qPOS(m_id, m_axis, &position))
		throw ExceptionMovement(prepare_message("qPOS failed"));
    return position;
}

void PI_TranslationStage::SetData(const double *) { }

void PI_TranslationStage::GetData(double *) { }

int PI_TranslationStage::accelerationAction(ParameteredContainer *pobj) {
    PI_TranslationStage *obj = dynamic_cast<PI_TranslationStage *>(pobj);
    if ( obj->m_alive ) {
        double val = obj->m_acceleration;
        if ( !PI_ACC(obj->m_id, obj->m_axis, &val) )
            throw ExceptionMovement(obj->prepare_message("ACC failed"));            // @@@ Create appropriate exception class
        }
    return 0;
}

int PI_TranslationStage::decelerationAction(ParameteredContainer *pobj) {
    PI_TranslationStage *obj = dynamic_cast<PI_TranslationStage *>(pobj);
    if ( obj->m_alive ) {
        double val = obj->m_deceleration;
        if ( !PI_DEC(obj->m_id, obj->m_axis, &val) )
            throw ExceptionMovement(obj->prepare_message("DEC failed"));            // @@@ Create appropriate exception class
        }
    return 0;
}

int PI_TranslationStage::speedAction(ParameteredContainer *pobj) {
    PI_TranslationStage *obj = dynamic_cast<PI_TranslationStage *>(pobj);
    if ( obj->m_alive ) {
        double val = obj->m_speed;
        if ( !PI_VEL(obj->m_id, obj->m_axis, &val) )
            throw ExceptionMovement(obj->prepare_message("VEL failed"));            // @@@ Create appropriate exception class
        }
    return 0;
}

void PI_TranslationStage::throw_exception_no_device(const char *const msg) const {
    char buffer[1024];
    format_error_message(buffer, msg);
    throw ExceptionNoDevice(prepare_message(buffer));
}

void PI_TranslationStage::throw_exception_cannot_open(const char *const msg) const {
    char buffer[1024];
    format_error_message(buffer, msg);
    throw ExceptionCannotOpen(prepare_message(buffer));
}

void PI_TranslationStage::format_error_message(char *buf, const char *const msg) const {
	int error_num = PI_GetError(m_id);
	char error_str[1024];
	PI_TranslateError(error_num, error_str, 1024);
	printf("%s - error %d, %s\n", buf, error_num, error_str);
}

std::string PI_TranslationStage::prepare_message(const char *msg) const {
    std::string result(msg);
    result += ": ";
    long err = PI_GetError(m_id);
    char buf[1024];
    PI_TranslateError(err, buf, sizeof(buf));
    result += buf;
    return result;
}

}

=======
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

PI_TranslationStage::PI_TranslationStage(const char *const deviceName) : ParameteredContainer(deviceName), TranslationStage(deviceName), SerialChannel(deviceName),
        m_id("ID", -1, true), m_idName("IDName", "", true), m_axis("Axis", "A", true),
         m_idStage("Stage ID", "M-505.4PD", true) {
    m_parameter_list.Add(&m_id);
    m_parameter_list.Add(&m_idName);
    m_parameter_list.Add(&m_axis);
    m_parameter_list.Add(&m_idStage);

    m_acceleration = 10.0;
    m_acceleration.SetAction(this, accelerationAction);
    m_deceleration = 10.0;
    m_deceleration.SetAction(this, decelerationAction);
    m_speed = 0.75;
    m_speed.SetAction(this, speedAction);
}

PI_TranslationStage::~PI_TranslationStage() {
    PI_CloseConnection(m_id);
}

void PI_TranslationStage::InitializeHardware() {

    // Connect to the device.

    m_id = PI_ConnectRS232(m_port, m_baud);
    if ( static_cast<int>(m_id)<0 )
        throw ExceptionNoDevice(prepare_message(m_device_name.c_str()));

    char buffer[255];
    if ( !PI_qIDN(m_id, buffer, 255) )
		throw ExceptionCannotOpen(prepare_message("Could not read *IDN?"));

    if ( !PI_qSAI_ALL(m_id, buffer, 255) )
        throw ExceptionCannotOpen(prepare_message("Could not read SAI? ALL"));

    // Init stage

	PI_qCST(m_id, m_axis, buffer, 255);                 // @@@ DEBUG

	if ( !PI_CST(m_id, m_axis, (const char *)m_idStage) ){
        throw ExceptionCannotOpen(prepare_message("CST failed"));
        }

    m_alive = true;                                     // We can update hardware settings now.
    accelerationAction(this);
    decelerationAction(this);
    speedAction(this);

// INI not supported by Mercury Controller
//	if ( !PI_INI(m_id, m_axis) )
//        throw ExceptionCannotOpen(prepare_message("INI failed"));

    //  Verify that reference exists if it is needed.  Not 100% sure yet what this is all about

    do {
        BOOL bFlag = TRUE;
        if ( !PI_SVO(m_id, m_axis, &bFlag) )
            throw ExceptionCannotOpen(prepare_message("SVO failed"));
        if ( !PI_qFRF(m_id, m_axis, &bFlag) )
            throw ExceptionCannotOpen(prepare_message("qFRF failed"));
        if ( bFlag )
            break;

        if ( !PI_qTRS(m_id, m_axis, &bFlag) )
            throw ExceptionCannotOpen(prepare_message("qTRS failed"));
        if ( bFlag ) { // stage has reference switch
            if ( !PI_FRF(m_id, m_axis) )
                throw ExceptionCannotOpen(prepare_message("REF failed"));
            }
        else {
            if ( !PI_qLIM(m_id, m_axis, &bFlag) )
                throw ExceptionCannotOpen(prepare_message("qLIM failed"));
            if ( bFlag ) {
                if ( !PI_FNL(m_id, m_axis) )
                    throw ExceptionCannotOpen(prepare_message("FNL failed"));
                }
            else break;
            }

        do {
            Sleep(500);
            if ( !PI_IsControllerReady(m_id, &bFlag) )
                throw ExceptionCannotOpen(prepare_message("IsControllerReady failed"));
            } while ( !bFlag );

        if ( !PI_qFRF(m_id, m_axis, &bFlag) )
            throw ExceptionCannotOpen(prepare_message("qFRF failed"));
        if ( bFlag )
            break;
        else break;
    } while ( false );


    // Get the limits

    double value;
    if ( !PI_qTMN(m_id, m_axis, &value) )
        throw ExceptionCannotOpen(prepare_message("qTMN failed"));
    m_minimum = value;
	if ( !PI_qTMX(m_id, m_axis, &value) )
        throw ExceptionCannotOpen(prepare_message("qTMX failed"));
    m_maximum = value;

}

void PI_TranslationStage::TerminateHardware() { }

void PI_TranslationStage::GoTo(double target, bool async) {
	if ( !PI_MOV(m_id, m_axis, &target) )
        throw ExceptionMovement(prepare_message("MOV failed"));
	BOOL bFlag = TRUE;
	if ( !async ) do {
        double position;
		Sleep(500);
		if ( !PI_IsMoving(m_id, m_axis, &bFlag))
            throw ExceptionMovement(prepare_message("IsMoving failed"));
		if ( !PI_qPOS(m_id, m_axis, &position))
            throw ExceptionMovement(prepare_message("qPOS failed"));
        } while ( bFlag );
}

double PI_TranslationStage::Poll() const {
    return 0.0;             // @@@ write this
}

void PI_TranslationStage::SetData(const double *) { }

void PI_TranslationStage::GetData(double *) { }

int PI_TranslationStage::accelerationAction(ParameteredContainer *pobj) {
    PI_TranslationStage *obj = dynamic_cast<PI_TranslationStage *>(pobj);
    if ( obj->m_alive ) {
        double val = obj->m_acceleration;
        if ( !PI_ACC(obj->m_id, obj->m_axis, &val) )
            throw ExceptionMovement(obj->prepare_message("ACC failed"));            // @@@ Create appropriate exception class
        }
    return 0;
}

int PI_TranslationStage::decelerationAction(ParameteredContainer *pobj) {
    PI_TranslationStage *obj = dynamic_cast<PI_TranslationStage *>(pobj);
    if ( obj->m_alive ) {
        double val = obj->m_deceleration;
        if ( !PI_DEC(obj->m_id, obj->m_axis, &val) )
            throw ExceptionMovement(obj->prepare_message("DEC failed"));            // @@@ Create appropriate exception class
        }
    return 0;
}

int PI_TranslationStage::speedAction(ParameteredContainer *pobj) {
    PI_TranslationStage *obj = dynamic_cast<PI_TranslationStage *>(pobj);
    if ( obj->m_alive ) {
        double val = obj->m_speed;
        if ( !PI_VEL(obj->m_id, obj->m_axis, &val) )
            throw ExceptionMovement(obj->prepare_message("VEL failed"));            // @@@ Create appropriate exception class
        }
    return 0;
}

void PI_TranslationStage::throw_exception_no_device(const char *const msg) {
    char buffer[1024];
    format_error_message(buffer, msg);
    throw ExceptionNoDevice(prepare_message(buffer));
}

void PI_TranslationStage::throw_exception_cannot_open(const char *const msg) {
    char buffer[1024];
    format_error_message(buffer, msg);
    throw ExceptionCannotOpen(prepare_message(buffer));
}

void PI_TranslationStage::format_error_message(char *buf, const char *const msg) {
	int error_num = PI_GetError(m_id);
	char error_str[1024];
	PI_TranslateError(error_num, error_str, 1024);
	printf("%s - error %d, %s\n", buf, error_num, error_str);
}

std::string PI_TranslationStage::prepare_message(const char *msg){
    std::string result(msg);
    result += ": ";
    long err = PI_GetError(m_id);
    char buf[1024];
    PI_TranslateError(err, buf, sizeof(buf));
    result += buf;
    return result;
}

}


>>>>>>> SGRLAB-FTIR/master
