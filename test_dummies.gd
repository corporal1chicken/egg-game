extends Control

func _on_save1_pressed() -> void:
	var ok: bool = SaveManager.save_slot(1)
	print("save1:", ok)

func _on_load1_pressed() -> void:
	var ok: bool = SaveManager.load_slot(1)
	print("load1:", ok)

func _on_save2_pressed() -> void:
	var ok: bool = SaveManager.save_slot(2)
	print("save2:", ok)

func _on_load2_pressed() -> void:
	var ok: bool = SaveManager.load_slot(2)
	print("load2:", ok)
