extends Node

var game = self.get_parent()

@onready var battle_player = $"battle player"
@onready var town_player = $"town player"

#for battles
@onready var drunken_sailer = preload("res://Res/music and sound/tracks/Pirate 3.mp3")
@onready var battle_song = preload("res://Res/music and sound/tracks/Pirate 8.mp3")
#for town
@onready var chill_town_music = preload("res://Res/music and sound/tracks/Pirate 3.mp3")

func on_first_load():
	battle_player.play_music(battle_song)
	town_player.play_music(chill_town_music)
	town_player.stop()

func switch():
	if battle_player.playing == true:
		battle_player.stop()
		town_player.play()
		return
	else:
		battle_player.play()
		town_player.stop()
		return
