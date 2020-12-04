extends KinematicBody2D

var velocity = Vector2()
export var isMimic = false
var hitten = false
export var direction = 1

func _ready():
	pass
	
func _physics_process(delta):
	$sprite.play('idle')
	
	if isMimic and hitten:
		$sprite.play('attack')
		if is_on_wall():
			direction = direction * -1
			
		velocity.y += 2 * direction
		
		velocity = move_and_slide(velocity, Vector2.ZERO)
