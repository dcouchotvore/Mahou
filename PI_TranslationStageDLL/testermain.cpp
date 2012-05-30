#include <iostream>

#include <windows.h>
#include "../Hardware/NamedParameterList.h"

using namespace std;

void check_windows_error() {
    int err = ::GetLastError();
    LPVOID pText = 0;
    ::FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_SYSTEM|FORMAT_MESSAGE_IGNORE_INSERTS,
	      NULL, err, MAKELANGID(LANG_NEUTRAL,SUBLANG_DEFAULT), (LPSTR)&pText, 0, NULL);
    ::MessageBox(NULL, (LPCSTR)pText, 0, MB_OK);
    LocalFree(pText);
}

typedef int (*VoidProc)();
typedef int (*PointerProc)(void *);
typedef int (*Pointer2Proc)(const char *, void *);

int main()
{
    HINSTANCE hinst = ::LoadLibrary("..\\..\\bin\\Debug\\PI_TranslationStage.dll");
    if ( hinst==0 )
        check_windows_error();
    else {
        VoidProc initialize = (VoidProc)::GetProcAddress(hinst, "Initialize");
        initialize();
        VoidProc getParameterCount = (VoidProc)::GetProcAddress(hinst, "GetParameterCount");
        int pcount = (*getParameterCount)();
        Mahou::ParameterData parm_data[pcount];
        PointerProc getParameters = (PointerProc)::GetProcAddress(hinst, "GetParameters");
        (*getParameters)(parm_data);
        Pointer2Proc getParameter = (Pointer2Proc)::GetProcAddress(hinst, "GetParameter");
        Pointer2Proc setParameter = (Pointer2Proc)::GetProcAddress(hinst, "SetParameter");
        char buf[100];
        (*getParameter)("Minumum", buf);
        strcpy(buf, "2");
        (*setParameter)("Minumum", buf);
        strcpy(buf, "-");
        (*getParameter)("Minumum", buf);
        PointerProc getName = (PointerProc)::GetProcAddress(hinst, "GetDeviceName");
        (*getName)(buf);



        ::FreeLibrary(hinst);
        }
    cout << "Hello world!" << endl;
    return 0;
}
