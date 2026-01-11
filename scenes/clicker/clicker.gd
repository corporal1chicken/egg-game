extends Control

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var stats = PlayerData.stats

var auto_active: bool = false
var upgrades_open: bool = false

# Godot Specific Functions
func _ready():
	timer.timeout.connect(_on_timer_timeout)
	Signals.new_unlock.connect(_on_unlock)
	Signals.change_total_eggs.connect(_on_change_total_eggs)
	
	$auto_rate.text = "%.1f eggs / %.1fs" % [stats.eggs_per_auto, stats.auto_eggs_per_tick]
	
func _on_timer_timeout():
	if auto_active:
		PlayerData.increase_eggs(stats.eggs_per_auto)

# Button Press Functions
func _on_main_button_pressed():
	if auto_active:
		_disable_autoegg()
		
	if upgrades_open and PlayerData.settings.close_upgrade:
		upgrades_open = false
		_play_animation("open_upgrades", "backwards")
	
	PlayerData.increase_eggs(stats.eggs_per_click)

func _on_enable_auto_pressed():
	if auto_active:
		_disable_autoegg()
	else:
		_enable_autoegg()
		
func _on_open_upgrades_pressed():
	if upgrades_open:
		upgrades_open = false
		_play_animation("open_upgrades", "backwards")
	else:
		upgrades_open = true
		_play_animation("open_upgrades", "forwards")

# Helper Functions
func _enable_autoegg():
	auto_active = true
	timer.start(stats.auto_eggs_per_tick)
	ButtonStyles.change_style($enable_auto, "normal", "enabled")
	
func _disable_autoegg():
	auto_active = false
	timer.stop()
	ButtonStyles.change_style($enable_auto, "normal", "disabled")

func _on_change_total_eggs():
	var counter: String = str(stats.total_eggs)
	
	if PlayerData.settings.hide_decimals:
		if is_equal_approx(stats.total_eggs, round(stats.total_eggs)):
			counter = str(int(stats.total_eggs))
	
	$egg_counter.text = "eggs: %s" % [counter]
	
	var possible_upgrades: int = 0
	
	for child in $upgrades/VBoxContainer.get_children():
		if child.can_upgrade:
			possible_upgrades += 1
	
	if possible_upgrades != 0:
		$upgrades/possible_upgrades.visible = true
		$upgrades/possible_upgrades.text = "(%d)" % [possible_upgrades]
	else:
		$upgrades/possible_upgrades.visible = false

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
