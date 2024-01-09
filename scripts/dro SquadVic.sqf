//====== Add action to self-set vehicle as squad vic
private _conditionSquadVicAdd = {True};

private _statementSquadVicAdd = {
    if (isNil "diwako_dui_special_track") then {
        diwako_dui_special_track = [];
    };

    if (typeName diwako_dui_special_track != "ARRAY") then {
        diwako_dui_special_track = [];
    };

    if !(isNil "squadVic_currentVic") then {
        private _currentVicIndex = diwako_dui_special_track find squadVic_currentVic;
        if (_currentVicIndex >= 0) then {
            diwako_dui_special_track deleteAt _currentVicIndex;
        };
    };

    squadVic_currentVic = this;
    diwako_dui_special_track pushBackUnique this;
};

private _actionSquadVicAdd = ["Set as Squad Vehicle","Set as Squad Vehicle","",_statementSquadVicAdd,_conditionSquadVicAdd] call ace_interact_menu_fnc_createAction;

//add set action to vehicle menu when player outside of vic
["LandVehicle", 0, ["ACE_MainActions"], _actionSquadVicAdd,true] call ace_interact_menu_fnc_addActionToClass;
["Air", 0, ["ACE_MainActions"], _actionSquadVicAdd,true] call ace_interact_menu_fnc_addActionToClass;
["Ship", 0, ["ACE_MainActions"], _actionSquadVicAdd,true] call ace_interact_menu_fnc_addActionToClass;

//add set action to vehicle menu when player inside of vic
["LandVehicle", 1, ["ACE_SelfActions"], _actionSquadVicAdd,true] call ace_interact_menu_fnc_addActionToClass;
["Air", 1, ["ACE_SelfActions"], _actionSquadVicAdd,true] call ace_interact_menu_fnc_addActionToClass;
["Ship", 1, ["ACE_SelfActions"], _actionSquadVicAdd,true] call ace_interact_menu_fnc_addActionToClass;
