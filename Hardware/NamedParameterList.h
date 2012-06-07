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
* Function: Implements named parameters and a container for them.
*
* The ancester class that can contain named parameters is ParameterContainer.
* ParameterContainers are automatically registered with the database
* interface (DBInterface), so that the parameter settings for all descendants
* can be saved and retrieved with simple calls.
*
* To create a parameter in a descendant class, Declare a paramater of the
* desired type.  As an example, for an integer:
*
* Parameter<int> bufferSize(m_parameter_list, "Buffer Size") = 1000.
*
* Things to observe:
* 1: Since Parameter is templated, a parameter of any data type can be
*    created.  However, DBInterface must be able to read and write that
*    datatype.  Consult DBInterface.cpp to see what types are supported
*    and add read/write support for any new type introduced. Attempts to
*    put this functionality into the Parameter template got awkward.
*
* 2. This first parameter in the constructor should always be "m_parameter_list",
*    which is defined in the parent class ParameterContainer.  This allows
*    automatic linking of the parameter into the parameter list when it is
*    created.
*
* 3. After created, the parameter can be used as any other variable.
*
************************************************************************/

#ifndef __NAMEDPARAMETERLIST_H__
#define __NAMEDPARAMETERLIST_H__

#define MAX_PARAMETER_NAME_SIZE (63)

#include "Exceptions.h"
#include <map>
#include <vector>
#include <string.h>
#include <iostream>
#include <sstream>
#include <stdlib.h>
#include <stdio.h>

