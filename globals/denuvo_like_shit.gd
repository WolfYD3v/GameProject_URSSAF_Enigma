# Original Script From: https://pastebin.com/Zfqy3vDE
# Modified To Match My Coding Style, And The New GDScript Syntax

extends Node

signal request_done

var time_between_checks: float = 15.0
var connected: bool = false
var http_request: HTTPRequest = null
var timer: Timer = null
var requesting: bool = false
var first_check: bool = true

var normal_gamemode: bool = false

var baby_message: String = "The server is not reachable. Check your Internet connection and re-launch the game.\n\nIn case the problem persists, well can't help."
var normal_message: String = "So, if I understand correctly, your computer isn't connected, and you want to play a game protected by some crappy Chinese version of Denuvo.\nYou're either an idiot or you're doing this on purpose.\n\nRestart the game once you've left the Stone Age."
 
func _ready() -> void:
	_spawn_http_request()
	_spawn_timer()

func _spawn_http_request() -> void:
	http_request = HTTPRequest.new()
	http_request.request_completed.connect(request_complete)
	add_child(http_request)
	
func _spawn_timer() -> void:
	timer = Timer.new()
	timer.timeout.connect(test_connection)
	add_child(timer)

func start_checking() -> void:
	test_connection()
	if timer: timer.start(time_between_checks)

func test_connection():
	if http_request:
		if requesting: await request_done
		
		requesting = true
		http_request.request("http://www.msftncsi.com/ncsi.txt")

func request_complete(_result, response_code, _headers, _body):
	if (response_code == 200):
		if not connected: print("Denuvo Like Shit - Player Connected")
		connected = true
	else:
		if not connected and first_check: connected = true
		if connected:
			print("Denuvo Like Shit - Player Disconnected")
			var message: String = baby_message
			if normal_gamemode: message = normal_message
			OS.alert(
				message,
				"URSSAF Enigma"
			)
			if normal_gamemode: OS.alert("What a moron...", "WolfY_D3v")
			get_tree().quit()
		connected = false
	
	if first_check: first_check = false
	requesting = false
	request_done.emit()
