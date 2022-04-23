extends Node

func getSystemTime():
	var dateTime = OS.get_datetime()
	return str(lessThan10(dateTime.get("hour")), ":", lessThan10(dateTime.get("minute")))

func lessThan10(value):
	value = value if value >= 10 else str("0", value)
	return value
