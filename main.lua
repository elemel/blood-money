local Game = require("Game")

function love.load()
  love.window.setTitle("Blood Money")

  love.window.setMode(800, 600, {
    fullscreentype = "desktop",
    resizable = true,
  })

  resources = {
    images = {
      blocks = {
        grass = loadImage("resources/images/blocks/grass.png"),
      },

      creatures = {
        vampire = {
          crouch = {
            loadImage("resources/images/creatures/vampire/crouch.png"),
          },

          fall = {
            loadImage("resources/images/creatures/vampire/fall.png"),
          },

          jump = {
            loadImage("resources/images/creatures/vampire/jump.png"),
          },

          stand = {
            loadImage("resources/images/creatures/vampire/stand.png"),
          },

          walk = {
            loadImage("resources/images/creatures/vampire/walk-1.png"),
            loadImage("resources/images/creatures/vampire/walk-2.png"),
          },
        },
      },
    },
  }

  game = Game.new(resources, {})
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  game:draw()
end

function loadImage(filename)
  local image = love.graphics.newImage(filename)
  image:setFilter("linear", "nearest")
  return image
end
