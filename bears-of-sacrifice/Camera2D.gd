extends Camera2D

var shake_strength = 0.0

func apply_shake(amount: float):
	shake_strength = amount

func _process(delta):
	if shake_strength > 0:
		offset = Vector2(randf_range(-shake_strength, shake_strength),
						 randf_range(-shake_strength, shake_strength))
		shake_strength = lerp(shake_strength, 0, delta * 5)
	else:
		offset = Vector2.ZERO

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
