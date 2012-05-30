

// MATLABconnector.cpp : Defines the entry point for the DLL application.
//

#include "stdafx.h"
#include "MATLABconnector.h"
#include <windows.h>

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
    return TRUE;
}

//This is the main function that gets called from Matlab: the "key" int variable
// in this switch/case group is the third parameter in the Matlab "calllib" function:
// By using the relevant number in the calllib function in Matlab, you can in this
// example specify which key you want to simulate being pressed.

__declspec(dllexport) void fnMATLABconnector(int key)
{
	switch (key)
	{
	case 1:
		PostMessage(HWND_BROADCAST, WM_KEYDOWN, VK_LEFT, 0);
		PostMessage(HWND_BROADCAST, WM_KEYUP, VK_LEFT, 0);
		break;
	case 2:
		PostMessage(HWND_BROADCAST, WM_KEYDOWN, VK_RIGHT, 0);
		PostMessage(HWND_BROADCAST, WM_KEYUP, VK_RIGHT, 0);
		break;
	case 3:
		PostMessage(HWND_BROADCAST, WM_KEYDOWN, VK_UP, 0);
		PostMessage(HWND_BROADCAST, WM_KEYUP, VK_UP, 0);
		break;
	case 4:
		PostMessage(HWND_BROADCAST, WM_KEYDOWN, VK_DOWN, 0);
		PostMessage(HWND_BROADCAST, WM_KEYUP, VK_DOWN, 0);
		break;
	}
}
