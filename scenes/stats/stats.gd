extends Node2D

export var max_health = 3
onready var health = max_health setget set_health 
var coins = 0

signal no_health
signal health_changed
signal coins_changed

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func collect_coins(value):
	coins += value
	emit_signal("coins_changed", coins)
