extends KinematicBody2D

const dieEffect = preload("res://scenes/player/deathEffect/playerDeathEffect.tscn")
const velocity = Vector2(0,0)
const SPEED = 100

enum PlayerStates {
	idle
	attack1
	attack2
	attack3
	moving
}

var animationPlayer = null
var playerState = PlayerStates.idle

const attack1Cooldown = 1
var attack1Timer = 0

const attack2Cooldown = 1
var attack2Timer = 0

const attack3Cooldown = 1
var attack3Timer = 0

const attackFollowupDelta = 1.5

onready var swordHitbox = $Sprite/Swordhit
onready var hurtBox = $hurtbox
onready var stats = PlayerStats
onready var menuTimer = $menuTimer
onready var attack1 = $Sprite/Swordhit/attack1
onready var attack2 = $Sprite/Swordhit/attack2
onready var attack3 = $Sprite/Swordhit/attack3

signal is_dead
signal collected_coin

func _ready():
	stats.connect("no_health", self, "on_death_called")
	animationPlayer = $AnimationPlayer
	swordHitbox.knockback_vector = Vector2.ZERO
	
func _physics_process(delta):
	reset_collisions()
	attack1Timer += delta
	attack2Timer += delta
	attack3Timer += delta
	if process_attacks():
		if Input.is_action_just_pressed("attack1") and attack1Timer > attack1Cooldown:
			playerState = PlayerStates.attack1
		if Input.is_action_just_pressed("attack2") and attack2Timer > attack2Cooldown:
			playerState = PlayerStates.attack2
		if Input.is_action_just_pressed("attack3") and attack3Timer > attack3Cooldown:
			playerState = PlayerStates.attack3
	elif process_movements():
		playerState = PlayerStates.moving
		if Input.is_action_pressed("ui_up"):
			velocity.y = -SPEED
			swordHitbox.knockback_vector = Vector2.UP
		if Input.is_action_pressed("ui_down"):
			velocity.y = SPEED
			swordHitbox.knockback_vector = Vector2.DOWN
		if Input.is_action_pressed("ui_right"):
			velocity.x = SPEED
			$Sprite.scale.x = 1
			swordHitbox.knockback_vector = Vector2.RIGHT
		if Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED
			$Sprite.scale.x = -1
			swordHitbox.knockback_vector = Vector2.LEFT
	else:
		playerState = PlayerStates.idle
		
	move_and_slide(velocity)
	processPlayerState()
	
	velocity.x = lerp(velocity.x, 0, 0.2)
	velocity.y = lerp(velocity.y, 0, 0.2)

func processPlayerState():
	match playerState:
		PlayerStates.idle:
			if animationPlayer.current_animation.begins_with('attack') and animationPlayer.is_playing():
				return
			animationPlayer.play('idle')
		PlayerStates.moving:
			if animationPlayer.current_animation.begins_with('attack') and animationPlayer.is_playing():
				return
			animationPlayer.play('walk')
		PlayerStates.attack1:
			attack1Timer = 0
			animationPlayer.play('attack1')
		PlayerStates.attack2:
			attack2Timer = 0
			animationPlayer.play('attack2')
		PlayerStates.attack3:
			attack3Timer = 0
			animationPlayer.play('attack3')

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
	if Input.is_action_just_pressed("attack1") or Input.is_action_just_pressed("attack2") or Input.is_action_just_pressed("attack3"):
		return true
	return false

func process_movements():
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		return true
	return false

func reset_collisions():
	if Input.is_action_just_released("attack1") or Input.is_action_just_released("attack2") or Input.is_action_just_released("attack3"):
		attack1.disabled = true
		attack2.disabled = true
		attack3.disabled = true
				
func _on_hurtbox_area_entered(area):
	stats.health -= 1
	hurtBox.start_invincibility(1)
	hurtBox.create_hit_effect()
