extends Node

signal new_upgrade(info: Dictionary)
signal new_unlock(unlock: String)
signal change_total_eggs()
signal change_screen(old_screen: String, new_screen: String)

signal save_started(slot: int)
signal save_finished(slot: int, ok: bool)

signal load_finished()
