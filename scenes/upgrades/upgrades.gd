extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var open: bool = false
var current_category: int = 1
var spacing: int = 5

# Godot Specific Functions
func _ready():
	for button in $categories.get_children():
		button.pressed.connect(_on_category_button.bind(int(button.name)))

	_change_holder()

# Button Functions
func _on_open_upgrades_pressed() -> void:
	if animation_player.is_playing(): return
	
	if open:
		open = false
		$AnimationPlayer.play_backwards("open")
	else:
		open = true
		$AnimationPlayer.play("open")
		
	$open_upgrades.release_focus()

func _on_category_button(category: int):
	if current_category == category: return
	
	current_category = category
	
	_change_holder()
			
# Helper Functions
func _change_holder():
	for upgrade in $holder.get_children():
		if upgrade.category == current_category:
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
