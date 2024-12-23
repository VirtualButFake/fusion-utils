local awaitLayer = require("./awaitLayer")
local getState = require("./getState")
local onDestroy = require("./onDestroy")
local propertyProvider = require("./propertyProvider")
local sizeFromLayer = require("./sizeFromLayer")
local topLayerProvider = require("./topLayerProvider")

local index = {
	propertyProvider = propertyProvider,
	awaitLayer = awaitLayer,
	getState = getState,
	onDestroy = onDestroy,
	sizeFromLayer = sizeFromLayer,
	topLayerProvider = topLayerProvider,
}

export type layer = topLayerProvider.layer

return index
