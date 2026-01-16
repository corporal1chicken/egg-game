extends Control

func _on_back_pressed() -> void:
	Signals.change_screen.emit("choose_slot", "play_screen")

func _disable_buttons(state: bool):
	for child in $saves.get_children():
		child.disabled = state
		
	$back.disabled = state

func _on_save_1_pressed() -> void:
	_disable_buttons(true)
	$saves/save_1.release_focus()
	$loading_text.visible = true
	$Timer.start(3.0)
	await $Timer.timeout
	
	var success: bool = SaveManager.load_slot(1)
	print("load1:", success)
	Signals.change_screen.emit("choose_slot", "clicker")
	_disable_buttons(false)
	$loading_text.visible = false
	
func _on_save_2_pressed() -> void:
	_disable_buttons(true)
	$saves/save_2.release_focus()
	$loading_text.visible = true
	
	$Timer.start(3.0)
	await $Timer.timeout
	
	var success: bool = SaveManager.load_slot(2)
	print("load2:", success)
	Signals.change_screen.emit("choose_slot", "clicker")
	_disable_buttons(false)
	$loading_text.visible = false
