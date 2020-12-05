extends KinematicBody2D

const velocity = Vector2(0,0)
const SPEED = 100

var animationPlayer = null

func _ready():
	animationPlayer = $AnimationPlayer
	

func _physics_process(delta):
	if Input.is_action_just_released("ui_select"):
		$Sprite/Swordhit/SwordCollision.set_deferred("disabled", true)
	if Input.is_action_pressed("ui_select"):
		animationPlayer.play("attack1")
	else:
		if Input.is_action_pressed("ui_up"):
			velocity.y = -SPEED
			animationPlayer.play('walk')
		elif Input.is_action_pressed("ui_down"):
			velocity.y = SPEED
			animationPlayer.play('walk')
		elif Input.is_action_pressed("ui_right"):
			velocity.x = SPEED
			animationPlayer.play('walk')
			$Sprite.scale.x = 1
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED
			animationPlayer.play('walk')
			$Sprite.scale.x = -1
		else:
			animationPlayer.play('idle')
		
		move_and_slide(velocity)
		
		velocity.x = lerp(velocity.x, 0, 0.2)
		velocity.y = lerp(velocity.y, 0, 0.2)
		
