local addonName, addon = ...
local L = addon
addon.version = GetAddOnMetadata(addonName, "Version")

function addon.CreateConfig()

	addon.panel = CreateFrame("Frame", addonName.."panel", UIParent)
	addon.panel.name = addonName
	InterfaceOptions_AddCategory(addon.panel)

	addon.title = addon.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	addon.title:SetPoint("TOPLEFT", 16, -16)
	addon.title:SetText(addonName)

	addon.subtitle = addon.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	addon.subtitle:SetPoint("TOPLEFT", addon.title, "BOTTOMLEFT", 0, -8)
	addon.subtitle:SetNonSpaceWrap(true)
	addon.subtitle:SetText("Version"..addon.version)
	
	addon.subtitle1 = addon.panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	addon.subtitle1:SetPoint("TOPLEFT", addon.subtitle, "BOTTOMLEFT", 0, -20)
	addon.subtitle1:SetText(L["Player interrupts"])
	
	addon.subtitle2 = addon.panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	addon.subtitle2:SetPoint("TOPLEFT", addon.subtitle, "BOTTOMLEFT", 300, -20)
	addon.subtitle2:SetText(L["Party interrupts"])
	
	local p1 = addon.panel
	p1.checkbox1 = {}
	p1.checkbox2 = {}
	p1.checkbox3 = {}
	p1.checkbox4 = {}
	p1.slider = {}
	----------------------------------
	-- player frame config start
	----------------------------------
	p1.checkbox1[1] = CreateFrame("CheckButton", addonName.."p1_checkbox1_1", p1, "ChatConfigCheckButtonTemplate")
	p1.checkbox1[1]:SetPoint("TOPLEFT", addon.subtitle1, "BOTTOMLEFT", -5, -20)
	_G[p1.checkbox1[1]:GetName().."Text"]:SetText(L["Enable"])
	_G[p1.checkbox1[1]:GetName().."Text"]:SetPoint("LEFT",  p1.checkbox1[1], "RIGHT", 3, 1)
	p1.checkbox1[1].tooltip = L["Click to enable"]
	p1.checkbox1[1]:Show()
	
	p1.checkbox2[1] = CreateFrame("CheckButton", addonName.."p1_checkbox1_2", p1, "ChatConfigCheckButtonTemplate")
	p1.checkbox2[1]:SetPoint("TOPLEFT", p1.checkbox1[1], "BOTTOMLEFT", 20, -30)
	_G[p1.checkbox2[1]:GetName().."Text"]:SetText(L["Set movable"])
	_G[p1.checkbox2[1]:GetName().."Text"]:SetPoint("LEFT",  p1.checkbox2[1], "RIGHT", 3, 1)
	p1.checkbox2[1].tooltip = L["Click to make frame movable"]
	p1.checkbox2[1]:Show()
	p1.checkbox2[1]:SetScript("OnClick", function(self, button, down)
		if  p1.checkbox2[1]:GetChecked() then
			addon.db.char[1].Movable = true
		else
			addon.db.char[1].Movable = false
		end
		addon.LoadFrameOptions("Movable",1)
	end)
	
	p1.checkbox3[1] = CreateFrame("CheckButton", addonName.."p1_checkbox1_3", p1, "ChatConfigCheckButtonTemplate")
	p1.checkbox3[1]:SetPoint("TOPLEFT", p1.checkbox2[1], "BOTTOMLEFT", 0, -30)
	_G[p1.checkbox3[1]:GetName().."Text"]:SetText(L["Display name"])
	_G[p1.checkbox3[1]:GetName().."Text"]:SetPoint("LEFT",  p1.checkbox3[1], "RIGHT", 3, 1)
	p1.checkbox3[1].tooltip = L["Click to display the name of the interrupted enemy"]
	p1.checkbox3[1]:Show()
	p1.checkbox3[1]:SetScript("OnClick", function(self, button, down)
		if  p1.checkbox3[1]:GetChecked() then
			addon.db.global[1].showName = true
		else
			addon.db.global[1].showName = false
		end
		addon.LoadFrameOptions("showName",1)
	end)
	
	p1.checkbox4[1] = CreateFrame("CheckButton", addonName.."p1_checkbox1_4", p1, "ChatConfigCheckButtonTemplate")
	p1.checkbox4[1]:SetPoint("TOPLEFT", p1.checkbox3[1], "BOTTOMLEFT", 0, -30)
	_G[p1.checkbox4[1]:GetName().."Text"]:SetText(L["Display time in numbers"])
	_G[p1.checkbox4[1]:GetName().."Text"]:SetPoint("LEFT",  p1.checkbox4[1], "RIGHT", 3, 1)
	p1.checkbox4[1].tooltip = L["Click to display the duratation in numbers (better disable this option if you use addons like OmniCC)"]
	p1.checkbox4[1]:Show()
	p1.checkbox4[1]:SetScript("OnClick", function(self, button, down)
		if  p1.checkbox4[1]:GetChecked() then
			addon.db.global[1].showTime = true
		else
			addon.db.global[1].showTime = false
		end
		addon.LoadFrameOptions("showTime",1)
	end)
	
	p1.slider[1] = CreateFrame("Slider", addonName.."slider1", p1, "OptionsSliderTemplate")
	p1.slider[1]:SetPoint("TOPLEFT", p1.checkbox4[1], "BOTTOMLEFT", 5, -50)
	_G[p1.slider[1]:GetName().."Text"]:SetText(L["Frame scale: "] .. string.format("%.0f", addon.db.global[1].Scale*100).."%")
	p1.slider[1].tooltipText = L["Drag to set frame scale"]
	_G[p1.slider[1]:GetName().."Low"]:SetText("100%")
	_G[p1.slider[1]:GetName().."High"]:SetText("200%")
	p1.slider[1]:SetWidth(175)
	p1.slider[1]:SetMinMaxValues(1, 2)
	p1.slider[1]:SetValue(addon.db.global[1].Scale)
	p1.slider[1]:SetValueStep(0.1)
	p1.slider[1]:SetScript("OnValueChanged", function(self, value)
		addon.db.global[1].Scale = value
		_G[p1.slider[1]:GetName().."Text"]:SetText(L["Frame scale: "] .. string.format("%.0f", value*100).."%")
		addon.LoadFrameOptions("Size",1)
	end)
	
	-- OnClick script for checkbox1 is here because it disables/enables buttons declared after
	p1.checkbox1[1]:SetScript("OnClick", function(self, button, down)
		if  p1.checkbox1[1]:GetChecked() then
			addon.db.global[1].Enable = true
			p1.checkbox2[1]:Enable()
			p1.checkbox3[1]:Enable()
			p1.checkbox4[1]:Enable()
			p1.slider[1]:Enable()
		else
			addon.db.global[1].Enable = false
			p1.checkbox2[1]:Disable()
			p1.checkbox3[1]:Disable()
			p1.checkbox4[1]:Disable()
			p1.slider[1]:Disable()
		end
		addon.LoadFrameOptions("Enable",1)
	end)
	----------------------------------
	-- player frame config end
	----------------------------------
	
	----------------------------------
	-- party frame config start
	----------------------------------
	p1.checkbox1[2] = CreateFrame("CheckButton", addonName.."p1_checkbox2_1", p1, "ChatConfigCheckButtonTemplate")
	p1.checkbox1[2]:SetPoint("TOPLEFT", addon.subtitle2, "BOTTOMLEFT", -5, -20)
	_G[p1.checkbox1[2]:GetName().."Text"]:SetText(L["Enable"])
	_G[p1.checkbox1[2]:GetName().."Text"]:SetPoint("LEFT",  p1.checkbox1[2], "RIGHT", 3, 1)
	p1.checkbox1[2].tooltip = L["Click to enable"]
	p1.checkbox1[2]:Show()
	
	p1.checkbox2[2] = CreateFrame("CheckButton", addonName.."p1_checkbox2_2", p1, "ChatConfigCheckButtonTemplate")
	p1.checkbox2[2]:SetPoint("TOPLEFT", p1.checkbox1[2], "BOTTOMLEFT", 20, -30)
	_G[p1.checkbox2[2]:GetName().."Text"]:SetText(L["Set movable"])
	_G[p1.checkbox2[2]:GetName().."Text"]:SetPoint("LEFT",  p1.checkbox2[2], "RIGHT", 3, 1)
	p1.checkbox2[2].tooltip = L["Click to make frame movable"]
	p1.checkbox2[2]:Show()
	p1.checkbox2[2]:SetScript("OnClick", function(self, button, down)
		if  p1.checkbox2[2]:GetChecked() then
			addon.db.char[2].Movable = true
		else
			addon.db.char[2].Movable = false
		end
		addon.LoadFrameOptions("Movable",2)
	end)
	
	p1.checkbox3[2] = CreateFrame("CheckButton", addonName.."p1_checkbox2_3", p1, "ChatConfigCheckButtonTemplate")
	p1.checkbox3[2]:SetPoint("TOPLEFT", p1.checkbox2[2], "BOTTOMLEFT", 0, -30)
	_G[p1.checkbox3[2]:GetName().."Text"]:SetText(L["Display name"])
	_G[p1.checkbox3[2]:GetName().."Text"]:SetPoint("LEFT",  p1.checkbox3[2], "RIGHT", 3, 1)
	p1.checkbox3[2].tooltip = L["Click to display the name of the interrupted enemy"]
	p1.checkbox3[2]:Show()
	p1.checkbox3[2]:SetScript("OnClick", function(self, button, down)
		if  p1.checkbox3[2]:GetChecked() then
			addon.db.global[2].showName = true
		else
			addon.db.global[2].showName = false
		end
		addon.LoadFrameOptions("showName",2)
	end)
	
	p1.checkbox4[2] = CreateFrame("CheckButton", addonName.."p1_checkbox2_4", p1, "ChatConfigCheckButtonTemplate")
	p1.checkbox4[2]:SetPoint("TOPLEFT", p1.checkbox3[2], "BOTTOMLEFT", 0, -30)
	_G[p1.checkbox4[2]:GetName().."Text"]:SetText(L["Display time in numbers"])
	_G[p1.checkbox4[2]:GetName().."Text"]:SetPoint("LEFT",  p1.checkbox4[2], "RIGHT", 3, 1)
	p1.checkbox4[2].tooltip = L["Click to display the duratation in numbers (better disable this option if you use addons like OmniCC)"]
	p1.checkbox4[2]:Show()
	p1.checkbox4[2]:SetScript("OnClick", function(self, button, down)
		if  p1.checkbox4[2]:GetChecked() then
			addon.db.global[2].showTime = true
		else
			addon.db.global[2].showTime = false
		end
		addon.LoadFrameOptions("showTime",2)
	end)
	
	p1.slider[2] = CreateFrame("Slider", addonName.."slider2", p1, "OptionsSliderTemplate")
	p1.slider[2]:SetPoint("TOPLEFT", p1.checkbox4[2], "BOTTOMLEFT", 5, -50)
	_G[p1.slider[2]:GetName().."Text"]:SetText(L["Frame scale: "] .. string.format("%.0f", addon.db.global[2].Scale*100).."%")
	p1.slider[2].tooltipText = L["Drag to set frame scale"]
	_G[p1.slider[2]:GetName().."Low"]:SetText("100%")
	_G[p1.slider[2]:GetName().."High"]:SetText("200%")
	p1.slider[2]:SetWidth(175)
	p1.slider[2]:SetMinMaxValues(1, 2)
	p1.slider[2]:SetValue(addon.db.global[2].Scale)
	p1.slider[2]:SetValueStep(0.1)
	p1.slider[2]:SetScript("OnValueChanged", function(self, value)
		addon.db.global[2].Scale = value
		_G[p1.slider[2]:GetName().."Text"]:SetText(L["Frame scale: "] .. string.format("%.0f", value*100).."%")
		addon.LoadFrameOptions("Size",2)
	end)
	
	-- OnClick script for checkbox1 is here because it disables/enables buttons declared after
	p1.checkbox1[2]:SetScript("OnClick", function(self, button, down)
		if  p1.checkbox1[2]:GetChecked() then
			addon.db.global[2].Enable = true
			p1.checkbox2[2]:Enable()
			p1.checkbox3[2]:Enable()
			p1.checkbox4[2]:Enable()
			p1.slider[2]:Enable()
		else
			addon.db.global[2].Enable = false
			p1.checkbox2[2]:Disable()
			p1.checkbox3[2]:Disable()
			p1.checkbox4[2]:Disable()
			p1.slider[2]:Disable()
		end
		addon.LoadFrameOptions("Enable",2)
	end)
	----------------------------------
	-- party frame config end
	----------------------------------
end

function addon.RegisterOptions()
	addon.update = CreateFrame("Frame")
	_G[addonName.."panel"]:SetScript("OnShow", function(...)
		addon.update:SetScript("OnUpdate", addon.LoadFrameOptions)
	end)
	_G[addonName.."panel"]:SetScript("OnHide", function(...)
		addon.update:SetScript("OnUpdate", nil)
	end)
end
