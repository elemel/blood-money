local class = require("class")

local Terrain = class.newClass()

function Terrain:init(game)
  self.game = game
  self.blocks = {}
end

function Terrain:draw()
  local images = self.game.resources.images.blocks
  local scale = self.game.texelScale

  for x, column in pairs(self.blocks) do
    for y, type_ in pairs(column) do
      local image = images[type_]
      love.graphics.draw(image, x - 0.5, y - 0.5, 0, scale, scale)
    end
  end
end

return Terrain
