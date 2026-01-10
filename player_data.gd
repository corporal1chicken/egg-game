extends Node

var stats: Dictionary = {
	total_eggs = 0.0,
	eggs_per_click = 1.0,
	eggs_per_auto = 0.5,
	auto_eggs_per_tick = 2.0,
	
	autoegg_unlocked = false
}

func _ready():
	Signals.new_upgrade.connect(_on_upgrade)
	
func increase_eggs(value: float):
	stats.total_eggs += value
	Signals.change_total_eggs.emit()

func _on_upgrade(change: Dictionary, cost: float):
	stats.total_eggs -= cost
	Signals.change_total_eggs.emit()
	
	match change.type:
		"stat_change":
			stats[change.stat] += change.amount
		"unlock":
			Signals.new_unlock.emit(change.gives)
			
			if change.gives == "autoegg":
				stats.autoegg_unlocked = true
