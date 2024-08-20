extends Control

@onready var progressBar = $ProgressBar
@onready var text = $Label
@onready var update = $Update
@onready var timer = $Timer

var exp = 0:
	set(value):
		if (value - exp) > 0:
			update.text = "+" + str(value - exp)
			timer.start(1)

		exp = value
		text.text = str(exp) + '/' + str(progressBar.max_value)
		progressBar.value = exp

func _ready():
	progressBar.max_value = 10
	self.exp = PlayerStats.EXP

	PlayerStats.connect("exp_change", set_exp)
	
func set_exp(value):
	exp = value


func _on_timer_timeout():
	update.text = ""
