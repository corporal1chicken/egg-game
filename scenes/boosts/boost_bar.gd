extends ColorRect

@export_category("Boost Information")
@export var title: String = "None Set"
@export var description: String = "None Set"
@export var data_name: String = ""
@export var change_data: Dictionary = {
	type = "temporary",
	stat = "",
	value = "",
	change_type = ""
}

@onready var timer: Timer = $Timer

var on_cooldown: bool = false

enum Mode {COOLDOWN, BOOST}
var end_mode: Mode = Mode.COOLDOWN

var data: Dictionary

var open: bool = false

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	
	if PlayerData.boosts.has(data_name):
		data = PlayerData.boosts[data_name]
		_start_cooldown()
	else:
		print("no data found in PlayerData.boosts with the name %s" % [data_name])
		return
		
	$title.text = title
	$description.text = description

func _process(_delta: float) -> void:
	if timer.is_stopped(): return
	
	$cooldown.text = "%.1fs" % [timer.time_left]
	
func _on_activate_pressed():
	_start_boost()
	
func _on_upgrade_pressed():
	#$upgrades_screen.visible = not $upgrades_screen.visible
	print("to fix")
	
func _on_open_pressed():
	if open:
		_play_tween(self.position + Vector2(190, 0))
		open = false
	else:
		_play_tween(self.position + Vector2(-190, 0))
		open = true
		
func _play_tween(target_position: Vector2):
	var duration: float = 0.3
	var tween: Tween = create_tween()
	
	tween.tween_property(self, "position", target_position, duration)
	
func _on_timer_timeout():
	match end_mode:
		Mode.COOLDOWN:
			_end_cooldown()
		Mode.BOOST:
			_end_boost()
	
func _start_cooldown():
	$activate.disabled = true
	$activate.text = "cooldown"
	
	timer.start(data.cooldown)
	end_mode = Mode.COOLDOWN
	
func _end_cooldown():
	$activate.disabled = false
	$activate.text = "activate"
	$cooldown.text = "READY"
	end_mode = Mode.BOOST
	
func _start_boost():
	if PlayerData.state.boost_active:
		print("boost already active")
		return
	
	timer.start(data.length)
	
	$activate.disabled = true
	$activate.text = "in use"

	PlayerData.process_boost("start", change_data)
	
func _end_boost():
	PlayerData.process_boost("end", change_data)
	_start_cooldown()
