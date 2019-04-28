local Camera = require("Camera")
local class = require("class")
local Creature = require("Creature")
local Player = require("Player")
local Terrain = require("Terrain")
local tableUtils = require("tableUtils")

local Game = class.newClass()

function Game:init(resources, config)
  self.resources = resources
  self.fixedDt = 1 / 60
  self.accumulatedDt = 0
  self.texelScale = 1 / 16
  self.camera = Camera.new({scaleX = 10, scaleY = 10})
  self.terrain = Terrain.new(self)
  self.creatures = {}

  for x = -10, 9 do
    tableUtils.set2(self.terrain.blocks, x, 4, "grass")
  end

  tableUtils.set2(self.terrain.blocks, 4, 3, "grass")
  tableUtils.set2(self.terrain.blocks, 4, 2, "grass")

  local creature = Creature.new(self, {
    directionX = -1,
    width = 0.75,
    height = 1.75,
  })

  self.player = Player.new(creature)
end

function Game:update(dt)
  self.accumulatedDt = self.accumulatedDt + dt

  while self.accumulatedDt >= self.fixedDt do
    self.accumulatedDt = self.accumulatedDt - self.fixedDt
    self:fixedUpdate(self.fixedDt)
  end
end

function Game:fixedUpdate(dt)
  self.camera:fixedUpdate(dt)
  self.player:updateInputs()

  for i, creature in ipairs(self.creatures) do
    creature:updatePosition()
  end

  for i, creature in ipairs(self.creatures) do
    creature:updateTransition()
  end

  for i, creature in ipairs(self.creatures) do
    creature:updateState(dt)
  end
end

function Game:draw()
  local t = self.accumulatedDt / self.fixedDt
  self:interpolatedDraw(t)
end

function Game:interpolatedDraw(t)
  self.camera:applyInterpolatedTransform(t)
  self.terrain:draw()

  for i, creature in ipairs(self.creatures) do
    creature:interpolatedDraw(t)
  end
end

return Game
