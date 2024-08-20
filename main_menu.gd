extends Control


func _ready():
	$VBoxContainer/Start.grab_focus()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://world.tscn")


func _on_quit_pressed():
	get_tree().quit()
