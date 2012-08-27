function EnableParameters(handles)
    global PARAMETER_MAP;
    
    row = get(handles.popupMethods, 'Value');
    PARAMETER_MAP(row, 1)
    set(handles.popupDataSource, 'Enable', 'on');
    set(handles.popupDataSource, 'Enable', PARAMETER_MAP{row, 1});
    set(handles.editNumScans,    'Enable', PARAMETER_MAP{row, 2});
    set(handles.editNumShots,    'Enable', PARAMETER_MAP{row, 3});
    set(handles.editStart,       'Enable', PARAMETER_MAP{row, 4});
    set(handles.editStop,        'Enable', PARAMETER_MAP{row, 5});
    set(handles.editSpeed,       'Enable', PARAMETER_MAP{row, 6});
    set(handles.editBinSize,     'Enable', PARAMETER_MAP{row, 7});
end
    