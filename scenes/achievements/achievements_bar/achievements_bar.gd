extends ColorRect

@export_category("Achievement Bar")
@export var title: String = "None Set"
@export var description: String = "None Set"
@export var reward: Dictionary = {
	key = "",
	text = ""
}
@export var stat_name: String = ""
@export var tiers: Array[float]
@export var tracking: bool = true
@export var current_tier: int = 0

# Godot Specific Functions
func _ready():
	if stat_name == "":
		print("%s has no stat name set" % [title])
		return
	elif not PlayerData.stats.has(stat_name):
		print("%s is not a stat found in PlayerData" % [stat_name])
		return
	
	Signals.change_total_eggs.connect(_on_stat_change)
	
	$title.text = title
	$description.text = description
	$tier.text = "(%d/%d)" % [current_tier, tiers.size()]
	$reward.text = reward.text
	
	_update_progress_text()

# Helper Functions
func _update_progress_text():
	$progress.text = "%.1f/%d" % [PlayerData.stats[stat_name], tiers[current_tier]]

func _on_stat_change():	
	if not tracking: 
		return
	
	_update_progress_text()
	
	if PlayerData.stats[stat_name] >= tiers[current_tier]:
		_tier_completed()
	
func _tier_completed():
	current_tier += 1
	$tier.text = "(%d/%d)" % [current_tier, tiers.size()]
	
	if current_tier >= tiers.size():
		_all_tiers_complete()
		tracking = false
	
func _all_tiers_complete():
	PlayerData.process_achievement(reward)
	Signals.change_total_eggs.disconnect(_on_stat_change)
	
	$status.visible = true
	$status.color = Color.GREEN
	$status.color.a = 0.5
	$title.text = "[✓] %s" % [title]
