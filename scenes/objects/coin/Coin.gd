extends Area2D

func _ready():
	pass


func _on_Coin_body_entered(body):
	PlayerStats.collect_coins(1)
	queue_free()
