local addon, engine = ...

engine[1] = CreateFrame("Frame", nil, UIParent)
engine[2] = bdCore.config.profile.Actionbars

function engine:unpack()
	return self[1], self[2]
end

local bdAB, config = select(2, ...):unpack()

