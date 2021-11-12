extends Node

const fps = 60
var player_position
var player_direction
var crt_noise = 0.0
var pause_msg = ""

var data =  {
	"jwt": "",
	"vechain": "",
	"scene": "CatsCradle",
	"location": 0,
	"present": true,
	"prog_var": {},
	"prog_dia": {},
	"player_hp": 100.0,
	"nav_visible": {},
	"nav_unlocked": {"CatsCradle": true},
	"sound": -6,
	"music": -6,
	"nosound": false,
	"nomusic": false,
}

var pumpkin_code = ""


func _enter_tree():
	get_tree().set_auto_accept_quit(false)
		
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Data.saveit()
		get_tree().quit()

#var url = "http://api.geocats.net"
var url = "http://127.0.0.1:8000"
var http_request

var nfts = {}
var updating = false

func _ready():
	randomize()
	for i in range(0, 7):
		pumpkin_code += str(int(rand_range(1, 8)))

	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")

func nft_api(path, nft_id):
	updating = true
	var uri = url + path + "-nft"
	var body = { "nft_id": nft_id, "vechain": data.vechain }
	_get_request(uri, body)

func _get_request(uri, body):
	# Convert data to json string:
	var query = JSON.print(body)
	var headers = PoolStringArray()
	# Add 'Content-Type' header:
	headers.append("Content-Type: application/json")
	headers.append("Authorization: Bearer " + data.jwt)
	var error = http_request.request(uri, headers, true, HTTPClient.METHOD_POST, query)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

var response_code
var response
func _on_request_completed(_result, new_response_code, _headers, body):
	response_code = new_response_code
	response = parse_json(body.get_string_from_utf8())
	if response and response.has("status") and response.status and response.has("name"):
		nfts[response.name] = response.val

	updating = false
