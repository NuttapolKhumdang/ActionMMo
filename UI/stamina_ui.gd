extends Control

@onready var progressBar = $ProgressBar
@onready var label = $Label
@onready var update = $Update
@onready var timer = $Timer

var stamina = 2:
	set(value):
		if (value - max_stamina) > 0:
			update.text = "+" + str(value - stamina)
		elif (value - max_stamina) < 0:
			update.text = str(value - stamina)
		timer.start(1)

		stamina = value
		progressBar.value = value
		label.text = str(value) + '/' + str(max_stamina)


var max_stamina = 2:
	set(value):
		if (value - max_stamina) > 0:
			update.text = "MAX +" + str(value - max_stamina)
			timer.start(1)

		max_stamina = value
		progressBar.max_value = max_stamina
		PlayerStats.stamina += 1

func _ready():
	self.stamina = PlayerStats.stamina
	self.max_stamina = PlayerStats.max_stamina
	
	PlayerStats.connect("stamina_change", set_stamina)
	PlayerStats.connect("max_stamina_change", set_max_stamina)

func set_stamina(value):
	stamina = value
	
func set_max_stamina(value):
	max_stamina = value

func _on_timer_timeout():
	update.text = ""
