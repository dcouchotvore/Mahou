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

#ifndef __PI_TRANSLATIONSTAGE_H__
#define __PI_TRANSLATIONSTAGE_H__

#include "DeviceContainer.h"
#include <string>

namespace Mahou {

class PI_TranslationStage : public TranslationStage, public DLLChannel {

public:
    PI_TranslationStage(const char *const deviceName);
    virtual ~PI_TranslationStage();
    virtual void GoTo(double pos);
    virtual double Poll() const;
    virtual void SetData(const double *);
    virtual void GetData(double *);

protected:
    void throw_exception_no_device(const char *const msg);
    void throw_exception_cannot_open(const char *const msg);
    void format_error_message(char *buf, const char *const msg);
    Parameter<int> m_id;
    Parameter<std::string> m_idName;
    Parameter<std::string> m_axis;
    Parameter<std::string> m_idStage;

};

}

#endif // PI_TRANSLATIONSTAGE_H_INCLUDED
