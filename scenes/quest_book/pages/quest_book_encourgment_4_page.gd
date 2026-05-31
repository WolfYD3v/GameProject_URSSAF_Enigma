extends QuestBookPage
class_name QuestBookEncourgment4Page

@onready var listen_button: Button = $Right/MarginContainer/Nodes/ListenButton
@onready var file_tool: FileTool = $FileTool

var file_text: String = '''Querido tú, eh... voy a ser sincero contigo. No te escribo esto por amor. Me han obligado a hacerlo. Pero como soy el único que habla español, pues puedo escribir lo que quiera. Así que...
Te odio, pedazo de mierda inútil y sin interés. ¿Y sabes por qué?
No. No, no lo sabes. Nunca lo sabes.
Déjame decirte POR QUÉ te contrataron en nuestro equipo. El tramposo.
Hemos hecho trampa durante 6 años, ¿eh? Nos sentíamos intocables, ¿eh? Nos creíamos reyes, ¿eh?
¿Sabes qué? Todos los reyes acaban cayendo algún día. Y ese día ha llegado, 6 años después.
Te pillaron, y te dimos una segunda oportunidad. ¿POR QUÉ?
Odio a los capullos de tu calaña, no le veo el sentido a darte otra oportunidad, ¡¡¡¡ES QUE NO TIENE NINGÚN SENTIDO, JODER!!!!!
Así que no, no te quiero. No hagas caso a sus mentiras, te vas a morir, así que llena tu pequeño cerebro podrido con información que está por encima de tu nivel.
Ya está, ya está.

https://www.youtube.com/watch?v=E_qy2XYPJBo&rco=1
'''

func _ready() -> void:
	pass

func _on_listen_button_pressed() -> void:
	listen_button.disabled = true
	file_tool.download_file("dear_you.txt", file_text, true)
