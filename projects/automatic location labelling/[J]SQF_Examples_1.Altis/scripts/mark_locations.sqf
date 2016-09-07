/*
	author: 		James
	file: 			mark_locations.sqf
	version: 		1.00
	date: 			2016-09-07
	purpose: 		mark all locations of given type
	arguments: 		types (array): array of types of location, has to be a type of CfgLocationTypes
	return value:	none

	example call: 		[] execVM ""
*/
#define RADIUS 100000
#define MARKER_NAME_CITY "opfor_city"
// arguments
private _types = param [0, ["nameCity"], [["string"]], []];

// begin of script
private _config_types = [];
{

	_config_types pushBackUnique toLower (configName _x);

} foreach ([configFile >> "CfgLocationTypes", 0, true] call BIS_fnc_returnChildren);


private _not_allowed = false;
{

	if !((toLower _x) in _config_types) exitWith {_not_allowed = true};

} forEach _types;

if (_not_allowed) exitWith {hint "Parameter type ist fehlerhaft, angegebene Typen nicht in CfgLocationTypes!"};

// create marker for all Locations

{

	private _name = text _x;
	private _marker = createMarker [format["%1_%2", MARKER_NAME_CITY, _name], locationPosition _x];
	_marker setMarkerType "o_installation";
	_marker setMarkerText _name;
	_marker setMarkerColor "colorOPFOR";
	_marker setMarkerShape "ICON";
	_marker setMarkerAlpha 0.8;

} forEach nearestLocations [[0,0,0], _types, RADIUS];