local fusion = require("@packages/fusion")

local awaitLayer = require("@src/awaitLayer")
local onDestroy = require("@src/onDestroy")
local types = require("@src/types")
local peek = fusion.peek

return function(scope: types.Scope, object: fusion.UsedAs<GuiObject>, size: UDim2): types.Value<UDim2>
	local passedSize = scope:Value(UDim2.new())
	local pendingCleanup = {}

	local function updateObject()
		if not peek(object) then
			return nil
		end

		awaitLayer(scope, peek(object), function(layer)
			local function updateSize()
				local newSize: UDim2 = layer.state.size:get()
				passedSize:set(
					UDim2.fromOffset(
						newSize.X.Offset * size.X.Scale + size.X.Offset,
						newSize.Y.Offset * size.Y.Scale + size.Y.Offset
					)
				)
			end

			local disconnect = scope:Observer(layer.state.size):onChange(updateSize)

			updateSize()
			onDestroy(peek(object), { disconnect, pendingCleanup })

			return nil
		end)

		return nil
	end

	table.insert(pendingCleanup, typeof(object) == "table" and scope:Observer(object):onChange(updateObject) or nil)
	updateObject()

	return passedSize
end
