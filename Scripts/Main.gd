extends Spatial

#Contains global data and delegates control of the game

onready var currentScene = $CurrentScene
onready var partyMembers = $PartyMembers
onready var anim =$AnimationPlayer

export var battleScene : PackedScene
export var mapScene : PackedScene

var previousScene

func _ready():
	#start_combat()
	pass

func start_combat(entity, enemyParty):
	print("starting combat")
	#Unload the current scene and load the battle scene
	anim.play("Fade")
	yield(anim, "animation_finished")
	#previousScene = currentScene.get_child(0)
	currentScene.get_child(0).queue_free()
	var battle = battleScene.instance()
	currentScene.add_child(battle)
	battle.connect("combatFinished", self, "end_combat", [entity])
	#Pass the list of party members and enemies to the battle scene
	var battlers = []
	for child in partyMembers.get_children():
		battlers.append(child)
	#var enemies = ["res://Resources/Enemies/Rat.tres"]
	battle.initialize(battlers, enemyParty)
	anim.play_backwards("Fade")
	yield(anim, "animation_finished")
	pass
	
func end_combat(entity):
	anim.play("Fade")
	yield(anim, "animation_finished")
	currentScene.get_child(0).queue_free()
	var map = mapScene.instance()
	currentScene.add_child(map)
	anim.play_backwards("Fade")
	yield(anim, "animation_finished")
	pass
