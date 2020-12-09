extends Area2D

onready var sound = $AudioStreamPlayer
onready var timer = $Timer
onready var sprite = $AnimatedSprite
onready var collision = $CollisionShape2D

func _ready():
	pass


func _on_Coin_body_entered(body):
	PlayerStats.collect_coins(1)
	sound.play()
	if weakref(sprite).get_ref(): 
		collision.queue_free()
		sprite.queue_free()
	timer.start(1)

func _on_Timer_timeout():
	queue_free()
