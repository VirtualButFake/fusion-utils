-- wrapper for reactive topLayerProvider.getLayer
local fusion = require("@packages/fusion")
local peek = fusion.peek

local topLayerProvider = require("@src/topLayerProvider")
local types = require("@src/types")

return function(scope: types.Scope, object: GuiObject, callback: (layer: topLayerProvider.layer) -> any): nil
	local parent = scope:Value(object.Parent :: GuiObject)

	local layerComputed

	local connection = object.AncestryChanged:Connect(function()
		parent:set(object.Parent)
		-- trigger an update (i think this is needed because it's not required by something like an instance)
		peek(layerComputed)
	end)

	local handled = false

	layerComputed = scope:Computed(function(use)
		local layer = topLayerProvider.getLayer(use(parent))

		if layer and not handled then
			handled = true
			connection:Disconnect()
			return callback(layer)
		end

		return nil
	end)

	return nil
end
