extends KinematicBody2D

const velocity = Vector2(0,0)
const SPEED = 100

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		velocity.y = -SPEED
		$Sprite.play('walk')
	elif Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
		$Sprite.play('walk')
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$Sprite.play('walk')
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$Sprite.play('walk')
		$Sprite.flip_h = true
	else:
		$Sprite.play('idle')
	
	move_and_slide(velocity)
	
	velocity.x = lerp(velocity.x, 0, 0.2)
	velocity.y = lerp(velocity.y, 0, 0.2)
	
