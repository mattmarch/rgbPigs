extends AudioStreamPlayer

# Shotgun_Quick_Pump_01 from: 
# https://gamesounds.xyz/?dir=Sonniss.com%20-%20GDC%202016%20-%20Game%20Audio%20Bundle/TS%20Sound%20-%2012%20Gauge%20Shotgun
const reload = preload("res://Assets/Sounds/Reload.wav")

# gun_revolver_pistol_shot_04 from:
# https://gamesounds.xyz/?dir=Sonniss.com%20-%20GDC%202017%20-%20Game%20Audio%20Bundle/Gamemaster%20Audio%20-%20%20Gun%20Sound%20Pack
const gun_shot = preload("res://Assets/Sounds/Shoot.wav")


var reloading := false


func _ready():
    connect("finished", self, "_on_finished")


func shoot():
    stream = gun_shot
    play()
    

func shoot_and_reload():
    reloading = true
    shoot()


func _on_finished():
    if reloading:
        stream = reload
        reloading = false
        play()
