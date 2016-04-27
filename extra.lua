local addon, ab = ...
local config = bdCore.config["Actionbars"]

ab.extra:SetPoint("LEFT", UIParent, "LEFT", 20, 0)
ab.extra:SetSize(180, 100)
bdCore:makeMovable(ab.extra)

ExtraActionBarFrame:SetParent(UIParent)
ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetPoint("CENTER", ab.extra, "CENTER", 0, 0)
ExtraActionBarFrame.ignoreFramePositionManager = true

DraenorZoneAbilityFrame:SetParent(UIParent)
DraenorZoneAbilityFrame:ClearAllPoints()
DraenorZoneAbilityFrame:SetPoint("CENTER", ab.extra, "CENTER", 0, 0)
DraenorZoneAbilityFrame.ignoreFramePositionManager = true

-- hook the texture, idea by roth via WoWInterface forums
local button = ExtraActionButton1
local icon = button.icon
local texture = button.style
local disableTexture = function(style, texture)
	-- looks like sometime the texture path is set to capital letter instead of lower-case
	if string.sub(texture,1,9) == "Interface" or string.sub(texture,1,9) == "INTERFACE" then
		style:SetTexture("")
	end
end
button.style:SetTexture("")
hooksecurefunc(texture, "SetTexture", disableTexture)