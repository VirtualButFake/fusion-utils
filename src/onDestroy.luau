local fusion = require("@packages/fusion")

local doCleanup = fusion.doCleanup

return function(object: Instance, pendingCleanup: { any })
	local connection
	connection = object.Destroying:Connect(function()
		doCleanup(connection, pendingCleanup)
	end)
end
