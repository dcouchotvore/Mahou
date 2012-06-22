

#define MAX_PARAMETER_NAME_SIZE (63)

typedef enum { INT, FLOAT, DOUBLE, STRING } ParameterType;

void __declspec(dllexport) Initialize(const char *const db_path);
void __declspec(dllexport) AddLibraryPath(const char *const path);
void __declspec(dllexport) LoadLibraries();
int __declspec(dllexport) GetLibraryCount();
int __declspec(dllexport) GetLibraryName(char *buffer);

int __declspec(dllexport) GetDeviceName(const char *const libname, char *value);
int __declspec(dllexport) GetDeviceName(const char *const libname, char *name);

int __declspec(dllexport) GetParameterCount(const char *const libname);
int __declspec(dllexport) GetParameterData(const char *const libname, char *name, int *type, int *is_read_only);
int __declspec(dllexport) SetParameter( char * libname,  char *name,  char *value);
int __declspec(dllexport) GetParameter(const char *const libname, const char *name, char *value);

int __declspec(dllexport) GoTo(const char *const libname, double pos, int async);
double __declspec(dllexport) Poll(const char *const libname);
int __declspec(dllexport) SetData(const char *const libname, const double *data);
int __declspec(dllexport) GetData(const char *const libname, double *data);

int __declspec(dllexport) IoCtrl(const char *const libname, const int method, void *data);
int __declspec(dllexport) SendMsg(const char *const libname, const char *msg, const unsigned int len);
int __declspec(dllexport) RecvMsg(const char *const libname, char *msg, const unsigned int max_len);
