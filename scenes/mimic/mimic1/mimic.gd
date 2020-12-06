extends KinematicBody2D

export var direction = 1
var velocity = Vector2()
var hitten = false
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
	
func _on_stats_no_health():
	queue_free()
