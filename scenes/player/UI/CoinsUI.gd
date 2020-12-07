extends Control

onready var label = $Label
var coins = 0 setget set_coins

func set_coins(value):
	coins = value
	if label != null:
		label.text = "X "+str(coins)

func _ready():
	self.coins = PlayerStats.coins
	PlayerStats.connect("coins_changed", self, "set_coins")
