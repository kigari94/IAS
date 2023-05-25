extends Camera2D

export(NodePath) var target1
export(NodePath) var target2

var currentTarget

func _ready():
	currentTarget = get_node(target1)
	# Setze die initiale Kamera-Zielposition
	position = currentTarget.position

func _process(delta):
	# Überprüfe, ob der aktuelle Zielknoten noch existiert
	if currentTarget != null:
		# Aktualisiere die Kamera-Zielposition
		position = currentTarget.position

func set_target(new_target):
	if (new_target == 1):
		currentTarget = get_node(target1)
	else:
		currentTarget = get_node(target2)

