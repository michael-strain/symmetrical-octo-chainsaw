extends Area2D

var players = []
var closestPos = Vector2(0,0)
var enemyPos = Vector2(0,0)

export var points = 1
export var MOVEMENT_SPEED = 1200
export var ROTATION_SPEED = 1000
export var MAX_HEALTH = 2
var health
var motion = Vector2(0,0)
var angle = 0.0
var killed_by
var prc
var T
var TL
var TR
var L
var R
var closest_node2d
var object_hit
var has_collided
var collision_point
var leftright
var forward

func _ready():
	set_fixed_process(true)
	set_process(true)
	add_to_group("enemies")
	health = MAX_HEALTH
	connect("body_enter",self,"_on_Area2D_body_enter")
	
	prc = get_node("PlayerRayCast2D")
	T = get_node("T")
	TL = get_node("TL")
	TR = get_node("TR")
	L = get_node("L")
	R = get_node("R")
	
	prc.set_enabled(true)
	T.set_enabled(true)
	TL.set_enabled(true)
	TR.set_enabled(true)
	L.set_enabled(true)
	R.set_enabled(true)

	#rc.add_exception(self)
	T.add_exception(self)
	TL.add_exception(self)
	TR.add_exception(self)
	L.add_exception(self)
	R.add_exception(self)
	
	angle = rand_range(-180.0,180.0)
	
func _process(delta):
	update()
	
func _fixed_process(delta):
	enemyPos = get_pos()
	#players = get_tree().get_nodes_in_group("players")
	players = get_parent().get_parent().players
	var playersize = get_parent().get_parent().playerSize
	if (players.size()>0):
	#if (playersize>0):
		closest_node2d = get_closest_node2d(players, enemyPos)
		#closestPos = closest_node2d.get_global_pos()
		prc.set_global_rot(self.get_pos().angle_to_point(closest_node2d.get_global_pos())-deg2rad(180))
		set_global_rotd(angle)
		
		T.set_global_rot(self.get_global_rot())
		L.set_global_rot(self.get_global_rot()+(deg2rad(90)))
		R.set_global_rot(self.get_global_rot()-(deg2rad(90)))
		TL.set_global_rot(self.get_global_rot()+(deg2rad(45)))
		TR.set_global_rot(self.get_global_rot()-(deg2rad(45)))
		
		if (T.is_colliding()==false&&TL.is_colliding()==false&&TR.is_colliding()==false):
			forward = -10
			leftright = 0
		if (T.is_colliding()):
			if(TL.is_colliding()&&TR.is_colliding()==false)||(L.is_colliding()&&R.is_colliding()==false):
				forward = 0
				leftright = -10 #move right
			if(TR.is_colliding()&&TL.is_colliding()==false)||(R.is_colliding()&&L.is_colliding()==false):
				forward = 0
				leftright = 10 #move left
		elif (TL.is_colliding()&&TR.is_colliding()==false):
			forward = 0
			leftright = -10 #move right
		elif (TR.is_colliding()&&TL.is_colliding()==false):
			forward=0
			leftright=10 #move left
		elif(T.is_colliding()&&TL.is_colliding()&&TR.is_colliding()):
			angle=angle-(deg2rad(180))

		if (prc.is_colliding()&&prc.get_collider()==closest_node2d):
			#has_collided = true
			#collision_point = prc.get_collision_point()
			#object_hit = prc.get_collider()
			#if (object_hit==closest_node2d):
			#player is in sight
				#if T&&TL&&TR is not colliding:
			if (T.is_colliding()==false&&TL.is_colliding()==false&&TR.is_colliding()==false):
				angle = self.get_pos().angle_to_point(closest_node2d.get_global_pos())#+deg2rad(0)
				set_global_rot(angle)
				forward=-10
				leftright=0
				#var t_dir= Vector2(0,1).rotated(angle)
				#var c_dir = Vector2(0,1).rotated(get_rot())
				#c_dir = c_dir.linear_interpolate(t_dir, min(ROTATION_SPEED*delta,1))
				#set_global_rot(atan2(c_dir.x,c_dir.y))
				#motion = Vector2(0,-10).rotated(angle)
				#motion=motion.normalized()
				#set_pos(get_pos() + motion * MOVEMENT_SPEED * delta)
				

				
		set_pos(get_pos()+_move_yo_self(angle,leftright,forward)*MOVEMENT_SPEED*delta)
	else:
		queue_free()
	
		
		
	
func _on_Area2D_body_enter(body):
	if(body.is_in_group("bullets")):
		health = health - 1
		var sampler = get_node("SamplePlayer")
		var voiceID = sampler.play("Boom")
		sampler.set_volume(voiceID, 1)
		if (health<=0):
			queue_free()
	if(body.is_in_group("players")):
		body.health = body.health - 1
		var sampler = get_node("SamplePlayer")
		var voiceID = sampler.play("Agh")
		sampler.set_volume(voiceID, 1.25)
		queue_free()
	
func get_closest_node2d(array_of_node2ds, enemyLocation):
	var min_node = null
	var min_distance_squared = 99999999999999999
	for kinematicbody2d in array_of_node2ds:
		var distance_squared = enemyLocation.distance_squared_to(kinematicbody2d.get_pos())
		if distance_squared < min_distance_squared:
			min_distance_squared = distance_squared
			min_node = kinematicbody2d
	return min_node

func _move_yo_self(direction,strafe,walk):
	var motion = Vector2(strafe,walk).rotated(direction)
	motion=motion.normalized()
	return motion