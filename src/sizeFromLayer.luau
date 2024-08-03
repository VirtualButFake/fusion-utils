local fusion = require("@packages/fusion")
local Observer = fusion.Observer
local Value = fusion.Value

local awaitLayer = require("@src/awaitLayer")
local use = require("@src/use")
local onDestroy = require("@src/onDestroy")

return function(object: fusion.CanBeState<GuiObject>, size: UDim2): fusion.Value<UDim2>
	local passedSize = Value(UDim2.new())
	local pendingCleanup = {}

	local function updateObject()
		if not use(object) then
			return nil
		end

		awaitLayer(use(object), function(layer)
			local function updateSize()
				local newSize: UDim2 = layer.state.size:get()
				passedSize:set(
					UDim2.fromOffset(
						newSize.X.Offset * size.X.Scale + size.X.Offset,
						newSize.Y.Offset * size.Y.Scale + size.Y.Offset
					)
				)
			end

			local disconnect = Observer(layer.state.size):onChange(updateSize)

			updateSize()

			onDestroy(use(object), { disconnect, pendingCleanup })

			return nil
		end)

		return nil
	end

	table.insert(pendingCleanup, typeof(object) == "table" and Observer(object):onChange(updateObject) or nil)
	updateObject()

	return passedSize
end
