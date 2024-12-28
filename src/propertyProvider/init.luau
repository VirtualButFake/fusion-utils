local module = {}
local fusion = require("@packages/fusion")
local types = require("./types")

function module.getProps(props: { [any]: any }, instanceType: string): { [string]: any }
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

function module.getPropsAndSpecialKeys(props: { [any]: any }, instanceType: string): { [any]: any }
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

function module.merge<T>(originalProps: T & {}, addedProps: fusion.PropertyTable): T
	-- merge only string keys, for the rest, check if they already exist and ignore and warn if they do, otherwise add them
	local newProps = table.clone(originalProps)

	for key, value in pairs(addedProps) do
		if newProps[key] and typeof(key) == "table" then
			warn(
				"PropertyProvider: SpecialKey (or table) already exists in original properties. Traceback: "
					.. debug.traceback()
			)
		else
			newProps[key] = value
		end
	end

	return newProps
end

return module
