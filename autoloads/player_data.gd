extends Node

var stats: Dictionary = {
	total_eggs = 0.0,
	lifetime_eggs = 0.0,
	
	eggs_per_click = 1.0,
	click_multiplier = 1.0,
	
	eggs_per_auto = 0.5,
	auto_eggs_rate = 2.0,
	auto_multiplier = 1.0,
	
	total_multiplier = 1.0,
	
	double_egg_cooldown = 30.0,
	double_egg_length = 10.0,
	
	autoegg_unlocked = false
}

var settings: Dictionary = {
	close_upgrade = false,
	hide_decimals = false
}

func _ready():
	Signals.new_upgrade.connect(_on_upgrade)
	
func increase_eggs(gain_type: String, value: float):
	var amount_to_add: float = 0.0
	
	match gain_type:
		"click":
			amount_to_add = (value * stats.click_multiplier)
		"auto":
			amount_to_add = (value * stats.auto_multiplier)
	
	stats.total_eggs += (amount_to_add * stats.total_multiplier)
	stats.lifetime_eggs += amount_to_add * stats.total_multiplier
	Signals.change_total_eggs.emit()
	
	if stats.lifetime_eggs >= 100.0:
		Signals.new_unlock.emit("lifetime_eggs_100")
	
func decrease_eggs(value: float):
	stats.total_eggs -= value
	Signals.change_total_eggs.emit()

func _on_upgrade(change: Dictionary, cost: float):
	decrease_eggs(cost)

	match change.type:
		"stat_change":
			change_stats(change.stat, change.amount)
		"unlock":
			Signals.new_unlock.emit(change.gives)
			
			if change.gives == "autoegg":
				stats.autoegg_unlocked = true

func change_setting(setting: String, new_value):
	settings[setting] = new_value

func change_stats(stat_name, amount):
	stats[stat_name] += amount
