extends Area2D

@onready var timer = $Timer

@export var show_hit : bool = true

const hitEffect = preload("res://Effects/hit_effect.tscn")

signal invencibility_started
signal invencibility_ended

var invencible = false:
	get: 
		return invencible
	set(value): 
		invencible = value
		if invencible:
			emit_signal("invencibility_started")
		else:
			emit_signal("invencibility_ended")

func create_hit_effect():
	var effect = hitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func start_invencibility(duration):
	self.invencible = true
	timer.start(duration)

func _on_timer_timeout():
	self.invencible = false

func _on_invencibility_started():
	set_deferred ("monitoring", false)

func _on_invencibility_ended():
	monitoring = true
