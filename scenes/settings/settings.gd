extends Control

func _on_back_pressed() -> void:
	Signals.change_screen.emit("settings", "play_screen")
