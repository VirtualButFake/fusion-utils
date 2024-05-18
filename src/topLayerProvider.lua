local layer = {}
local activeLayers = {}

local fusion = require("@packages/fusion")
local Children = fusion.Children
local Cleanup = fusion.Cleanup
local New = fusion.New

local Value = fusion.Value
local Ref = fusion.Ref

function layer.new(content: Frame): (Frame, layer)
	local contents = fusion.Value({})

	local newLayer = setmetatable({
		contents = contents,
		referenceLayer = content,
		_connections = {},
        state = {}
	}, { __index = layer })

	local containerSize = Value(UDim2.new(0, content.AbsoluteSize.X, 0, content.AbsoluteSize.Y))
	local containerPositionalData = {
		AnchorPoint = Value(content.AnchorPoint),
		Position = Value(content.Position),
	}

	local parentFrameRef = Value(nil)

	local sizeConnection = content:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local size = content.AbsoluteSize
		containerSize:set(UDim2.new(0, size.X, 0, size.Y))
	end)

	local positionConnection = content:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
		local position = content.Position
		local anchorPoint = content.AnchorPoint

		containerPositionalData.AnchorPoint:set(anchorPoint)
		containerPositionalData.Position:set(position)
	end)

	local parentFrame: Frame = New("Frame")({
		Name = "Layer",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		[Ref] = parentFrameRef,
		[Cleanup] = function()
			newLayer:destroy()
			sizeConnection:Disconnect()
			positionConnection:Disconnect()
		end,

		[Children] = {
			New("Frame")({
				Name = "TopLayer",
				AnchorPoint = containerPositionalData.AnchorPoint,
				BackgroundTransparency = 1,
				Position = containerPositionalData.Position,
				Size = containerSize,
				ZIndex = 2,
				[Children] = contents,
			}),
			content,
		},
	}) :: Frame

	newLayer.contentFrame = parentFrame
	table.insert(activeLayers, newLayer)

	local mousePosition = Value(Vector2.new())
	local mouseDown = Value(false)

	table.insert(
		newLayer._connections,
		parentFrame.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				mousePosition:set(input.Position)
			end
		end)
	)

	table.insert(
		newLayer._connections,
		parentFrame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				mouseDown:set(true)
			end
		end)
	)

	table.insert(
		newLayer._connections,
		parentFrame.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				mouseDown:set(false)
			end
		end)
	)

	newLayer.state = {
		mousePosition = mousePosition,
		mouseDown = mouseDown,
		size = containerSize,
	}

	return parentFrame, newLayer
end

function layer.getLayer(content: GuiObject): layer?
	local eligibleLayers = {}

	for _, activeLayer in activeLayers do
		if
			activeLayer.contentFrame:IsAncestorOf(content)
			or activeLayer.contentFrame == content
			or activeLayer.referenceLayer == content
		then
			table.insert(eligibleLayers, activeLayer)
		end
	end

	if #eligibleLayers == 0 then
		return
	end

	-- find the closest layer to the instance
	for _, eligibleLayer in eligibleLayers do
		local ancestorCount = 0

		for _, otherLayer in eligibleLayers do
			if eligibleLayer ~= otherLayer and otherLayer.contentFrame:IsAncestorOf(eligibleLayer.contentFrame) then
				ancestorCount += 1
			end
		end

		if ancestorCount == #eligibleLayers - 1 then
			return eligibleLayer
		end
	end

	return
end

function layer.add(self: layer, content: GuiObject)
	local currentContents = self.contents:get()

	if table.find(currentContents, content) then
		return
	end

	table.insert(currentContents, content)
	self.contents:set(currentContents)
end

function layer.remove(self: layer, content: GuiObject)
	local currentContents = self.contents:get()
	local index = table.find(currentContents, content)

	if not index then
		return
	end

	table.remove(currentContents, index)
	self.contents:set(currentContents)
end

function layer.destroy(self: layer)
	local index = table.find(activeLayers, self)

	if index then
		table.remove(activeLayers, index)
	end

	for _, connection in self._connections do
		connection:Disconnect()
	end

	self.contentFrame.Parent = nil
end

export type layer = typeof(setmetatable(
	{} :: {
		contents: fusion.Value<{ GuiObject }>,
		contentFrame: Frame,
		referenceLayer: Frame,
		state: {
			mousePosition: fusion.Value<Vector2>,
			mouseDown: fusion.Value<boolean>,
			size: fusion.Value<UDim2>,
		},
		_connections: { RBXScriptConnection },
	},
	{ __index = layer }
))

return layer
