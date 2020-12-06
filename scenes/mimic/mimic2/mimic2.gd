extends KinematicBody2D

var knockback = Vector2.ZERO
onready var stats = $stats

func _ready():
	pass
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 100*delta)
	knockback = move_and_slide(knockback)
#	if is_on_wall():
#		direction = direction * -1
#
#	velocity.y += 2 * direction
#
#	velocity = move_and_slide(velocity, Vector2.ZERO)

func _on_hurtbox_area_entered(area):
	knockback = area.knockback_vector * 100
	stats.health -= area.damage
	hit_effect()
	

func _on_stats_no_health():
	$Timer.start()
	$sprite.queue_free()
	$CollisionShape2D.queue_free()
	$hurtbox.queue_free()
	death_effect()


func _on_Timer_timeout():
	queue_free()

func death_effect():
	var scene = load("res://scenes/mimic/mimic2/dieEffect/mimic2DieEffect.tscn")
	var instance = scene.instance()
	var main = get_tree().current_scene
	instance.global_position = global_position
	main.add_child(instance)
	
func hit_effect():
	var scene = load("res://scenes/effects/hit/hitEffect.tscn")
	var instance = scene.instance()
	var main = get_tree().current_scene
	instance.global_position = global_position
	main.add_child(instance)
