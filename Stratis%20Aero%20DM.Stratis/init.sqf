execVM "spawn_crates.sqf";

_secInAMinute = 60;											
_minutes = 30;

waitUntil {
	_wait = _minutes * _secInAMinute;
	_until = diag_tickTime + _wait;

	waitUntil {
		sleep 1;

		_half = round(_until - _wait/2);
		if(round(diag_tickTime) == _half) then {
			hint format ["Перезагрузка ящиков через %1 минут", _minutes/2];
		};

		_one = round(_until - _secInAMinute);
		if(round(diag_tickTime) == _one) then {
			hint "Перезагрузка ящиков через 1 минуту";
		};

		diag_tickTime > _until;
	};
	execVM "spawn_crates.sqf";
	

	// waitUntil {sleep 1; diag_tickTime > _until;};

	false; // Loop waitUntil forever
};