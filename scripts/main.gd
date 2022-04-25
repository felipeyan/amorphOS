extends PanelContainer

# External scripts
onready var DateTime = preload("res://scripts/DateTime.gd").new()
onready var Window = preload("res://scripts/Window.gd").new()

# Nodes
onready var content = get_node("container/content")
onready var systemTime = get_node("container/bottombar/panel/container/systemTime")

# Variables
var systemTimeTimer
var overlappingNode

func _ready():
	enableSystemTime()
	selectableNodeSignals()
	Window.setParent(content)
	
func _process(delta):
	if rect_min_size != get_viewport_rect().size:
		rect_min_size = get_viewport_rect().size
	
	if overlappingNode:
		if Input.is_action_just_pressed("mouse_left"):
			if overlappingNode.is_in_group("shortcut"):
				Window.createWindow()
			elif overlappingNode.is_in_group("window"):
				Window.setFocusedWindow(overlappingNode)
				
			if Window.focusedWindow:
				match overlappingNode.name:
					"headerbar":
						Window.mouseClickOrigin = get_global_mouse_position()
						Window.distanceBetweenOrigin = Window.focusedWindow.position - Window.mouseClickOrigin
		elif Input.is_action_pressed("mouse_left"):
			if Window.focusedWindow:
				match overlappingNode.name:
					"headerbar":
						if Window.mouseClickOrigin and Window.distanceBetweenOrigin:
							Window.moveWindow(get_global_mouse_position())
		elif Input.is_action_just_released("mouse_left"):
			Window.mouseClickOrigin = null
			Window.distanceBetweenOrigin = Vector2()
				
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
