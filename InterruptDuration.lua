local addonName, addon = ...
local L = addon
addon.events = CreateFrame("Frame")
local addonDefaults_Global = {
	[1] = {
		["Size"] = {
			["Width"] = 40,
			["Height"] = 40,
		},
		["Scale"] = 1,
		["showName"] = true,
		["Enable"] = true,
		["showTime"] = true,
	},
	[2] = {	
		["Size"] = {
			["Width"] = 40,
			["Height"] = 40,
		},
		["Scale"] = 1,
		["showName"] = true,
		["Enable"] = true,
		["showTime"] = true,
	},
}
local addonDefaults_Character = {
	[1] = {
		["Pos"] = {
			["X"] = 800,
			["Y"] = 130,
		},
		["Movable"] = true,
	},
	[2] = {
		["Pos"] = {
			["X"] = 880,
			["Y"] = 130,
		},
		["Movable"] = true,
	},
}
local LastAddedOrRemovedFields = {
	["Global"] = {
		["Removed"] = {
			"Pos",
			"Movable",
		},
		["Added"] = {
			"showTime",
		}
	}
}
	
local spells = {
	[2139] = 6,   -- Counterspell
	[19647] = 6,  -- Spell Lock
	[47528] = 4,  -- Mind Freeze
	[1766] = 5,   -- Kick
	[93985] = 4,  -- Skull Bash
	[96231] = 4,  -- Rebuke
	[6552] = 4,   -- Pummel
	[57994] = 3,  -- Wind Shear
	[116705] = 5, -- Spear Hand Strike 
	[26679] = 6,  -- Deadly Throw
	[147362] = 3, -- Counter Shot
	[78675] = 4,  -- Solar Beam
}
for i=1,2 do
	local f = CreateFrame("Frame", "InterruptDurationFrame"..i, UIParent)
	f.t=f:CreateTexture(nil,"BORDER")
	f.t:SetAllPoints()
	f.t:SetTexture(0,0,0,0.6)
	f.c = CreateFrame("Cooldown",nil,f, "CooldownFrameTemplate")
	f.c:SetAllPoints()
	f.c:SetSwipeColor(0, 0, 0, 1)
	f.c:SetDrawEdge(false)
	f.name = f:CreateFontString(nil,"ARTWORK")
	f.name:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE")
	f.name:SetTextColor(1,1,0,0.6)
	f.name:SetPoint("TOP", f, "TOP", 0, 12)
	f.name:SetText(L["Enemy name"])
	f.c.timerText=f.c:CreateFontString(nil,"ARTWORK")
	f.c.timerText:SetFont(STANDARD_TEXT_FONT,22,"OUTLINE")
	f.c.timerText:SetTextColor(1,1,0,1)
	f.c.timerText:SetPoint("CENTER", f.c, "CENTER", 0, 0)
	f.what = f:CreateFontString(nil,"ARTWORK")
	f.what:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE")
	f.what:SetTextColor(1,1,0,0.6)
	f.what:SetPoint("CENTER", f, "CENTER", 0, 0)
	f.interrupts = {}
	if i==1 then
		f.what:SetText(L["Player"])
	else
		f.what:SetText(L["Party"])
	end
end

function AddRemoveFields(options,fields,defaults)
	if not fields then return end
	if fields.Added then
		for i,field in pairs(fields.Added) do
			if options[field] == nil then
				options[field] = defaults[field]
			end
		end
	end
	if fields.Removed then
		for i,field in pairs(fields.Removed) do
			if options[field] ~= nil then
				options[field] = nil
			end
		end
	end
end
 
