extends AudioStreamPlayer

func play_music(music : AudioStream):
	if stream == music:
		return
	stream = music
	play()
