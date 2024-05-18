local propertyProvider = require("./propertyProvider")
local awaitLayer = require("./awaitLayer")
local getState = require("./getState")
local onDestroy = require("./onDestroy")
local use = require("./use")
local peek = require("./peek")
local sizeFromLayer = require("./sizeFromLayer")
local topLayerProvider = require("./topLayerProvider")

local index = {
	propertyProvider = propertyProvider,
	awaitLayer = awaitLayer,
	getState = getState,
	onDestroy = onDestroy,
	use = use,
	peek = peek,
	sizeFromLayer = sizeFromLayer,
	topLayerProvider = topLayerProvider,
}

export type layer = topLayerProvider.layer

return index
