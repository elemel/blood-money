local class = require("class")
local mathUtils = require("mathUtils")
local physics = require("physics")
local tableUtils = require("tableUtils")

local Creature = class.newClass()

function Creature:init(game, config)
  self.game = game

  self.x = config.x or 0
  self.y = config.y or 0

  self.width = config.width or 1
  self.height = config.height or 1

  self.directionX = config.directionX or 1
  self.state = config.state or "fall"

  self.crouchAcceleration = config.crouchAcceleration or 16
  self.fallAcceleration = config.fallAcceleration or 16
  self.fallSpeed = config.fallSpeed or 16
  self.glideAcceleration = config.glideAcceleration or 8
  self.glideSpeed = config.glideSpeed or 2
  self.jumpAcceleration = config.jumpAcceleration or 8
  self.jumpSpeed = config.jumpSpeed or 9
  self.standAcceleration = config.standAcceleration or 16
  self.walkAcceleration = config.walkAcceleration or 16
  self.walkSpeed = config.walkSpeed or 4

  self.oldX = self.x
  self.oldY = self.y

  self.inputX = 0
  self.inputY = 0
  self.jumpInput = false
  self.oldJumpInput = false

  self.leftCollision = false
  self.rightCollision = false
  self.upCollision = false
  self.downCollision = false

  table.insert(self.game.creatures, self)
end

function Creature:destroy()
  tableUtils.removeLast(self.game.creatures, self)
end

function Creature:updatePosition()
  physics.updatePosition(self)
end

function Creature:updateTransition()
  if self.state == "crouch" then
    if not self.downCollision then
      self.state = "fall"
      return
    end

    if self.inputY ~= 1 then
      self.state = "stand"
      return
    end
  elseif self.state == "fall" then
    if self.downCollision then
      self.state = "stand"
      return
    end
  elseif self.state == "jump" then
    if self.downCollision then
      self.state = "stand"
      return
    end

    if not self.jumpInput then
      self.state = "fall"
      return
    end
  elseif self.state == "stand" then
    if not self.downCollision then
      self.state = "fall"
      return
    end

    if self.jumpInput and not self.oldJumpInput then
      self.y = self.oldY - self.jumpSpeed * self.game.fixedDt
      self.state = "fall"
      return
    end

    if self.inputY == 1 then
      self.state = "crouch"
      return
    end

    if self.inputX ~= 0 then
      self.state = "walk"
      return
    end
  elseif self.state == "walk" then
    if not self.downCollision then
      self.state = "fall"
      return
    end

    if self.jumpInput and not self.oldJumpInput then
      self.y = self.oldY - self.jumpSpeed * self.game.fixedDt
      self.state = "fall"
      return
    end

    if self.inputY == 1 then
      self.state = "crouch"
      return
    end

    if self.inputX == 0 then
      self.state = "stand"
      return
    end
  end
end

function Creature:updateState(dt)
  if self.state == "crouch" then
    self:updateCrouchState(dt)
  elseif self.state == "fall" then
    self:updateFallState(dt)
  elseif self.state == "stand" then
    self:updateStandState(dt)
  elseif self.state == "walk" then
    self:updateWalkState(dt)
  end
end

function Creature:updateCrouchState(dt)
  self:updateDirection()
  physics.applyFrictionX(self, self.crouchAcceleration, 0, dt)
  physics.applyFrictionY(self, self.fallAcceleration, self.fallSpeed, dt)
  self:updateCollisions()
end

function Creature:updateFallState(dt)
  self:updateDirection()
  physics.applyBoostX(self, self.glideAcceleration, self.inputX * self.glideSpeed, dt)
  physics.applyFrictionY(self, self.fallAcceleration, self.fallSpeed, dt)
  self:updateCollisions()
end

function Creature:updateStandState(dt)
  physics.applyFrictionX(self, self.standAcceleration, 0, dt)
  physics.applyFrictionY(self, self.fallAcceleration, self.fallSpeed, dt)
  self:updateCollisions()
end

function Creature:updateWalkState(dt)
  self:updateDirection()

  physics.applyFrictionX(
    self, self.walkAcceleration, self.inputX * self.walkSpeed, dt)

  physics.applyFrictionY(self, self.fallAcceleration, self.fallSpeed, dt)
  self:updateCollisions()
end

function Creature:updateCollisions()
  self:clearCollisions()
  self:resolveCollisions()
end

function Creature:clearCollisions()
  self.leftCollision = false
  self.rightCollision = false
  self.upCollision = false
  self.downCollision = false
end

function Creature:resolveCollisions()
  for i = 1, 4 do
    local distance, normalX, normalY = physics.resolveTerrainCollision(
      self, self.game.terrain.blocks)

    if normalX == -1 then
      self.leftCollision = true
    elseif normalX == 1 then
      self.rightCollision = true
    elseif normalY == -1 then
      self.upCollision = true
    elseif normalY == 1 then
      self.downCollision = true
    end
  end
end

function Creature:updateDirection()
  if self.inputX ~= 0 then
    self.directionX = self.inputX
  end
end

function Creature:interpolatedDraw(t)
  local image = self.game.resources.images.creatures.vampire[self.state][1]
  local imageWidth, imageHeight = image:getDimensions()
  local scaleX = self.directionX * self.game.texelScale
  local scaleY = self.game.texelScale

  local x, y = mathUtils.mix2(self.oldX, self.oldY, self.x, self.y, t)

  love.graphics.draw(
    image, x, y, 0, scaleX, scaleY, 0.5 * imageWidth, 0.5 * imageHeight)
end

return Creature
