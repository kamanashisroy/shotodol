
local plugin_dirs = { 
"libs/iostream" 
,"libs/unittest" 
,"libs/watchdog" 
,"libs/module" 
,"libs/str_arms" 
,"libs/config" 
,"$(PLATFORM)/platform_extra" 
,"libs/propeller" 
,"libs/bundle" 
,"libs/db" 
,"libs/make100" 
,"$(PLATFORM)/platform_net" 
,"libs/netio" 
,"core/base" 
,"core/commands" 
,"core/test" 
,"core/fileconfig" 
,"core/console" 
,"core/idle" 
,"core/profiler" 
,"core/make" 
,"libs/turbine" 
,"apps/net_echo" 
,"main/main" 
}

local makevars = assert(io.open("build/Makevars.mk", "w"))
makevars:write("PLUGIN_DIRS:=")
for i,x in ipairs(plugin_dirs) do
	makevars:write(" " .. x)
end
makevars:write("\n")
makevars:write("\n")
makevars:close()


local makefile = assert(io.open("./Makefile", "w"))
local intro = assert(io.open("./Makefile.in", "r"))
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
	makefile:write("\t$(BUILD) -C " .. x .. "\n")
end
makefile:write("\n")
makefile:write("\n")
makefile:write("cleanplugins:\n")
for i,x in ipairs(plugin_dirs) do
	makefile:write("\t$(CLEAN) -C " .. x .. "\n")
end
makefile:write("\n")
makefile:write("\n")
assert(makefile:close())

