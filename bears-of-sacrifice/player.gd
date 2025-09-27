extends CharacterBody2D

@export var speed: int = 200
@export var jump_force: int = -400
@export var gravity: int = 800

var is_alive: bool = true
var is_active: bool = false   # for multiple characters if needed

func _physics_process(delta):
	if not is_alive:
		return
	if not is_active:
		velocity = Vector2.ZERO
		return

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Horizontal movement
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		$JumpSound.play()

	move_and_slide()

	# Sacrifice action
	if Input.is_action_just_pressed("sacrifice"):
		do_sacrifice()

# Play sacrifice animation
func do_sacrifice():
	$AnimationPlayer.play("SacrificeFade")

# Called at the end of fade animation
func do_final_sacrifice():
	$SacrificeSound.play()

	# Spawn bridge block
	var bridge_scene = load("res://BridgeBlock.tscn")
	var bridge = bridge_scene.instantiate()
	bridge.global_position = $SacrificePosition.global_position
	get_parent().add_child(bridge)

	is_alive = false
	queue_free()
