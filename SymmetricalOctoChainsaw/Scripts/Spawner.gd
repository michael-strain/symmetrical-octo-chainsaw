extends Node2D

export (PackedScene) var spawn_object
export var cooldown = 1
var timer
var area
var isPresent = false
var bodiesPresent=0

func _ready():
	area = get_node("Area2D")
	timer = cooldown
	set_fixed_process(true)
	area.connect("body_enter",self,"_on_Area2D_body_enter")
	area.connect("body_exit",self,"_on_Area2D_body_exit")

func _fixed_process(delta):
	timer -= delta
	if isPresent:
		if(timer<=0):
			timer = cooldown + rand_range(-0.75,1)
			var object = spawn_object.instance()
			object.set_pos(get_global_pos())
			object.set_rot(get_global_rot())
			get_parent().add_child(object)
		
	
func _on_Area2D_body_enter(body):
	if (body.is_in_group("players")):
		bodiesPresent+=1
		if(timer<=0):
			timer = cooldown + rand_range(-2,2)
			var object = spawn_object.instance()
			object.set_pos(get_global_pos())
			object.set_rot(get_global_rot())
			get_parent().add_child(object)
			isPresent=true
			
func _on_Area2D_body_exit(body):
	if (body.is_in_group("players")):
		bodiesPresent-=1
		if (bodiesPresent == 0):
			isPresent=false