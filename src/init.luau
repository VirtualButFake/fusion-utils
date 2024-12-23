local awaitLayer = require("./awaitLayer")
local getState = require("./getState")
local onDestroy = require("./onDestroy")
local peek = require("./peek")
local propertyProvider = require("./propertyProvider")
local sizeFromLayer = require("./sizeFromLayer")
local topLayerProvider = require("./topLayerProvider")
local use = require("./use")

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
