_prefix = "weaponSpawnPoint";
_prefix = toUpper _prefix;
_weaponSpawnpoints = allMapMarkers select {toUpper _x find _prefix >= 0};

_weaponsPerPoint = 100;

_weapons = [];

{
	for[{private _i = 0}, {_i < _weaponsPerPoint}, {_i = _i + 1}] do {
		_pos = getMarkerPos _x;
		_radius = 50;
		_addX = (random _radius * 2) - _radius;
		_addY = (random _radius * 2) - _radius;
		_pos = _pos vectorAdd[_addX, _addY, 0];


		_holder = "weaponholdersimulated" createVehicle _pos;
		_holder addWeaponCargo["srifle_EBR_DMS_pointer_snds_F", 1];

		_ammoQty = round((random 8) + 2);
		_holder addMagazineCargo["20Rnd_762x51_Mag", _ammoQty];
	};
} forEach _weaponSpawnpoints;


