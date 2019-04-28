local tableUtils = {}

function tableUtils.get2(t, x, y)
  return t[x] and t[x][y]
end

function tableUtils.set2(t, x, y, v)
  t[x] = t[x] or {}
  t[x][y] = v
end

function tableUtils.removeAll(t, v)
  local n = 0

  for k, v2 in pairs(t) do
    if v2 == v then
      t[k] = nil
      n = n + 1
    end
  end

  return n
end

function tableUtils.removeLast(a, v)
  for i = #a, 1, -1 do
    if a[i] == v then
      table.remove(a, i)
      return i
    end
  end

  return nil
end

return tableUtils
