"===========Происходит обновление ящиков...===========" remoteExec ["systemChat"];

_prefix = "crateSpawnPoint";
_prefix = toUpper _prefix;
_cratesSpawnpoints = allMapMarkers select {toUpper _x find _prefix >= 0};

_cratesPerPoint = 10;

//Список ящиков
_crates = [
	"Box_NATO_Wps_F",
	"Box_NATO_WpsSpecial_F",
	"Box_T_NATO_Wps_F", 
	"Box_East_Wps_F", 
	"Box_T_East_Wps_F",	
	"Box_East_WpsSpecial_F",
	"Box_NATO_WpsLaunch_F", 
	"Box_East_WpsLaunch_F", 
	"Box_IND_Wps_F", 
	"Box_Syndicate_Wps_F",
	"Box_Syndicate_WpsLaunch_F",
	"Box_IED_Exp_F",
	"Box_NATO_Equip_F",
	"Box_CSAT_Equip_F",
	"Box_AAF_Equip_F",
	"Box_GEN_Equip_F",
	"Box_NATO_Uniforms_F",
	"Box_CSAT_Uniforms_F",
	"Box_AAF_Uniforms_F",
	"Box_IND_WpsLaunch_F",
	"Box_IND_WpsSpecial_F",
	"Box_T_NATO_WpsSpecial_F",
	"Box_T_East_WpsSpecial_F",
	"Box_EAF_WpsSpecial_F"
];

//Предметы для удаления из всех ящиков
_weaponsToRemove = [
	"launch_O_Titan_short_F",
	"launch_B_Titan_short_F",
	"launch_I_Titan_short_F",
	"launch_O_Titan_short_F",
	"B_AA_01_weapon_F",
	"O_AA_01_weapon_F",
	"I_AA_01_weapon_F",
	"B_AT_01_weapon_F",
	"O_AT_01_weapon_F",
	"I_AT_01_weapon_F",
	"launch_B_Titan_short_tna_F",
	"launch_O_Titan_short_ghex_F",
	"I_E_AT_01_weapon_F",
	"I_E_AA_01_weapon_F",
	"srifle_GM6_F",
	"srifle_GM6_camo_F",
	"srifle_GM6_ghex_F",
	"srifle_DMR_02_sniper_F",
	"srifle_LRR_tna_F",
	"srifle_EBR_F",
	"srifle_DMR_01_F",
	"srifle_DMR_01_F",
	"srifle_DMR_04_F",
	"srifle_DMR_07_blk_F",
	"srifle_DMR_03_F",
	"srifle_DMR_03_multicam_F",
	"srifle_DMR_03_khaki_F",
	"srifle_DMR_03_tan_F",
	"srifle_DMR_03_woodland_F",
	"srifle_DMR_02_F",
	"srifle_DMR_02_camo_F",
	"srifle_DMR_02_sniper_F",
	"srifle_LRR_F",
	"srifle_LRR_camo_F",
	"srifle_LRR_tna_F",
	"srifle_DMR_05_hex_F",
	"srifle_DMR_05_tan_f"
];

_itemsToRemove = [
	"optic_NVS",
	"optic_tws",
	"optic_tws_mg",
	"Laserdesignator",
	"Laserdesignator_02",
	"Laserdesignator_03",
	"O_NVGoggles_hex_F",
	"O_NVGoggles_urb_F",
	"O_NVGoggles_ghex_F",
	"NVGoggles_tna_F",
	"NVGogglesB_blk_F",
	"NVGogglesB_grn_F",
	"NVGogglesB_gry_F",
	"O_NVGoggles_grn_F",
	"Laserdesignator_01_khk_F",
	"Laserdesignator_02_ghex_F",
	"optic_Nightstalker",
	"H_HelmetO_ghex_F",
	"H_HelmetO_ViperSP_hex_F",
	"H_HelmetO_ViperSP_ghex_F",
	"optic_LRPS",
	"optic_LRPS_tna_F",
	"optic_LRPS_ghex_F",
	"optic_AMS",
	"optic_AMS_khk",
	"optic_AMS_snd",
	"optic_KHS_blk",
	"optic_KHS_hex",
	"optic_KHS_old",
	"optic_KHS_tan"
];

//Оставляем только контент из базовой игры и DLC, которыми владеют игроки.
//AppID DLC игроков: Apex = 395180. Malden/Zeus бесплатны; базовый (не-DLC) контент всегда остаётся.
DM_OwnedDLCs = ["395180"];

//Разбор результата getAssetDLCInfo -> [isDlc, isOwned, isInstalled, isAvailable, appID, DLCName]
DM_fnc_isDLCInfoOwned = {
	params ["_info"];
	if (count _info < 5) exitWith { true };
	_info params ["_isDlc", "", "", "", "_appID"];
	if (!_isDlc) exitWith { true };
	_appID in DM_OwnedDLCs
};

//Оружие — класс в CfgWeapons.
Fnc_IsWeaponOwned = {
	params ["_class"];
	[getAssetDLCInfo [_class, configFile >> "CfgWeapons"]] call DM_fnc_isDLCInfoOwned
};

//Предметы: прицелы/жилеты/головные уборы — класс в CfgWeapons.
//Униформа (ItemInfo type == 801) хранит DLC на модели персонажа в CfgVehicles.
Fnc_IsItemOwned = {
	params ["_class"];
	private _cfg = configFile >> "CfgWeapons" >> _class;
	private _info = if (getNumber (_cfg >> "ItemInfo" >> "type") == 801) then {
		getAssetDLCInfo [getText (_cfg >> "ItemInfo" >> "uniformClass"), configFile >> "CfgVehicles"]
	} else {
		getAssetDLCInfo [_class, configFile >> "CfgWeapons"]
	};
	[_info] call DM_fnc_isDLCInfoOwned
};

