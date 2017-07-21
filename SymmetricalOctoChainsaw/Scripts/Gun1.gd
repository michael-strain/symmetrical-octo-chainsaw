extends Node2D

export var fire_rate = 0.1
export var bullet_scene_path = "res://Assets/bullet1.tscn"
export var bullet_setting = ""

var bullet_offset = Vector2(0,0)
var time_to_next_shot = 0.0
var bullet_holder #The node that contains the bullet nodes
var player
var timer = Timer.new()
var bullet_scn


func _ready():
	bullet_offset = get_node("SpawnPosition2D").get_pos()
	player = get_parent()
	bullet_holder = player.get_parent()
	
	if(bullet_setting != ""):
		var setting = get_node("/root/global").get(bullet_setting)
		bullet_scn = load(str(bullet_scene_path.basename(), "_", setting, ".", bullet_scene_path.extension()))
	else:
		bullet_scn = load(bullet_scene_path)
	
	set_fixed_process(true)
	
func _fixed_process(delta):
	time_to_next_shot -= delta

func shot():
	if (time_to_next_shot <= 0):
		var rotation = player.get_rot()+rand_range(-0.01,0.01)
		var bullet = bullet_scn.instance()
		if(not bullet extends RigidBody2D):
			var holder = bullet
			for child in holder.get_children():
				if(child extends RigidBody2D):
					holder.remove_child(child)
					bullet = child
			holder.queue_free()
		bullet_holder.add_child(bullet)
		bullet.set_pos(player.get_pos() + bullet_offset.rotated(rotation))
		bullet.force = Vector2(0,bullet.BULLET_SPEED).rotated(rotation)
		#if(bullet.take_player_speed):
			#bullet.set_linear_velocity(player.get_linear_velocity()*bullet.take_player_speed)
		bullet.source = get_parent().get_parent()
		time_to_next_shot = fire_rate
		Input.start_joy_vibration(player.device,1.0,1.0,0.1)
	else:
		pass
		
