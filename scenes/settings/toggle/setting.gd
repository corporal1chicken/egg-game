extends ColorRect

@export_category("Setting")
@export var title: String = "None Set"
@export var description: String = "None Set"
@export var setting_name: String = ""
@export var state: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	$title.text = title
	$description.text = description

func _on_toggle_pressed():
	state = not state
	$ColorRect/toggle.release_focus()
	
	PlayerData.change_setting(setting_name, state)

	if state:
		animation_player.play("enabled")
		$ColorRect/toggle.text = "ON"
	else:
		animation_player.play("disabled")
		$ColorRect/toggle.text = "OFF"
