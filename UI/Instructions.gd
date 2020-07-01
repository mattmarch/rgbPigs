extends Control

onready var instructions := [
    ["Use WASD to move and the mouse to look around", null],
    ["Use left click to shoot and right click to toggle flashlight colour", null],
    ["Kill the demon pigs before they get you", $AngryPigHead],
    ["Don't murder the innocent pigs or you will lose sanity, increasing the number of demon pigs", $HappyPigHead]
   ]

var current_instruction: int


func _ready():
    $Timer.connect("timeout", self, "display_next_instruction")


func start():
    $Instructions.visible = true
    current_instruction = -1
    display_next_instruction()
    $Timer.start()


func display_next_instruction():
    var prev_instruction_image = instructions[current_instruction][1]
    if prev_instruction_image != null:
        prev_instruction_image.visible = false
    current_instruction += 1
    if current_instruction < instructions.size():
        $Timer.start()
        $Instructions.text = instructions[current_instruction][0]
        var instruction_image = instructions[current_instruction][1]
        if instruction_image != null:
            instruction_image.visible = true
    else:
        current_instruction = -1
        $Instructions.visible = false
        Events.emit_signal("tutorial_finished")


func _input(event):
    if !event.is_action_pressed("skip"):
        return
    $Timer.stop()
    display_next_instruction()
    Events.emit_signal("tutorial_finished")
    
        
