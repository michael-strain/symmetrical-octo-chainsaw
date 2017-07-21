extends KinematicBody2D

export var MAX_HEALTH = 8
export var MOVEMENT_SPEED = 2500
export(PackedScene) var bullet0_scene
var trigger
var time_to_next_shot = 0.0
var device = 0
var playerSprite
var direction
var health
var points = 0
var who_killed_me
var speed_holder
#Base weapon variables
var weaponHeld

func _ready():
	set_fixed_process(true)
	health = MAX_HEALTH
	speed_holder = MOVEMENT_SPEED
	weaponHeld = "basic"
	add_to_group("players")
	
func _fixed_process(delta):
	time_to_next_shot -= delta
	var force = Vector2(0,0)
	MOVEMENT_SPEED = speed_holder
	var motion = Vector2(Input.get_joy_axis((device), JOY_ANALOG_0_X), Input.get_joy_axis((device), JOY_ANALOG_0_Y))
	motion = motion.normalized()*MOVEMENT_SPEED*delta
	if ((Input.get_joy_axis(device, JOY_ANALOG_0_X))>0.5|| (Input.get_joy_axis(device, JOY_ANALOG_0_Y))>0.5||(Input.get_joy_axis(device, JOY_ANALOG_0_X))<-0.5||(Input.get_joy_axis(device, JOY_ANALOG_0_Y))<-0.5):
		move(motion)
	var direction = Vector2(Input.get_joy_axis((device), JOY_ANALOG_1_X),Input.get_joy_axis((device),JOY_ANALOG_1_Y))
	var angle = direction.angle()
	if ((Input.get_joy_axis(device, JOY_ANALOG_1_X))>0.5|| (Input.get_joy_axis(device, JOY_ANALOG_1_Y))>0.5||(Input.get_joy_axis(device, JOY_ANALOG_1_X))<-0.5||(Input.get_joy_axis(device, JOY_ANALOG_1_Y))<-0.5):
		set_rot(angle)
	else:
		if ((Input.get_joy_axis(device, JOY_ANALOG_0_X))>0.5|| (Input.get_joy_axis(device, JOY_ANALOG_0_Y))>0.5||(Input.get_joy_axis(device, JOY_ANALOG_0_X))<-0.5||(Input.get_joy_axis(device, JOY_ANALOG_0_Y))<-0.5):
			set_rot(motion.angle())
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		move(motion)
	trigger = Input.get_joy_axis(device, JOY_ANALOG_R2)
	if (trigger > 0.5):
		if (weaponHeld == "basic"):
			get_node("Gun0").shot()
	if (health<=0):
		MOVEMENT_SPEED = 0
		weaponHeld = "none"
		queue_free()
	
func percent_damage_taken(from): #See living_object.gd for more info
	if(from !=self):
		return 1.0
	return 0
	
func damage(from, amount):
	var percent = percent_damage_taken(from)
	if(percent !=0):
		who_killed_me = from
		update_health(-amount)
		return true
	return false
	
func die():
	set_layer_mask(0)
	set_collision_mask(0)
	add_player_points()
	queue_free()
	#display player score
	
func add_player_points():
	if(who_killed_me != null):
		who_killed_me.add_points(self.points)

func add_points(points_external):
	points += points_external
	
func get_percent_life(val):
	var temp_health = health
	temp_health += val
	if(temp_health>MAX_HEALTH):
		health=MAX_HEALTH
	elif(temp_health<0):
		health=0
	else:
		health+=val
	var percent = health/MAX_HEALTH
	return percent
