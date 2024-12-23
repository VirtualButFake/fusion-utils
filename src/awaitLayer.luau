-- wrapper for reactive topLayerProvider.getLayer
local topLayerProvider = require("@src/topLayerProvider")
local types = require("@src/types")

return function(scope: types.Scope, object: GuiObject, callback: (layer: topLayerProvider.layer) -> any): nil
	local parent = scope:Value(object.Parent :: GuiObject)

	local layerComputed
	local updateValue = scope:Value(false)

	local connection = object.AncestryChanged:Connect(function()
		parent:set(object.Parent)
		updateValue:set(true)
		-- we just trigger an update here
		-- i don't know why this works, since computeds should update anyways, no?
		-- but hey :shrug:
		layerComputed:get()
	end)

	local handled = false

	layerComputed = scope:Computed(function(use)
		if updateValue:get() then
			updateValue:set(false)
		end

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
