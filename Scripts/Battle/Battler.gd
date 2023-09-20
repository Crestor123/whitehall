extends CharacterBody3D

class_name Battler

#Contains the data used by a particular battler
@export var data : String
@export var abilityObject : PackedScene
@export var zoneObject : PackedScene
@export var speed = 14

@export var sprite : Texture2D
@export var battlerName : String

@onready var targetList = get_parent()
@onready var movementNode = get_parent().get_parent().get_node("MovementZone")
@onready var healthBar = $HealthBar
@onready var mesh = $Pivot/MeshInstance3D
@onready var raycast = $RayCast3D

var isActive = false
var partyMember = false
var movePosition : Vector3
var moveRange : float = 0
var attackRange : float = 0
var targetsInRange = []
var currentTarget = null

var moving = false
var inRange = false

signal active
signal finishedMoving
signal turnFinished
signal dead

#For party members, this is set to point to their ability node
#For enemies, it points to this node's child
var abilities : Node
var resource : Resource

var stats = {
	"maxhealth": 0,
	"health": 0, 
	"mana": 0, 
	"strength": 0, 
	"dexterity": 0, 
	"constitution": 0, 
	"intelligence": 0,
	"wisdom": 0,
	"charisma": 0
	}
	
var resistances = {
	"fire": 0,
	"light": 0,
	"heat": 0,
	"electricity": 0,
	"earth": 0,
	"metal": 0,
	"crystal": 0,
	"wood": 0,
	"air": 0,
	"sound": 0,
	"motion": 0,
	"void": 0,
	"water": 0,
	"cold": 0,
	"acid": 0,
	"darkness": 0,
	"mind": 0,
	"soul": 0,
	"flesh": 0,
	"time": 0
}
	
var buffs = []
var buffSources = []

func _ready():
	if abilities == null:
		abilities = $Abilities

func _physics_process(delta):
	if isActive == true && partyMember == true:
		var direction = Vector3.ZERO
	
		if moving == false:
			if Input.is_action_pressed("move_right"):
				direction.x += 1
			if Input.is_action_pressed("move_left"):
				direction.x -= 1
			if Input.is_action_pressed("move_down"):
				direction.z += 1
			if Input.is_action_pressed("move_up"):
				direction.z -= 1
		
			if direction != Vector3.ZERO:
				direction = direction.normalized()
	
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			#velocity.y -= fall_acceleration * delta
	
			#Check if the movment will put the battler outside of its movement radius
			var newPosition = position + Vector3(velocity.x * delta, 0, 0)
			var normal = -movePosition.direction_to(newPosition).normalized()
			if newPosition.distance_to(movePosition) >= moveRange:
				velocity += normal * (speed / 2)
				velocity.x = 0
			newPosition = position + Vector3(0, 0, velocity.z * delta)
			normal = -movePosition.direction_to(newPosition).normalized()
			if newPosition.distance_to(movePosition) >= moveRange:
				velocity += normal * (speed / 2)
				velocity.z = 0
	
		else:
			direction = Vector3.ZERO
			direction = position.direction_to(currentTarget.position)
			direction = direction.normalized()
		
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			
			var newPosition = position + Vector3(velocity.x * delta, 0, velocity.z * delta)
			if position.distance_to(currentTarget.position) <= attackRange:
				velocity = Vector3.ZERO
				moving = false
				inRange = true
				finishedMoving.emit()
				return
			if newPosition.distance_to(movePosition) >= moveRange:
				velocity = Vector3.ZERO
				moving = false
				finishedMoving.emit()
	
		set_velocity(velocity)
		set_up_direction(Vector3.UP)
		move_and_slide()
	
	if isActive == true and partyMember == false:
		if moving == false: return
		var direction = Vector3.ZERO
		direction = position.direction_to(currentTarget.position)
		direction = direction.normalized()
		
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		var newPosition = position + Vector3(velocity.x * delta, 0, velocity.z * delta)
		if position.distance_to(currentTarget.position) <= attackRange:
			velocity = Vector3.ZERO
			moving = false
			inRange = true
			finishedMoving.emit()
			return
		if newPosition.distance_to(movePosition) >= moveRange:
			velocity = Vector3.ZERO
			moving = false
			finishedMoving.emit()
		
		set_velocity(velocity)
		set_up_direction(Vector3.UP)
		move_and_slide()
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		var collider = collision.get_collider()
		if collider.is_in_group("entities"):
			print("collision")
			collider.on_collide()
	
	pass

func initialize():
	if data:
		resource = load(data)
		battlerName = resource.name
		for ability in resource.abilities:
			var newAbility = abilityObject.instantiate()
			newAbility.data = ability
			newAbility.initialize()
			abilities.add_child(newAbility)
		
		stats.maxhealth = resource.health
		stats.health = resource.health
		stats.mana = resource.mana
		stats.strength = resource.strength
		stats.dexterity = resource.dexterity
		stats.constitution = resource.constitution
		stats.intelligence = resource.intelligence
		stats.wisdom = resource.wisdom
		stats.charisma = resource.charisma
		
		if resource.sprite != null:
			set_sprite(resource.sprite)
		for stat in resource.resistances:
			resistances[stat] = resource.resistances[stat]
		
	moveRange = stats.dexterity * 3
		#Temporary - set attack range
	attackRange = 3
		

		
	healthBar.updateBar(100 * (stats.health / stats.maxhealth))
	pass

