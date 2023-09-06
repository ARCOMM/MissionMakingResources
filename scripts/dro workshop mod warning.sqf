/*
    Check if the player is loading mods from Steam Workshop and warn them if they are.
    Place code in init.sqf
*/

if (hasInterface) then {
    [
        {
            private _classes = "true" configClasses (configFile >> "CfgPatches");
            private _modlist = [];
            {
                private _mod = configSourceModList _x select 0;
                private _data = modParams [_mod, ["name", "picture","logo","logoOver","logoSmall"]];
                if !(_data isEqualTo []) then {
                    private _data0 = _data select 0;
                    
                    for "_i" from 1 to 4 do {
                        private _data1 = _data select _i splitString "\";
                        if ((_data1 find "!workshop") > -1) then {
                            _modlist pushBackUnique _data0;
                        };
                    };
                    
                };
            } forEach _classes;

            if !(_modlist isEqualTo []) then {
                _modlist sort true;
                _modlist = _modlist joinString "\n        ";

                "Warning!" hintC [
                    (format ["The following mods are not being loaded from the ARCOMM modpack:\n\n        %1", _modlist]),
                    "Make sure you only load mods from the ARCOMM modpack",
                    "Failure to do so will result in errors."
                ];
            };
        },
        [],
        5
    ] call CBA_fnc_waitAndExecute;
};
