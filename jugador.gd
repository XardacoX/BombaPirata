extends KinematicBody2D

var bomba_r=load('res://bomba.tscn')

var velocidad=Vector2()
var acel=15
var gravedad=500
var salto=250

var estado='parado'

func _ready():
	pass
#	var grupo=get_tree().get_nodes_in_group('bomba')
#	for i in grupo:
#		add_collision_exception_with(i)

func _physics_process(delta):
	velocidad.y+=gravedad*delta
	
	if Input.is_action_just_pressed("click_der"):
		var bomba=bomba_r.instance()
		bomba.global_position=Vector2(global_position.x,global_position.y-35)
		
		get_parent().add_child(bomba)
	
	match estado:
		'parado':
			
			if Input.is_action_pressed("derecha") or Input.is_action_pressed("izquierda"):
				estado='corriendo'
			else:
				velocidad.x=0
			if is_on_floor():
				if Input.is_action_just_pressed("saltar"):
					velocidad.y=-salto
					estado='saltando'
			else:
				estado='cayendo'
		
		'corriendo':
			
			if Input.is_action_pressed("izquierda"):
				velocidad.x-=acel
				velocidad.x=clamp(velocidad.x,-200,0)
				$anim.flip_h=true
			elif Input.is_action_pressed('derecha'):
				velocidad.x+=acel
				velocidad.x=clamp(velocidad.x,0,200)
				$anim.flip_h=false
			else:
				estado='parado'
			
			
			
			if is_on_floor():
				if Input.is_action_just_pressed("saltar"):
					velocidad.y=-salto
					estado='saltando'
			else:
				estado='cayendo'
			
		'saltando':
			if Input.is_action_pressed("derecha"):
				velocidad.x+=5
				velocidad.x=clamp(velocidad.x,0,200)
			elif Input.is_action_pressed("izquierda"):
				velocidad.x-=5
				velocidad.x=clamp(velocidad.x,-200,0)
			
			if velocidad.y>0:
				estado='cayendo'
			
			
		'cayendo':
			if Input.is_action_pressed("derecha"):
				velocidad.x+=5
				velocidad.x=clamp(velocidad.x,0,200)
			elif Input.is_action_pressed("izquierda"):
				velocidad.x-=5
				velocidad.x=clamp(velocidad.x,-200,0)
			
			if is_on_floor():
				estado='parado'
		'golpeado':
			if is_on_floor():
				estado='parado'
	$anim.animation=estado

	velocidad=move_and_slide(velocidad,Vector2(0,-1))

func _on_jugador_area_entered(area):
	if area.name=='explosion':
		estado='golpeado'
		if area.global_position.x>global_position.x:
			velocidad=move_and_slide(Vector2(-300,-300),Vector2(0,-1))
		else:
			velocidad=move_and_slide(Vector2(300,-300),Vector2(0,-1))