function addon_COMBAT_LOG_EVENT_UNFILTERED_f1(self,event,...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, _, spellID, spellName, _, extraSkillID, extraSkillName = ...
		if eventType == "SPELL_INTERRUPT" and (sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet")) and spells[spellID] then
			local _, _, icon = GetSpellInfo(extraSkillID)
			self.t:SetTexture(icon)
			self:Show()
			self.c:SetCooldown(GetTime(), spells[spellID])
			self.name:SetText(destName)
			self.what:Hide()
			self.id = spellID
			self.start = GetTime()
			self:SetScript("OnUpdate", addon_TimerOnUpdate)
	-- elseif (sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet")) and spells[spellID] then
		-- print("other")
			-- self.interrupts.spell = spellID
			-- self.interrupts.unit = sourceGUID 
		-- end
	-- elseif event == "UNIT_SPELLCAST_INTERRUPTED" and self.interrupts then
	-- print("UNIT_SPELLCAST")
		-- unitID, spell, rank, lineID, spellID = ...
		-- local _, _, icon = GetSpellInfo(spellID)
		-- self.t:SetTexture(icon)
		-- self:Show()
		-- self.c:SetCooldown(GetTime(), spells[self.interrupts.spell])
		-- self.name:SetText(GetUnitName(unitID))
		-- self.what:Hide()
		-- self.id = self.interrupts.spell
		-- self:SetScript("OnUpdate", addon_TimerOnUpdate)
		-- self.interrupts = {}
		end
	end
end

function addon_COMBAT_LOG_EVENT_UNFILTERED_f2(self,event,...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, _, spellID, spellName, _, extraSkillID, extraSkillName = ...
		if eventType == "SPELL_INTERRUPT" and (sourceGUID == UnitGUID("party1") or sourceGUID == UnitGUID("party2") or sourceGUID == UnitGUID("party3") or sourceGUID == UnitGUID("party4") or
		sourceGUID == UnitGUID("party1pet") or sourceGUID == UnitGUID("party2pet") or sourceGUID == UnitGUID("party3pet") or sourceGUID == UnitGUID("party4pet")) and spells[spellID] then
			local _, _, icon = GetSpellInfo(extraSkillID)
			self.t:SetTexture(icon)
			self:Show()
			self.c:SetCooldown(GetTime(), spells[spellID])
			self.name:SetText(destName)
			self.what:Hide()
			self.id = spellID
			self.start = GetTime()
			self:SetScript("OnUpdate", addon_TimerOnUpdate)
			--print("Interrupted: "..extraSkillName.." ("..destName..")")
		--[[elseif (sourceGUID == UnitGUID("party1") or sourceGUID == UnitGUID("party2") or sourceGUID == UnitGUID("party3") or sourceGUID == UnitGUID("party4") or
		sourceGUID == UnitGUID("party1pet") or sourceGUID == UnitGUID("party2pet") or sourceGUID == UnitGUID("party3pet") or sourceGUID == UnitGUID("party4pet")) and spells[spellID] then
			self.interrupts.spell = spellID
			self.interrupts.unit = sourceGUID ]]--
		end
	--[[elseif event == "UNIT_SPELLCAST_INTERRUPTED" and self.interrupts then
		unitID, spell, rank, lineID, spellID = ...
		local _, _, icon = GetSpellInfo(spellID)
		self.t:SetTexture(icon)
		self:Show()
		self.c:SetCooldown(GetTime(), spells[self.interrupts.spell])
		self.name:SetText(GetUnitName(unitID))
		self.what:Hide()
		self.id = self.interrupts.spell
		self:SetScript("OnUpdate", addon_TimerOnUpdate)
		self.interrupts = {}]]--
	end
end

function addon.LoadFrameOptions(msg, fNum)
	for i=1,2 do
		if i == fNum or not fNum then
			f = _G["InterruptDurationFrame"..i]
			global = addon.db.global[i]
			char = addon.db.char[i]
			if msg == "Size" or not msg then
				f:SetSize(global.Size.Width*global.Scale, global.Size.Height*global.Scale)
			end
			if global.Enable then
				if msg == "Enable" or not msg then
					if not f:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED") then
						f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
						f:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
						if char.Movable then f:Show() end
					end
				end
				if msg == "showName" or not msg then
					if global.showName then
						f.name:Show() 
					else
						f.name:Hide()
					end
				end
				if msg == "showTime" or not msg then
					if global.showTime then
						f.c.timerText:Show() 
					else
						f.c.timerText:Hide()
					end
				end
				if msg == "Movable" or not msg then
					f.Movable = char.Movable
					f:SetMovable(char.Movable)
					if char.Movable then
						f:Show()
						f:SetScript("OnMouseDown", addon_OnMouseDown)
						f:SetScript("OnMouseUp", addon_OnMouseUp)
					else
						f:Hide()
						f:SetScript("OnMouseDown", nil)
						f:SetScript("OnMouseUp", nil)
					end
				end
			elseif msg == "Enable" or not msg then
				if f:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED") then
					f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
					f:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
				end
				f:Hide()
			end
		end
	end
end

function addon_TimerOnUpdate(self, elapsed)
	if spells[self.id]-(GetTime()-self.start) >= 0 then
		self.c.timerText:SetText(format("%1.1f", spells[self.id]-(GetTime()-self.start)))
	else
		self.c.timerText:SetText("")
	end
	if GetTime()-self.start-1 > spells[self.id] then
		self.t:SetTexture(0,0,0,0.6)
		self.what:Show()
		if not self.Movable then self:Hide() end
		self:SetScript("OnUpdate", nil)
	end
end

function addon_Options_SaveLoad(self,event)
	if event == "ADDON_LOADED" then
		print("|cFF00CC00InterruptDuration|r "..L["loaded"].."! "..L["Current version"]..": |cFF00CC00"..addon.version..".|r "..L["Type"].." |cFF00CC00/id|r "..L["to open configuration"])
		if not InterruptDurationOptions_Global then
			InterruptDurationOptions_Global = addonDefaults_Global
		end
		if not InterruptDurationOptions_Character then
			InterruptDurationOptions_Character = addonDefaults_Character
		end
		addon.db = {}
		addon.db.global = InterruptDurationOptions_Global
		addon.db.char = InterruptDurationOptions_Character
		for i=1,2 do
			AddRemoveFields(addon.db.global[i],LastAddedOrRemovedFields.Global,addonDefaults_Global[i])
			AddRemoveFields(addon.db.char[i],LastAddedOrRemovedFields.Character,addonDefaults_Character[i])
		end
		InterruptDurationFrame1:SetPoint("BOTTOMLEFT",addon.db.char[1].Pos.X, addon.db.char[1].Pos.Y)
		InterruptDurationFrame2:SetPoint("BOTTOMLEFT",addon.db.char[2].Pos.X, addon.db.char[2].Pos.Y)
		addon.LoadFrameOptions()
		addon.CreateConfig()
		for i=1,2 do
			addon.panel.checkbox2[i]:SetChecked(addon.db.char[i].Movable)
			addon.panel.checkbox3[i]:SetChecked(addon.db.global[i].showName)
			addon.panel.checkbox4[i]:SetChecked(addon.db.global[i].showTime)
			addon.panel.slider[i]:SetValue(addon.db.global[i].Scale)
			addon.panel.checkbox1[i]:SetChecked(addon.db.global[i].Enable)
			if addon.db.global[i].Enable then
				addon.panel.checkbox2[i]:Enable()
				addon.panel.checkbox3[i]:Enable()
				addon.panel.checkbox4[i]:Enable()
				addon.panel.slider[i]:Enable()
			else
				addon.panel.checkbox2[i]:Disable()
				addon.panel.checkbox3[i]:Disable()
				addon.panel.checkbox4[i]:Disable()
				addon.panel.slider[i]:Disable()
			end
		end
		self:UnregisterEvent("ADDON_LOADED")
	elseif event == "PLAYER_LOGOUT" then
		for i=1,2 do
			addon.db.char[i].Pos.X = _G["InterruptDurationFrame"..i]:GetLeft()
			addon.db.char[i].Pos.Y = _G["InterruptDurationFrame"..i]:GetBottom()
		end
		InterruptDurationOptions_Global = addon.db.global
		InterruptDurationOptions_Character = addon.db.char
	end
end

addon.events:RegisterEvent("ADDON_LOADED")
addon.events:RegisterEvent("PLAYER_LOGOUT")
addon.events:SetScript("OnEvent", addon_Options_SaveLoad)

function addon_OnMouseUp(self, button)
	if button == "LeftButton" then
		self:StopMovingOrSizing()
	end
end

function addon_OnMouseDown(self, button)
	if button == "LeftButton" and self:IsMovable() then
		self:StartMoving()
	elseif button == "RightButton" then
		InterfaceOptionsFrame_OpenToCategory(addon.panel)
		InterfaceOptionsFrameOkay:Click("button", down)
		InterfaceOptionsFrame_OpenToCategory(addon.panel)
	end
end

for i=1,2 do
	_G["InterruptDurationFrame"..i]:SetScript("OnEvent", _G["addon_COMBAT_LOG_EVENT_UNFILTERED_f"..i])
	_G["InterruptDurationFrame"..i]:SetScript("OnMouseDown", addon_OnMouseDown)
end

function SlashCmdList.INTERRUPTDURATION(msg)
	InterfaceOptionsFrame_OpenToCategory(addon.panel)
	InterfaceOptionsFrameOkay:Click("button", down)
	InterfaceOptionsFrame_OpenToCategory(addon.panel)
end
SLASH_INTERRUPTDURATION1 = "/id"