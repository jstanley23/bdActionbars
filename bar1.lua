local addon, ab = ...
local config = bdCore.config["Actionbars"]

bdCore:makeMovable(ab.bar1)

function ab.bar1.UpdateBar1()
	local Button

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		Button = _G["ActionButton"..i]
		ab.bar1:SetFrameRef("ActionButton"..i, Button)
	end	

	ab.bar1:Execute([[
		Button = table.new()
		for i = 1, 12 do
			table.insert(Button, self:GetFrameRef("ActionButton"..i))
		end
	]])

	ab.bar1:SetAttribute("_onstate-page", [[ 
		if HasTempShapeshiftActionBar() then
			newstate = GetTempShapeshiftBarIndex() or newstate
		end

		for i, Button in ipairs(Button) do
			Button:SetAttribute("actionpage", tonumber(newstate))
		end
	]])

	RegisterStateDriver(ab.bar1, "page", ab.bar1.GetBar())
end

function ab.bar1:GetBar()
	local Class = select(2, UnitClass("player"))
	local Druid, Warrior, Priest, Rogue, Warlock, Monk = "", "", "", "", "", ""
	if (config.stanceswitch) then
		Warrior = "[stance:1] 7; [stance:2] 8; [stance:3] 9;"
		Rogue = "[bonusbar:1] 7;"
		Warlock = "[stance:1] 10; "
		Druid = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;"
		Priest = "[bonusbar:1] 7;"
		Monk = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;"
	end
	ab.bar1.Page = {
		["DRUID"] = Druid,
		["WARRIOR"] = Warrior,
		["PRIEST"] = Priest,
		["ROGUE"] = Rogue,
		["WARLOCK"] = Warlock,
		["MONK"] = Monk,
		["DEFAULT"] = "[vehicleui:12] 12; [possessbar] 12; [overridebar] 14; [shapeshift] 13; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
	}
	local Condition = ab.bar1.Page["DEFAULT"]
	local Page = ab.bar1.Page[Class]
	
	if Page then
		Condition = Condition .. " " .. Page
	end
	
	Condition = Condition .. " [form] 1; 1"

	return Condition
end

ab.bar1.UpdateBar1()

function ab.bar1:Update()
	local rows = math.floor(NUM_ACTIONBAR_BUTTONS/config.bar1rows)
	local index = 1
	local lastrow = ActionButton1
	local lastbutton = nil
	ab:Size(ab.bar1,'bar1rows',NUM_ACTIONBAR_BUTTONS)
	
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["ActionButton"..i]
		local border = bdCore.config['General'].border
		Button:SetSize(config.buttonsize,config.buttonsize)
		Button:ClearAllPoints()
		Button:SetParent(self)
		Button:SetFrameStrata("BACKGROUND")
		Button:SetFrameLevel(15)
		ab:skinButton(Button,"bar1",ab.bar1)
		if (not lastbutton) then
			Button:SetPoint("TOPLEFT", ab.bar1, "TOPLEFT", 0, 0)
		else
			Button:SetPoint("LEFT", lastbutton, "RIGHT", config.buttonspacing+border, 0)
			if (i > rows and index >= rows) then
				Button:SetPoint("TOPLEFT", lastrow, "BOTTOMLEFT", 0, -config.buttonspacing-border)
				index = 0
				lastrow = Button
			end
		end
		index = index + 1
		lastbutton = Button
	end
end
bdCore:hookEvent("bdcore_redraw",function() ab.bar1:Update() end)

ab.bar1:RegisterEvent("PLAYER_ENTERING_WORLD")
ab.bar1:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
ab.bar1:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
ab.bar1:RegisterEvent("BAG_UPDATE")
ab.bar1:SetScript("OnEvent", function(self, event, unit, ...)
	if (event == "ACTIVE_TALENT_GROUP_CHANGED") then
		ab.bar1.UpdateBar1()
	elseif (event == "PLAYER_ENTERING_WORLD") then
		ab.bar1:Update()
	else
		MainMenuBar_OnEvent(self, event, ...)
	end
end)

for i = 1, NUM_ACTIONBAR_BUTTONS do
	local Button = _G["ActionButton"..i]
	ab.bar1["Button"..i] = Button
end

MainMenuBar:SetScale(0.001)
MainMenuBar:SetAlpha(0)
MainMenuBarArtFrame:Hide()