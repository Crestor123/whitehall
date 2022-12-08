extends Sprite3D

onready var bar = $Viewport/HealthBar
onready var tween = $Tween

func _ready():
	texture = $Viewport.get_texture()

func initialize():
	pass

func updateBar(percentage):
	tween.interpolate_property(bar, "value", bar.value, percentage, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield($Tween, "tween_completed")
	pass
