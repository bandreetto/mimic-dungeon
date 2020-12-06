extends Node2D

export var isMimic = false
var timer = null
var mimic_delay = 0.5

func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(mimic_delay)
	timer.connect('timeout', self, 'on_timeout_complete')
	add_child(timer)
	
func _on_hurtbox_area_entered(area):
	create_destroy_effect()
	$StaticBody2D.queue_free()
	$hurtbox.queue_free()
	timer.start()
	print('iniciado timer')

func on_timeout_complete():
	print('finalizou timer')
	if isMimic == true:
		create_mimic_instance()
	queue_free()
	   

func create_destroy_effect():
	var scene = load("res://scenes/barrel/effect/barrelEffect.tscn")
	var instance = scene.instance()
	var main = get_tree().current_scene
	instance.global_position = global_position
	main.add_child(instance)
	
func create_mimic_instance():
	var scene = load("res://scenes/mimic/mimic1/mimic.tscn")
	var instance = scene.instance()
	var main = get_tree().current_scene
	instance.global_position = global_position
	main.add_child(instance)


