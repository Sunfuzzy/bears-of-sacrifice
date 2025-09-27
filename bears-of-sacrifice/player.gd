extends CharacterBody2D

@export var speed: int = 200
@export var jump_force: int = -400
@export var gravity: int = 800

var is_alive: bool = true

func _physics_process(delta):
	if not is_alive:
		return

	# Horizontal input
	var input_dir = Input.get_axis("move_left", "move_right")
	velocity.x = input_dir * speed

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_force

	move_and_slide()

func _input(event):
	if event.is_action_pressed("sacrifice") and is_alive:
		do_sacrifice()

func do_sacrifice():
	var bridge_scene = load("res://BridgeBlock.tscn")
	var bridge = bridge_scene.instantiate()
	bridge.global_position = $SacrificePosition.global_position
	get_parent().add_child(bridge)

	is_alive = false
	queue_free()