func set_sprite(newSprite : Texture2D):
	mesh.mesh.material.albedo_color = Color.WHITE
	mesh.mesh.material.albedo_texture = newSprite

func setActive():
	print(self, "active")
	inRange = false
	
	if stats.health <= 0:
		emit_signal("turnFinished")
	isActive = true
	if stats.health <= 0:
		return
	#Create a movement zone that the battler can move within
	#Create an attack zone that shows wher the battler can reach
	
	var attackZone = await createZone(moveRange + attackRange, Color.RED)
	createZone(moveRange)
	
	targetsInRange = attackZone.collisions
	movePosition = position
	
	emit_signal("active")
	#For party members, need to wait for the player's selection of move
	#For enemies, need to select one of their moves
	if partyMember == false:
		var timer = Timer.new()
		#timer.connect("timeout",Callable(self,"turnTest"))
		timer.one_shot = true
		add_child(timer)
		timer.start()
		await timer.timeout
		
		currentTarget = chooseTarget(targetList.get_children())
		#Move towards the target until it is in range, then end turn
		if position.distance_to(currentTarget.position) > moveRange:
			moving = true
			await finishedMoving
		else: inRange = true
		
		if inRange:
			if abilities.get_child_count() == 1:
				useAbility(abilities.get_child(0), currentTarget)
		else:
			emit_signal("turnFinished")
			isActive = false
				
	if partyMember == true:
		await turnFinished
	stepBuff()
	movementNode.get_child(0).queue_free()
	movementNode.get_child(1).queue_free()
	pass

func turnTest():
	emit_signal("turnFinished")

func createZone(radius, color = Color.BLUE):
	#Create a new node to hold the movement zone and ring
	var newZone = zoneObject.instantiate()
	movementNode.add_child(newZone)
	newZone.transform = self.transform
	newZone.position.y -= 1
	#Set the zone's radius to be proportional to the battler's dexterity
	await newZone.initialize(radius, color)
	newZone.visible = false
	return newZone
	pass

func chooseTarget(list):
	var target : Battler
	for item in list:
		if item != self and item.partyMember == true:
			target = item
	return target
	pass

func useAbility(ability, target = null):
	set_velocity(Vector3.ZERO)
	
	var damage = stats[ability.mainStat] * ability.multiplier + ability.baseDamage
	if ability.name == "Defend": target = self
	if ability.type == "buff":
		addBuff(ability.attackName, ability.mainStat, damage, ability.element, ability.turns)
		pass
	if ability.type == "attack":
		
		if target == null:
			target = chooseTarget(targetsInRange)
			#chooseTarget(targetsInRange).takeDamage(damage, ability.element)
		#else:
			#target.takeDamage(damage, ability.element)
		#If the target is not within attack range, move until it is
		if position.distance_to(target.position) > attackRange:
			currentTarget = target
			moving = true
			await finishedMoving
		target.takeDamage(damage, ability.element)
	
	if ability.additionalEffects.size() > 0:
		for effect in ability.additionalEffects:
			if effect == "resistances":
				for i in ability.additionalEffects[effect]:
					if i == "all":
						for j in resistances:
							addBuff(ability.attackName, j, ability.additionalEffects[effect][i], 
								ability.element, ability.turns)
					else: addBuff(ability.attackName, i, ability.additionalEffects[effect][i], 
						ability.element, ability.turns)
				
	emit_signal("turnFinished")
	isActive = false
	pass
	
#Positive values denote damage, and negative values are healing
func takeDamage(damage, element):
	if partyMember == true:
		print("Player taking ", damage, "damage")
	var damageValue = 0
	if damage > 0:
		damageValue = damage - ceil(float(damage * (float(resistances[element]) / 100)))
	else: damageValue = damage
	print(damageValue)
	stats.health -= damageValue
	if stats.health > stats.maxhealth:
		stats.health = stats.maxhealth
	if stats.health < 0:
		die()
	healthBar.updateBar(100 * (stats.health / stats.maxhealth))
	pass

func addBuff(source: String, stat : String, value : int, element : String, turns : int):
	#Add a persistent effect to the battler's list of buffs
	var exists = false
	for item in buffs:
		if item["source"] == source and item["stat"] == stat and item["element"] == element:
			item["turns"] == turns
			exists = true
	if exists == true: 
		print("found buff")
		return
	var buff = {"source": source, "stat": stat, "value": value, "element": element, "turns": turns}
	if stats.has(stat) and stat != "health":
		stats[stat] += value
	if resistances.has(stat):
		resistances[stat] += value
	buffs.append(buff)
	pass
	
func stepBuff():
	#Checks each buff and evaluates the effects 
	for i in buffs.size():
		var buff = buffs[i]
		buff["turns"] -= 1
		if buff["stat"] == "health":
			takeDamage(-buff["value"], buff["type"])
		if buff["turns"] <= 0:  #The buff has expired
			if stats.has(buff["stat"]) and buff["stat"] != "heatlh":
				stats[buff["stat"]] -= buff["value"]
			if resistances.has(buff["stat"]):
				resistances[buff["stat"]] -= buff["value"]
	
	var removedBuffs = buffs.duplicate()
	for buff in removedBuffs:
		if buff["turns"] <= 0:
			buffs.erase(buff)
	pass

func die():
	print(self, " dead")
	emit_signal("dead", self)
	if isActive == true:
		#emit_signal("turnFinished")
		isActive = false
	await(healthBar.updateBar(0))
	#get_parent().remove_child(self)
	queue_free()
	pass
