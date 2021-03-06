--- utils.lua
-- Uncategorized utilities that are used often enough to justify inclusion in the framework

--- Given a table with indexes as keys (a list in any other language, thanks lua) returns a random element
-- @param table A table with indexes as keys
-- @return A random element from the table
HOGGIT.randomInList = function(list)
  local idx = math.random(1, #list)
  return list[idx]
end

--- Filters out elements that do not return true when passed to the function "filter"
-- @param t Table to iterate over
-- @param filter Function that each element in table "t" will be passed into.
-- @return New table with filtered elements only
HOGGIT.filterTable = function(t, filter)
  local out = {}
  for k,v in pairs(t) do
    if filter(v) then out[k] = v end
  end
  return out
end

--- Checks to see if value "elem" is contained in any value of table "list"
-- @param list Table to check
-- @param elem Value to look for in each table element
-- @return True/False if "elem" was found in "list"
HOGGIT.listContains = function(list, elem)
  for _, value in ipairs(list) do
    if value == elem then
      return true
    end
  end

  return false
end

--- Takes a DCS Vec2 position and returns a string with the lat and long
-- @param pos Vec2 from DCS engine
-- @param decimal if true then return result in Decimal instead of Seconds
-- @return The Lat/Long string
HOGGIT.getLatLongString = function(pos, decimal)
    local lat, long = coord.LOtoLL(pos)
    if decimal == nil then decimal = false end
    return mist.tostringLL(lat, long, 3, decimal)
end

--- Returns a textual smoke name based on the provided enum
-- @param a trigger.smokeColor enum
-- @return the English word as a string representing the color of the smoke. i.e. trigger.smokeColor.Red returns "Red"
HOGGIT.getSmokeName = function(smokeColor)
  if smokeColor == trigger.smokeColor.Green then return "Green" end
  if smokeColor == trigger.smokeColor.Red then return "Red" end
  if smokeColor == trigger.smokeColor.White then return "White" end
  if smokeColor == trigger.smokeColor.Orange then return "Orange" end
  if smokeColor == trigger.smokeColor.Blue then return "Blue" end
end


--- Returns if Group object is alive.
-- This will catch some of the edge cases that the more common functions miss.
-- @param group Group
-- @return True if Group is indeed, alive.  False otherwise.
HOGGIT.GroupIsAlive = function(group)
    local grp = nil
    if type(group) == "string" then
        grp = Group.getByName(group)
    else
        grp = group
    end
    if grp and grp:isExist() and grp:getSize() > 0 then return true else return false end
end