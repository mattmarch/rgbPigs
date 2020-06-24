extends Control

func _ready():
    $BackButton.connect("pressed", self, "_on_back_pressed")
    $MusicVolume/HSlider.connect("value_changed", self, "_on_music_slider_changed")
    $EffectsVolume/HSlider.connect("value_changed", self, "_on_effects_slider_changed")
    
    
func _on_back_pressed():
    visible = false


func _on_music_slider_changed(value: float):
    SoundEffects.set_music_volume(linear2db(value/100))


func _on_effects_slider_changed(value: float):
    SoundEffects.set_effects_volume(linear2db(value/100))
