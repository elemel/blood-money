local mathUtils = {}

function mathUtils.round(x)
  return math.floor(x + 0.5)
end

function mathUtils.clamp(x, x1, x2)
  return math.min(math.max(x, x1), x2)
end

function mathUtils.clampLength(x, length)
  return math.min(math.max(x, -length), length)
end

function mathUtils.mix(x1, x2, t)
  return (1 - t) * x1 + t * x2
end

function mathUtils.mix2(x1, y1, x2, y2, t)
  return (1 - t) * x1 + t * x2, (1 - t) * y1 + t * y2
end

function mathUtils.boxDistance(x1, y1, x2, y2, x3, y3, x4, y4)
  if math.max(x1 - x4, x3 - x2) > math.max(y1 - y4, y3 - y2) then
    if x1 - x4 > x3 - x2 then
      return x1 - x4, -1, 0
    else
      return x3 - x2, 1, 0
    end
  else
    if y1 - y4 > y3 - y2 then
      return y1 - y4, 0, -1
    else
      return y3 - y2, 0, 1
    end
  end
end

return mathUtils
