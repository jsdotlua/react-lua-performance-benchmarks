local PackagesWorkspace = script.Parent.Parent.Packages
local Roact = require(PackagesWorkspace.Roact)

local function bootstrap(rootInstance, component, props)
	local root = Roact.createBlockingRoot(rootInstance)
	root:render(Roact.createElement(component, props))

	return function()
		root:unmount()
		rootInstance.Parent = nil
	end
end

return bootstrap
