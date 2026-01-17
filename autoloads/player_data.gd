extends Node

var stats: Dictionary = {
	total_eggs = 0.0,
	lifetime_eggs = 0.0,
	lifetime_clicks = 0.0,
	
	eggs_per_click = 1.0,
	special_clicks = 10.0,
	click_multiplier = 1.0,
	
	eggs_per_special = 5.0,
	
	eggs_per_auto = 0.5,
	auto_eggs_rate = 2.0,
	auto_multiplier = 1.0,
	
	total_multiplier = 1.0,
	
	autoegg_unlocked = false
}

var settings: Dictionary = {
	close_upgrade = false,
	hide_decimals = false
}

var boosts = {
	double_egg = {
		cooldown = 5.0,
		length = 7.0
	},
	special_clicks = {
		cooldown = 5.0,
		length = 5.0
	}
}

var events: Dictionary = {
	"lifetime_eggs" = [10.0, 20.0, 50.0]
}

var state: Dictionary = {
	boost_active = false
}

var original_values: Dictionary = {}

var passive_egg_timer: Timer

func _ready():
	passive_egg_timer = Timer.new()
	passive_egg_timer.wait_time = 1.0
	passive_egg_timer.one_shot = false
	passive_egg_timer.autostart = false
	add_child(passive_egg_timer)
	
	passive_egg_timer.timeout.connect(_on_passive_eggs)
	
func increase_eggs(gain_type: String, value: float, extra: Array):
	var amount_to_add: float = 0.0
	
	match gain_type:
		"click":
			amount_to_add = (value * stats.click_multiplier)						
		"auto":
			amount_to_add = (value * stats.auto_multiplier)
		"passive":
			amount_to_add += value
	
	for key in extra:
		amount_to_add += key
	
	amount_to_add *= stats.total_multiplier
	
	stats.total_eggs += amount_to_add
	stats.lifetime_eggs += amount_to_add
	Signals.change_total_eggs.emit()
		
	_check_event()

func _check_event():
	for key in events.keys():
		for value in events[key]:
			if value <= stats[key]:
				Signals.new_unlock.emit(key + "_" + str(value))
				events[key].erase(value)
				break

func decrease_eggs(value: float):
	stats.total_eggs -= value
	Signals.change_total_eggs.emit()

func change_setting(setting: String, new_value):
	settings[setting] = new_value

func _on_passive_eggs():
	increase_eggs("passive", 0.1, [])

func process_boost(action: String, change: Dictionary):
	if action == "start":
		state.boost_active = true
		
		original_values[change.stat] = stats[change.stat]
		_change_stat(change)
	
	if action == "end":
		state.boost_active = false
		
		if not original_values.has(change.stat):
			print("no stat found: %s" % [change.stat])
			return

		stats[change.stat] = original_values[change.stat]

	pass

func process_upgrade(change: Dictionary, cost: float):
	decrease_eggs(cost)
	
	if change.type == "stat_change":
		_change_stat(change)
		
	if change.type == "unlock":
		Signals.new_unlock.emit(change.gives)
			
		if change.gives == "autoegg":
			stats.autoegg_unlocked = true

	
func process_achievement(change: Dictionary):
	if change.key == "passive_egg_unlock":
		passive_egg_timer.start(1)
	
func _change_stat(change: Dictionary):
	match change.change_type:
		"replace":
			stats[change.stat] = float(change.value)
		"addition":
			stats[change.stat] += float(change.value)
		"multiply":
			stats[change.stat] *= float(change.value)
		"subtract":
			stats[change.stat] -= float(change.value)

func increase_clicks():
	stats.lifetime_clicks += 1.0

func apply_loaded_info(target: Dictionary, loaded: Dictionary):
	for key in loaded.keys():
		target[key] = loaded[key]

func reset_progress():
	apply_loaded_info(stats, Constants.STATS)
	apply_loaded_info(boosts, Constants.BOOSTS)
	apply_loaded_info(events, Constants.EVENTS)
	
	Signals.change_total_eggs.emit()
