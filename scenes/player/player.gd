extends KinematicBody2D

const velocity = Vector2(0,0)
const SPEED = 100

var animationPlayer = null
onready var swordHitbox = $Sprite/Swordhit

func _ready():
	animationPlayer = $AnimationPlayer
	swordHitbox.knockback_vector = Vector2.ZERO
	
func _physics_process(delta):
	if Input.is_action_just_released("ui_select"):
		$Sprite/Swordhit/SwordCollision.set_deferred("disabled", true)
	if Input.is_action_pressed("ui_select"):
		animationPlayer.play("attack1")
	else:
		if Input.is_action_pressed("ui_up"):
			velocity.y = -SPEED
			animationPlayer.play('walk')
			swordHitbox.knockback_vector = Vector2.UP
		elif Input.is_action_pressed("ui_down"):
			velocity.y = SPEED
			animationPlayer.play('walk')
			swordHitbox.knockback_vector = Vector2.DOWN
		elif Input.is_action_pressed("ui_right"):
			velocity.x = SPEED
			animationPlayer.play('walk')
			$Sprite.scale.x = 1
			swordHitbox.knockback_vector = Vector2.RIGHT
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED
			animationPlayer.play('walk')
			$Sprite.scale.x = -1
			swordHitbox.knockback_vector = Vector2.LEFT
		else:
			animationPlayer.play('idle')
		
		move_and_slide(velocity)
		
		velocity.x = lerp(velocity.x, 0, 0.2)
		velocity.y = lerp(velocity.y, 0, 0.2)
		
