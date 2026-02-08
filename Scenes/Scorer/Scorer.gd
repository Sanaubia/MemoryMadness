extends Node

class_name Scorer

static var SelectionEnabled: bool = true

@onready var sound: AudioStreamPlayer = $Sound
@onready var reveals_timer: Timer = $RevealsTimer

var _selections: Array[MemoryTile]

func _enter_tree() -> void:
	SignalHub.on_tile_selected.connect(on_tile_selected)

func check_fos_pair() -> void:
	if _selections[0].matches_other_tile(_selections[1]) == true:
		_selections[0].kill_on_success()
		_selections[1].kill_on_success()
		SoundManager.play_sound(sound, SoundManager.SOUND_SUCCESS)
		
func process_pair() -> void:
	if _selections.size() != 2:
		return
	
	SelectionEnabled = false
	reveals_timer.start()
	check_fos_pair()
	
	
func on_tile_selected(tile: MemoryTile) -> void:
	if tile in _selections:
		return
	
	_selections.append(tile)
	#sound.play()
	SoundManager.play_sound(sound, SoundManager.SOUND_SELECT_TILE)
	process_pair()


func _on_reveals_timer_timeout() -> void:
	for s in _selections:
		s.reveal(false)
	_selections.clear()
	SelectionEnabled = true
