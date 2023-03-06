extends Sprite3D

@onready var bar = $SubViewport/HealthBar

func _ready():
	texture = $SubViewport.get_texture()

func initialize():
	pass

func updateBar(percentage):
	if percentage < 0: return
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", percentage, 1.0).set_trans(Tween.TRANS_CUBIC)
	#tween.tween_property(bar, "value", bar.value, percentage, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	#tween.start()
	await tween.finished
	pass
