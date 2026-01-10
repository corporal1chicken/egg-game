extends Node

var stats: Dictionary = {
	total_eggs = 0.0,
	eggs_per_click = 1.0,
	eggs_per_auto = 0.5,
	auto_eggs_per_tick = 2.0,
	click_multiplier = 1.0,
	
	autoegg_unlocked = false
}

var settings: Dictionary = {
	close_upgrade = false,
	hide_decimals = false
}

func _ready():
	Signals.new_upgrade.connect(_on_upgrade)
	
func increase_eggs(value: float):
	stats.total_eggs += (value * stats.click_multiplier)
	Signals.change_total_eggs.emit()
	
func decrease_eggs(value: float):
	stats.total_eggs -= value
	Signals.change_total_eggs.emit()

func _on_upgrade(change: Dictionary, cost: float):
	decrease_eggs(cost)

	match change.type:
		"stat_change":
			stats[change.stat] += change.amount
		"unlock":
			Signals.new_unlock.emit(change.gives)
			
			if change.gives == "autoegg":
				stats.autoegg_unlocked = true

func change_setting(setting: String, new_value):
	settings[setting] = new_value
