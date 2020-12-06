extends KinematicBody2D

export var ACCELERATION = 200
export var MAXSPEED = 50
export var FRICTION = 100

const dieEffect = preload("res://scenes/mimic/mimic2/dieEffect/mimic2DieEffect.tscn")
const hitEffect = preload("res://scenes/effects/hit/hitEffect.tscn")
var knockback = Vector2.ZERO
onready var stats = $stats
onready var detection = $PlayerDetectionZone
onready var sprite = $sprite
onready var softCollision = $softCollision

enum {
	IDLE, WANDER, CHASE
}
var state = IDLE
var velocity = Vector2.ZERO

func _ready():
	pass
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 100*delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = detection.player
			if player != null:
				var move_direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(move_direction*MAXSPEED, ACCELERATION*delta)
			else:
				state = IDLE	
	
	if sprite != null:
		sprite.flip_h = velocity.x < 0
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func seek_player():
	if detection.can_see_player():
		state = CHASE

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
	var instance = dieEffect.instance()
	var main = get_tree().current_scene
	instance.global_position = global_position
	main.add_child(instance)
	
func hit_effect():
	var instance = hitEffect.instance()
	var main = get_tree().current_scene
	instance.global_position = global_position
	main.add_child(instance)
