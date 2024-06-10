local fusion = require("@packages/fusion")

local Clean = fusion.cleanup

return function(object: Instance, pendingCleanup: { any })
	local connection
	connection = object.Destroying:Connect(function()
		Clean(connection, pendingCleanup)
	end)
end
