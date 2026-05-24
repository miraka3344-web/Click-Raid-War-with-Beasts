extends Area2D

@export var shot_speed: float = 1200.0   # Скорость полета пули при выстреле
@export var bullet_damage: int = 30     # Урон пули

var start_position: Vector2
var movement_tween: Tween
var is_flying: bool = false             # Флаг, летит ли пуля в данный момент

func _ready():
	start_position = global_position
	body_entered.connect(_on_body_entered)
	
	# На старте игры пуля стоит на персонаже, поэтому делаем её полностью прозрачной
	modulate.a = 0.0

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_flying:
			shoot()

func shoot():
	is_flying = true
	
	# Сразу в момент клика делаем пулю полностью видимой
	modulate.a = 1.0
	
	var target_position = start_position + Vector2(1000, 0)
	var duration = 1000.0 / shot_speed
	
	movement_tween = create_tween()
	movement_tween.tween_property(self, "global_position", target_position, duration)
	movement_tween.finished.connect(reset_bullet)

func _on_body_entered(body):
	if is_flying and body.has_method("take_damage"):
		body.take_damage(bullet_damage)
		reset_bullet()

func reset_bullet():
	if movement_tween and movement_tween.is_valid():
		movement_tween.kill()
		
	monitoring = false
	global_position = start_position
	
	# Пуля вернулась на персонажа — снова делаем её прозрачной
	modulate.a = 0.0
	
	# Обязательная задержка в 10 миллисекунд (0.01 секунды) перед возможностью нового выстрела
	get_tree().create_timer(0.01).timeout.connect(func():
		monitoring = true
		is_flying = false 
	)
