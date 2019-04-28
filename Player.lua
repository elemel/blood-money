local class = require("class")

local Player = class.newClass()

function Player:init(creature)
  self.creature = creature
end

function Player:updateInputs()
  self.creature.oldJumpInput = self.creature.jumpInput

  local left = love.keyboard.isDown("a")
  local right = love.keyboard.isDown("d")
  local up = love.keyboard.isDown("w")
  local down = love.keyboard.isDown("s")

  self.creature.inputX = (right and 1 or 0) - (left and 1 or 0)
  self.creature.inputY = (down and 1 or 0) - (up and 1 or 0)
  self.creature.jumpInput = love.keyboard.isDown("space")
end

return Player
