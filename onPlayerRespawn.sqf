//select random respawn point
_prefix = "crateSpawnPoint";
_prefix = toUpper _prefix;
_spawnpoints = allMapMarkers select {toUpper _x find _prefix >= 0};
_spawnpoint = _spawnpoints call BIS_fnc_selectRandom;


//add radius to respawn points position 
_pos = getMarkerPos _spawnpoint;
_radius = 100;
_addX = (random _radius * 2) - _radius;
_addY = (random _radius * 2) - _radius;
_pos = _pos vectorAdd[_addX, _addY, 0];


_plyr = _this select 0;

//teleporting player
_plyr setPos(_pos);
//hint format ["%1 respawned", name _plyr];

//giving player loadout
_loadout = getUnitLoadout example_loadout_unit;

_plyr setUnitLoadout _loadout;