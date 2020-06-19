extends Control

const FADED_COLOUR := Color(0.2, 0.2, 0.2)
const BRIGHT_COLOUR := Color(1, 1, 1)

onready var start_button: Button = $StartButton
onready var title: Label = $Title
onready var background: ColorRect = $BlackBackground
onready var center_text: Label = $CenterText
onready var anims: AnimationPlayer = $AnimationPlayer
onready var hearts: Control = $Hearts
onready var shells: Control = $Shells

onready var heart_array := [$Hearts/H1, $Hearts/H2, $Hearts/H3]
var health := 3;

onready var shell_array := [$Shells/S1, $Shells/S2]


func _ready():
    start_button.connect("pressed", self, "_on_start_button_pressed")
    anims.connect("animation_finished", self, "_on_animation_finished")
    Events.connect("player_hit", self, "_on_player_hit")
    Events.connect("game_over", self, "_on_game_over")
    Events.connect("update_shells", self, "_on_update_shells")


func _on_start_button_pressed():
    start_button.visible = false
    center_text.visible = true
    hearts.visible = true
    health = 3
    for heart in heart_array:
        heart.modulate = BRIGHT_COLOUR
    shells.visible = true
    anims.play("FadeIntro")
    Events.emit_signal("start")

    
func _on_animation_finished(anim_name: String):
    if anim_name == "FadeGameOver":
        start_button.text = "Retry?"
        start_button.visible = true
        shells.visible = false
        hearts.visible = false

func _on_player_hit():
    health -= 1
    heart_array[health].modulate = FADED_COLOUR
    if health == 0:
        Events.emit_signal("game_over")


func _on_game_over():
    anims.play("FadeGameOver")
    center_text.text = "Game Over!"


func _on_update_shells(number: int):
    match number:
        0:
            shell_array[0].modulate = FADED_COLOUR
            shell_array[1].modulate = FADED_COLOUR
        1:
            shell_array[0].modulate = BRIGHT_COLOUR
            shell_array[1].modulate = FADED_COLOUR
        2:
            shell_array[0].modulate = BRIGHT_COLOUR
            shell_array[1].modulate = BRIGHT_COLOUR
            
