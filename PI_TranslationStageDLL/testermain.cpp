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
typedef int (*CharPtrProc)(const char *);
typedef int (*HandleProc)(HANDLE handle);
typedef int (*GetParmDataProc)(const char *module, char *parmname, int *type, int *is_read_only);
typedef int (*GetSetParmProc)(const char *module, char *parmname, char *value);
typedef int (*DoubleIntProc)(const char *name, const double val, const int async);

int main()
{
    HINSTANCE hinst = ::LoadLibrary("..\\..\\..\\DLLInterface\\bin\\Debug\\DLLInterface.dll");
    //HINSTANCE hinst = ::LoadLibrary("DLLInterface.dll");
    if ( hinst==0 )
        check_windows_error();
    else {
        CharPtrProc initialize = (CharPtrProc)::GetProcAddress(hinst, "Initialize");
        initialize("C:\\temp\\experiment.cfg");
        CharPtrProc addlibpath = (CharPtrProc)::GetProcAddress(hinst, "AddLibraryPath");
        addlibpath("Hardware\\");
        VoidProc loadlibs = (VoidProc)::GetProcAddress(hinst, "LoadLibraries");
        loadlibs();
        VoidProc getLibCount = (VoidProc)::GetProcAddress(hinst, "GetLibraryCount");
        int lcount = getLibCount();
        std::map<std::string, std::vector<std::string> > module_data;
        CharPtrProc getLibaryName = (CharPtrProc)::GetProcAddress(hinst, "GetLibraryName");
        CharPtrProc getParameterCount = (CharPtrProc)::GetProcAddress(hinst, "GetParameterCount");
        GetParmDataProc getParameterData = (GetParmDataProc)::GetProcAddress(hinst, "GetParameterData");

        for ( int ii=0; ii<lcount; ii++ ){
            char name_buf[200];
            getLibaryName(name_buf);
            std::string module_name = name_buf;
            std::vector<std::string> parameters;
            int pcount = getParameterCount(name_buf);
            for ( int jj=0; jj<pcount; jj++ ){
                char parm_name[100];
                getParameterData(name_buf, parm_name, 0, 0);
                parameters.push_back(std::string(parm_name));
                }
            module_data[module_name] = parameters;
            }

        GetSetParmProc setParameter = (GetSetParmProc)::GetProcAddress(hinst, "SetParameter");
        setParameter("PI_TranslationStage1", "Speed", "0.75");
        DoubleIntProc goTo = (DoubleIntProc)::GetProcAddress(hinst, "GoTo");
		VoidProc poll = (VoidProc)::GetProcAddress(hinst, "Poll");
		goTo("PI_TranslationStage1", 7.0, 0);
        double pos = poll();
        goTo("PI_TranslationStage1", 15.0, 1);
        goTo("PI_TranslationStage1", 0.0, 0);

/*        int pcount = (*getParameterCount)();
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
*/


        ::FreeLibrary(hinst);
        }
    cout << "Hello world!" << endl;
    return 0;
}
