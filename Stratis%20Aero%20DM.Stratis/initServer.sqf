//https://www.reddit.com/r/armadev/comments/c67wc7/is_there_a_way_to_disable_the_negative_score_for/
Fnc_AddScoreHandler = {
	_this addEventHandler ["HandleScore", {
	    params["_Unit", "_Object", "_Score"];
	    
	    if(isPlayer _Object) then {
	    	_Unit addPlayerScores [abs _Score, 0, 0, 0, 0];	
	    };

	    false;
	}];
};

execVM "spawn_crates.sqf";

spawnFlares = {
	{
		format ["Спавн сигнальных ракет"] remoteExec ["systemChat"]; 
		// systemChat format [
		// 	"Player %1 is %2. Pos: %3 Id: %4",   
		// 	name _x,   
		// 	["dead", "alive"] select alive _x,   
		// 	getPos _x,
		// 	getPlayerID _x
		// ];   

		private _playerPos = getPos _x; 
		private _entityPos = [   
			(_playerPos select 0),   
			(_playerPos select 1),   
			(_playerPos select 2) + 200   
		];

		private _flareType = switch (getPlayerID _x) do {
			case "2": {"F_40mm_Red"};
			case "3": {"F_40mm_Green"};
			case "4": {"F_40mm_Yellow"};
			case "5": {"F_40mm_CIR"};
			default { "F_40mm_White" };
		};
		private _flare = _flareType createVehicle _entityPos;   
		_flare setVelocity [0,0,-20];

		private _smokeType = switch (getPlayerID _x) do {
			case "2": {"G_40mm_SmokeRed"};
			case "3": {"G_40mm_SmokeGreen"};
			case "4": {"G_40mm_SmokeYellow"};
			case "5": {"G_40mm_SmokePurple"};
			default   {"G_40mm_Smoke"};
		};
		private _smoke = _smokeType createVehicle _entityPos;

		playSound3D ["a3\missions_f_beta\data\sounds\showcase_night\flaregun_4.wss", _x];
		
		// systemChat format [   
		// 	"flareType = %1    smokeType = %2",   
		// 	_flareType,
		// 	_smokeType
		// ];
	} forEach allPlayers;
};


_secInAMinute = 60;											
_minutes = 30;

waitUntil {
	_wait = _minutes * _secInAMinute;
	_until = round(diag_tickTime + _wait);

	waitUntil {
		sleep 1;

		// format ["Time: %1", round(diag_tickTime)] remoteExec ["systemChat"];

		_every9Minutes = round(diag_tickTime) % (10*60) == 540; 
		if(_every9Minutes) then {
			format ["Через минуту заспавняться сигнальные ракеты над головой"] remoteExec ["systemChat"];
		};

		_every10Minutes = round(diag_tickTime) % 600 == 0; 
		if(_every10Minutes) then spawnFlares;

		//Уведомление о перезагрузке через 50% времени
		_half = round(_until - _wait/2);
		_isHalfTimeTillSpawn = round(diag_tickTime) == _half;
		if(_isHalfTimeTillSpawn) then {
			format ["Перезагрузка ящиков через %1 минут", _minutes/2] remoteExec ["systemChat"];
		};

		//Уведомление о перезагрузке за минуту до перезагрузки
		_one = round(_until - _secInAMinute);
		_isOneMinuteTillSpawn = round(diag_tickTime) == _one;
		if(_isOneMinuteTillSpawn) then {
			"Перезагрузка ящиков через 1 минуту" remoteExec ["systemChat"];
		};

		diag_tickTime > _until;
	};
	execVM "spawn_crates.sqf";
	

	// waitUntil {sleep 1; diag_tickTime > _until;};

	false; // Loop waitUntil forever
};

// Define the execution interval in seconds (10 minutes)
_timeInterval = 10 * 60;



