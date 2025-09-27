extends CharacterBody2D

# --- VARIABLES ---
@export var speed: int = 200
@export var jump_force: int = -400
@export var gravity: int = 800

var is_alive: bool = true
var is_active: bool = false

# --- PHYSICS ---
func _physics_process(delta):
	if not is_alive or not is_active:
		velocity = Vector2.ZERO
		return

	var input_dir = Input.get_axis("move_left", "move_right")
	velocity.x = input_dir * speed

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
			$JumpSound.play()

	move_and_slide()

# --- INPUT ---
func _input(event):
	if event.is_action_pressed("sacrifice") and is_alive and is_active:
		do_sacrifice()

# --- SACRIFICE ---
func do_sacrifice():
	$AnimationPlayer.play("SacrificeFade")  # fade animation calls do_final_sacrifice() at end

func do_final_sacrifice():
	# Play sound
	$SacrificeSound.play()

	# Spawn particle effect
	var effect_scene = load("res://BridgeEffect.tscn")
	var effect = effect_scene.instantiate()
	effect.global_position = global_position
	get_parent().add_child(effect)

	# Spawn bridge block
	var bridge_scene = load("res://BridgeBlock.tscn")
	var bridge = bridge_scene.instantiate()
	bridge.global_position = $SacrificePosition.global_position
	get_parent().add_child(bridge)

	# Remove player
	is_alive = false
	queue_free()
