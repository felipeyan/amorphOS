extends Node

var parent
var root
var focusedWindow
var mouseClickOrigin
var distanceBetweenOrigin = Vector2()

func setParent(node):
	parent = node
	root = parent.get_tree().root.get_node("screen")
	
func setFocusedWindow(window):
	focusedWindow = window
	
	for child in parent.get_tree().get_nodes_in_group("window"):
		child.get_node("panel/focusArea").visible = false if child == window else true
	
	parent.move_child(focusedWindow, parent.get_child_count() - 1)

func connectWindowSignals(window):
	var selection = window.get_node("panel/focusArea")
	var headerbar = window.get_node("panel/container/headerbar")
	
	selection.connect("mouse_entered", root, "mouseEntered", [window])
	selection.connect("mouse_exited", root, "mouseExited")
	headerbar.connect("mouse_entered", root, "mouseEntered", [headerbar])
	headerbar.connect("mouse_exited", root, "mouseExited")

func createWindow():
	var window = preload("res://scenes/window.tscn").instance()
	window.position = randomPos(window)
	parent.add_child(window)
	connectWindowSignals(window)
	setFocusedWindow(window)

func randomPos(window):
	var x = parent.rect_size.x - window.get_node("panel").rect_min_size.x
	var y = parent.rect_size.y - window.get_node("panel").rect_min_size.y
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	return Vector2(random.randi_range(0, x), random.randi_range(0, y))

func moveWindow(mousePos):
	var panel = focusedWindow.get_node("panel")
	focusedWindow.position = mousePos + distanceBetweenOrigin
	focusedWindow.position.x = max(0, min(focusedWindow.position.x, parent.rect_size.x - panel.rect_size.x))
	focusedWindow.position.y = max(0, min(focusedWindow.position.y, parent.rect_size.y - panel.rect_size.y))
