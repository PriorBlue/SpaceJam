local audiolist = require "src/audiolist"

local audio = {}

function audio.init()
	love.audio.setVolume(settings.loaded.volume)
	audio.sfx = {}
	audio.music = {}
	for k,v in pairs(audiolist.sfx) do
		audio.sfx[v[1]] = love.audio.newSource(v[2],"static")
		if v[3] ~= nil then
			audio.sfx[v[1]]:setVolume(v[3])
		end
	end
	for k,v in pairs(audiolist.music) do
		audio.music[v[1]] = love.audio.newSource(v[2])
		if v[3] ~= nil then
			audio.music[v[1]]:setVolume(v[3])
		end
	end
end

function audio.update()
	playMusic = event.pull("playMusic")
	playSound = event.pull("playSound")		--example: event.push("playSound", {play = true, soundname = "laser_shoot"})
	if playMusic then -- marker layout: m.start, m.pause, m.resume, m.stopmusic, m.musicname
		for k,m in pairs(playMusic) do
			if m.start then
				love.audio.play(audio.music[m.stopmusic][2])
			elseif m.pause then
				if audio.musicname then
					love.audio.pause(audio.music[m.musicname][2])
				else
					for k,v in pairs(audiolist.music) do
						love.audio.pause(v[2])
					end
				end
			elseif m.stopmusic then	-- set musicname if you only want to stop a certain title
				if audio.musicname then
					love.audio.stop(audio.music[m.musicname][2])
				else
					for k,v in pairs(audiolist.music) do
						love.audio.stop(v[2])
					end
				end
			end
		end
	end
	if playSound then -- marker layout: s.play, s.soundname, s.looping, s.stop, s.norewind
		for k,s in pairs(playSound) do
			if s.play then
				love.audio.play(audio.sfx[s.soundname])
				if not s.norewind then
					love.audio.rewind(audio.sfx[s.soundname])
				end
				if s.looping then
					audio.sfx[s.soundname]:setLooping(true)
				end
			elseif s.stop then
				if s.soundname then
					love.audio.stop(audio.sfx[s.soundname])
				else
					for k,v in pairs(audio.sfx) do
						love.audio.stop(v[2])
					end
				end
			end
		end
	end
end

function audio.changeVolume(newVolume)
	settings.loaded.volume = newVolume
	love.audio.setVolume(settings.loaded.volume)
end

return audio