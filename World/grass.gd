extends Node2D

func create_grass_effect():
	var grassEffect = load("res://Effects/grass_effect.tscn")
	var grassEffectInstance = grassEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(grassEffectInstance)
	grassEffectInstance.global_position = global_position

func _on_hurt_box_area_entered(area):
	create_grass_effect()
	queue_free()
