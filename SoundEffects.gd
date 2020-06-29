extends Node

const MAX_MUSIC_PITCH := 2.0
const MUSIC_PITCH_DELTA = 0.05

# Shotgun_Quick_Pump_01 from: 
# https://gamesounds.xyz/?dir=Sonniss.com%20-%20GDC%202016%20-%20Game%20Audio%20Bundle/TS%20Sound%20-%2012%20Gauge%20Shotgun
const reload = preload("res://Assets/Sounds/Reload.wav")

# gun_revolver_pistol_shot_04 from:
# https://gamesounds.xyz/?dir=Sonniss.com%20-%20GDC%202017%20-%20Game%20Audio%20Bundle/Gamemaster%20Audio%20-%20%20Gun%20Sound%20Pack
const gun_shot = preload("res://Assets/Sounds/Shoot.wav")

var reloading := false


func _ready():
    $Effects.connect("finished", self, "_on_effects_finished")
    Events.connect("happy_pig_slain", self, "_on_happy_pig_slain")
    Events.connect("game_over", self, "_on_game_over")
    Events.connect("start", self, "_on_start")
    Events.connect("game_exited", self, "_on_game_over")


func shoot():
    $Effects.stream = gun_shot
    $Effects.play()
    

func shoot_and_reload():
    reloading = true
    shoot()


func _on_effects_finished():
    if reloading:
        $Effects.stream = reload
        reloading = false
        $Effects.play()


func _on_music_finished():
    $Music.play()


func _on_happy_pig_slain():
    $Music.pitch_scale = clamp($Music.pitch_scale + MUSIC_PITCH_DELTA, 1.0, MAX_MUSIC_PITCH)


func _on_game_over():
    $Music.stop()


func _on_start():
    $Music.play(0.0)
    $Music.pitch_scale = 1.0
    
    
func set_music_volume(valueDb: float):
    $Music.volume_db = valueDb
    
    
func set_effects_volume(valueDb: float):
    $Effects.volume_db = valueDb
