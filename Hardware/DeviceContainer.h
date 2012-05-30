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

#ifndef __DEVICECONTAINER_H__
#define __DEVICECONTAINER_H__

#include "NamedParameterList.h"
#include "windows.h"

namespace Mahou {

//-----------------------------------------------------------------------
// Notice to newbies:
// Multiple inheritance is normally a questionable practice at best, but it
// does have its moments. Here we device an ancestor class of device functions
// and one of communications methods.  The reason for multiple inheritance
// here is to allow device DLL's build from one of each (i.e., a translation
// stage that we talk to via RS-232 (yuk!), so that both components share a
// common properties list.
//
// These classes also define the common interfaces that are not defined in
// ParameteredContainer.
//-----------------------------------------------------------------------

class DeviceFunction : public virtual ParameteredContainer {
    public:
        DeviceFunction(const char *const deviceName) : ParameteredContainer(deviceName),
            m_data_size("Data Size", 8, true)
            {
                m_parameter_list.Add(&m_data_size);
            }
        virtual ~DeviceFunction() { }
        virtual void GoTo(double pos) = 0;
        virtual double Poll() const = 0;
        virtual void SetData(const double *data) = 0;
        virtual void GetData(double *data) = 0;
    protected:
        Parameter<int> m_data_size;
};

class CommunicationsMethod : public virtual ParameteredContainer {
    public:
        CommunicationsMethod(const char *const deviceName) : ParameteredContainer(deviceName) { }
        virtual ~CommunicationsMethod() { }
        virtual void IoCtrl(const int method, void *data) = 0;                                                                      /// @@@ Be alert for a way to improve on this.
        virtual void SendMsg(const std::string msg) = 0;
        virtual void RecvMsg(std::string msg) = 0;
};

class TranslationStage : public DeviceFunction {
    public:
        TranslationStage(const char *const deviceName) : ParameteredContainer(deviceName), DeviceFunction(deviceName),
            m_minimum("Minumum", 0),
            m_maximum("Maximum", 100),
            m_acceleration("Acceleration", 10)
            {
                m_parameter_list.Add(&m_minimum);
                m_parameter_list.Add(&m_maximum);
                m_parameter_list.Add(&m_acceleration);
            }
    protected:
        Parameter<float> m_minimum;
        Parameter<float> m_maximum;
        Parameter<float> m_acceleration;
};

class Spectrometer : public DeviceFunction {
    public:
        Spectrometer(const char *const deviceName) : ParameteredContainer(deviceName), DeviceFunction(deviceName),
            m_elements("Elements", 32)
            {
                m_parameter_list.Add(&m_elements);
            }
    protected:
        Parameter<int> m_elements;
};

class AnalogToDigital : public DeviceFunction {
    public:
        AnalogToDigital(const char *const deviceName) : ParameteredContainer(deviceName), DeviceFunction(deviceName),
            m_minimum("Minimum", 0),
            m_maximum("Maximum", 4096),
            m_offset("Offset", 0),
            m_gain("Gain", 2.0),
            m_range_select("Range Select", 0)
            {
                m_parameter_list.Add(&m_minimum);
                m_parameter_list.Add(&m_maximum);
                m_parameter_list.Add(&m_offset);
                m_parameter_list.Add(&m_gain);
                m_parameter_list.Add(&m_range_select);
            }
    protected:
        Parameter<int> m_minimum;
        Parameter<int> m_maximum;
        Parameter<float> m_offset;
        Parameter<float> m_gain;
        Parameter<int> m_range_select;
};

class DigitalToAnalog : public DeviceFunction {
    public:
        DigitalToAnalog(const char *const deviceName) : ParameteredContainer(deviceName), DeviceFunction(deviceName),
            m_minimum("Minimum", 0),
            m_maximum("Maximum", 4096),
            m_offset("Offset", 0),
            m_gain("Gain", 2.0),
            m_range_select("Range Select", 0)
            {
                m_parameter_list.Add(&m_minimum);
                m_parameter_list.Add(&m_maximum);
                m_parameter_list.Add(&m_offset);
                m_parameter_list.Add(&m_gain);
                m_parameter_list.Add(&m_range_select);
            }
    protected:
        Parameter<int> m_minimum;
        Parameter<int> m_maximum;
        Parameter<float> m_offset;
        Parameter<float> m_gain;
        Parameter<int> m_range_select;
};

class SerialChannel : public CommunicationsMethod {
    public:
        SerialChannel(const char *const deviceName) : ParameteredContainer(deviceName), CommunicationsMethod(deviceName),
            m_port("Port", "COM1"),
            m_baud("Baud", 57600),
            m_start_bits("Start Bits", 1),
            m_stop_bits("Stop Bits", 2),
            m_data_bits("Data Bits", 8),
            m_parity("Parity", false)
            {
                m_parameter_list.Add(&m_port);
                m_parameter_list.Add(&m_baud);
                m_parameter_list.Add(&m_start_bits);
                m_parameter_list.Add(&m_stop_bits);
                m_parameter_list.Add(&m_data_bits);
                m_parameter_list.Add(&m_parity);
            }
        virtual void CommOpen();
        virtual void CommClose();
        virtual void IoCtrl(const int method, void *data) { }
        virtual void SendMsg(const std::string msg);
        virtual void RecvMsg(std::string msg);
    protected:
        Parameter<std::string> m_port;
        Parameter<int> m_baud;
        Parameter<int> m_start_bits;
        Parameter<int> m_stop_bits;
        Parameter<int> m_data_bits;
        Parameter<bool> m_parity;
        HANDLE m_serial_handle;
};

class USBChannel : public CommunicationsMethod {
    public:
        USBChannel(const char *const deviceName) : ParameteredContainer(deviceName), CommunicationsMethod(deviceName) { }
        virtual void IoCtrl(const int method, void *data);
        virtual void SendMsg(const std::string msg);
        virtual void RecvMsg(std::string msg);
};

class EthernetChannel : public CommunicationsMethod {
    public:
        EthernetChannel(const char *const deviceName) : ParameteredContainer(deviceName), CommunicationsMethod(deviceName) { }
        virtual void IoCtrl(const int method, void *data);
        virtual void SendMsg(const std::string msg);
        virtual void RecvMsg(std::string msg);
};

class DLLChannel : public CommunicationsMethod {
    public:
        DLLChannel(const char *const deviceName) : ParameteredContainer(deviceName), CommunicationsMethod(deviceName) { }
        ~DLLChannel() { }
        virtual void IoCtrl(const int method, void *data);
        virtual void SendMsg(const std::string msg);
        virtual void RecvMsg(std::string msg);
};

class OCXChannel : public CommunicationsMethod {
    public:
        OCXChannel(const char *const deviceName) : ParameteredContainer(deviceName), CommunicationsMethod(deviceName) { }
        virtual void IoCtrl(const int method, void *data);
        virtual void SendMsg(const std::string msg);
        virtual void RecvMsg(std::string msg);
};

}

#endif // __DEVICECONTAINER_H__
