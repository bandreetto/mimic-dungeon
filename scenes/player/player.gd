extends KinematicBody2D

const dieEffect = preload("res://scenes/player/deathEffect/playerDeathEffect.tscn")
const velocity = Vector2(0,0)
const SPEED = 100

var animationPlayer = null

onready var swordHitbox = $Sprite/Swordhit
onready var hurtBox = $hurtbox
onready var stats = PlayerStats
onready var menuTimer = $menuTimer

signal is_dead
signal collected_coin

func _ready():
	stats.connect("no_health", self, "on_death_called")
	animationPlayer = $AnimationPlayer
	swordHitbox.knockback_vector = Vector2.ZERO
	
func _physics_process(delta):
	reset_collisions()

	if process_attacks():
		if Input.is_action_pressed("ui_select"):
			animationPlayer.play("attack1")
		if Input.is_action_pressed("attack2"):
			animationPlayer.play("attack2")
		if Input.is_action_pressed("attack3"):
			animationPlayer.play("attack3")
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

func on_death_called():
	death_effect()
	emit_signal("is_dead")
	PlayerStats.clear_coins()
	queue_free()

func death_effect():
	var instance = dieEffect.instance()
	var main = get_tree().current_scene
	instance.global_position = (global_position + Vector2(5,5))
	main.add_child(instance)

func process_attacks():
	if Input.is_action_pressed("ui_select") or Input.is_action_pressed("attack2") or Input.is_action_pressed("attack3"):
		return true
	return false

func reset_collisions():
	if Input.is_action_just_released("ui_select") or Input.is_action_just_released("attack2") or Input.is_action_just_released("attack3"):
		$Sprite/Swordhit/attack1.set_deferred("disabled", true)
		$Sprite/Swordhit/attack2.set_deferred("disabled", true)
		$Sprite/Swordhit/attack3.set_deferred("disabled", true)
				
func _on_hurtbox_area_entered(area):
	stats.health -= 1
	hurtBox.start_invincibility(1)
	hurtBox.create_hit_effect()
