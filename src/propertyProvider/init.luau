local module = {}
local types = require("./types")

function module.getProps(props: { [string]: any }, instanceType: string): { [string]: any }
	local validProps = types[instanceType]

	if not validProps then
		return props
	end

	local newProps = table.clone(props)

	for key in newProps do
		if not validProps[key] then
			newProps[key] = nil
		end
	end

	return newProps
end

function module.getPropsAndSpecialKeys(props: { [string]: any }, instanceType: string): { [string]: any }
	local validProps = types[instanceType]

	if not validProps then
		return props
	end

	local newProps = table.clone(props)

	for key in newProps do
		if typeof(key) ~= "string" then
			continue
		end

		if not validProps[key] then
			newProps[key] = nil
		end
	end

	return newProps
end

return module
