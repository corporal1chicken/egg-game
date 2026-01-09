extends Node

var themes: Dictionary = {
	enabled = preload("res://resources/buttons/enabled.tres"),
	disabled = preload("res://resources/buttons/disabled.tres")
}

func change_style(button: Button, type: String, theme: String):
	if not themes.get(theme):
		push_warning("No button theme found. Theme change requested from %s, with theme %s (type: %s)" % [button.name, theme, type])
		return
		
	button.add_theme_stylebox_override(type, themes.get(theme))
