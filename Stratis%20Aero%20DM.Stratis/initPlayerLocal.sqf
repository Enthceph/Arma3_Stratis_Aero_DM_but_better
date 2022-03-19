//https://www.reddit.com/r/armadev/comments/c67wc7/is_there_a_way_to_disable_the_negative_score_for/
player remoteExec ["Fnc_AddScoreHandler", 2];

//Т.к. после респавна обработчик HandleScore не сохраняется,
//нужно добавить ещё ещё раз после респавна
player addEventHandler ["Respawn", {
    params["_Unit", "_Corpse"];
    _Unit remoteExec ["Fnc_AddScoreHandler", 2];
}];