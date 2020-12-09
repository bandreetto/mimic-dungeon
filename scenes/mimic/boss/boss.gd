extends KinematicBody2D

export var ACCELERATION = 200
export var MAXSPEED = 50
export var FRICTION = 100

const dieEffect = preload("res://scenes/mimic/boss/dieEffect/bossDieEffect.tscn")
const hitEffect = preload("res://scenes/effects/hit/hitEffect.tscn")
const coin = preload("res://scenes/objects/coin/Coin.tscn")

onready var stats = $stats
onready var detection = $PlayerDetectionZone
onready var sprite = $sprite
onready var softCollision = $softCollision
onready var wanderController = $wanderController

enum {
	IDLE, WANDER, CHASE
}
var state = IDLE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var has_coin = false  setget set_has_coin

func _ready():
	stats.set_health(20)

func set_has_coin(value):
	has_coin = value
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 100*delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_timer(rand_range(1,3))
		WANDER:
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_timer(rand_range(1,3))
				
			var target_position = wanderController.target_position
			var move_direction = global_position.direction_to(target_position)
			velocity = velocity.move_toward(move_direction*MAXSPEED, ACCELERATION*delta)
		CHASE:
			var player = detection.player
			if player != null:
				var move_direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(move_direction*MAXSPEED, ACCELERATION*delta)
			else:
				state = IDLE	
	
	if sprite != null && weakref(sprite).get_ref():
		sprite.flip_h = velocity.x < 0
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func seek_player():
	if detection.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

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
	drop_coin()

func _on_Timer_timeout():
	queue_free()

func death_effect():
	var instance = dieEffect.instance()
	var main = get_tree().current_scene
	instance.global_position = global_position
	main.add_child(instance)
	
func drop_coin():
	if has_coin:
		var instance = coin.instance()
		var main = get_tree().current_scene
		instance.global_position = Vector2(rand_range(206, 306),rand_range(130,190))
		main.add_child(instance)
		
func hit_effect():
	var instance = hitEffect.instance()
	var main = get_tree().current_scene
	instance.global_position = global_position
	main.add_child(instance)
