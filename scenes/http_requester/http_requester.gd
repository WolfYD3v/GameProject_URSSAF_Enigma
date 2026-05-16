extends Node
class_name HttpRequester

signal request_success

@onready var http_request: HTTPRequest = $HTTPRequest

var _request_data: Variant

func _ready():
	http_request.request_completed.connect(_request_completed)

func request(url: String) -> Variant:
	http_request.request(url)
	await request_success
	return _request_data

func _request_completed(_result, _response_code, _headers, body):
	var body_string = body.get_string_from_utf8()
	if body_string is Dictionary or body_string is Array:
		_request_data = JSON.parse_string(body_string)
	else: _request_data = body_string
	request_success.emit()
