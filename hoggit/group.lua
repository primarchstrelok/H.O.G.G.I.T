--- Returns the location of the first unit in a given group.
-- If the group is nil, this function returns nil.
-- @param grp The group you want coordinates for.
-- @return Vec3 The group's first unit's coordinates, or nil if the group is nil
HOGGIT.groupCoords = function(grp)
  if grp ~= nil then
    return grp:getUnits()[1]:getPosition().p
  end
  return nil
end

--- Starts a smoke beacon at the specified group's location
-- @param grp The group to smoke. Will be placed on or near the first unit.
-- @param smokeColor The trigger.smokeColor enum value to use. Defaults to White smoke
HOGGIT.smokeAtGroup = function(grp, smokeColor)
  local pos = HOGGIT.groupCoords(grp)
  if smokeColor == nil then smokeColor = trigger.smokeColor.White end
  trigger.action.smoke(pos, smokeColor)
end

--- Returns a string of coordinates in a format appropriate for the planes of the
--- provided group. i.e. if the group contains F/A-18Cs then we'll return Degrees Minutes Seconds format
--@param grp The group the coordinates are going to be presented to
--@param position The position (table of x,y,z) coordinates to be translated.
--@return String containing the formatted coordinates. Returns an empty string if either grp or position are nil
HOGGIT.CoordsForGroup = function(grp, position)
  if grp == nil or position == nil then return "" end
  local u = grp:getUnit(1)
  if not u then return "" end -- Can't get any units from the group to inspect.

  local groupPlaneType = u:getTypeName()
  return HOGGIT.CoordFuncForPlaneType(groupPlaneType, position)
end

--- Given a plane type and position, return a string representing the position in a format useful for that planetype.
HOGGIT.CoordFuncForPlaneType = function(planeType, pos)
  local lat,long = coord.LOtoLL(pos)
  local dms = function()
    return mist.tostringLL(lat, long, 0, "")
  end
  local ddm = function()
    return mist.tostringLL(lat, long, 3)
  end
  local mgrs = function()
    return mist.tostringMGRS(coord.LLtoMGRS(lat,long),4)
  end
  --If it's not defined here we'll use dms.
  local unitCoordTypeTable = {
    ["Ka-50"] = ddm,
    ["M-2000C"] = ddm,
    ["A-10C"] = mgrs
    -- Everything else will default to dms. Add things here if we need exclusions.
  }
  local f = unitCoordTypeTable[planeType]
  if f then return f() else return dms() end
end
