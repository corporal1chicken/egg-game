extends Control

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var stats = PlayerData.stats

var auto_active: bool = false

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
	
	PlayerData.increase_eggs(stats.eggs_per_click)

func _on_enable_auto_pressed():
	if auto_active:
		_disable_autoegg()
	else:
		_enable_autoegg()

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
	$egg_counter.text = "eggs: %.1f" % [stats.total_eggs]

# Main Functions		
func _on_unlock(unlock: String):
	if unlock == "autoegg":
		$AnimationPlayer.play("unlocked_autoegg")
