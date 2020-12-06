extends Control

var max_hearts = 5 setget set_max_hearts
var hearts = 5 setget set_hearts
onready var label = $Label
onready var heartUI = $HeartUI

func set_max_hearts(value):
	max_hearts = max(value, 1)
	
func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUI != null:
		heartUI.rect_size.x = hearts * 64
		
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health 
	PlayerStats.connect("health_changed", self, "set_hearts")

