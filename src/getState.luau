local fusion = require("@packages/fusion")
local types = require("@src/types")

-- for some reason types are especially annoying on this!
return function<T>(scope: types.Scope, state: fusion.UsedAs<T>): types.Value<T>
	if typeof(state) == "table" and state["_EXTREMELY_DANGEROUS_usedAsValue"] ~= nil then
		return (state :: any) :: types.Value<T>
	end

	return (scope:Value(state) :: any) :: types.Value<T>
end
