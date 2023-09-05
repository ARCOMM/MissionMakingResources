//currently set up to be placed in unit init

private _statementDrawBlood = {
    if (!alive this) exitWith {
        [
            ["You can't draw blood from a corpse."],
            true
        ] call CBA_fnc_notify;
    };
    
    if (!([ace_player, "ACE_bloodIV_250", 1, true, true, true] call CBA_fnc_canAddItem)) exitWith {
        [
            ["You don't have any room to carry a bag of blood."],
            true
        ] call CBA_fnc_notify;
    };

    [
        15, //Time it takes to complete the action
        [this],
        {
            private _target = _this select 0 select 0;

            //Reduce the blood volume of the target by 0.25 L
            _target setVariable ["ace_medical_bloodVolume", ((_target getVariable ["ace_medical_bloodVolume", 6]) - 0.25)];

            //Attempt to add a 250 ml blood bag to the player, warn if it will be placed on the ground instead.
            if (!([ace_player, "ACE_bloodIV_250", 1, true, true, true] call CBA_fnc_canAddItem)) then {
                [
                    ["You don't have any room to carry a bag of blood so you've dropped it on the ground."],
                    true
                ] call CBA_fnc_notify;
            };
            [ace_player, "ACE_bloodIV_250", true] call CBA_fnc_addItem;
        },
        {
            [
                ["You didn't spend enough time drawing blood to get a complete sample."],
                true
            ] call CBA_fnc_notify;
        },
        "Drawing blood.",
        nil,
        ["isNotInside", "isNotSitting"]
    ] call ace_common_fnc_progressBar;
};

private _actionDrawBlood = ["Draw Blood", "Draw Blood", "\z\ace\addons\medical_gui\ui\iv.paa", _statementDrawBlood, {true}] call ace_interact_menu_fnc_createAction;

{
    [this, 0, [_x], _actionDrawBlood] call ace_interact_menu_fnc_addActionToObject;
    [this, 0, ["ACE_MainActions", "ACE_Medical_Radial",_x], _actionDrawBlood] call ace_interact_menu_fnc_addActionToObject;
} forEach ["ACE_ArmLeft", "ACE_ArmRight"];
