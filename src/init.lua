local propertyProvider = require("./propertyProvider")
local awaitLayer = require("./awaitLayer")
local getState = require("./getState")
local onDestroy = require("./onDestroy")
local use = require("./use")
local peek = require("./peek")
local sizeFromLayer = require("./sizeFromLayer")
local topLayerProvider = require("./topLayerProvider")

local index = {
	propertyProvider = propertyProvider :: typeof(propertyProvider),
	awaitLayer = awaitLayer :: typeof(awaitLayer),
	getState = getState :: typeof(getState),
	onDestroy = onDestroy :: typeof(onDestroy),
	use = use :: typeof(use),
	peek = peek :: typeof(peek),
	sizeFromLayer = sizeFromLayer :: typeof(sizeFromLayer),
	topLayerProvider = topLayerProvider :: typeof(topLayerProvider),
}

export type layer = topLayerProvider.layer

return index :: typeof(index)
