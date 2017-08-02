extends KinematicBody2D

export var MAX_HEALTH = 8
export var MOVEMENT_SPEED = 2500
var direction
var health
var who_killed_me
var speed_holder

func _ready():
	set_fixed_process(true)
	health = 9999
	speed_holder = MOVEMENT_SPEED
	
func _fixed_process(delta):
	var force = Vector2(0,0)
	MOVEMENT_SPEED = speed_holder
	#var motion = Vector2(Input.get_joy_axis((device), JOY_ANALOG_0_X), Input.get_joy_axis((device), JOY_ANALOG_0_Y))
	motion = motion.normalized()*MOVEMENT_SPEED*delta
	move(motion)
	#var direction = Vector2(Input.get_joy_axis((device), JOY_ANALOG_1_X),Input.get_joy_axis((device),JOY_ANALOG_1_Y))
	#var angle = direction.angle()
	#if ((Input.get_joy_axis(device, JOY_ANALOG_1_X))>0.5|| (Input.get_joy_axis(device, JOY_ANALOG_1_Y))>0.5||(Input.get_joy_axis(device, JOY_ANALOG_1_X))<-0.5||(Input.get_joy_axis(device, JOY_ANALOG_1_Y))<-0.5):
	set_rot(angle)

	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		move(motion)

	if (health<=0):
		MOVEMENT_SPEED = 0
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
