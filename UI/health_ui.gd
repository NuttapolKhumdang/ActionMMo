extends Control

@onready var progressBar = $ProgressBar
@onready var text = $Label
@onready var update = $Update
@onready var timer = $Timer

var heart = 4:
	get:
		return heart
	set(value):
		if (value - heart) > 0:
			update.text = "+" + str(value - heart)
		elif (value - heart) < 0:
			update.text = str(value - heart)
		timer.start(1)

		heart = clamp(value, 0, max_heart)
		text.text = str(heart) + '/' + str(max_heart)
		progressBar.value = heart

var max_heart = 4:
	set(value):
		if (value - max_heart) > 0:
			update.text = "MAX +" + str(value - max_heart)
			timer.start(1)

		max_heart = max(value, 1)
		progressBar.max_value = max_heart

func _ready():
	self.max_heart = PlayerStats.max_health
	self.heart = PlayerStats.health

	PlayerStats.connect("health_change", set_heart)
	PlayerStats.connect("max_health_change", set_max_heart)
	
func set_heart(value):
	heart = value

func set_max_heart(value):
	max_heart = value


func _on_timer_timeout():
	update.text = ""
