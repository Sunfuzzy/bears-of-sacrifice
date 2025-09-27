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
@onready var char_label = $CanvasLayer/Label

func update_ui():
	char_label.text = "Characters left: %d" % players.size()


func _on_goal_level_complete() -> void:
	pass # Replace with function body.
func _on_Goal_level_complete():
	# Pysäytä peli
	get_tree().paused = true

	# Luo tausta
	var panel = ColorRect.new()
	panel.color = Color(0, 0, 0, 0.7) # läpinäkyvä musta
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(panel)

	# Luo teksti
	var win_label = Label.new()
	win_label.text = "YOU WIN!"
	win_label.add_theme_font_size_override("font_size", 64)
	win_label.set_anchors_preset(Control.PRESET_CENTER)
	win_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	win_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	panel.add_child(win_label)

	# Luo restart-nappi
	var restart_button = Button.new()
	restart_button.text = "Restart"
	restart_button.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	restart_button.offset_bottom = -50
	panel.add_child(restart_button)

	restart_button.connect("pressed", Callable(self, "_on_restart_pressed"))
func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
