local shotodol = {}

function shotodol.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end


function shotodol.trim1(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

shotodol.projects= {}

function shotodol.compilePlatform(s)
	return (s:gsub("OS_PLATFORM", shotodol.projects["PLATFORM"]))
end

function shotodol.parseConfig(projectdir)
	local f = assert(io.open(projectdir .. "/build/.config.mk", "r"))
	if f == nil then
		return
	end


	while true do
		local line = f:read("*line")
		if line == nil then break end
		local lntrm = shotodol.trim1(line)
		if lntrm ~= "" then
			local key = lntrm:gsub("^([A-Za-z_]*)=.*$", "%1");
			local value = lntrm:gsub("^[A-Za-z_]*=(.*)$", "%1");
			shotodol.projects[key] = value;
		end
	end
end

function shotodol.parsePluginDirs(subdir,p)
	local x = {}
	local i = 1
	local fpath = shotodol.projects[p];
	local f = assert(io.open(fpath .. "/" .. subdir .. "/pkg.depend", "r"))
	if f == nil then
		return
	end

	
	local pkgdir = "SHOTODOL_HOME"
	while true do
		local line = f:read("*line")
		if line == nil then break end
		local lntrm = shotodol.trim1(line)
		if lntrm ~= "" then
			local c = lntrm:sub(0,1)
			if c == "-" then
				pkgdir = lntrm:sub(2)
			else
				local otherpkg = shotodol.compilePlatform(lntrm)
				x[i] = otherpkg
				i = i+1
			end 
		end
	end
	f:close()
	return x;
end

function shotodol.genmake(projecthome)
	shotodol.parseConfig(projecthome)
	local plugin_dirs = shotodol.parsePluginDirs("build", "PROJECT_HOME")
	
	-- generate Makevars.mk
	local makevars = assert(io.open("build/Makevars.mk", "w"))
	makevars:write("PLUGIN_DIRS:=")
	for i,x in ipairs(plugin_dirs) do
		makevars:write(" " .. x)
	end
	makevars:write("\n")
	makevars:write("\n")
	assert(makevars:close())


	-- generate Makefile
	local makefile = assert(io.open("./Makefile", "w"))
	local fpath = shotodol.projects["SHOTODOL_HOME"];
	local intro = assert(io.open(fpath .. "/build/Makefile.in", "r"))
	while true do
		local line = intro:read("*line")
		if line == nil then break end
		makefile:write(line .. "\n")
	end
	intro:close()
	makefile:write("\n")
	makefile:write("\n")
	makefile:write("makeplugins:\n")
	for i,x in ipairs(plugin_dirs) do
		local module_depth = "../"
		for word in string.gmatch(x, "/") do module_depth = module_depth .. "../" end
		makefile:write("\t$(BUILD) -C " .. x .. " MODULE_DEPTH=\"".. module_depth .."\" AROOP_MODULE_NAME=\"".. x .."\"\n")
	end
	makefile:write("\n")
	makefile:write("\n")
	makefile:write("cleanplugins:\n")
	for i,x in ipairs(plugin_dirs) do
		local module_depth = "../"
		for word in string.gmatch(x, "/") do module_depth = module_depth .. "../" end
		makefile:write("\t$(CLEAN) -C " .. x .. " MODULE_DEPTH=\"".. module_depth .."\" AROOP_MODULE_NAME=\"".. x .."\"\n")
	end
	makefile:write("\n")
	makefile:write("\n")
	makefile:write("distplugins:\n")
	for i,x in ipairs(plugin_dirs) do
		local module_depth = "../"
		for word in string.gmatch(x, "/") do module_depth = module_depth .. "../" end
		makefile:write("\t$(DIST) -C " .. x .. " MODULE_DEPTH=\"".. module_depth .."\" AROOP_MODULE_NAME=\"".. x .."\"\n")
	end
	makefile:write("\n")
	makefile:write("\n")
	assert(makefile:close())

end

return shotodol