//Рюкзаки — класс в CfgVehicles.
Fnc_IsBackpackOwned = {
	params ["_class"];
	[getAssetDLCInfo [_class, configFile >> "CfgVehicles"]] call DM_fnc_isDLCInfoOwned
};

_radius = 150;	

//Удаление старых ящиков
"Удаление старых ящиков" remoteExec ["systemChat"];
{

	_pos = getMarkerPos _x;
	_old = _pos nearSupplies _radius * 2;
	{
		
		if(typeOf _x in _crates) then {
			deleteVehicle _x;
		}
		// else {
		// 	systemChat str typeOf _x;
		// }
	} forEach _old;


} forEach _cratesSpawnpoints;

//Спавн новых ящиков
"Спавн новых ящиков" remoteExec ["systemChat"];
{
	for[{private _i = 0}, {_i < _cratesPerPoint}, {_i = _i + 1}] do {
		_pos = getMarkerPos _x;

		_addX = (random _radius * 2) - _radius;
		_addY = (random _radius * 2) - _radius;
		_pos = _pos vectorAdd[_addX, _addY, 0];


		_crate = selectRandom _crates;
		_holder = _crate createVehicle _pos;

		

		
		// Сохраняем копию текущего инвентаря оружий и их количество
		_weapons = getWeaponCargo _holder;
		_weaponsClassNames = _weapons # 0;
		_weaponsQuantities = _weapons # 1;

		// Сохраняем копию текущего инвентаря предметов и их количество
		_items = getItemCargo _holder;
		_itemsClassNames = _items # 0;
		_itemsQuantities = _items # 1;

		// Сохраняем копию рюкзаков и их количество
		_backpacks = getBackpackCargo _holder;
		_backpacksClassNames = _backpacks # 0;
		_backpacksQuantities = _backpacks # 1;


		// systemChat "===============================";
		// {
		// 	systemChat _x;
		// } forEach _weaponsClassNames;

		// {
		// 	systemChat _x;
		// } forEach _itemsClassNames;


		clearWeaponCargoGlobal _holder;
		clearItemCargoGlobal _holder;
		clearBackpackCargoGlobal _holder;

		// Удаляем оружия: из чёрного списка (баланс) и не принадлежащие DLC игроков
		_keptWeaponClassNames = [];
		_keptWeaponQuantities = [];
		{
			if (!(_x in _weaponsToRemove) && {[_x] call Fnc_IsWeaponOwned}) then {
				_keptWeaponClassNames pushBack _x;
				_keptWeaponQuantities pushBack (_weaponsQuantities # _forEachIndex);
			};
		} forEach _weaponsClassNames;
		_weaponsClassNames = _keptWeaponClassNames;
		_weaponsQuantities = _keptWeaponQuantities;
		
		// Удаляем предметы: из чёрного списка (баланс) и не принадлежащие DLC игроков
		// (униформа, жилеты, головные уборы и т.п. приходят сюда же)
		_keptItemClassNames = [];
		_keptItemQuantities = [];
		{
			if (!(_x in _itemsToRemove) && {[_x] call Fnc_IsItemOwned}) then {
				_keptItemClassNames pushBack _x;
				_keptItemQuantities pushBack (_itemsQuantities # _forEachIndex);
			};
		} forEach _itemsClassNames;
		_itemsClassNames = _keptItemClassNames;
		_itemsQuantities = _keptItemQuantities;

		// Удаляем рюкзаки, не принадлежащие DLC игроков
		_keptBackpackClassNames = [];
		_keptBackpackQuantities = [];
		{
			if ([_x] call Fnc_IsBackpackOwned) then {
				_keptBackpackClassNames pushBack _x;
				_keptBackpackQuantities pushBack (_backpacksQuantities # _forEachIndex);
			};
		} forEach _backpacksClassNames;
		_backpacksClassNames = _keptBackpackClassNames;
		_backpacksQuantities = _keptBackpackQuantities;
		

		// Добавляем оставщиеся оружия
		for[{private _y = 0}, {_y < count _weaponsClassNames}, {_y = _y + 1}] do {
			_holder addWeaponCargoGlobal [_weaponsClassNames # _y, _weaponsQuantities # _y];
		};

		// Добавляем оставщиеся предметы
		for[{private _y = 0}, {_y < count _itemsClassNames}, {_y = _y + 1}] do {
			_holder addItemCargoGlobal [_itemsClassNames # _y, _itemsQuantities # _y];
		};

		// Добавляем оставшиеся рюкзаки
		for[{private _y = 0}, {_y < count _backpacksClassNames}, {_y = _y + 1}] do {
			_holder addBackpackCargoGlobal [_backpacksClassNames # _y, _backpacksQuantities # _y];
		};



		// _holder removeWeaponGlobal "arilfe_MX_F";
		// _holder addWeaponCargo["srifle_EBR_DMS_pointer_snds_F", 1];
		// _ammoQty = round((random 8) + 2);
		// _holder addMagazineCargo["20Rnd_762x51_Mag", _ammoQty];
	};
} forEach _cratesSpawnpoints;

"===========Обновление ящиков завершено===========" remoteExec ["systemChat"];