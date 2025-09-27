extends Node2D

var players = []
var current_index = 0
var current_player: Node = null

func _ready():
	players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		current_player = players[0]
		$Camera2D.position = current_player.global_position

func _process(delta):
	if current_player == null:
		return

	# Camera follows current player
	$Camera2D.global_position = current_player.global_position

	# Switch control
	if Input.is_action_just_pressed("ui_select"):
		switch_player()

func switch_player():
	if players.size() == 0:
		return
	current_index = (current_index + 1) % players.size()
	current_player = players[current_index]
