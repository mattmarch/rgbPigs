extends Control

onready var start_button: Button = $StartButton
onready var title: Label = $Title
onready var background: ColorRect = $BlackBackground
onready var center_text: Label = $CenterText
onready var anims: AnimationPlayer = $AnimationPlayer


func _ready():
    start_button.connect("pressed", self, "_on_start_button_pressed")
    anims.connect("animation_finished", self, "_on_animation_finished")


func _on_start_button_pressed():
    start_button.visible = false
    center_text.visible = true
    anims.play("FadeIntro")
    
func _on_animation_finished(anim_name: String):
    if anim_name == "FadeIntro":
        Events.emit_signal("start")
