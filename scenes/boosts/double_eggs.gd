extends ColorRect

@export var cooldown_length: float = 30.0
@export var boost_length: float = 10.0

@onready var timer: Timer = $Timer

var on_cooldown: bool = false

enum Mode {COOLDOWN, BOOST}
var end_mode: Mode = Mode.COOLDOWN

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	
	_start_cooldown()

func _process(delta: float) -> void:
	if timer.is_stopped(): return
	
	$cooldown.text = "%.1fs" % [timer.time_left]
	
func _on_activate_pressed():
	_start_boost()
	
func _on_timer_timeout():
	match end_mode:
		Mode.COOLDOWN:
			_end_cooldown()
		Mode.BOOST:
			_end_boost()
	
func _start_cooldown():
	$activate.disabled = true
	$activate.text = "unavilable"
	
	timer.start(cooldown_length)
	end_mode = Mode.COOLDOWN
	
func _end_cooldown():
	$activate.disabled = false
	$activate.text = "activate"
	end_mode = Mode.BOOST
	
func _start_boost():
	timer.start(boost_length)
	$activate.disabled = true
	$activate.text = "unavilable"
	PlayerData.change_stats("multiplier", 2.0)
	
func _end_boost():
	PlayerData.change_stats("multiplier", -1.0)
	_start_cooldown()
