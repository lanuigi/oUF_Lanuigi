
  -- // oUF_Lanuigi an oUF tutorial layout
  -- // zork - 2012

  --get the addon namespace
  local addon, ns = ...

  --get the config values
  local cfg = ns.cfg
  --get the library
  local lib = ns.lib
  local dragFrameList = ns.dragFrameList

  --fix oUF mana color
  oUF.colors.power["MANA"] = {0, 0.4, 0.9}

  -----------------------------
  -- STYLE FUNCTIONS
  -----------------------------
  

  --init func
  local initHeader = function(self)
    self.menu = lib.menu
    self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type2", "menu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    lib.gen_hpbar(self)
    lib.gen_hpstrings(self)
    lib.gen_ppbar(self)
  end

  --init func
  local init = function(self)
    self:SetSize(self.width, self.height)
    self:SetPoint("CENTER",UIParent,"CENTER",0,0)
    self:SetScale(cfg.unitscale)
    rCreateDragFrame(self, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
    initHeader(self)
  end

  --the player style
  local function CreatePlayerStyle(self)
    --style specific stuff
    self.width = 110
    self.height = 30
    self.mystyle = "player"
    init(self)
    self.Health.colorClass = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
	lib.gen_castbar(self)
	
    self.Castbar.CustomTimeText = lib.CustomCastTimeText
	
	local Combat = self.Health:CreateTexture(nil, "OVERLAY")
	Combat:SetSize(32, 32)
	Combat:SetPoint('TOP', self, "TOP", -25, 0)
	-- Register it with oUF
	self.Combat = Combat
	
	local ClassIcons = {}
	for index = 1, 5 do
		local Icon = self:CreateTexture(nil, 'BACKGROUND')
		-- Position and size.
		Icon:SetSize(24, 24)
		Icon:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', index * (1.4 * Icon:GetWidth())-28, 100)
		Icon:SetTexture("Interface\\AddOns\\oUF_Lanuigi\\media\\statusbar2")
		local class, classFileName = UnitClass("player");
		local color = RAID_CLASS_COLORS[classFileName]
		Icon:SetVertexColor(color.r, color.g, color.b, 1)
		ClassIcons[index] = Icon
	end
	-- Register with oUF
	self.ClassIcons = ClassIcons
	
	local PvP = self.Health:CreateTexture(nil, 'OVERLAY')
	PvP:SetSize(64, 64)
	PvP:SetPoint('TOPLEFT', self, 'TOPLEFT', -18, 0)
	-- Register it with oUF
	self.PvP = PvP
	

  end

  --the target style
  local function CreateTargetStyle(self)
    --style specific stuff
    self.width = 110
    self.height = 30
    self.mystyle = "target"
    init(self)
    self.Health.colorTapping = true
    self.Health.colorDisconnected = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
    lib.createBuffs(self)
    lib.createDebuffs(self)
	
	-- Position and size
	local RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	RaidIcon:SetSize(32, 32)
	RaidIcon:SetPoint('TOPLEFT', self)
	-- Register it with oUF
	self.RaidIcon = RaidIcon

	local CPoints = {}
	for index = 1, MAX_COMBO_POINTS do
		local CPoint = self:CreateTexture("StatusBar", 'BACKGROUND')
		-- Position and size of the combo point.
		CPoint:SetSize(16, 16)
		CPoint:SetTexture("Interface\\AddOns\\oUF_Lanuigi\\media\\statusbar2")
		if index < 4 then
			CPoint:SetVertexColor(1,0.8,0.3,1);
		elseif index == 4 then
			CPoint:SetVertexColor(0,1,0,1);		
		elseif index == 5 then 
			CPoint:SetVertexColor(1,0,0,1);	
		else
			CPoint:SetVertexColor(0,1,1,1);		
		end
		CPoint:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -22, (index * CPoint:GetHeight())  + 8)
		CPoints[index] = CPoint
	end
	-- Register with oUF
	self.CPoints = CPoints
  end

  --the tot style
  local function CreateToTStyle(self)
    --style specific stuff
    self.width = 50
    self.height = 20
    self.mystyle = "tot"
    self.hptag = "[Lanuigi:hpperc]"
    init(self)
    self.Health.colorTapping = true
    self.Health.colorDisconnected = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
    lib.createDebuffs(self)
  end

  --the focus style
  local function CreateFocusStyle(self)
    --style specific stuff
    self.width = 110
    self.height = 30
    self.mystyle = "focus"
    init(self)
    self.Health.colorDisconnected = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
    
    lib.createDebuffs(self)
  end

  --the pet style
  local function CreatePetStyle(self)
    --style specific stuff
    self.width = 110
    self.height = 30
    self.mystyle = "pet"
    --init
    init(self)
    --stuff
    self.Health.colorDisconnected = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
 
    lib.gen_portrait(self)
    lib.createDebuffs(self)
  end

  --now header units, examples for party, raid10, raid25, raid40

  --party frames
  local function CreatePartyStyle(self)
    --style specific stuff
    --style specific stuff
    self.width = 45
    self.height = 25
    self.mystyle = "party"
	self.hptag = "[Lanuigi:hpraid]"
    --init
    initHeader(self)
    --stuff
    self.Health.colorDisconnected = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
	
	self.Range = {
		insideAlpha = 1,
		outsideAlpha = 0.2
	}	

	local LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRole:SetSize(16, 16)
	LFDRole:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 10, 0)
	-- Register it with oUF
	self.LFDRole = LFDRole
  end

  --party frames
  local function CreateRaidStyle(self)
    --style specific stuff
    self.width = 45
    self.height = 25
    self.mystyle = "raid"
    self.hptag = "[Lanuigi:hpraid]"
    --init
    initHeader(self)
    --stuff
    self.Health.colorDisconnected = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
	lib.createDebuffs(self)
	
	local RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint('CENTER', self, 'CENTER', 0, 15)
	-- Register it with oUF
	self.RaidIcon = RaidIcon
	
	self.Range = {
		insideAlpha = 1,
		outsideAlpha = 0.2
	}	

	local LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRole:SetSize(16, 16)
	LFDRole:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 10, 0)
	-- Register it with oUF
	self.LFDRole = LFDRole
  end
  
    local function CreateRaid40Style(self)
    --style specific stuff
    self.width = 30
    self.height = 15
    self.mystyle = "raid40"
    --init
    initHeader(self)
    --stuff
    self.Health.colorDisconnected = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
	
	self.Range = {
		insideAlpha = 1,
		outsideAlpha = 0.2
	}	
	
	local LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRole:SetSize(16, 16)
	LFDRole:SetPoint("CENTER", self, "CENTER", 0, 0)
	-- Register it with oUF
	self.LFDRole = LFDRole
  end
	
  local function CreateArenaStyle(self)
    --style specific stuff
    self.width = 45
    self.height = 25
    self.mystyle = "arena"
    --init
    initHeader(self)
    --stuff
    self.Health.colorDisconnected = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
	
	self.Range = {
		insideAlpha = 1,
		outsideAlpha = 0.2
	}	
  end
  
  
  -----------------------------
  -- SPAWN UNITS
  -----------------------------

  if cfg.showplayer then
    oUF:RegisterStyle("oUF_LanuigiPlayer", CreatePlayerStyle)
    oUF:SetActiveStyle("oUF_LanuigiPlayer")
    oUF:Spawn("player","oUF_LanuigiPlayer")
  end

  if cfg.showtarget then
    oUF:RegisterStyle("oUF_LanuigiTarget", CreateTargetStyle)
    oUF:SetActiveStyle("oUF_LanuigiTarget")
    oUF:Spawn("target","oUF_LanuigiTarget")
  end

  if cfg.showtot then
    oUF:RegisterStyle("oUF_LanuigiToT", CreateToTStyle)
    oUF:SetActiveStyle("oUF_LanuigiToT")
    oUF:Spawn("targettarget","oUF_LanuigiToT")
  end

  if cfg.showfocus then
    oUF:RegisterStyle("oUF_LanuigiFocus", CreateFocusStyle)
    oUF:SetActiveStyle("oUF_LanuigiFocus")
    oUF:Spawn("focus","oUF_LanuigiFocus")
  end

  if cfg.showpet then
    oUF:RegisterStyle("oUF_LanuigiPet", CreatePetStyle)
    oUF:SetActiveStyle("oUF_LanuigiPet")
    oUF:Spawn("pet","oUF_LanuigiPet")
  end
  
  if cfg.showparty then
	oUF:RegisterStyle("oUF_LanuigiParty", CreatePartyStyle)
    oUF:SetActiveStyle("oUF_LanuigiParty")

    local party = oUF:SpawnHeader(
      "oUF_LanuigiParty",
      nil,
      "custom [@raid1,exists] hide; [group:party,nogroup:raid] show; hide",
      "showPlayer",         true,
      "showSolo",           false,
      "showParty",          true,
      "showRaid",           false,
      "point",              "TOP",
      "yOffset",            -24,
      "xoffset",            0,
      "oUF-initialConfigFunction", [[
        self:SetHeight(30)
        self:SetWidth(45)
      ]]
    )
    party:SetPoint("CENTER",UIParent,"CENTER",0,0)

  end

  
  if cfg.showarena then
	oUF:RegisterStyle("oUF_LanuigiArena", CreateArenaStyle)
    oUF:SetActiveStyle("oUF_LanuigiArena")
    oUF:Spawn("arena")
	
	local arena = {}
	for i = 1, 5 do
		if i == 1 then
			arena[i] = oUF:Spawn("arena"..i, "oUF_LanuigiArena"..i);
			arena[i]:SetPoint("RIGHT", UIParent, "RIGHT", -45, 30);
			arena[i]:SetSize(60, 35);
		else
			arena[i] = oUF:Spawn("arena"..i, "oUF_LanuigiArena"..i);
			arena[i]:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
			arena[i]:SetSize(45, 25);
		end
	end
	
  
  end
  
  if cfg.showraid then

    --die raid panel, die
    CompactRaidFrameManager:UnregisterAllEvents()
    CompactRaidFrameManager.Show = CompactRaidFrameManager.Hide
    CompactRaidFrameManager:Hide()

    CompactRaidFrameContainer:UnregisterAllEvents()
    CompactRaidFrameContainer.Show = CompactRaidFrameContainer.Hide
    CompactRaidFrameContainer:Hide()

    --setup for 10 man raid
    oUF:RegisterStyle("oUF_LanuigiRaid10", CreateRaidStyle)
    oUF:SetActiveStyle("oUF_LanuigiRaid10")

    local raid10 = oUF:SpawnHeader(
      "oUF_LanuigiRaid10",
      nil,
      "custom [@raid11,exists] hide; [@raid1,exists] show; hide",
      "showPlayer",         false,
      "showSolo",           false,
      "showParty",          false,
      "showRaid",           true,
      "point",              "LEFT",
      "yOffset",            0,
      "xoffset",            28,
      "columnSpacing",      37,
      "columnAnchorPoint",  "TOP",
      "groupFilter",        "1,2,3,4,5,6,7,8",
      "groupBy",            "GROUP",
      "groupingOrder",      "1,2,3,4,5,6,7,8",
      "sortMethod",         "NAME",
      "maxColumns",         8,
      "unitsPerColumn",     5,
      "oUF-initialConfigFunction", [[
        self:SetHeight(30)
        self:SetWidth(45)
      ]]
    )
    raid10:SetPoint("CENTER",UIParent,"CENTER",0,0)

    --setup for 25 man raid

    oUF:RegisterStyle("oUF_LanuigiRaid25", CreateRaidStyle)
    oUF:SetActiveStyle("oUF_LanuigiRaid25")

    local raid25 = oUF:SpawnHeader(
      "oUF_LanuigiRaid25",
      nil,
      "custom [@raid26,exists] hide; [@raid11,exists] show; hide",
      "showPlayer",         false,
      "showSolo",           false,
      "showParty",          false,
      "showRaid",           true,
      "point",              "LEFT",
      "yOffset",            0,
      "xoffset",            28,
      "columnSpacing",      37,
      "columnAnchorPoint",  "TOP",
      "groupFilter",        "1,2,3,4,5,6,7,8",
      "groupBy",            "GROUP",
      "groupingOrder",      "1,2,3,4,5,6,7,8",
      "sortMethod",         "NAME",
      "maxColumns",         8,
      "unitsPerColumn",     5,
      "oUF-initialConfigFunction", [[
        self:SetHeight(30)
        self:SetWidth(45)
      ]]
    )
    raid25:SetPoint("CENTER",UIParent,"CENTER",0,0)

    --setup for 40 man raid

    oUF:RegisterStyle("oUF_LanuigiRaid40", CreateRaid40Style)
    oUF:SetActiveStyle("oUF_LanuigiRaid40")

    local raid40 = oUF:SpawnHeader(
      "oUF_LanuigiRaid40",
      nil,
      "custom [@raid26,exists] show; hide",
      "showPlayer",         false,
      "showSolo",           false,
      "showParty",          false,
      "showRaid",           true,
      "point",              "LEFT",
      "yOffset",            0,
      "xoffset",            10,
      "columnSpacing",      17,
      "columnAnchorPoint",  "TOP",
      "groupFilter",        "1,2,3,4,5,6,7,8",
      "groupBy",            "GROUP",
      "groupingOrder",      "1,2,3,4,5,6,7,8",
      "sortMethod",         "NAME",
      "maxColumns",         8,
      "unitsPerColumn",     5,
      "oUF-initialConfigFunction", [[
        self:SetHeight(20)
        self:SetWidth(30)
      ]]
    )
    raid40:SetPoint("CENTER",UIParent,"CENTER",0,0)

  end
