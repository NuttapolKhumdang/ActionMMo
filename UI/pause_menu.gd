extends Control


func _on_continue_pressed():
	queue_free()


func _on_quit_pressed():
	get_tree().quit()
