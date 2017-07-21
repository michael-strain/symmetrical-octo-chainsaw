extends Node2D

export (PackedScene) var spawn_object
export var cooldown = 3
var timer
var area

func _ready():
	area = get_node("Area2D")
	timer = cooldown
	set_fixed_process(true)

func _fixed_process(delta):
	timer -= delta
	if(timer <0):
		var blocked = area.get_overlapping_bodies()
		if(blocked.size()==0):
			var object = spawn_object.instance()
			object.set_pos(get_global_pos())
			object.set_rot(get_global_rot())
			get_parent().add_child(object)
			timer = cooldown + rand_range(-2,2)
