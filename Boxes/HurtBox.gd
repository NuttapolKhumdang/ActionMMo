extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")
signal invencible_started
signal invencible_ended

@onready var timer = $Timer
@onready var collsionShape = $CollisionShape2D

var invencible = false:
	get:
		return invencible
	set(value):
		invencible = value
		
		if invencible:
			emit_signal("invencible_started")
		else:
			emit_signal("invencible_ended")
		
func start_invencibility(duration):
#	invencible = true
	self.invencible = true
	timer.start(duration)
	
	
func create_hit_effect():
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_timer_timeout():
	self.invencible = false

func _on_invencible_started():
	collsionShape.set_deferred("disabled", true)

func _on_invencible_ended():
	collsionShape.disabled = false
