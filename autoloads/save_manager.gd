extends Node

const SAVE_FOLDER := "user://saves/"
const SAVE_FILE := "slot_%d.json"

var current_slot: int = 1

func _slot_path(slot: int) -> String:
	return SAVE_FOLDER + (SAVE_FILE % slot)

func collect_upgrade_bars():
	var saved_bars: Dictionary = {}
	
	for child in get_tree().get_nodes_in_group("upgrade_bars"):
		if child.save_id != "":
			saved_bars[child.save_id] = child.get_save_data()
			
	return saved_bars

func apply_upgrade_bars(data: Dictionary):
	for child in get_tree().get_nodes_in_group("upgrade_bars"):
		if child.save_id != "" and data.has(child.save_id):
			child.apply_save_data(data[child.save_id])

func save_slot(slot: int):
	if not DirAccess.dir_exists_absolute(SAVE_FOLDER):
		DirAccess.make_dir_recursive_absolute(SAVE_FILE)
		
	Signals.save_started.emit(slot)

	var data: Dictionary = {
		"version": 1,
		"stats": PlayerData.stats,
		"settings": PlayerData.settings,
		"boosts": PlayerData.boosts,
		"events": PlayerData.events,
		"upgrade_bars": collect_upgrade_bars(),
	}

	var file: FileAccess = FileAccess.open(_slot_path(slot), FileAccess.WRITE)

	file.store_string(JSON.stringify(data))
	file.close()
	
	Signals.save_finished.emit(slot, true)
	return true

func load_slot(slot: int):
	var path: String = SAVE_FOLDER + (SAVE_FILE % slot)

	var file: FileAccess = FileAccess.open(path, FileAccess.READ)

	var text: String = file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(text)

	var data: Dictionary = parsed as Dictionary

	var loaded_stats: Dictionary = data.get("stats", {}) as Dictionary
	var loaded_settings: Dictionary = data.get("settings", {}) as Dictionary
	var loaded_boosts: Dictionary = data.get("boosts", {}) as Dictionary
	var loaded_events: Dictionary = data.get("events", {}) as Dictionary

	PlayerData.apply_loaded_info(PlayerData.stats, loaded_stats)
	PlayerData.apply_loaded_info(PlayerData.settings, loaded_settings)
	PlayerData.apply_loaded_info(PlayerData.boosts, loaded_boosts)
	PlayerData.apply_loaded_info(PlayerData.events, loaded_events)

	apply_upgrade_bars(data.get("upgrade_bars", {}) as Dictionary)
	
	Signals.change_total_eggs.emit()
	current_slot = slot
	
	Signals.load_finished.emit()
	
	return true

func _notification(event: int) -> void:
	if event == NOTIFICATION_WM_CLOSE_REQUEST:
		save_slot(current_slot)
