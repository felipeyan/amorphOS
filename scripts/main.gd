extends PanelContainer

# External scripts
onready var DateTime = preload("res://scripts/DateTime.gd").new()

# Nodes
onready var content = get_node("container/content")
onready var systemTime = get_node("container/bottombar/panel/container/systemTime")

# Variables
var systemTimeTimer
var overlappingNode

func _ready():
	enableSystemTime()
	selectableNodeSignals()

func _process(delta):
	if rect_min_size != get_viewport_rect().size:
		rect_min_size = get_viewport_rect().size

func selectableNodeSignals():
	var selectableNodes = get_tree().get_nodes_in_group("selectable")
	
	for i in selectableNodes.size():
		var child = selectableNodes[i]
		child.connect("mouse_entered", self, "mouseEntered", [child])
		child.connect("mouse_exited", self, "mouseExited")

func mouseEntered(node):
	overlappingNode = node

func mouseExited():
	overlappingNode = null

func timerTimeout(timerName):
	match timerName:
		"systemTimeTimer":
			systemTime.text = DateTime.getSystemTime()

func enableSystemTime():
	systemTime.text = DateTime.getSystemTime()
	
	if not has_node("systemTimeTimer"):
		systemTimeTimer = Timer.new()
		systemTimeTimer.name = "systemTimeTimer"
		systemTimeTimer.wait_time = 1
		systemTimeTimer.connect("timeout", self, "timerTimeout", [systemTimeTimer.name])
		add_child(systemTimeTimer)
		
	systemTimeTimer.start()
