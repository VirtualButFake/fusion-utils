local fusion = require("@packages/fusion")

local function isState(target: any): boolean
	return typeof(target) == "table" and target.get ~= nil
end

local function peek<T>(target: fusion.CanBeState<T>): T
	if isState(target) then
		return (target :: fusion.StateObject<T>):get(false)
	else
		return target :: T
	end
end

return peek
