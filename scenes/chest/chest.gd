extends Node2D

func _on_hutbox_area_entered(area):
	create_destroy_effect()
	queue_free()


func create_destroy_effect():
	var scene = load("res://scenes/chest/effect/chestEffect.tscn")
	var instance = scene.instance()
	var main = get_tree().current_scene
	instance.global_position = global_position
	main.add_child(instance)
