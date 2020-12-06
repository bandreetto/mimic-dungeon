extends Node2D

export var isMimic = false

func _on_hurtbox_area_entered(area):
	create_destroy_effect()
	$StaticBody2D.queue_free()
	$hurtbox.queue_free()
	$Timer.start()

func create_destroy_effect():
	var scene = load("res://scenes/objects/barrel/effect/barrelEffect.tscn")
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


func _on_Timer_timeout():
	if isMimic == true:
		create_mimic_instance()
	queue_free()
