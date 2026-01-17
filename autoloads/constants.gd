extends Node

const STATS: Dictionary = {
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

const BOOSTS = {
	double_egg = {
		cooldown = 5.0,
		length = 7.0
	},
	special_clicks = {
		cooldown = 5.0,
		length = 5.0
	}
}

const EVENTS: Dictionary = {
	"lifetime_eggs" = [10.0, 20.0, 50.0]
}
