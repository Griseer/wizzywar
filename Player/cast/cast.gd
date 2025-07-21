extends CanvasLayer


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var mouseSensitivity:float = 10
@export var cast_container: Node2D
@export var cast_point: Node2D 
@export var cast_pointer: Sprite2D
@export var top: Sprite2D 
@export var top_left: Sprite2D 
@export var top_right: Sprite2D 
@export var buttom_left: Sprite2D
@export var buttom_right: Sprite2D
@export var buttom: Sprite2D
@export var center: Sprite2D 








var elementPosArr := [ 
	StringName("CENTER"), 
	StringName("TOP"), 
	StringName("TOP-LEFT"), 
	StringName("TOP-RIGHT"),
	StringName("BUTTOM-LEFT"),
	StringName("BUTTOM-RIGHT"),
	StringName("BUTTOM"), 
	]

var elementNameArr := [
	StringName("NULL"), 
	StringName("WATER"), 
	StringName("ROCK"), 
	StringName("FIRE"),
	StringName("ICE"),
	StringName("RAY"),
	StringName("DEAD")
]


const DEAD = preload("res://Assests/cast/dead.jpg")
const FIRE = preload("res://Assests/cast/fire.jpg")
const ICE = preload("res://Assests/cast/ice.jpg")
const LIFE = preload("res://Assests/cast/life.jpg")
const RAY = preload("res://Assests/cast/ray.jpg")
const ROCK = preload("res://Assests/cast/rock.jpg")
const SHIELD = preload("res://Assests/cast/shield.jpg")
const WATER = preload("res://Assests/cast/water.jpg")


var elementNameDic: Dictionary = {
	"WATER":{
		"img": WATER
	},
	"ROCK":{
		"img": ROCK
	},
	"FIRE":{
		"img": FIRE
	},
	"ICE":{
		"img": ICE
	},
	"RAY":{
		"img": RAY
	},
	"DEAD":{
		"img": DEAD
	},
}


var elementPosDic: Dictionary = {}
 

var currPos:StringName = StringName("CENTER")

var velocityMouse:Vector2 = Vector2(0.0, 0.0)

var arrClean:Array = [0, 0 , 0 , 0 , 0, 0, 0, 0] 

var arrAngle:Array = [0, 0 , 0 , 0 , 0, 0, 0, 0] 


var idxAngle = 0


func _ready() -> void:

	elementPosDic= {
		"CENTER": {
			"ELEME": elementNameArr[0],
			"NODE": center,
			"330": "TOP-RIGHT",
			"270": "TOP",
			"210": "TOP-LEFT",
			"150": "BUTTOM-LEFT",
			"90": "BUTTOM",
			"30":"BUTTOM-RIGHT"
		},
		"TOP":{
			"ELEME": elementNameArr[1],
			"NODE": top,
			"0": "TOP-RIGHT",
			"30": "TOP-RIGHT",
			"90": "BUTTOM",
			"120": "BUTTOM-LEFT",
			"150": "TOP-LEFT",
			"180": "TOP-LEFT"
		},
		"TOP-LEFT":{
			"ELEME":elementNameArr[2],
			"NODE": top_left,
			"330": "TOP",
			"0": "TOP-RIGHT",
			"60": "BUTTOM",
			"90": "BUTTOM-LEFT"
		},
		"TOP-RIGHT":{
			"ELEME": elementNameArr[3],
			"NODE": top_right,
			"210": "TOP",
			"180": "TOP-LEFT",
			"120": "BUTTOM",
			"90": "BUTTOM-RIGHT"
		},
		"BUTTOM-LEFT":{
			"ELEME": elementNameArr[4] ,
			"NODE": buttom_left,
			"60": "BUTTOM",
			"30": "BUTTOM",
			"0": "BUTTOM-RIGHT",
			"270":  "TOP-LEFT",
		},
		"BUTTOM-RIGHT":{
			"ELEME": elementNameArr[5] ,
			"NODE": buttom_right,
			"120": "BUTTOM",
			"150": "BUTTOM",
			"180": "BUTTOM-LEFT",
			"270": "TOP-RIGHT"
		},
		"BUTTOM":{
			"ELEME": elementNameArr[6],
			"NODE": buttom,
			"0": "BUTTOM-RIGHT",
			"330": "BUTTOM-RIGHT",
			"300": "TOP-RIGHT",
			"270": "TOP",
			"240": "TOP-LEFT",
			"210": "BUTTOM-LEFT",
			"180": "BUTTOM-LEFT"
		},
		
	}


