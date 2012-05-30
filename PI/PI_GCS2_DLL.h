/////////////////////////////////////////////////////////////////////////////
// This is a part of the PI-Software Sources
// Copyright (C) 1995-2002 PHYSIK INSTRUMENTE GmbH
// All rights reserved.
//

///////////////////////////////////////////////////////////////////////////// 
// Program: PI_G-Control DLL
//
// Developer: JKa
//  
// File: PI_GCS_DLL.h : 
/////////////////////////////////////////////////////////////////////////////

//#include <windows.h>
//#include "stdwx.h"


#ifdef __cplusplus
extern "C" {
#endif

#ifdef WIN32
	#undef PI_FUNC_DECL
	#ifdef PI_GCS2_DLL_STATIC
		#define PI_FUNC_DECL WINAPI
	#else
		#ifdef PI_DLL_EXPORTS
			#ifndef UNKNOWN_GCS_DLL
				#define PI_FUNC_DECL __declspec(dllexport) WINAPI
			#else
				#define PI_FUNC_DECL WINAPI
			#endif
		#else
			#define PI_FUNC_DECL __declspec(dllimport) WINAPI
		#endif
	#endif
#else
	#define PI_FUNC_DECL
#endif


#ifndef WIN32
	#ifndef BOOL
	#define BOOL int
	#endif

	#ifndef TRUE
	#define TRUE 1
	#endif

	#ifndef FALSE
	#define FALSE 0
	#endif
#endif //WIN32



////////////////////////////////
// E-7XX Bits (PI_BIT_XXX). //
////////////////////////////////

/* Curve Controll PI_BIT_WGO_XXX */
#define PI_BIT_WGO_START_DEFAULT			0x00000001U
#define PI_BIT_WGO_START_EXTERN_TRIGGER		0x00000002U
#define PI_BIT_WGO_WITH_DDL_INITIALISATION	0x00000040U
#define PI_BIT_WGO_WITH_DDL					0x00000080U
#define PI_BIT_WGO_START_AT_ENDPOSITION		0x00000100U
#define PI_BIT_WGO_SINGLE_RUN_DDL_TEST		0x00000200U
#define PI_BIT_WGO_EXTERN_WAVE_GENERATOR	0x00000400U
#define PI_BIT_WGO_SAVE_BIT_1				0x00100000U
#define PI_BIT_WGO_SAVE_BIT_2				0x00200000U
#define PI_BIT_WGO_SAVE_BIT_3				0x00400000U

/* Wave-Trigger PI_BIT_TRG_XXX */
#define	PI_BIT_TRG_LINE_1					0x0001U
#define	PI_BIT_TRG_LINE_2					0x0002U
#define	PI_BIT_TRG_LINE_3					0x0003U
#define	PI_BIT_TRG_LINE_4					0x0008U
#define	PI_BIT_TRG_ALL_CURVE_POINTS			0x0100U

/* Data Record Configuration PI_DRC_XXX */
#define	PI_DRC_DEFAULT					0U
#define	PI_DRC_AXIS_TARGET_POS			1U
#define	PI_DRC_AXIS_ACTUAL_POS			2U
#define	PI_DRC_AXIS_POS_ERROR			3U
#define	PI_DRC_AXIS_DDL_DATA			4U
#define	PI_DRC_AXIS_DRIVING_VOL			5U
#define	PI_DRC_PIEZO_MODEL_VOL			6U
#define	PI_DRC_PIEZO_VOL				7U
#define	PI_DRC_SENSOR_POS				8U


/* P(arameter)I(nfo)F(lag)_M(emory)T(ype)_XX */
#define PI_PIF_MT_RAM					0x00000001U
#define PI_PIF_MT_EPROM					0x00000002U
#define PI_PIF_MT_ALL					(PI_PIF_MT_RAM | PI_PIF_MT_EPROM)

/* P(arameter)I(nfo)F(lag)_D(ata)T(ype)_XX */
#define PI_PIF_DT_INT					1U
#define PI_PIF_DT_FLOAT					2U
#define PI_PIF_DT_CHAR					3U


/////////////////////////////////////////////////////////////////////////////
// DLL initialization and comm functions
long	PI_FUNC_DECL	PI_InterfaceSetupDlg(const char* szRegKeyName);
long 	PI_FUNC_DECL	PI_ConnectRS232(long nPortNr, long iBaudRate);
#ifndef WIN32
long 	PI_FUNC_DECL	PI_ConnectRS232ByDevName(const char* szDevName, long BaudRate);
#endif
long 	PI_FUNC_DECL	PI_OpenRS232DaisyChain(long iPortNumber, long iBaudRate, long* pNumberOfConnectedDaisyChainDevices, char* szDeviceIDNs, long iBufferSize);
long 	PI_FUNC_DECL	PI_ConnectDaisyChainDevice(long iPortId, long iDeviceNumber);
void 	PI_FUNC_DECL	PI_CloseDaisyChain(long iPortId);

long	PI_FUNC_DECL	PI_ConnectNIgpib(const long nBoard, const long nDevAddr);

long	PI_FUNC_DECL	PI_ConnectTCPIP(const char* szHostname, long port);
long	PI_FUNC_DECL	PI_EnableTCPIPScan(long iMask);
long	PI_FUNC_DECL	PI_EnumerateTCPIPDevices(char* szBuffer, long iBufferSize, const char* szFilter);
long	PI_FUNC_DECL	PI_ConnectTCPIPByDescription(const char* szDescription);

long	PI_FUNC_DECL	PI_EnumerateUSB(char* szBuffer, long iBufferSize, const char* szFilter);
long	PI_FUNC_DECL	PI_ConnectUSB(const char* szDescription);
long	PI_FUNC_DECL	PI_ConnectUSBWithBaudRate(const char* szDescription,long iBaudRate);
long 	PI_FUNC_DECL	PI_OpenUSBDaisyChain(const char* szDescription, long* pNumberOfConnectedDaisyChainDevices, char* szDeviceIDNs, long iBufferSize);

BOOL	PI_FUNC_DECL	PI_IsConnected(long ID);
void	PI_FUNC_DECL	PI_CloseConnection(long ID);
long	PI_FUNC_DECL	PI_GetError(long ID);
BOOL	PI_FUNC_DECL	PI_SetErrorCheck(long ID, BOOL bErrorCheck);
BOOL	PI_FUNC_DECL	PI_TranslateError(long errNr, char* szBuffer, long iBufferSize);




/////////////////////////////////////////////////////////////////////////////
// general
BOOL PI_FUNC_DECL PI_qERR(long ID, long* pnError);
BOOL PI_FUNC_DECL PI_qIDN(long ID, char* szBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_INI(long ID, const char* szAxes);
BOOL PI_FUNC_DECL PI_qHLP(long ID, char* szBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_qHPA(long ID, char* szBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_qHPV(long ID, char* szBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_qCSV(long ID, double* pdCommandSyntaxVersion);
BOOL PI_FUNC_DECL PI_qOVF(long ID, const char* szAxes, BOOL* piValueArray);
BOOL PI_FUNC_DECL PI_RBT(long ID);
BOOL PI_FUNC_DECL PI_REP(long ID);
BOOL PI_FUNC_DECL PI_BDR(long ID, int iBaudRate);
BOOL PI_FUNC_DECL PI_qBDR(long ID, int* iBaudRate);
BOOL PI_FUNC_DECL PI_DBR(long ID, int iBaudRate);
BOOL PI_FUNC_DECL PI_qDBR(long ID, int* iBaudRate);
BOOL PI_FUNC_DECL PI_qVER(long ID, char* szBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_qSSN(long ID, char* szSerialNumber, int iBufferSize);
BOOL PI_FUNC_DECL PI_CCT(long ID, int iCommandType);
BOOL PI_FUNC_DECL PI_qCCT(long ID, int *iCommandType);
BOOL PI_FUNC_DECL PI_qTVI(long ID, char* szBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_IFC(long ID, const char* szParameters, const char* szValues);
BOOL PI_FUNC_DECL PI_qIFC(long ID, const char* szParameters, char* szBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_IFS(long ID, const char* szPassword, const char* szParameters, const char* szValues);
BOOL PI_FUNC_DECL PI_qIFS(long ID, const char* szParameters, char* szBuffer, int iBufferSize);

BOOL PI_FUNC_DECL PI_MOV(long ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_qMOV(long ID, const char* szAxes, double* pdValueArray);
BOOL PI_FUNC_DECL PI_MVR(long ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_MVE(long ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_POS(long ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_qPOS(long ID, const char* szAxes, double* pdValueArray);
BOOL PI_FUNC_DECL PI_IsMoving(long ID, const char* szAxes, BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_HLT(long ID, const char* szAxes);
BOOL PI_FUNC_DECL PI_STP(long ID);
BOOL PI_FUNC_DECL PI_qONT(long ID, const char* szAxes, BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_RTO(long ID, const char* szAxes);
BOOL PI_FUNC_DECL PI_qRTO(long ID, const char* szAxes, int* piValueArray);
BOOL PI_FUNC_DECL PI_ATZ(long ID, const char* szAxes, const double* pdLowvoltageArray, const BOOL* pfUseDefaultArray);
BOOL PI_FUNC_DECL PI_qATZ(long ID, const char* szAxes, int* piAtzResultArray);
BOOL PI_FUNC_DECL PI_AOS(int ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_qAOS(int ID, const char* szAxes, double* pdValueArray);
BOOL PI_FUNC_DECL PI_HasPosChanged(long ID, const char* szAxes, BOOL* pbValueArray);

BOOL PI_FUNC_DECL PI_SVA(long ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_qSVA(long ID, const char* szAxes, double* pdValueArray);
BOOL PI_FUNC_DECL PI_SVR(long ID, const char* szAxes, const double* pdValueArray);

BOOL PI_FUNC_DECL PI_DFH(long ID, const char* szAxes);
BOOL PI_FUNC_DECL PI_qDFH(long ID, const char* szAxes, double* pdValueArray);
BOOL PI_FUNC_DECL PI_GOH(long ID, const char* szAxes);

BOOL PI_FUNC_DECL PI_qCST(long ID, const char* szAxes, char* szNames, int iBufferSize);
BOOL PI_FUNC_DECL PI_CST(long ID, const char* szAxes, const char* szNames);
BOOL PI_FUNC_DECL PI_qVST(long ID, char* szBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_qPUN(long ID, const char* szAxes, char* szUnit, int iBufferSize);

BOOL PI_FUNC_DECL PI_SVO(long ID, const char* szAxes, const BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_qSVO(long ID, const char* szAxes, BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_SMO( long ID, const char*  szAxes, const int* piValueArray);
BOOL PI_FUNC_DECL PI_qSMO(long ID, const char* szAxes, int* piValueArray);
BOOL PI_FUNC_DECL PI_DCO(long ID, const char* szAxes, const BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_qDCO(long ID, const char* szAxes, BOOL* pbValueArray);

BOOL PI_FUNC_DECL PI_BRA(long ID, const char* szAxes, const BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_qBRA(long ID, const char* szAxes, BOOL* pbValueArray);

BOOL PI_FUNC_DECL PI_RON(long ID, const char* szAxes, const BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_qRON(long ID, const char* szAxes, BOOL* pbValueArray);

BOOL PI_FUNC_DECL PI_VEL(long ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_qVEL(long ID, const char* szAxes, double* pdValueArray);

BOOL PI_FUNC_DECL PI_qTCV(long ID, const char* szAxes, double* pdValueArray);

BOOL PI_FUNC_DECL PI_VLS(long ID, double dSystemVelocity);
BOOL PI_FUNC_DECL PI_qVLS(long ID, double* pdSystemVelocity);

BOOL PI_FUNC_DECL PI_ACC(long ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_qACC(long ID, const char* szAxes, double* pdValueArray);

BOOL PI_FUNC_DECL PI_DEC(long ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_qDEC(long ID, const char* szAxes, double* pdValueArray);

BOOL PI_FUNC_DECL PI_VCO(long ID, const char* szAxes, const BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_qVCO(long ID, const char* szAxes, BOOL* pbValueArray);

BOOL PI_FUNC_DECL PI_SPA(long ID, const char* szAxes, const unsigned int* iParameterArray, const double* pdValueArray, const char* szStrings);
BOOL PI_FUNC_DECL PI_qSPA(long ID, const char* szAxes, unsigned int* iParameterArray, double* pdValueArray, char* szStrings, int iMaxNameSize);
BOOL PI_FUNC_DECL PI_SEP(long ID, const char* szPassword, const char* szAxes, const unsigned int* iParameterArray, const double* pdValueArray, const char* szStrings);
BOOL PI_FUNC_DECL PI_qSEP(long ID, const char* szAxes, unsigned int* iParameterArray, double* pdValueArray, char* szStrings, int iMaxNameSize);
BOOL PI_FUNC_DECL PI_WPA(long ID, const char* szPassword, const char* szAxes, const unsigned int* iParameterArray);
BOOL PI_FUNC_DECL PI_RPA(long ID, const char* szAxes, const unsigned int* iParameterArray);
BOOL PI_FUNC_DECL PI_SPA_String(long ID, const char* szAxes, const unsigned int* iParameterArray, const char* szStrings);
BOOL PI_FUNC_DECL PI_qSPA_String(long ID, const char* szAxes, const unsigned int* iParameterArray, char* szStrings, int iMaxNameSize);
BOOL PI_FUNC_DECL PI_SEP_String(long ID, const char* szPassword, const char* szAxes, const unsigned int* iParameterArray, const char* szStrings);
BOOL PI_FUNC_DECL PI_qSEP_String(long ID, const char* szAxes, unsigned int* iParameterArray, char* szStrings, int iMaxNameSize);

BOOL PI_FUNC_DECL PI_STE(long ID, const char* szAxes, const double* dOffsetArray);
BOOL PI_FUNC_DECL PI_qSTE(long ID, const char* szAxes, double* pdValueArray);
BOOL PI_FUNC_DECL PI_IMP(long ID, const char*  szAxes, const double* pdImpulseSize);
BOOL PI_FUNC_DECL PI_IMP_PulseWidth(long ID, char cAxis, double dOffset, int iPulseWidth);
BOOL PI_FUNC_DECL PI_qIMP(long ID, const char* szAxes, double* pdValueArray);

BOOL PI_FUNC_DECL PI_SAI(long ID, const char* szOldAxes, const char* szNewAxes);
BOOL PI_FUNC_DECL PI_qSAI(long ID, char* szAxes, int iBufferSize);
BOOL PI_FUNC_DECL PI_qSAI_ALL(long ID, char* szAxes, int iBufferSize);

BOOL PI_FUNC_DECL PI_CCL(long ID, int iComandLevel, const char* szPassWord);
BOOL PI_FUNC_DECL PI_qCCL(long ID, int* piComandLevel);

BOOL PI_FUNC_DECL PI_AVG(long ID, int iAverrageTime);
BOOL PI_FUNC_DECL PI_qAVG(long ID, int *iAverrageTime);

BOOL PI_FUNC_DECL PI_qHAR(long ID, const char* szAxes, BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_qLIM(long ID, const char* szAxes, BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_qTRS(long ID, const char* szAxes, BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_FNL(long ID, const char* szAxes);
BOOL PI_FUNC_DECL PI_FPL(long ID, const char* szAxes);
BOOL PI_FUNC_DECL PI_FRF(long ID, const char* szAxes);
BOOL PI_FUNC_DECL PI_FED(long ID, const char* szAxes, const int* piEdgeArray, const int* piParamArray);
BOOL PI_FUNC_DECL PI_qFRF(long ID, const char* szAxes, BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_DIO(long ID, const long* piChannelsArray, const BOOL* pbValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qDIO(long ID, const long* piChannelsArray, BOOL* pbValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qTIO(long ID, int* piInputNr, int* piOutputNr);
BOOL PI_FUNC_DECL PI_IsControllerReady(long ID, int* piControllerReady);
BOOL PI_FUNC_DECL PI_qSRG(long ID, const char* szAxes, const int* iRegisterArray, int* iValArray);

BOOL PI_FUNC_DECL PI_ATC(long ID, const int* piChannels, const int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qATC(long ID, const int* piChannels, int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qATS(long ID, const int* piChannels, const int* piOptions, int* piValueArray, int iArraySize);

BOOL PI_FUNC_DECL PI_SPI(long ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_qSPI(long ID, const char* szAxes, double* pdValueArray);

/////////////////////////////////////////////////////////////////////////////
// Macro commande
BOOL PI_FUNC_DECL PI_IsRunningMacro(long ID, BOOL* pbRunningMacro);
BOOL PI_FUNC_DECL PI_MAC_BEG(long ID, const char* szMacroName);
BOOL PI_FUNC_DECL PI_MAC_START(long ID, const char* szMacroName);
BOOL PI_FUNC_DECL PI_MAC_NSTART(long ID, const char* szMacroName, int nrRuns);
BOOL PI_FUNC_DECL PI_MAC_END(long ID);
BOOL PI_FUNC_DECL PI_MAC_DEL(long ID, const char* szMacroName);
BOOL PI_FUNC_DECL PI_MAC_DEF(long ID, const char* szMacroName);
BOOL PI_FUNC_DECL PI_MAC_qDEF(long ID, char* szBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_MAC_qERR(long ID, char* szBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_qMAC(long ID, const char* szMacroName, char* szBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_qRMC(long ID, char* szBuffer, int iBufferSize);

BOOL PI_FUNC_DECL PI_DEL(long ID, int nMilliSeconds);
BOOL PI_FUNC_DECL PI_WAC(long ID, const char* szCondition);
BOOL PI_FUNC_DECL PI_MEX(long ID, const char* szCondition);

BOOL PI_FUNC_DECL PI_VAR(long ID, const char* szVariables, const char* szValues);
BOOL PI_FUNC_DECL PI_qVAR(long ID, const char* szVariables, char* szValues,  int iBufferSize);

/////////////////////////////////////////////////////////////////////////////
// String commands.
BOOL PI_FUNC_DECL PI_GcsCommandset(long ID, const char* szCommand);
BOOL PI_FUNC_DECL PI_GcsGetAnswer(long ID, char* szAnswer, int iBufferSize);
BOOL PI_FUNC_DECL PI_GcsGetAnswerSize(long ID, int* iAnswerSize);


/////////////////////////////////////////////////////////////////////////////
// limits
BOOL PI_FUNC_DECL PI_qTMN(long ID, const char* szAxes, double* pdValueArray);
BOOL PI_FUNC_DECL PI_qTMX(long ID, const char* szAxes, double* pdValueArray);
BOOL PI_FUNC_DECL PI_NLM(long ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_qNLM(long ID, const char* szAxes, double* pdValueArray);
BOOL PI_FUNC_DECL PI_PLM(long ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_qPLM(long ID, const char* szAxes, double* pdValueArray);
BOOL PI_FUNC_DECL PI_SSL(long ID, const char* szAxes, const BOOL* pbValueArray);
BOOL PI_FUNC_DECL PI_qSSL(long ID, const char* szAxes, BOOL* pbValueArray);


/////////////////////////////////////////////////////////////////////////////
// Wave commands.
BOOL PI_FUNC_DECL PI_IsGeneratorRunning(long ID, const int* piWaveGeneratorIds, BOOL* pbValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qTWG(long ID, int* piWaveGenerators);
BOOL PI_FUNC_DECL PI_WAV_SIN_P(long ID, int iWaveTableId, int iOffsetOfFirstPointInWaveTable, int iNumberOfPoints, int iAddAppendWave, int iCenterPointOfWave, double dAmplitudeOfWave, double dOffsetOfWave, int iSegmentLength);
BOOL PI_FUNC_DECL PI_WAV_LIN(long ID, int iWaveTableId, int iOffsetOfFirstPointInWaveTable, int iNumberOfPoints, int iAddAppendWave, int iNumberOfSpeedUpDownPointsInWave, double dAmplitudeOfWave, double dOffsetOfWave, int iSegmentLength);
BOOL PI_FUNC_DECL PI_WAV_RAMP(long ID, int iWaveTableId, int iOffsetOfFirstPointInWaveTable, int iNumberOfPoints, int iAddAppendWave, int iCenterPointOfWave, int iNumberOfSpeedUpDownPointsInWave, double dAmplitudeOfWave, double dOffsetOfWave, int iSegmentLength);
BOOL PI_FUNC_DECL PI_WAV_PNT(long ID, int iWaveTableId, int iOffsetOfFirstPointInWaveTable, int iNumberOfPoints, int iAddAppendWave, const double* pdWavePoints);
BOOL PI_FUNC_DECL PI_qWAV(long ID, const int* piWaveTableIdsArray, const int* piParamereIdsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_WGO(long ID, const int* piWaveGeneratorIdsArray, const int* iStartModArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qWGO(long ID, const int* piWaveGeneratorIdsArray, int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_WGC(long ID, const int* piWaveGeneratorIdsArray, const int* piNumberOfCyclesArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qWGC(long ID, const int* piWaveGeneratorIdsArray, int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_WSL(long ID, const int* piWaveGeneratorIdsArray, const int* piWaveTableIdsArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qWSL(long ID, const int* piWaveGeneratorIdsArray, int* piWaveTableIdsArray, int iArraySize);
BOOL PI_FUNC_DECL PI_DTC(long ID, const int* piDdlTableIdsArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qDTL(long ID, const int* piDdlTableIdsArray, int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_WCL(long ID, const int* piWaveTableIdsArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qTLT(long ID, int* piNumberOfDdlTables);
BOOL PI_FUNC_DECL PI_qGWD_SYNC(long ID, int iWaveTableId, int iOffsetOfFirstPointInWaveTable, int iNumberOfValues, double* pdValueArray);
BOOL PI_FUNC_DECL PI_qGWD(long ID, const int* iWaveTableIdsArray, int iNumberOfWaveTables, int iOffset, int nrValues, double** pdValarray, char* szGcsArrayHeader, int iGcsArrayHeaderMaxSize);
BOOL PI_FUNC_DECL PI_WOS(long ID, const int* iWaveTableIdsArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qWOS(long ID, const int* iWaveTableIdsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_WTR(long ID, const int* piWaveGeneratorIdsArray, const int* piTableRateArray, const int* piInterpolationTypeArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qWTR(long ID, const int* piWaveGeneratorIdsArray, long* piTableRateArray, long* piInterpolationTypeArray, int iArraySize);
BOOL PI_FUNC_DECL PI_DDL(long ID, int iDdlTableId,  int iOffsetOfFirstPointInDdlTable,  int iNumberOfValues, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_qDDL_SYNC(long ID,  int iDdlTableId,  int iOffsetOfFirstPointInDdlTable,  int iNumberOfValues, double* pdValueArray);
BOOL PI_FUNC_DECL PI_qDDL(long ID, const int* iDdlTableIdsArray, int iNumberOfDdlTables, int iOffset, int nrValues, double** pdValarray, char* szGcsArrayHeader, int iGcsArrayHeaderMaxSize);
BOOL PI_FUNC_DECL PI_DPO(long ID, const char* szAxes);
BOOL PI_FUNC_DECL PI_qWMS(long ID, const int* piWaveTableIds, int* iWaveTableMaimumSize, int iArraySize);



///////////////////////////////////////////////////////////////////////////////
//// Trigger commands.
BOOL PI_FUNC_DECL PI_TWC(long ID);
BOOL PI_FUNC_DECL PI_TWS(long ID, const int* piTriggerChannelIdsArray, const int* piPointNumberArray, const int* piSwitchArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qTWS(long ID, const int* iTriggerChannelIdsArray, int iNumberOfTriggerChannels, int iOffset, int nrValues, double** pdValarray, char* szGcsArrayHeader, int iGcsArrayHeaderMaxSize);
BOOL PI_FUNC_DECL PI_CTO(long ID, const int* piTriggerOutputIdsArray, const int* piTriggerParameterArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qCTO(long ID, const int* piTriggerOutputIdsArray, const int* piTriggerParameterArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_TRO(long ID, const long* piTriggerChannelIds, const BOOL* pbTriggerChannelEnabel, long iArraySize);
BOOL PI_FUNC_DECL PI_qTRO(long ID, const long* piTriggerChannelIds, BOOL* pbTriggerChannelEnabel, long iArraySize);


/////////////////////////////////////////////////////////////////////////////
// Record tabel commands.
BOOL PI_FUNC_DECL PI_qHDR(long ID, char* szBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_qTNR(long ID, int* piNumberOfRecordCannels);
BOOL PI_FUNC_DECL PI_DRC(long ID, const int* piRecordTableIdsArray, const char* szRecordSourceIds, const int* piRecordOptionArray);
BOOL PI_FUNC_DECL PI_qDRC(long ID, const int* piRecordTableIdsArray, char* szRecordSourceIds, int* piRecordOptionArray, int iRecordSourceIdsBufferSize, int iRecordOptionArraySize);
BOOL PI_FUNC_DECL PI_qDRR_SYNC(long ID,  int iRecordTablelId,  int iOffsetOfFirstPointInRecordTable,  int iNumberOfValues, double* pdValueArray);
BOOL PI_FUNC_DECL PI_qDRR(long ID, const int* piRecTableIdIdsArray,  int iNumberOfRecChannels,  int iOffsetOfFirstPointInRecordTable,  int iNumberOfValues, double** pdValueArray, char* szGcsArrayHeader, int iGcsArrayHeaderMaxSize);
BOOL PI_FUNC_DECL PI_DRT(long ID, const int* piRecordChannelIdsArray, const int* piTriggerSourceArray, const char* szValues, int iArraySize);
BOOL PI_FUNC_DECL PI_qDRT(long ID, const int* piRecordChannelIdsArray, int* piTriggerSourceArray, char* szValues, int iArraySize, int iValueBufferLength);
BOOL PI_FUNC_DECL PI_RTR(long ID, int piReportTableRate);
BOOL PI_FUNC_DECL PI_qRTR(long ID, int* piReportTableRate);
BOOL PI_FUNC_DECL PI_WGR(long ID);
BOOL PI_FUNC_DECL PI_qDRL(long ID, int* piRecordChannelIdsArray, int* piNuberOfRecordedValuesArray, int iArraySize);


/////////////////////////////////////////////////////////////////////////////
// Piezo-Channel commands.
BOOL PI_FUNC_DECL PI_VMA(long ID, const int* piPiezoChannelsArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qVMA(long ID, const int* piPiezoChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_VMI(long ID, const int* piPiezoChannelsArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qVMI(long ID, const int* piPiezoChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_VOL(long ID, const int* piPiezoChannelsArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qVOL(long ID, const int* piPiezoChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qTPC(long ID, int* piNumberOfPiezoChannels);
BOOL PI_FUNC_DECL PI_ONL(long ID, const int* iPiezoCannels, const int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qONL(long ID, const int* iPiezoCannels, long* piValueArray, int iArraySize);


/////////////////////////////////////////////////////////////////////////////
// Sensor-Channel commands.
BOOL PI_FUNC_DECL PI_qTAD(long ID, const int* piSensorsChannelsArray, int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qTNS(long ID, const int* piSensorsChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qTSP(long ID, const int* piSensorsChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_SCN(long ID, const int* piSensorsChannelsArray, const int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qSCN(long ID, const int* piSensorsChannelsArray, int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qTSC(long ID, int* piNumberOfSensorChannels);


/////////////////////////////////////////////////////////////////////////////
// PIEZOWALK(R)-Channel commands.
BOOL PI_FUNC_DECL PI_APG(long ID, const int* piPIEZOWALKChannelsArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qAPG(long ID, const int* piPIEZOWALKChannelsArray, int* piValueArray, int iArraySize);

BOOL PI_FUNC_DECL PI_OAC(long ID, const int* piPIEZOWALKChannelsArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qOAC(long ID, const int* piPIEZOWALKChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_OAD(long ID, const int* piPIEZOWALKChannelsArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qOAD(long ID, const int* piPIEZOWALKChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_ODC(long ID, const int* piPIEZOWALKChannelsArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qODC(long ID, const int* piPIEZOWALKChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_OCD(long ID, const int* piPIEZOWALKChannelsArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qOCD(long ID, const int* piPIEZOWALKChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_OSM(long ID, const int* piPIEZOWALKChannelsArray, const int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qOSM(long ID, const int* piPIEZOWALKChannelsArray, int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_OSMf(long ID, const int* piPIEZOWALKChannelsArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qOSMf(long ID, const int* piPIEZOWALKChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_OVL(long ID, const int* piPIEZOWALKChannelsArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qOVL(long ID, const int* piPIEZOWALKChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qOSN(long ID, const int* piPIEZOWALKChannelsArray, int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_SSA(long ID, const int* piPIEZOWALKChannelsArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qSSA(long ID, const int* piPIEZOWALKChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_RNP(long ID, const int* piPIEZOWALKChannelsArray, const double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_PGS(long ID, const int* piPIEZOWALKChannelsArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qTAC(long ID, int* pnNrChannels);
BOOL PI_FUNC_DECL PI_qTAV(long ID, const int* piChannelsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_OMA(long ID, const char* szAxes, const double* pdValueArray);
BOOL PI_FUNC_DECL PI_qOMA(long ID, const char* szAxes, double* pdValueArray);
BOOL PI_FUNC_DECL PI_OMR(long ID, const char* szAxes, const double* pdValueArray);

/////////////////////////////////////////////////////////////////////////////
// Joystick
BOOL PI_FUNC_DECL PI_qJAS(long ID, const int* iJoystickIDsArray, const int* iAxesIDsArray, double* pdValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_JAX(long ID,  int iJoystickID,  int iAxesID, const char* szAxesBuffer);
BOOL PI_FUNC_DECL PI_qJAX(long ID, const int* iJoystickIDsArray, const int* iAxesIDsArray, int iArraySize, char* szAxesBuffer, int iBufferSize);
BOOL PI_FUNC_DECL PI_qJBS(long ID, const int* iJoystickIDsArray, const int* iButtonIDsArray, BOOL* pbValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_JDT(long ID, const int* iJoystickIDsArray, const int* iAxisIDsArray,const int* piValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_JLT(long ID, int iJoystickID, int iAxisID, int iStartAdress, const double* pdValueArray,int iArraySize);
BOOL PI_FUNC_DECL PI_qJLT(long ID, const int* iJoystickIDsArray, const int* iAxisIDsArray,  int iNumberOfTables,  int iOffsetOfFirstPointInTable,  int iNumberOfValues, double** pdValueArray, char* szGcsArrayHeader, int iGcsArrayHeaderMaxSize);
BOOL PI_FUNC_DECL PI_JON(long ID, const int* iJoystickIDsArray, const BOOL* pbValueArray, int iArraySize);
BOOL PI_FUNC_DECL PI_qJON(long ID, const int* iJoystickIDsArray, BOOL* pbValueArray, int iArraySize);




/////////////////////////////////////////////////////////////////////////////
// Spezial
BOOL	PI_FUNC_DECL	PI_GetSupportedFunctions(long ID, long* piCommandLevelArray, const int iiBufferSize, char* szFunctionNames, const int iMaxFunctioNamesLength);
BOOL	PI_FUNC_DECL	PI_GetSupportedParameters(long ID, int* piParameterIdArray, int* piCommandLevelArray, int* piMemoryLocationArray, int* piDataTypeArray, int* piNumberOfItems, const int iiBufferSize, char* szParameterName, const int iMaxParameterNameSize);
BOOL	PI_FUNC_DECL	PI_GetSupportedControllers(char* szBuffer, int iBufferSize);
int		PI_FUNC_DECL	PI_GetAsyncBufferIndex(long ID);
BOOL	PI_FUNC_DECL	PI_GetAsyncBuffer(long ID, double** pdValueArray);


BOOL	PI_FUNC_DECL	PI_AddStage(long ID, const char* szAxes);
BOOL	PI_FUNC_DECL	PI_RemoveStage(long ID, const char* szStageName);
BOOL	PI_FUNC_DECL	PI_OpenUserStagesEditDialog(long ID);
BOOL	PI_FUNC_DECL	PI_OpenPiStagesEditDialog(long ID);
///////////////////////////////////////////////////////////////////////////////
// for internal use
BOOL	PI_FUNC_DECL	PI_DisableSingleStagesDatFiles(long ID,BOOL bDisable);
BOOL	PI_FUNC_DECL	PI_DisableUserStagesDatFiles(long ID,BOOL bDisable);


#ifdef __cplusplus
}
#endif
