extends YSort

onready var timer = $Player/resetTimer

func _ready():
	PlayerStats.set_health(5)

func _on_player_is_dead():
	timer.start(5)


func _on_resetTimer_timeout():
	get_tree().change_scene("res://scenes/menu/menu.tscn")

