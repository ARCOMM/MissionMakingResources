/*
    Automatically delete any map markers placed after the mission starts if they are created in a restricted channel.
    Informs the placing player that map markers are forbidden in that channel.
    Place in init.sqf
*/

addMissionEventHandler ["MarkerCreated", {
    params ["_marker", "_channelNumber", "_owner"];

    private _restrictedIDs = [0, 1, 2, 3]; // Global, Side, Command, Group, https://community.bistudio.com/wiki/Channel_IDs

    if (
        CBA_missionTime > 1 //allows any markers during briefing
        && {!([] call TMF_safestart_fnc_isActive)} //allows markers during safe start
        && {_channelNumber in _restrictedIDs} // filters by channel ID
        && {_owner == player} // Only handle own marks
        && {isNull getAssignedCuratorLogic _owner} //Zeuses can always place new markers
    ) then {

        private _allowedIDs = [0, 1, 2, 3, 4, 5] - _restrictedIDs;
        private _allowedChannelNames = "";

        {
            switch _x do {
                case 0 : {_allowedChannelNames = _allowedChannelNames + " Global"};
                case 1 : {_allowedChannelNames = _allowedChannelNames + " Side"};
                case 2 : {_allowedChannelNames = _allowedChannelNames + " Command"};
                case 3 : {_allowedChannelNames = _allowedChannelNames + " Group"};
                case 4 : {_allowedChannelNames = _allowedChannelNames + " Vehicle"};
                case 5 : {_allowedChannelNames = _allowedChannelNames + " Direct"};
            };
            if (count _allowedIDs > 1) then {
                if (_allowedIDs select -2 == _x) then {
                    _allowedChannelNames = _allowedChannelNames + ", or";
                } else {
                    if (_allowedIDs select -1 != _x) then {
                        _allowedChannelNames = _allowedChannelNames + ",";
                    };
                };
            };
        } forEach _allowedIDs;

        if (_allowedChannelNames == "") then {
            _allowedChannelNames = "Placing map markers during the mission is forbidden.";
        } else{
            _allowedChannelNames = "Placing map markers during the mission is forbidden in this channel. You must use the " + _allowedChannelNames + " channels.";
        };

        systemChat _allowedChannelNames; // Warn the player and list allowed channels

        [
            {
                params ["_marker"];
                deleteMarker _marker;
            },
            [_marker],
            0.1
        ] call CBA_fnc_waitAndExecute;
    };
}];
