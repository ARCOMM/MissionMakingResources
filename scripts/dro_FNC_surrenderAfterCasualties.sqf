/*
 * Author: drofseh
 *
 * Description:
 * Causes a group of AI units to surrender once a randomized percentage of their group are casualties (killed or uncon).
 * If the AI are not taken prisoner then they will un-surrender after a randomized delay.
 * If the group does un-surrender, then function is run on the group again with the same original input.
 *
 * Arguments:
 * 0: Group <GROUP>
 * 1: Surrender percentage Randomization <ARRAY>
 * - 0: Minimum percentage of units remaining to surrender <NUMBER> (optional, default: 0.0)
 * - 1: Average percentage of units remaining to surrender <NUMBER> (optional, default: 0.5)
 * - 2: Maximum percentage of units remaining to surrender <NUMBER> (optional, default: 0.8)
 * 2: Un-surrender Delay Randomization <ARRAY>
 * - 0: Minimum time in seconds before un-surrender <NUMBER> (optional, default: 60)
 * - 1: Additional randomized time in seconds added to minimum time <NUMBER> (optional, default: 840 (14 minutes))
 *
 * Return Value:
 * Recursive success <BOOL>
 *
 * Example:
 * [this] call dro_FNC_SurrenderAfterCasualties;
 * [this,[0,0.75,0.9]] call dro_FNC_SurrenderAfterCasualties;
 * [this,[0,0.25,0.5],[90,600]] call dro_FNC_SurrenderAfterCasualties;
*/

dro_FNC_SurrenderAfterCasualties = {
    params ["_group",["_surrenderPercentage",[0,0.5,0.8]],["_unSurrenderDelay",[60,840]]];

    if (!isServer) exitWith {};

    private _countUnits = count units _group;
    _group setVariable ["dro_SurrenderAfterCasualties_unSurrenderTime", _unSurrenderDelay#0 + (random _unSurrenderDelay#1), true];
    _group setVariable ["dro_SurrenderAfterCasualties_surrenderNumber", ceil random [_surrenderPercentage#0 * _countUnits, _surrenderPercentage#1 * _countUnits, _surrenderPercentage#2 * _countUnits], true];

    [{
        params ["_group"];

        ({alive _x || {_x getVariable ["ACE_isUnconscious",false]}} count units _group) <= (_group getVariable ["dro_SurrenderAfterCasualties_surrenderNumber", 0];)

    },{
        params ["_group","_countUnits","_surrenderPercentage","_unSurrenderDelay"];
        private _units = units _group;

        {
            if (alive _x &&  {!(_x getVariable ["ACE_isUnconscious",false])}) then {
                [_x,_group,_countUnits, _surrenderPercentage, _unSurrenderDelay] call dro_FNC_SurrenderUnit;
            };
        } forEach _units;
    }, [_group,_countUnits, _surrenderPercentage, _unSurrenderDelay]] call CBA_fnc_waitUntilAndExecute;
};

dro_FNC_SurrenderUnit = {
    params ["_unit","_group","_countUnits","_surrenderPercentage","_unSurrenderDelay"];

    [_unit, true] remoteExecCall ["ACE_captives_fnc_setSurrendered", _x];

    [{
        params ["_unit","_group","_countUnits","_surrenderPercentage","_unSurrenderDelay"];

        if ((alive _unit) && (!(_unit getVariable ["ace_captives_isHandcuffed", false]))) then {

            [_unit, false] remoteExecCall ["ACE_captives_fnc_setSurrendered", _x];

            if (_unit == leader _group) then {
                [_group,_surrenderPercentage, _unSurrenderDelay] call dro_FNC_SurrenderAfterCasualties;
            };
        };
    }, [_unit,_group,_countUnits, _surrenderPercentage, _unSurrenderDelay], (group _unit) getVariable ["dro_SurrenderAfterCasualties_unSurrenderTime", 60]] call CBA_fnc_waitAndExecute;
};
