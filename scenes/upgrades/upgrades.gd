extends ColorRect

var open: bool = false
var current_category: Button
var spacing: int = 5

# Godot Specific Functions
func _ready():
	for button in $categories.get_children():
		button.pressed.connect(_on_category_button.bind(button))
		
	current_category = 	$categories/clicker
	
	_change_holder()

# Button Functions
func _on_open_upgrades_pressed() -> void:
	if open:
		_play_tween(self.position + Vector2(0, 190))
		open = false
	else:
		_play_tween(self.position + Vector2(0, -190))
		open = true
		
	$open_upgrades.release_focus()

func _play_tween(target_position: Vector2):
	var duration: float = 0.3
	var tween: Tween = create_tween()
	
	tween.tween_property(self, "position", target_position, duration)

func _on_category_button(button: Button):
	if current_category == button: return
	
	current_category.text = current_category.name
	current_category = button
	button.text = "[>] %s" % button.name
	
	button.release_focus()
	_change_holder()
			
# Helper Functions
func _change_holder():
	for upgrade in $holder.get_children():
		if upgrade.category == current_category.name:
			upgrade.visible = true
		else:
			upgrade.visible = false

	_rearrange_children()

func _rearrange_children():
	var current_y: int = 0
	
	for upgrade in $holder.get_children():
		if not upgrade.visible: continue
		
		upgrade.position.y = current_y
		current_y += upgrade.size.y + spacing

func close_upgrade_setting_enabled():
	if open:
		_on_open_upgrades_pressed()
		
