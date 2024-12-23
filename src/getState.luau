local fusion = require("@packages/fusion")
local types = require("@src/types")

return function<T>(scope: types.Scope, state: fusion.UsedAs<T>): types.Value<T>
	if typeof(state) == "table" and state.kind == "State" then
		return state :: types.Value<T>
	end

	return scope:Value(state) :: types.Value<T>
end
