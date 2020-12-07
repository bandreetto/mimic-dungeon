extends YSort

onready var deathTimer = $Player/deathTimer

func _ready():
	pass

func _on_player_is_dead():
	deathTimer.start(5)

func _on_deathTimer_timeout():
	queue_free()
	get_tree().change_scene("res://scenes/menu/menu.tscn")