func _input(event)->void:
	if event is InputEventMouseMotion and Input.is_action_pressed("cast"):
		velocityMouse += event.relative  * mouseSensitivity
		var velo:Vector2 = event.velocity.normalized()
		
		var angle = velo.angle()
		
		
		var fixed_angle = roundi((rad_to_deg(angle)) /  30 )  * 30 
		
		if fixed_angle < 0:
			fixed_angle += 360
		
		
		if confirm_angle(fixed_angle):
			
			cast_element(fixed_angle)



func confirm_angle(angle):
	if idxAngle == 0:
		arrAngle[0] = angle
		idxAngle += 1
		return false
	
	if idxAngle > arrAngle.size()-1:
		arrAngle =  arrClean
		idxAngle = 0
		return true
	
	if arrAngle[idxAngle-1] == angle:
		arrAngle[idxAngle] = angle
		idxAngle += 1
		return false
	else: 
		arrAngle = arrClean
		idxAngle = 0
		return false
	
	return false
	

var castElementArr: = []

func cast_element_by_name(spell:StringName):
	var textureElement = elementNameDic[spell]["img"]
	var spriteElement = Sprite2D.new()
	spriteElement.texture = textureElement
	cast_container.add_child(spriteElement) 
	spriteElement.global_position =  Vector2(cast_point.global_position.x + castElementArr.size() * 30 ,  cast_point.global_position.y)
	castElementArr.push_back(spell)
	if castElementArr.size() == 3:
		cast_end()

func cast_element(angle:int ):
	
	var strAngle = str(angle)
	
	var currPosDic:Dictionary =  elementPosDic[currPos]
	
	var newPosName = currPosDic.get(strAngle)
	
	
	
	if newPosName:
		
		var castElement:StringName =  elementPosDic[newPosName]["ELEME"]
		var textureElement = elementNameDic[castElement]["img"]
		var spriteElement = Sprite2D.new()
		
		
		
		
		
		
		update_pointer_to_pos(newPosName)
		
		
		spriteElement.texture = textureElement
		cast_container.add_child(spriteElement) 
		spriteElement.global_position =  Vector2(cast_point.global_position.x + castElementArr.size() * 30 ,  cast_point.global_position.y)
		
		
		castElementArr.push_back(castElement)
		currPos =  newPosName
		arrAngle = arrClean
		
		if castElementArr.size() == 3:
			cast_end()

		
		
	else :
		print("no elemment: ", angle )


func update_pointer_to_pos(pos:StringName):
	
	var fromNode = elementPosDic[StringName(currPos)]["NODE"]
	var toNode = elementPosDic[StringName(pos)]["NODE"]
	
	var tween: Tween = create_tween()                    
	tween.tween_property(cast_pointer, "position", toNode.position, 0.1)



func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("cast"):
		cast_start()

	
	if Input.is_action_just_released("cast"):
		cast_end()



func cast_start():
	$CenterScreen/Star.visible = true
	arrAngle = arrClean
	update_pointer_to_pos(elementPosArr[0])
	currPos = "CENTER"



func cast_end():
	$CenterScreen/Star.visible = false
	arrAngle = arrClean
	if castElementArr.size() == 0:
		return
	if castElementArr.size() < 3 and castElementArr.size() > 0:
		cast_element_by_name(castElementArr[castElementArr.size()-1])
		cast_end()
		return
		
	cast_container.position.y = cast_container.position.y - 50
	castElementArr = []
	currPos = elementPosArr[0]
