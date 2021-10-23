/*
	Author: Krail

	Description:
		Спавнит машину на рандомно выбранной точке в заданном радиусе

	Parameter(s):
		0: OBJECT - автомобиль, который нужно зареспавнить
		1: NumberToDate >= 0 - (Опционально, по-умолчанию 0) - радиус респавна от метки




	Returns:
		Nothing

	Examples:
		_vehicle1 respawnVehicleRandom;
	
		//Респавн автомобиля в радиусе 150 метров
		[_vehicle1, 150] respawnVehicleRandom;

		//Респавн автомобиля при его взрыве
		this addEventHandler ["Killed", [this, 150] respawnVehicleRandom"];
*/

// params = [
// 	["_vehicle", objNull],
// 	["_radius", 0, [Number]]
// ];

_vehicle = _this select 0;
_radius = _this select 1;

systemChat "Function executed!";