
  -- // oUF_Lanuigi2, an oUF tutorial layout
  -- // zork - 2011

  -----------------------------
  -- TAGS
  -----------------------------

  --number format func
  local numFormat = function(v)
    if v > 1E10 then
      return (floor(v/1E9)).."b"
    elseif v > 1E9 then
      return (floor((v/1E9)*10)/10).."b"
    elseif v > 1E7 then
      return (floor(v/1E6)).."m"
    elseif v > 1E6 then
      return (floor((v/1E6)*10)/10).."m"
    elseif v > 1E4 then
      return (floor(v/1E3)).."k"
    elseif v > 1E3 then
      return (floor((v/1E3)*10)/10).."k"
    else
      return v
    end
  end

oUF.Tags.Methods["Lanuigi:hpdefault"] = function(unit)
  if not UnitIsConnected(unit) then
    return "|cff999999Off|r"
  end
  if(UnitIsDead(unit) or UnitIsGhost(unit)) then
    return "|cff999999Dead|r"
  end
  local min, max = UnitHealth(unit), UnitHealthMax(unit)
  local per = 0
  if max > 0 then
    per = floor(min/max*100)
  end
  local val = numFormat(min)
  return val.."|cffcccccc / |r"..per.."%"
end
oUF.Tags.Events["Lanuigi:hpdefault"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags.Methods["Lanuigi:hpvalue"] = function(unit)
  if not UnitIsConnected(unit) then
    return "|cff999999Off|r"
  end
  if(UnitIsDead(unit) or UnitIsGhost(unit)) then
    return "|cff999999Dead|r"
  end
  local min, max = UnitHealth(unit), UnitHealthMax(unit)
  local per = 0
  if max > 0 then
    per = floor(min/max*100)
  end
  local val = numFormat(min)
  return val
end
oUF.Tags.Events["Lanuigi:hpvalue"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags.Methods["Lanuigi:uppercasename"] = function(unit)
  local nam = UnitName(unit)
  local val = strupper(nam)
  return val
end
oUF.Tags.Events["Lanuigi:uppercasename"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["Lanuigi:hpperc"] = function(unit)
  if not UnitIsConnected(unit) then
    return "|cff999999Off|r"
  end
  if(UnitIsDead(unit) or UnitIsGhost(unit)) then
    return "|cff999999Dead|r"
  end
  local min, max = UnitHealth(unit), UnitHealthMax(unit)
  local per = 0
  if max > 0 then
    per = floor(min/max*100)
  end
  return per.."%"
end

oUF.Tags.Events["Lanuigi:hpperc"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags.Methods["Lanuigi:hpraid"] = function(unit)
  if not UnitIsConnected(unit) then
    return "|cff999999Off|r"
  end
  if(UnitIsDead(unit) or UnitIsGhost(unit)) then
    return "|cff999999Dead|r"
  end
  local min, max = UnitHealth(unit), UnitHealthMax(unit)
  if min == max and max > 0 then
    return UnitName(unit)
  end
  return "-"..numFormat(max-min)
end

oUF.Tags.Events["Lanuigi:hpraid"] = "UNIT_NAME_UPDATE UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"