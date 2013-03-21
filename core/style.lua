
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
    self.height = 35
    self.mystyle = "player"
    init(self)
    self.Health.colorClass = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3

  end

  --the target style
  local function CreateTargetStyle(self)
    --style specific stuff
    self.width = 110
    self.height = 35
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
  end

  --the tot style
  local function CreateToTStyle(self)
    --style specific stuff
    self.width = 50
    self.height = 25
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
    self.width = 180
    self.height = 25
    self.mystyle = "focus"
    init(self)
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

  --the pet style
  local function CreatePetStyle(self)
    --style specific stuff
    self.width = 110
    self.height = 35
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
    self.width = 180
    self.height = 25
    self.mystyle = "party"
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
    lib.gen_portrait(self)
    lib.createDebuffs(self)
  end

  --party frames
  local function CreateRaidStyle(self)
    --style specific stuff
    self.width = 100
    self.height = 30
    self.mystyle = "raid"
    self.hptag = "[Lanuigi:hpraid]"
    self.hidename = true
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
        self:SetHeight(30)
        self:SetWidth(100)
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
        self:SetHeight(30)
        self:SetWidth(100)
      ]]
    )
    raid25:SetPoint("CENTER",UIParent,"CENTER",0,0)

    --setup for 40 man raid

    oUF:RegisterStyle("oUF_LanuigiRaid40", CreateRaidStyle)
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
        self:SetHeight(30)
        self:SetWidth(100)
      ]]
    )
    raid40:SetPoint("CENTER",UIParent,"CENTER",0,0)

  end
