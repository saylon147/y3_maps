--
GameManager = {
    im_ready = false,
    all_ready = false,
    player_kill = 0,
    game_result = "init",
    player = y3.player.get_by_handle(GameAPI.get_client_role()),
}


return GameManager
