extends ColorRect

@export_category("Upgrade Bar")
@export var upgrade_name: String = "None Set"
@export var upgrade_path: Dictionary[int, Upgrade]
@export var upgrade_index: int = 0
@export var max_upgrades: int = 0
@export var path_completed: bool = false

var current_upgrade: Upgrade

# Built In Godot Functions
func _ready() -> void:
	current_upgrade = upgrade_path.get(upgrade_index)
	
	_update_upgrade_text()

# Button Functions
func _on_upgrade_mouse_entered() -> void:
	$upgrade/hover.visible = true

func _on_upgrade_mouse_exited() -> void:
	$upgrade/hover.visible = false

func _on_upgrade_pressed() -> void:
	if current_upgrade.cost <= PlayerData.stats.total_eggs:
		Signals.new_upgrade.emit(current_upgrade.change, current_upgrade.cost)
		
		_check_upgrade_path_completed()
	else:
		print("not enough eggs")

# Helper Functions
func _update_upgrade_text():
	$upgrade_name.text = upgrade_name
	$upgrade/hover.text = current_upgrade.description
	$upgrade.text = "%.1f eggs" % [current_upgrade.cost]

func _check_upgrade_path_completed():
	upgrade_index += 1
	
	if upgrade_index >= max_upgrades:
		queue_free()
	else:
		current_upgrade = upgrade_path.get(upgrade_index)
		_update_upgrade_text()
