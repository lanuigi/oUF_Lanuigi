
  -- // oUF_Lanuigi2, an oUF tutorial layout
  -- // zork - 2011

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  --get the config values
  local cfg = ns.cfg
  local dragFrameList = ns.dragFrameList
  --holder for some lib functions
  local lib = CreateFrame("Frame")
  ns.lib = lib

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --backdrop table
  local backdrop_tab = {
    bgFile = cfg.backdrop_texture,
    edgeFile = cfg.backdrop_edge_texture,
    tile = false,
    tileSize = 0,
    edgeSize = 5,
    insets = {
      left = 5,
      right = 5,
      top = 5,
      bottom = 5,
    },
  }

  --backdrop func
  lib.gen_backdrop = function(f)
    f:SetBackdrop(backdrop_tab);
    f:SetBackdropColor(0,0,0,0.8)
    f:SetBackdropBorderColor(0,0,0,1)
  end

  --fontstring func
  lib.gen_fontstring = function(f, name, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(name, size, outline)
    fs:SetShadowColor(0,0,0,0.5)
    fs:SetShadowOffset(0,-0)
    return fs
  end

  local dropdown = CreateFrame("Frame", addon.."DropDown", UIParent, "UIDropDownMenuTemplate")

  UIDropDownMenu_Initialize(dropdown, function(self)
    local unit = self:GetParent().unit
    if not unit then return end
    local menu, name, id
    if UnitIsUnit(unit, "player") then
      menu = "SELF"
    elseif UnitIsUnit(unit, "vehicle") then
      menu = "VEHICLE"
    elseif UnitIsUnit(unit, "pet") then
      menu = "PET"
    elseif UnitIsPlayer(unit) then
      id = UnitInRaid(unit)
      if id then
        menu = "RAID_PLAYER"
        name = GetRaidRosterInfo(id)
      elseif UnitInParty(unit) then
        menu = "PARTY"
      else
        menu = "PLAYER"
      end
    else
      menu = "TARGET"
      name = RAID_TARGET_ICON
    end
    if menu then
      UnitPopup_ShowMenu(self, menu, unit, name, id)
    end
  end, "MENU")

  lib.menu = function(self)
    dropdown:SetParent(self)
    ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
  end

  --remove focus from menu list
  do
    for k,v in pairs(UnitPopupMenus) do
      for x,y in pairs(UnitPopupMenus[k]) do
        if y == "SET_FOCUS" then
          table.remove(UnitPopupMenus[k],x)
        elseif y == "CLEAR_FOCUS" then
          table.remove(UnitPopupMenus[k],x)
        end
      end
    end
  end

  --update health func
  lib.updateHealth = function(bar, unit, min, max)
    --color the hp bar in red if the unit has aggro
    --if not the preset color does not get overwritten
    if unit and UnitThreatSituation(unit) == 3 then
		bar.bo:SetBackdropBorderColor(1,0,0,1)
	else
		bar.bo:SetBackdropBorderColor(0,0,0,1)
    end

  end

  --check threat
  lib.checkThreat = function(f,event,unit)
    --force an update on the health frame
    f.Health:ForceUpdate()
  end

  --gen healthbar func
  lib.gen_hpbar = function(f)
    --statusbar
    local s = CreateFrame("StatusBar", nil, f)
    s:SetStatusBarTexture(cfg.statusbar_texture)
    s:SetHeight(f.height)
    s:SetWidth(f.width)
    s:SetPoint("CENTER",0,0)
    --helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h)
    --bg
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(cfg.statusbar_texture)
    b:SetAllPoints(s)

    --debuff highlight
    local dbh = s:CreateTexture(nil, "OVERLAY")
    dbh:SetAllPoints(f)
    dbh:SetTexture(cfg.debuff_highlight_texture)
    dbh:SetBlendMode("ADD")
    dbh:SetVertexColor(0,0,0,0)

    f.DebuffHighlightAlpha = 1
    f.DebuffHighlightFilter = false

    f.DebuffHighlight = dbh
    f.Health = s
    f.Health.bg = b
	f.Health.bo = h

    f.Health.PostUpdate = lib.updateHealth
    f:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", lib.checkThreat)
	f:RegisterEvent("PLAYER_TARGET_CHANGED", lib.checkThreat)
	f:RegisterEvent("RAID_ROSTER_UPDATE", lib.checkThreat)


  end

  --gen hp strings func
  lib.gen_hpstrings = function(f)

    local name, hpval

    --health/name text strings
    if not f.hidename then
		if f.mystyle == "tot" then
			name = lib.gen_fontstring(f.Health, cfg.font, 16, "THINOUTLINE")
			name:SetPoint("LEFT", f.Health, "LEFT", 2, 32)
			name:SetJustifyH("LEFT")
		elseif f.mystyle == "raid" then
			name = lib.gen_fontstring(f.Health, cfg.font, 10, "THINOUTLINE")
			name:SetPoint("LEFT", f.Health, "LEFT", 0, 26)
			name:SetJustifyH("LEFT")
		elseif f.mystyle == "party" then
			name = lib.gen_fontstring(f.Health, cfg.font, 10, "THINOUTLINE")
			name:SetPoint("LEFT", f.Health, "LEFT", 0, 12)
			name:SetJustifyH("LEFT")
		elseif f.mystyle == "raid40" then
			name = lib.gen_fontstring(f.Health, cfg.font, 10, "THINOUTLINE")
			name:SetPoint("LEFT", f.Health, "LEFT", 0, 12)
			name:SetJustifyH("LEFT")
		else
			name = lib.gen_fontstring(f.Health, cfg.font, 26, "THINOUTLINE")
			name:SetPoint("LEFT", f.Health, "LEFT", 0, 32)
			name:SetJustifyH("LEFT")
		end
    end
	if f.mystyle == "raid" or f.mystyle == "raid40" or f.mystyle == "tot" or f.mystyle == "party" then
		hpval = lib.gen_fontstring(f.Health, cfg.font, 16, "THINOUTLINE")
		hpval:SetPoint("RIGHT", f.Health, "RIGHT", -2, 0)
	else
		hpval = lib.gen_fontstring(f.Health, cfg.font, 26, "THINOUTLINE")
		hpval:SetPoint("RIGHT", f.Health, "RIGHT", -2, 0)
	end
    if f.hidename then
      hpval:SetJustifyH("CENTER")
      hpval:SetPoint("LEFT", f.Health, "LEFT", 2, 0)
    else
	  if f.mystyle ~= "player" and f.mystyle ~= "target" and f.mystyle ~= "pet" and f.mystyle ~= "raid" and f.mystyle ~= "focus" and f.mystyle ~= "party" and f.mystyle ~="raid40" then
      --this will make the name go "..." when its to long
		if f.mystyle == "raid40" then
			name:SetPoint("RIGHT", hpval, "LEFT", 4, 0)
			hpval:SetJustifyH("RIGHT")
		elseif f.mystyle == "tot" then
			name:SetPoint("RIGHT", hpval, "LEFT", 54, 0)
			hpval:SetJustifyH("RIGHT")
		else
			name:SetPoint("RIGHT", hpval, "LEFT", -5, 0)
			hpval:SetJustifyH("RIGHT")
		end
	  end
      if f.nametag then
        f:Tag(name, f.nametag)
      else
        f:Tag(name, "[Lanuigi:uppercasename]")
      end
    end

    if f.hptag then
		f:Tag(hpval, f.hptag)
    else
		if f.mystyle == "raid40" then
		
		else
			f:Tag(hpval, "[Lanuigi:hpvalue]")
		end
    end

  end

  --gen healthbar func
  lib.gen_ppbar = function(f)
    --statusbar
    local s = CreateFrame("StatusBar", nil, f)
    s:SetStatusBarTexture(cfg.statusbar_texture)
    s:SetHeight((f.height/5)+6)
    s:SetWidth(f.width)
    s:SetPoint("TOP",f,"BOTTOM",0,4)
    --helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h)
    --bg
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(cfg.statusbar_texture)
    b:SetAllPoints(s)
    f.Power = s
    f.Power.bg = b
  end

  --moveme func
  lib.moveme = function(f)
    f:SetMovable(true)
    f:SetUserPlaced(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton","RightButton")
    --f:SetScript("OnDragStart", function(self) if IsAltKeyDown() and IsShiftKeyDown() then self:StartMoving() end end)
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  end

  
  --gen castbar
  lib.gen_castbar = function(f)

    local s = CreateFrame("StatusBar", "oUF_LanuigiCastbar"..f.mystyle:sub(1,1):upper()..f.mystyle:sub(2), f)
    s:SetHeight(25)
    s:SetWidth(200)
    if f.mystyle == "player" then
      --lib.moveme(s)
      rCreateDragFrame(s, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
      s:SetPoint("CENTER",UIParent,0,-50)
    elseif f.mystyle == "target" then
      --lib.moveme(s)
      rCreateDragFrame(s, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
      s:SetPoint("CENTER",UIParent,0,0)
    else
      s:SetPoint("BOTTOM",f,"TOP",0,5)
    end
    s:SetStatusBarTexture(cfg.statusbar_texture)
    s:SetStatusBarColor(1,0.8,0,1)
    --helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h)

    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(cfg.statusbar_texture)
    b:SetAllPoints(s)
    b:SetVertexColor(1*0.3,0.8*0.3,0,0.7)

    local txt = lib.gen_fontstring(s, cfg.font, 16, "THINOUTLINE")
    txt:SetPoint("LEFT", 2, 0)
    txt:SetJustifyH("LEFT")
    --time
    local t = lib.gen_fontstring(s, cfg.font, 16, "THINOUTLINE")
    t:SetPoint("RIGHT", -2, 0)
    txt:SetPoint("RIGHT", t, "LEFT", -5, 0)
	

    --icon
    local i = s:CreateTexture(nil, "ARTWORK")
    i:SetWidth(32)
    i:SetHeight(32)
    i:SetPoint("RIGHT", s, "LEFT", -5, 0)
    i:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    --helper2 for icon
    local h2 = CreateFrame("Frame", nil, s)
    h2:SetFrameLevel(0)
    h2:SetPoint("TOPLEFT",i,"TOPLEFT",-5,5)
    h2:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h2)

    if f.mystyle == "player" then
      --latency only for player unit
      local z = s:CreateTexture(nil,"OVERLAY")
      z:SetTexture(cfg.statusbar_texture)
      z:SetVertexColor(0.6,0,0,0.6)
      z:SetPoint("TOPRIGHT")
      z:SetPoint("BOTTOMRIGHT")
      s.SafeZone = z
    end

    f.Castbar = s
    f.Castbar.Text = txt
    f.Castbar.Time = t
    f.Castbar.Icon = i
	
  end

  	lib.CustomCastTimeText = function(self, duration)
        self.Time:SetText(("%.1f"):format(self.channeling and duration or self.max - duration, self.max))
    end
  
  lib.gen_portrait = function(f)
    if cfg.hideportraits then return end
    local p = CreateFrame("PlayerModel", nil, f)
	if f.mystyle == "pet" then
		p:SetWidth(60)
		p:SetHeight(60)
    else
		p:SetWidth(140)
		p:SetHeight(140)
    end
    if f.mystyle == "pet" then
      p:SetPoint("TOPRIGHT", f, "TOPLEFT", 90, 65)
    else
      p:SetPoint("TOPRIGHT", f, "TOPLEFT", 130, 210)
    end

    --helper
    local h = CreateFrame("Frame", nil, p)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h)

    f.Portrait = p
  end

  lib.PostCreateIcon = function(self, button)
    button.cd:SetReverse()
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    button.icon:SetDrawLayer("BACKGROUND")
    --count
    button.count:ClearAllPoints()
    button.count:SetJustifyH("RIGHT")
    button.count:SetPoint("TOPRIGHT", 2, 2)
    button.count:SetTextColor(0.7,0.7,0.7)
    --helper
    local h = CreateFrame("Frame", nil, button)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h)
  end
  
  local whitelist = {
	[GetSpellInfo(25771)] = true, -- Forbearance
}
  
  lib.CustomAuraFilterRaid = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff)
    local ret = false
    if(whitelist[name]) then
      ret = true
    elseif isBossDebuff then
      ret = true
    elseif caster and caster:match("(boss)%d?$") == "boss" then
      ret = true
    end
    return ret
  end

  
  lib.createBuffs = function(f)
    b = CreateFrame("Frame", nil, f)
    b.size = 30
    if f.mystyle == "target" then
      b.num = 4
    elseif f.mystyle == "player" then
      b.num = 10
      b.onlyShowPlayer = true
    else
      b.num = 5
    end
    b.spacing = 10
    b.onlyShowPlayer = false
    b:SetHeight((b.size+b.spacing)*4)
    b:SetWidth(f.width)
    b:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 30)
    b.initialAnchor = "BOTTOMLEFT"
    b["growth-x"] = "RIGHT"
    b["growth-y"] = "UP"
    b.PostCreateIcon = lib.PostCreateIcon
    f.Buffs = b
  end

  lib.createDebuffs = function(f)
    b = CreateFrame("Frame", nil, f)
    b.size = 20
    if f.mystyle == "target" then
      b.num = 9
	  b.size = 30
    elseif f.mystyle == "player" then
      b.num = 10
    elseif f.mystyle == "raid" or f.mystyle == "raid40" then
	  b.num = 1
	else
      b.num = 5
    end
    b.spacing = 5
    b.onlyShowPlayer = false
    b:SetHeight((b.size+b.spacing)*4)
    b:SetWidth(f.width)
	if f.mystyle == "raid" or f.mystyle == "raid40" then
		b.CustomFilter	= lib.CustomAuraFilterRaid
		b:SetPoint("TOPLEFT", f.Power, "BOTTOMLEFT", 0, 20)
	elseif f.mystyle == "target" then
		b:SetPoint("TOPLEFT", f.Power, "BOTTOMLEFT", 0, -15)
	else
		b:SetPoint("TOPLEFT", f.Power, "BOTTOMLEFT", 0, -5)
	end
    b.initialAnchor = "TOPLEFT"
    b["growth-x"] = "RIGHT"
    b["growth-y"] = "DOWN"
    b.PostCreateIcon = lib.PostCreateIcon
    f.Debuffs = b
  end
