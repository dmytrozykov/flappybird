local WINDOW_WIDTH, WINDOW_HEIGHT = 360, 800
local WINDOW_TITLE = "Flappy Bird"

function love.conf(t)
  t.identity = "FlappyBird"

  t.window.title = WINDOW_TITLE
  t.window.height = WINDOW_HEIGHT
  t.window.width = WINDOW_WIDTH
end