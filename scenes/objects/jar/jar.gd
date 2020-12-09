extends Node2D

export var isMimic = false
export var has_coin = false

func _on_hutbox_area_entered(area):
	create_destroy_effect()
	$StaticBody2D.queue_free()
	$hutbox.queue_free()
	$Timer.start()

func create_destroy_effect():
	var scene = load("res://scenes/objects/jar/effect/jarEffect.tscn")
	var instance = scene.instance()
	var main = get_tree().current_scene
	instance.global_position = global_position
	main.add_child(instance)

func create_mimic_instance():
	var scene = load("res://scenes/mimic/boss/boss.tscn")
	var instance = scene.instance()
	instance.set_has_coin(has_coin)
	var main = get_tree().current_scene
	instance.global_position = global_position
	main.add_child(instance)


func _on_Timer_timeout():
	if isMimic == true:
		create_mimic_instance()
	queue_free()
