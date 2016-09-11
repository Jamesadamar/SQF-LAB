/*
	author: 		James
	file: 			mark_locations.sqf
	version: 		1.00
	date: 			2016-09-07
	purpose: 		mark all locations of given type
	arguments: 	types (array): array of types of location, has to be a type of CfgLocationTypes
	return value:	none

	example call: 		[["nameCity", "nameCityCapital"]] execVM "mark_locations.sqf"
*/
// options that can be changed if wanted
#define RADIUS 30000 // 30km
#define MARKER_NAME "opfor_city"
#define JITTER [100,150,250] // Versetzt Marker um 100 - 300 m nach oben/unten + links/rechts

// arguments
private _types = param [0, ["nameCity"], [[]], []]; // Liste mit bel. vielen Einträgen - default: ["nameCity"]

// begin of script
private _config_types = [];
{

	_config_types pushBackUnique toLower (configName _x); // bin\config.bin/CfgLocationTypes/Mount -> "mount"

} foreach ([configFile >> "CfgLocationTypes", 0, true] call BIS_fnc_returnChildren);


private _not_allowed = false;
{

	if !((toLower _x) in _config_types) exitWith {_not_allowed = true};

} forEach _types;

if (_not_allowed) exitWith {hint "Parameter type ist fehlerhaft, angegebene Typen nicht in CfgLocationTypes!"};

// create marker for all Locations
_nr_of_cities = 0;
{

	private _name = text _x; // _x = gefundene location
	private _pos = locationPosition _x;
	// Jitter
	_pos = [
		(_pos select 0) + random JITTER * (selectRandom [-1,1]),
		(_pos select 1) + random JITTER * (selectRandom [-1,1]),
		_pos select 2
	];

	private _marker_name = format["%1_%2", MARKER_NAME, _name];
	if ( ({_x find _marker_name >=0} count allMapMarkers) > 0 ) then {
		deleteMarker _marker_name;
	};

	private _marker = createMarker [format["%1_%2", MARKER_NAME, _name], _pos]; // erzeugt marker mit Namen "opfor_city_cityname"
	_marker setMarkerType "o_installation";
	_marker setMarkerText _name;
	_marker setMarkerColor "colorOPFOR";
	_marker setMarkerShape "ICON";
	_marker setMarkerAlpha 0.7;
	_nr_of_cities = _forEachIndex + 1;

} forEach nearestLocations [[0,0,0], _types, RADIUS];

hint format["Skript beendet. Es wurden insgesamt %1 Locations markiert", _nr_of_cities];