namespace Mahou {

typedef enum { INT, FLOAT, DOUBLE, STRING } ParameterType;

struct ParameterData {
    char Name[MAX_PARAMETER_NAME_SIZE+1];
    ParameterType Type;
    bool IsReadOnly;
    };

class ParameteredContainer;

class ParameterGeneric {
    friend class NamedParameterList;
    friend class ParameteredContainer;
	public:
        ParameterGeneric(const char *name, const bool readOnly): m_name(name), m_read_only(readOnly), f_obj(0), f_action(0) { }
		virtual ~ParameterGeneric() {}
        const char *const Name() const { return m_name.c_str(); }
		bool isReadOnly() const { return m_read_only; }
		virtual operator std::string() const = 0;
		virtual operator int() const = 0;
		virtual operator long int() const = 0;
		virtual operator double() const = 0;
		virtual operator bool() const = 0;
		virtual operator const char *() const = 0;
		virtual ParameterGeneric &operator=(const std::string data) = 0;
		virtual ParameterGeneric &operator=(const int data) = 0;
		virtual ParameterGeneric &operator=(const long int data) = 0;
		virtual ParameterGeneric &operator=(const double data) = 0;
		virtual ParameterGeneric &operator=(const bool data) = 0;
		void SetAction(ParameteredContainer *const obj , int (*action)(ParameteredContainer*)) { f_obj = obj; f_action = action; }
		virtual void DispatchAction() { if ( f_action ) (*f_action)(f_obj); }
    protected:
		std::string m_name;
		bool m_read_only;
		ParameteredContainer *f_obj;
		int (*f_action)(ParameteredContainer *);
		mutable char m_cbuf[128];             // @@@ !!! Warning!  Not thread safe!
};

template <class T>
class Parameter : public ParameterGeneric {
	public:
		Parameter(const char * const name, T defaultVal, bool readOnly=false) : ParameterGeneric(name, readOnly), m_data(defaultVal) { }
		Parameter(const std::string &name, T defaultVal, bool readOnly=false) : ParameterGeneric(name, readOnly), m_data(defaultVal) { }
 		virtual operator std::string() const { std::stringstream buf; buf<<static_cast<T>(m_data); return buf.str(); }
		virtual operator int() const { return static_cast<int>(m_data); }
		virtual operator long int() const { return static_cast<long int>(m_data); }
		virtual operator double() const { return static_cast<double>(m_data); }
		virtual operator bool() const { return m_data!=0; }
		virtual operator const char *() const {
		    std::stringstream buf;
		    buf<<m_data;
		    std::string str(buf.str());
		    const char *p = str.c_str();
		    strncpy(m_cbuf, p, sizeof(m_cbuf)-1);
		    m_cbuf[sizeof(m_cbuf)-1] = '\0';
		    return m_cbuf;
            }
		virtual ParameterGeneric &operator=(const std::string data) { std::stringstream buf(data); buf>>m_data; return *this; }
		virtual ParameterGeneric &operator=(const int data) { m_data = data; return *this; }
		virtual ParameterGeneric &operator=(const long int data) { m_data = data; return *this; }
		virtual ParameterGeneric &operator=(const double data) { m_data = data; return *this; }
		virtual ParameterGeneric &operator=(const bool data) { m_data = data ? 1 : 0; return *this; }
	protected:
		T m_data;
};

// Non-numeric types need specializations because of conversion issues

template <> class Parameter<std::string> : public ParameterGeneric {
	public:
		Parameter(const char * const name, std::string defaultVal, bool readOnly=false) : ParameterGeneric(name, readOnly), m_data(defaultVal) { }
		Parameter(const std::string &name, std::string defaultVal, bool readOnly=false) : ParameterGeneric(name.c_str(), readOnly), m_data(defaultVal) { }
		virtual operator std::string() const { return m_data; }
		virtual operator int() const { char *p; return strtol(m_data.c_str(), &p, 10); }
		virtual operator long int() const { char *p; return strtol(m_data.c_str(), &p, 10); }
		virtual operator double() const { char *p; return strtod(m_data.c_str(), &p); }
		virtual operator bool() const { return stricmp(m_data.c_str(), "true")==0; }
		virtual operator const char*() const { return m_data.c_str(); }
		virtual ParameterGeneric &operator=(const std::string data) { m_data = data; return *this; }
		virtual ParameterGeneric &operator=(const int data) { char buf[256]; sprintf(buf, "%d", data), m_data = buf; return *this; }
		virtual ParameterGeneric &operator=(const long int data) { char buf[256]; sprintf(buf, "%ld", data), m_data = buf; return *this; }
		virtual ParameterGeneric &operator=(const double data) { char buf[256]; sprintf(buf, "%f", data), m_data = buf; return *this; }
		virtual ParameterGeneric &operator=(const bool data) { m_data = data ? "true" : "false"; return *this; }
	protected:
		std::string m_data;
};

template <> class Parameter<bool> : public ParameterGeneric {
    public:
		Parameter(const char * const name, bool defaultVal, bool readOnly=false) : ParameterGeneric(name, readOnly), m_data(defaultVal) { }
		Parameter(const std::string &name, bool defaultVal, bool readOnly=false) : ParameterGeneric(name.c_str(), readOnly), m_data(defaultVal) { }
		virtual operator bool() const { return m_data; }
		virtual operator int() const { return m_data ? 1 : 0; }
		virtual operator long int() const { return m_data ? 1 : 0; }
		virtual operator double() const { return m_data ? 1.0 : 0.0; }
		virtual operator std::string() const { return m_data ? "true" : "false"; }
		virtual operator const char *() const { return m_data ? "true" : "false"; }
		virtual ParameterGeneric &operator=(const std::string data) { m_data = stricmp(data.c_str(), "true")==0; return *this; }
		virtual ParameterGeneric &operator=(const int data) { m_data = data!=0; return *this; }
		virtual ParameterGeneric &operator=(const long int data) { m_data = data!=0; return *this; }
		virtual ParameterGeneric &operator=(const double data) { m_data = data!=0.0; return *this; }
		virtual ParameterGeneric &operator=(const bool data) { m_data = data; return *this; }
	protected:
		bool m_data;
};

class NamedParameterList {
    friend class DBInterface;
    friend class ParameteredContainer;
	public:
		NamedParameterList() { }
		virtual ~NamedParameterList() { }           // Can't delete parameters here because they're declared elsewhere.

