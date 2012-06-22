/************************************************************************
* Project:
* Create Date: 7 June 2012
* Originator:  Duane A. Couchot-Vore
* $Rev: 1 $
* $Date: $
*************************************************************************
*
* Function: Class that wraps sundry system tools
*
*************************************************************************
*
* Copyright 2012 Garrett-Roe Lab, University of Pittsburgh
*
************************************************************************/

#ifndef __TOOLS_H__
#define __TOOLS_H__

#include <string>

namespace Mahou {

class Tools {
    public:

        static void C2W(WCHAR *wstr, const char *str) {
            char c;
            do {
                *wstr++ = static_cast<WCHAR>(c=*str++);
                } while ( c );
        }

		static std::string ConvertBSTRToMBS(BSTR bstr) {
			int wslen = ::SysStringLen(bstr);
			return ConvertWCSToMBS((wchar_t*)bstr, wslen);
		}

		static std::string ConvertWCSToMBS(const wchar_t* pstr, long wslen) {
			int len = ::WideCharToMultiByte(CP_ACP, 0, pstr, wslen, NULL, 0, NULL, NULL);

			std::string dblstr(len, '\0');
			len = ::WideCharToMultiByte(CP_ACP, 0 /* no flags */,
                                pstr, wslen /* not necessary NULL-terminated */,
                                &dblstr[0], len,
                                NULL, NULL /* no default char */);
			return dblstr;
		}

		static BSTR ConvertMBSToBSTR(const std::string& str) {
			int wslen = ::MultiByteToWideChar(CP_ACP, 0 /* no flags */,
										str.data(), str.length(), NULL, 0);

			BSTR wsdata = ::SysAllocStringLen(NULL, wslen);
			::MultiByteToWideChar(CP_ACP, 0 /* no flags */,
										str.data(), str.length(), wsdata, wslen);
			return wsdata;
		}
};

}

#endif // __TOOLS_H__
