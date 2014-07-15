
function trim1(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

projects= {}

function compilePlatform(s)
	return (s:gsub("OS_PLATFORM", projects["PLATFORM"]))
end

function depend(pkg,p)
	local x = pkg
	local fpath = projects[p] .. "/" .. pkg;
	if pkg == "." then
		fpath = "."
		x = ""
	end
	local f = assert(io.open(fpath .. "/pkg.depend", "r"))
	if f == nil then
		return
	end

	
	local pkgdir = "SHOTODOL_HOME"
	while true do
		local line = f:read("*line")
		if line == nil then break end
		local lntrm = trim1(line)
		if lntrm ~= "" then
			local c = lntrm:sub(0,1)
			if c == "-" then
				pkgdir = lntrm:sub(2)
			else
				local otherpkg = compilePlatform(lntrm)
				x = x .. " " .. projects[pkgdir] .. "/" .. depend(otherpkg,pkgdir)
			end 
		end
	end
	f:close()
	return x;
end

function parseConfig(projectdir)
	local f = assert(io.open(projectdir .. "/build/.config.mk", "r"))
	if f == nil then
		return
	end


	while true do
		local line = f:read("*line")
		if line == nil then break end
		local lntrm = trim1(line)
		if lntrm ~= "" then
			local key = lntrm:gsub("^([A-Za-z_]*)=.*$", "%1");
			local value = lntrm:gsub("^[A-Za-z_]*=(.*)$", "%1");
			projects[key] = value;
		end
	end
end


parseConfig(arg[2])
local x = " " .. depend(arg[1],"SHOTODOL_HOME") .. " "
local allpkg = ""
for pkg in string.gmatch(x, "%S+") do if not string.match(allpkg, pkg .. " ") then allpkg = allpkg .. " " .. pkg .. " " end end
print(allpkg)