		void Add(ParameterGeneric *parm) {
		    if ( strlen(parm->Name())>MAX_PARAMETER_NAME_SIZE )
                throw ExceptionParameterNameTooLong(parm->Name());
            if  ( Find(parm->Name(), true) )
                throw ExceptionDuplicateParameter(parm->Name());
            m_list.push_back(parm);
        }

        ParameterGeneric *Find(const char *name, bool noException=false) {
   			std::vector<ParameterGeneric *>::const_iterator ii;
			for ( ii=m_list.begin(); ii!=m_list.end(); ii++ ) {
                if ( stricmp((*ii)->Name(), name)==0 )
                    return *ii;
                }
            if ( !noException )
                throw ExceptionUnknownParameter(name);
            return 0;
         }

        bool ValidateName(const char *name) {
  			std::vector<ParameterGeneric *>::const_iterator ii;
			for ( ii=m_list.begin(); ii!=m_list.end(); ii++ ) {
                if ( stricmp((*ii)->Name(), name)==0 )
                    return true;
                }
            return false;
         }

		// The following will produce an error if the reference cannot be assigned to an external reference
		// variable.  This is what we want.
		ParameterGeneric &GetRef(const char *name) {
		    return *dynamic_cast<ParameterGeneric*>(Find(name));
		}
		ParameterGeneric &GetRef(const std::string &name) {
		    const char *sname = name.c_str();
		    return GetRef(sname);
		}

        int GetparameterCount() { return m_list.size(); }
        int GetParameters(ParameterData *data) {
  			std::vector<ParameterGeneric *>::const_iterator ii;
  			int jj;
			for ( ii=m_list.begin(), jj=0; ii!=m_list.end(); ii++, jj++ ) {
			    memset(&data[jj], 0, sizeof(ParameterData));
                ParameterGeneric *parm = (*ii);
                strcpy(data[jj].Name, parm->Name());
                if ( dynamic_cast<Parameter<int>*>(parm) )
                    data[jj].Type = INT;
                else if ( dynamic_cast<Parameter<float>*>(parm) )
                    data[jj].Type = FLOAT;
                else if ( dynamic_cast<Parameter<double>*>(parm) )
                    data[jj].Type = FLOAT;
                else if ( dynamic_cast<Parameter<std::string>*>(parm) )
                    data[jj].Type = STRING;
                data[jj].IsReadOnly = parm->isReadOnly();
                }
            return jj;
        }

    protected:
		const std::vector<ParameterGeneric *> &getParameters() const { return m_list; }
		void clear() { m_list.clear(); }
        void assert() {
  			std::vector<ParameterGeneric *>::const_iterator ii;
			for ( ii=m_list.begin(); ii!=m_list.end(); ii++ )
			    (*ii)->DispatchAction();
        }
	private:
		std::vector<ParameterGeneric *> m_list;

};

class ParameteredContainer {
    public:
        ParameteredContainer(const char *const deviceName) : m_device_name(deviceName), m_alive(false) { }
//        NamedParameterList &GetParameters() { return m_parameter_list; }          // Exposing this would allow writing of read-only properties from outside the class.
        const std::string &GetDeviceName() const { return m_device_name; }
        template <class T> bool SetParameter(const char * key, T val, bool force=false){
            ParameterGeneric &parm = m_parameter_list.GetRef(key);
            bool ro = parm.isReadOnly();
            if ( !ro || force ){
                parm = val;
                parm.DispatchAction();
                }
            return !ro;
            }
        ParameterGeneric *GetParameter(const char *key) { return &m_parameter_list.GetRef(key); }
        int GetParameterCount() { return m_parameter_list.GetparameterCount(); }
        virtual int GetParameters(ParameterData *data) { return m_parameter_list.GetParameters(data); }
        bool ValidateParameterName(const char *const name) { return m_parameter_list.ValidateName(name); }
        std::string m_device_name;
        NamedParameterList m_parameter_list;
    protected:
        void assert() {}
        bool m_alive;
};

}
#endif // __NAMEDPARAMETERLIST_H__

