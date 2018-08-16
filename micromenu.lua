local addon, bdAB = ...
local config = bdCore.config.profile["Actionbars"]

local microButtons = {
	"CharacterMicroButton"
	, "SpellbookMicroButton"
	, "TalentMicroButton"
	, "AchievementMicroButton"
	, "QuestLogMicroButton"
	, "GuildMicroButton"
	, "LFDMicroButton"
	, "CollectionsMicroButton"
	, "EJMicroButton"
	, "StoreMicroButton"
	, "MainMenuMicroButton"
}


---------------------------------------------------------
-- Create Micro Menu container
---------------------------------------------------------
local microMenu = CreateFrame("frame", "bdMicroMenu", UIParent)
microMenu:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 10)

function microMenu:configCallback()
	self:SetSize(config.microSize * #microButtons, config.microSize)
end

microMenu:configCallback()
bdCore:makeMovable(microMenu)

---------------------------------------------------------
-- Skin micro buttons
---------------------------------------------------------
local lastButton
for i = 1, #microButtons do
	local frame = _G[microButtons[i]]
	frame:ClearAllPoints()
	frame:SetParent(self)
	frame:SetSize(config.microSize, config.microSize)
	bdCore:setBackdrop(frame)

	if (lastButton) then
		frame:SetPoint("LEFT", lastButton, "RIGHT", 0, 0)
	else
		frame:SetPoint("LEFT", self, "LEFT")
	end

	lastButton = frame
end

bdAB.MicroMenu = microMenu

-- MicroButtonAndBagsBar
-- Hide this?