extends CharacterBody3D

# Velocidades
var walk_speed = 5.0
var rotation_speed = 2.0

# Referência para a câmera
@onready var camera = $Camera3D

func _ready():
	# Configurar física básica
	gravity = 9.8

func _process(delta):
	# Rotação da câmera com setas esquerda/direita
	handle_camera_rotation(delta)
	
	# Movimento relativo à direção da câmera
	handle_movement(delta)

func handle_camera_rotation(delta):
	var rotation_input = 0.0
	
	# Setas esquerda/direita para rotacionar
	if Input.is_action_pressed("camera_left"):
		rotation_input += 1.0
	if Input.is_action_pressed("camera_right"):
		rotation_input -= 1.0
	
	# Aplicar rotação ao jogador (e consequentemente à câmera)
	rotate_y(rotation_input * rotation_speed * delta)

func handle_movement(delta):
	var input_dir = Vector3.ZERO
	
	# Capturar entrada WASD ou setas
	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1.0
	if Input.is_action_pressed("move_back"):
		input_dir.z += 1.0
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1.0
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1.0
	
	# Normalizar o vetor de entrada se necessário
	if input_dir.length() > 0.0:
		input_dir = input_dir.normalized()
	
	# Converter a direção local para global baseado na rotação da câmera
	var direction = Vector3.ZERO
	direction = transform.basis.z * input_dir.z + transform.basis.x * input_dir.x
	
	# Aplicar movimento
	velocity.x = direction.x * walk_speed
	velocity.z = direction.z * walk_speed
	
	# Aplicar gravidade
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Mover o personagem
	move_and_slide()

func _input(event):
	# Debug: mostrar informações
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			# Pulo simples
			if is_on_floor():
				velocity.y = 5.0
