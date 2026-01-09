extends Control

var unlocks: Dictionary = {
	"autoegg" = 20.0
}

var eggs: float = 0.0
var auto_active: bool = false

var auto_tick: float = 2.0
var auto_egg_amount: float = 0.5

var click_egg_amount: float = 1.0

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Godot Specific Functions
func _ready():
	timer.timeout.connect(_on_timer_timeout)
	
	$auto_rate.text = "%.1f eggs / %.1fs" % [auto_egg_amount, auto_tick]
	
func _on_timer_timeout():
	if auto_active:
		_give_egg(auto_egg_amount)

# Button Press Functions
func _on_main_button_pressed():
	if auto_active:
		_disable_autoegg()
	
	_give_egg(click_egg_amount)

func _on_enable_auto_pressed():
	if auto_active:
		_disable_autoegg()
	else:
		_enable_autoegg()

# Helper Functions
func _enable_autoegg():
	auto_active = true
	timer.start(auto_tick)
	ButtonStyles.change_style($enable_auto, "normal", "enabled")
	
func _disable_autoegg():
	auto_active = false
	timer.stop()
	ButtonStyles.change_style($enable_auto, "normal", "disabled")
	
func _check_unlock():
	for key in unlocks.keys():
		var egg_requirement = unlocks.get(key)
		
		if egg_requirement == eggs:
			if key == "autoegg":
				animation_player.play("unlocked_autoegg")

# Main Functions	
func _give_egg(egg_amount: float):
	eggs += egg_amount
	$egg_counter.text = "eggs: %.1f" % [eggs]
	
	_check_unlock()
