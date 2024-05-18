local fusion = require("@packages/fusion")

return function<T>(state: fusion.CanBeState<T>): fusion.Value<T>
	if typeof(state) == "table" and state.get then
		return state :: fusion.Value<T>
	end

	return fusion.Value(state) :: fusion.Value<T>
end
