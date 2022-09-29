extends Control

var multiplayer_peer = ENetMultiplayerPeer.new()

var port:int
var max_players:int
var admin_password:String

func _ready():
	var args = OS.get_cmdline_user_args()
	
	for arg in args:
		var key_value = arg.rsplit("=")
		match key_value[0]:
			"port":
				port = key_value[1].to_int()
			"max-players":
				max_players = key_value[1].to_int()
			"admin-password":
				admin_password = key_value[1]
	multiplayer_peer.create_server(
		port,
		max_players
	)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(func(id): add_player_character(id))
	print("Server running.")	
	
	


func add_player_character(id=1):
	print("Player connected.")
	var character = load("res://player_character/player_character.tscn").instantiate()
	character.name = str(id)
	add_child(character)

@rpc(any_peer)
func kick_player(peer_id, password):
	if password == admin_password:
		multiplayer_peer.get_peer(peer_id).peer_disconnect()
