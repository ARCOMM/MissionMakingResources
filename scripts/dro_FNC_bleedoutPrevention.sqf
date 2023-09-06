/*
 * Author: drofseh
 *
 * Description:
 * Recursive function to prevent a unit from bleeding to death in ACE Medical.
 * Unit will continue to bleed until it gets to a fatal level, blood will then either be kept at that level, or restored to a level where wakeup is possible.
 * _unit setVariable ["dro_endBleedoutPrevention", true] will stop the function from continuing.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Give unit enough blood to wake up.<BOOL> (optional, default: false)
 *
 * Return Value:
 * Recursive success <BOOL>
 *
 * Example:
 * [unit,true] call dro_FNC_bleedoutPrevention;
 *
*/

dro_FNC_bleedoutPrevention = {
    params ["_unit", ["_wakeup", false, [true]]];
    if (!alive _unit || {_unit getVariable ["dro_endBleedoutPrevention", false]}) exitWith {false};

    if (_unit getVariable ["ACE_isUnconscious",false]) then {
        private _bloodVolume = _unit getVariable ["ace_medical_bloodVolume", 6];

        if (_bloodVolume < 3.5) then {
            [_unit, false] call ace_medical_fnc_setUnconscious;
            _unit setVariable ["ace_medical_bloodVolume", ([3.5, 5.2] select _wakeup)];
        };
    };

    [{
        _this call dro_FNC_bleedoutPrevention;
    }, [_unit,_wakeup], 1] call CBA_fnc_waitAndExecute;
};
