extends Control

const FADED_COLOUR := Color(0.2, 0.2, 0.2)
const BRIGHT_COLOUR := Color(1, 1, 1)

onready var start_button: Button = $MenuButtons/StartButton
onready var credits_button: Button = $MenuButtons/CreditsButton
onready var title: Label = $Title
onready var background: ColorRect = $BlackBackground
onready var center_text: Label = $CenterText
onready var anims: AnimationPlayer = $AnimationPlayer
onready var score_counter: Label = $InGameDisplays/ScoreCounter
onready var insanity_display: Label = $InGameDisplays/InsanityLevel

onready var heart_array := [$InGameDisplays/Hearts/H1, $InGameDisplays/Hearts/H2, $InGameDisplays/Hearts/H3]
var health := 3
var score := 0

var in_credits := false

onready var shell_array := [$InGameDisplays/Shells/S1, $InGameDisplays/Shells/S2]


func _ready():
    start_button.connect("pressed", self, "_on_start_button_pressed")
    credits_button.connect("pressed", self, "_on_credits_button_pressed")
    anims.connect("animation_finished", self, "_on_animation_finished")
    Events.connect("player_hit", self, "_on_player_hit")
    Events.connect("game_over", self, "_on_game_over")
    Events.connect("update_shells", self, "_on_update_shells")
    Events.connect("demon_pig_slain", self, "_on_demon_pig_slain")
    Events.connect("update_insanity", self, "_on_update_insanity")


func _on_start_button_pressed():
    $MenuButtons.visible = false
    center_text.visible = true
    anims.play("FadeIntro")
    Events.emit_signal("start")

    
func _on_animation_finished(anim_name: String):
    if anim_name == "FadeGameOver":
        start_button.text = "Retry?"
        $MenuButtons.visible = true
    elif anim_name == "FadeIntro":
        health = 3
        for heart in heart_array:
            heart.modulate = BRIGHT_COLOUR
        score = 0
        update_score_display()
        $InGameDisplays.visible = true
        
        
func _on_player_hit():
    health -= 1
    heart_array[health].modulate = FADED_COLOUR
    if health == 0:
        Events.emit_signal("game_over")


func _on_game_over():
    anims.play("FadeGameOver")
    center_text.text = "Game Over!\nScore: %s" % score
    $InGameDisplays.visible = false


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
            

func _on_demon_pig_slain():
    score += 1
    update_score_display()    


func update_score_display():
    score_counter.text = "Demon Pigs Slain: %s" % score


func _on_update_insanity(level: float):
    insanity_display.text = "Insanity Level: %d%%" % round(level * 100)


func _on_credits_button_pressed():
    if !in_credits:
        in_credits = true
        start_button.visible = false
        credits_button.text = "Back"
        $Credits.visible = true
        center_text.visible = false
    else:
        in_credits = false
        start_button.visible = true
        credits_button.text = "Credits"
        $Credits.visible = false
        if health == 0:
            # i.e. if Game over
            center_text.visible = true
