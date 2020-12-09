extends YSort

onready var timer = $Player/resetTimer
var coins = 0 setget set_coins

func set_coins(value):
	pass
	
func _ready():
	PlayerStats.set_health(5)
	PlayerStats.collect_coins(0)
	PlayerStats.connect("coins_changed", self, "set_coins")

func _on_player_is_dead():
	timer.start(5)

func _on_resetTimer_timeout():
	queue_free()
	get_tree().change_scene("res://scenes/menu/menu.tscn")

func _on_boss_is_dead():
	timer.start(3)
