extends RigidBody2D
var mouse=false
var estado
var dir=Vector2()
var pateame=false

func _ready():
	set_process(false)
#	var jugador=get_tree().get_nodes_in_group('jugador')
#	for i in jugador:
#		add_collision_exception_with(i)

func _physics_process(delta):
	$tiempo.text=str(ceil($Timer.time_left))

func _process(delta):
	match estado:
		'listo':
			if Input.is_action_just_pressed("click_izq"):
				dir=global_position
				
				if get_tree().get_nodes_in_group('linea')[0].get_point_count()==null:
					get_tree().get_nodes_in_group('linea')[0].add_point(global_position)
				
				estado='definir'
		'definir':
			if get_tree().get_nodes_in_group('linea')[0].get_point_count()!=2:
				get_tree().get_nodes_in_group('linea')[0].add_point(get_global_mouse_position())
			else:
				get_tree().get_nodes_in_group('linea')[0].set_point_position(0,global_position)
				get_tree().get_nodes_in_group('linea')[0].set_point_position(1,get_global_mouse_position())

			if Input.is_action_just_released("click_izq"):
				get_tree().get_nodes_in_group('linea')[0].clear_points()
				dir-=get_global_mouse_position()
				linear_velocity=dir*2
				set_process(false)


func _on_detect_click_mouse_entered():
	if pateame:
		mouse=true
		estado='listo'
		set_process(true)
	


func _on_detect_click_mouse_exited():
	if estado!='listo':
		mouse=false


func _on_detect_click_area_entered(area):
	if area.name=='jugador':
		pateame=true


func _on_detect_click_area_exited(area):
	if area.name=='jugador':
		pateame=false

func _on_Timer_timeout():
	estado='explota'
	$anim.animation=estado
	$explosion/CollisionShape2D.disabled=false


func _on_anim_animation_finished():
	if $anim.animation=='explota':
		get_tree().get_nodes_in_group('linea')[0].clear_points()
		queue_free()
