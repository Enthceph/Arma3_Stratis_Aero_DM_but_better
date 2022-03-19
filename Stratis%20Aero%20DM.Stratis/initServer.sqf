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

_secInAMinute = 60;											
_minutes = 30;

waitUntil {
	_wait = _minutes * _secInAMinute;
	_until = round(diag_tickTime + _wait);

	waitUntil {
		sleep 1;

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

		// format ["_until:%1", _until] remoteExec ["systemChat"];
		// format ["round(diag_tickTime):%1", round(diag_tickTime)] remoteExec ["systemChat"];

		diag_tickTime > _until;
	};
	execVM "spawn_crates.sqf";
	

	// waitUntil {sleep 1; diag_tickTime > _until;};

	false; // Loop waitUntil forever
};