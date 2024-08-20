extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
	var grassEffect = GrassEffect.instantiate()
	get_parent().add_child(grassEffect) 
	grassEffect.global_position = global_position

func _on_hurt_box_area_entered(_area):
	var give_stamina = [0,0,0,0,0,1]
	give_stamina.shuffle()

	PlayerStats.give_stamina_current += 1
	if PlayerStats.give_stamina_current >= PlayerStats.give_stamina_rate:
		PlayerStats.max_stamina += 1
		PlayerStats.give_stamina_current = 0
	else:
		PlayerStats.max_stamina += give_stamina.pop_front()

	create_grass_effect()
	queue_free()
