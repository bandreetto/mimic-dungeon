extends Area2D

onready var timer = $Timer
onready var collision = $CollisionShape2D
const hitEffect = preload("res://scenes/effects/hit/hitEffect.tscn")
var invincible = false setget set_invincible
signal invincibility_started
signal invincibility_ended

func create_hit_effect():
	var effect = hitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	print("invincibility started")
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invincible = false

func _on_hurtbox_invincibility_ended():
	collision.set_deferred("disabled", false)

func _on_hurtbox_invincibility_started():
	collision.set_deferred("disabled", true)

