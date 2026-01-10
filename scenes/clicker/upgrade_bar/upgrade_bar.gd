extends ColorRect

@export_category("Upgrade Bar")
@export var upgrade_name: String = "None Set"
@export var upgrade_path: Dictionary[int, Upgrade]
@export var upgrade_index: int = 0
@export var max_upgrades: int = 0
@export var path_completed: bool = false
@export var path: Dictionary = {
	unlocked = false,
	cost = 0.0,
	text = "None Set",
	type = ""
}

var can_upgrade: bool = false
var current_upgrade: Upgrade

# Built In Godot Functions
func _ready() -> void:
	Signals.new_unlock.connect(_check_dependency)
	Signals.change_total_eggs.connect(_on_change_total_eggs)
	
	current_upgrade = upgrade_path.get(upgrade_index)
	max_upgrades = upgrade_path.keys().size()
	
	_update_upgrade_text()
	
	if not path.unlocked:
		if path.type == "dependency":
			$status.visible = true
			$path_level.visible = false
		else:
			$purchase/unlock.text = path.text
			$purchase.visible = true
			$path_level.visible = false
			
# Button Functions
func _on_upgrade_mouse_entered() -> void:
	$upgrade/hover.visible = true

func _on_upgrade_mouse_exited() -> void:
	$upgrade/hover.visible = false

func _on_unlock_pressed() -> void:
	if PlayerData.stats.total_eggs >= path.cost:
		_unlock_path()
	else:
		print("not enough eggs for path")

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
	$path_level.text = "(%d/%d)" % [upgrade_index, max_upgrades]

func _check_upgrade_path_completed():
	upgrade_index += 1
	
	if upgrade_index >= max_upgrades:
		$status.visible = true
		$status.color = Color.GREEN
		$status.color.a = 0.5
		$path_level.visible = false
		$status/label.text = "Path Completed!"
	else:
		current_upgrade = upgrade_path.get(upgrade_index)
		_update_upgrade_text()
		
func _unlock_path():
	path.unlocked = true
	$status.visible = false
	$purchase.visible = false
	$path_level.visible = true
	
	if path.cost != -1.0:
		PlayerData.decrease_eggs(path.cost)

func _check_dependency(unlock: String):
	if path.type == "dependency":
		if unlock == path.needs:
			_unlock_path()

func _on_change_total_eggs():
	if not path.unlocked: return
	
	if current_upgrade.cost <= PlayerData.stats.total_eggs:
		can_upgrade = true
		$path_level.add_theme_color_override("default_color", Color.GREEN)
	else:
		can_upgrade = false
		$path_level.add_theme_color_override("default_color", Color.WHITE)
