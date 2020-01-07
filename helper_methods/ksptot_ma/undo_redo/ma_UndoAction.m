function ma_UndoAction(handles)
%ma_UndoAction Summary of this function goes here
%   Detailed explanation goes here
    global number_state_log_entries_per_coast num_SoI_search_revs strict_SoI_search use_selective_soi_search soi_search_tol num_soi_search_attempts_per_rev;

    undo_states = getappdata(handles.ma_MainGUI,'undo_states');
    undo_pointer = getappdata(handles.ma_MainGUI,'undo_pointer');
    maData = getappdata(handles.ma_MainGUI,'ma_data');
    celBodyData = getappdata(handles.ma_MainGUI,'celBodyData');
    
    if(undo_pointer < 1 || undo_pointer > size(undo_states,1))
        return;
    end
    
    if(undo_pointer == size(undo_states,1))
        undo_states{end+1,1} = maData;
        undo_states{end,2}   = '';
    end
    
    maData = undo_states{undo_pointer,1};
    undo_pointer = undo_pointer - 1;
    
    number_state_log_entries_per_coast = maData.settings.numStateLogPtsPerCoast;
    num_SoI_search_revs = maData.settings.numSoISearchRevs;
    strict_SoI_search = maData.settings.strictSoISearch;
    use_selective_soi_search = maData.settings.useSelectiveSoISearch;
    soi_search_tol = maData.settings.soiSearchTol;
    num_soi_search_attempts_per_rev = maData.settings.numSoiSearchAttemptsPerRev;
    
    maData.stateLog = ma_executeScript(maData.script,handles,celBodyData,findobj('Tag','scriptWorkingLbl'));
    maData.celBodyData = celBodyData;
    setappdata(handles.ma_MainGUI,'undo_pointer',undo_pointer);
    setappdata(handles.ma_MainGUI,'undo_states',undo_states);
    setappdata(handles.ma_MainGUI,'ma_data',maData);
    ma_processData(handles);
end