local class = require("class")
local mathUtils = require("mathUtils")

local Camera = class.newClass()

function Camera:init(config)
  self.x = config.x or 0
  self.y = config.y or 0
  self.angle = config.angle or 0
  self.scaleX = config.scaleX or 1
  self.scaleY = config.scaleY or 1

  self.oldX = self.x
  self.oldY = self.y
  self.oldAngle = self.angle
  self.oldScaleX = self.scaleX
  self.oldScaleY = self.scaleY

  self.transform = love.math.newTransform()
end

function Camera:fixedUpdate(dt)
  self.oldX = self.x
  self.oldY = self.y
  self.oldAngle = self.angle
  self.oldScaleX = self.scaleX
  self.oldScaleY = self.scaleY
end

function Camera:applyInterpolatedTransform(t)
  local width, height = love.graphics.getDimensions()
  love.graphics.translate(0.5 * width, 0.5 * height)
  love.graphics.scale(height)

  local x, y = mathUtils.mix2(self.oldX, self.oldY, self.x, self.y, t)

  local scaleX, scaleY = mathUtils.mix2(
    self.oldScaleX, self.oldScaleY, self.scaleX, self.scaleY, t)

  self.transform:setTransformation(x, y, 0, scaleX, scaleY)
  self.transform = self.transform:inverse()
  love.graphics.applyTransform(self.transform)

  love.graphics.setLineWidth(1 / (height * self.scaleX))
end

return Camera
