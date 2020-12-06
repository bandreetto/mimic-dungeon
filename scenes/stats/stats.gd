extends Node2D

export var max_health = 3
onready var health = max_health

func take_damage(damage):
	if health > 0:
		health = health - damage
		print("health", health)
	
