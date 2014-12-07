-- Audio

-- require('bullet')

Audio = {
  sounds = {
    player_death = {
      love.audio.newSource('audio/player_death.wav', 'static')
    },
    enemy_death = {
      love.audio.newSource('audio/enemy_death.wav', 'static')
    }
  } 
}

Audio.__index = Audio

function Audio.play(sound_collection)
  sound_collection[1]:play()
end