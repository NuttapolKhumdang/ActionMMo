extends Node

signal die
signal health_change(value)
signal max_health_change(value)

signal stamina_change(value)
signal max_stamina_change(value)

signal exp_change(value)

@export var max_health: int = 1:
	set(value):
		max_health = value
		emit_signal("max_health_change", max_health)

@export var max_stamina: int = 2:
	set(value):
		max_stamina = value
		emit_signal("max_stamina_change", max_stamina)

@export var EXP = 0:
	set(value):
		if value >= 10:
			self.max_health += 1
			EXP = 0
		else:
			EXP = value
		emit_signal("exp_change", EXP)

@export var give_stamina_rate: int = 6
@onready var give_stamina_current: int = give_stamina_rate

@onready var health = max_health:
	set(value):
		health = min(value, max_health)
		emit_signal("health_change", health)

		if health <= 0:
			emit_signal("die")

@onready var stamina = max_stamina:
	set(value):
		stamina = clamp(value, 0, max_stamina)
		emit_signal("stamina_change", stamina)

func _on_timer_timeout():
	stamina += 1
