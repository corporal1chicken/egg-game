extends Control

var current_screen: String = "play_screen"

func _ready() -> void:
	for child in $CanvasLayer/play_screen/VBoxContainer.get_children():
		child.pressed.connect(_on_option_pressed.bind(child.name))
	
	Signals.change_screen.connect(_on_change_screen)
	
	$CanvasLayer/saving.visible = false

	Signals.save_started.connect(_on_save_started)
	Signals.save_finished.connect(_on_save_finished)
	
func _on_option_pressed(option: String):
	match option:
		"play":
			_on_change_screen("play_screen", "choose_slot")
		"settings":
			_on_change_screen("play_screen", "settings")
		"achievements":
			_on_change_screen("play_screen", "achievements")
		"quit":
			get_tree().quit()

func _on_change_screen(old_screen, new_screen):
	$CanvasLayer.get_node(old_screen).visible = false
	$CanvasLayer.get_node(new_screen).visible = true
	
	current_screen = new_screen
	
func _on_save_started(slot: int) -> void:
	$CanvasLayer/saving.visible = true
	$CanvasLayer/saving.text = "saving slot %d" % slot
	
func _on_save_finished(slot: int, ok: bool) -> void:
	$CanvasLayer/saving.text = "saving finished"

	$CanvasLayer/Timer.start()
	
func _on_timer_timeout() -> void:
	$CanvasLayer/saving.visible = false
