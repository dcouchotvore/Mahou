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

#define BLOCKSIZE (4096)

namespace Mahou {

void SerialChannel::Connect() {
    m_serial_handle = ::CreateFile(static_cast<const char *>(m_port), GENERIC_READ | GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    if ( m_serial_handle==INVALID_HANDLE_VALUE ) {
        if ( ::GetLastError()==ERROR_FILE_NOT_FOUND )
            throw ExceptionNoFile(m_port);
        throw ExceptionCannotOpen(m_port);
        }
    DCB serial_parms = {0};
    serial_parms.DCBlength=sizeof(serial_parms);
    if ( !GetCommState(m_serial_handle, &serial_parms) )
        throw ExceptionIOUnknown(m_port);
    serial_parms.BaudRate = static_cast<long int>(m_baud);
    serial_parms.ByteSize = static_cast<int>(m_data_bits);
    serial_parms.StopBits = static_cast<int>(m_stop_bits);
    serial_parms.Parity = m_parity.operator int();
    if ( !SetCommState(m_serial_handle, &serial_parms) )
        throw ExceptionIOUnknown(m_port);
}

void SerialChannel::Disconnect() {
    ::CloseHandle(m_serial_handle);
}

void SerialChannel::SendMsg(const std::string msg){
    int remaining = msg.length();
    const char *p = msg.data();
    while ( remaining>0 ){
        int to_send = remaining > BLOCKSIZE ? BLOCKSIZE : remaining;
        DWORD bytes_transferred;
        if ( !::WriteFile(m_serial_handle, p, to_send, &bytes_transferred, NULL) )
            throw ExceptionNoWrite(m_port);
        p += to_send;
        remaining -= to_send;
        }
}

void SerialChannel::RecvMsg(std::string msg) {
    struct block {
        char data[BLOCKSIZE];
        DWORD data_count;
        struct block *next;
        };
    struct block *root = 0;
    struct block *p = 0;
    struct block *last = 0;
    bool go = true;
    int count = 0;
    while ( go ){
        if ( p ){
            if ( !root )
                root = p;
            else if ( last )
                last->next = p;
            }
        p = new block;
        memset(p, 0, sizeof(block));
        if ( !::ReadFile(m_serial_handle, p->data, BLOCKSIZE, &p->data_count, NULL) )
            throw ExceptionNoRead(m_port);
        count += p->data_count;
        if ( p->data_count<BLOCKSIZE )
            go=false;
        last = p;
        }
    msg = "";
    p = root;
    msg.reserve(count+1);
    while ( p ) {
        int size = p->data_count;
        msg.append(p->data, size);
        p = p->next;
        }
}

}
