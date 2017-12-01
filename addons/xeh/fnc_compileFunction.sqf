/* ----------------------------------------------------------------------------
Function: CBA_fnc_compileFunction

Description:
    Compiles a function into mission namespace and into ui namespace for caching purposes.
    Recompiling can be enabled by inserting the CBA_cache_disable.pbo from the optionals folder.

Parameters:
    0: _funcFile - Path to function sqf file <STRING>
    1: _funcName - Final function name <STRING>

Returns:
    None

Examples:
    (begin example)
        [_funcFile, _funcName] call CBA_fnc_compileFunction;
    (end)

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_funcFile", "", [""]], ["_funcName", "", [""]], ["_trimHeaderInclude", false, [false]]];

private _cachedFunc = uiNamespace getVariable _funcName;

if (isNil "_cachedFunc") then {
    private _precompiledScript = preprocessFileLineNumbers _funcFile;

    //if (_trimHeaderInclude) then {
        private _index = _precompiledScript find 'PREPROCESSOR_TRIM_END;';

        if (_index > -1) then {
            _index = _index + count 'PREPROCESSOR_TRIM_END;' + 1;
            _precompiledScript = _precompiledScript select [_index];
        };
    //};

    uiNamespace setVariable [_funcName, compileFinal _precompiledScript];
    missionNamespace setVariable [_funcName, uiNamespace getVariable _funcName];
} else {
    if (["compile"] call CBA_fnc_isRecompileEnabled) then {
        missionNamespace setVariable [_funcName, compileFinal preprocessFileLineNumbers _funcFile];
    } else {
        missionNamespace setVariable [_funcName, _cachedFunc];
    };
};
