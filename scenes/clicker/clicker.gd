extends Control

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var stats = PlayerData.stats

var auto_active: bool = false
var upgrades_open: bool = false

var local_clicks: float = 0.0

# Godot Specific Functions
func _ready():
	timer.timeout.connect(_on_timer_timeout)
	Signals.new_unlock.connect(_on_unlock)
	Signals.change_total_eggs.connect(_on_change_total_eggs)

func _on_timer_timeout():
	if auto_active:
		PlayerData.increase_eggs("auto", stats.eggs_per_auto, [])

# Button Press Functions
func _on_main_button_pressed():
	local_clicks += 1
	PlayerData.increase_clicks()
	
	if auto_active:
		_disable_autoegg()
		
	if PlayerData.settings.close_upgrade:
		$upgrades.close_upgrade_setting_enabled()
	
	if local_clicks == PlayerData.stats.special_clicks:
		local_clicks = 0
		PlayerData.increase_eggs("click", stats.eggs_per_click, [PlayerData.stats.eggs_per_special])
	else:
		PlayerData.increase_eggs("click", stats.eggs_per_click, [])

func _on_enable_auto_pressed():
	if auto_active:
		_disable_autoegg()
	else:
		_enable_autoegg()
		
func _on_menu_pressed():
	Signals.change_screen.emit("clicker", "play_screen")

func _on_save_pressed():
	print("(menu button clicker) slot: ", str(SaveManager.current_slot))
	var success: bool = SaveManager.save_slot(SaveManager.current_slot)
	print("save:", success)

# Helper Functions
func _enable_autoegg():
	auto_active = true
	timer.start(stats.auto_eggs_rate)
	ButtonStyles.change_style($enable_auto, "normal", "enabled")
	
func _disable_autoegg():
	auto_active = false
	timer.stop()
	ButtonStyles.change_style($enable_auto, "normal", "disabled")

func _on_change_total_eggs():
	#var counter = stats.total_eggs
	
	#if PlayerData.settings.hide_decimals:
	#	if is_equal_approx(stats.total_eggs, round(stats.total_eggs)):
	#		counter = stats.total_eggs
	
	$egg_counter.text = "eggs: %.1f" % [stats.total_eggs]
	
func _play_animation(animation_name: String, direction: String):
	if animation_player.is_playing():
		await animation_player.animation_finished

	if direction == "forwards":
		animation_player.play(animation_name)
	else:
		animation_player.play_backwards(animation_name)

# Main Functions		
func _on_unlock(unlock: String):
	if unlock == "autoegg":
		_play_animation("unlocked_autoegg", "forwards")
