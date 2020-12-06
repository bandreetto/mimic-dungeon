extends Node2D

export var isMimic = false

func _on_hurtbox_area_entered(area):
	create_destroy_effect()
	queue_free()
	create_mimic_instance()

func create_destroy_effect():
	var scene = load("res://scenes/barrel/effect/barrelEffect.tscn")
	var instance = scene.instance()
	
	var main = get_tree().current_scene
	instance.global_position = global_position
	main.add_child(instance)
	
func create_mimic_instance():
	if isMimic == true:
		var scene = load("res://scenes/mimic/mimic1/mimic.tscn")
		var instance = scene.instance()
		var main = get_tree().current_scene
		instance.global_position = global_position
		main.add_child(instance)
