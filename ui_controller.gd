extends Control

func _ready() -> void:
	for child in $CanvasLayer/play_screen/VBoxContainer.get_children():
		child.pressed.connect(_on_option_pressed.bind(child.name))
	
func _on_option_pressed(option: String):
	match option:
		"play":
			$CanvasLayer/play_screen.visible = false
			$CanvasLayer/clicker.visible = true
			$CanvasLayer/back.visible = false
		"settings":
			$CanvasLayer/play_screen.visible = false
			$CanvasLayer/settings.visible = true
			$CanvasLayer/back.visible = true
		"quit":
			get_tree().quit()

func _on_back_pressed():
	$CanvasLayer/settings.visible = false
	$CanvasLayer/play_screen.visible = true
	$CanvasLayer/back.visible = false
