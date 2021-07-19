local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages
local Benchmarks = Packages.PerformanceBenchmarks.benchmarks

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array

return function(Roact, ReactRoblox)
	local impl = require(Benchmarks.impl)(Roact, ReactRoblox)
	local implementations = impl
	local packageNames = Object.keys(implementations)

	local function createTestBlock(fn)
		return Array.reduce(packageNames, function(testSetups, packageName)
			local implementation = implementations[packageName]
			local name, components, version = implementation.name, implementation.components, implementation.version

			local componentInfo = fn(components)
			local Component, getComponentProps, sampleCount, Provider, benchmarkType =
				componentInfo.Component,
				componentInfo.getComponentProps,
				componentInfo.sampleCount,
				componentInfo.Provider,
				componentInfo.benchmarkType

			testSetups[packageName] = {
				Component = Component,
				getComponentProps = getComponentProps,
				sampleCount = sampleCount,
				Provider = Provider,
				benchmarkType = benchmarkType,
				version = version,
				name = name,
			}
			return testSetups
		end, {})
	end

	return {
		createTestBlock = createTestBlock,
	}
end
