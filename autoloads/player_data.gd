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
		cooldown = 25.0,
		length = 7.0
	},
	special_clicks = {
		cooldown = 45.0,
		length = 5.0
	}
}

var original_values: Dictionary = {}

func _ready():
	Signals.new_upgrade.connect(_on_upgrade)
	
func increase_eggs(gain_type: String, value: float, args: Array):
	var amount_to_add: float = 0.0
	
	match gain_type:
		"click":
			amount_to_add = (value * stats.click_multiplier)
			
			if args[0]:
				amount_to_add += 5.0
						
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

func temporary_stat_change(change_data: Dictionary):
	original_values[change_data.stat] = stats[change_data.stat]
	
	if change_data.change_type == "replace":
		stats[change_data.stat] = float(change_data.value)
	elif change_data.change_type == "addition":
		stats[change_data.stat] += float(change_data.value)
	elif change_data.change_type == "multiply":
		stats[change_data.stat] *= float(change_data.value)
	
func revert_stat_change(change_data: Dictionary):
	if not original_values.has(change_data.stat):
		print("no stat found: %s" % [change_data.stat])
		return

	stats[change_data.stat] = original_values[change_data.stat]
	
func permenant_stat_change(change_data: Dictionary):
	stats[change_data.stat] += change_data.value
	
func change_stat(change_data: Dictionary):
	match change_data.type:
		"permenant":
			permenant_stat_change(change_data)
		"temporary":
			temporary_stat_change(change_data)
