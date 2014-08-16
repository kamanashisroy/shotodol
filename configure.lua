function yes_no_to_bool(x)
	if(x == "y") then return true end
	return false
end

function prompt_yes_no(y)
	local x = "n"
	repeat
		 io.write(y)
		 io.flush()
		 x=io.read()
	until x=="y" or x=="n"
	return x
end

function prompt(y,xval)
	local x = xval
	io.write(y)
	io.flush()
	x=io.read()
	if x == "" then
		return xval
	end
	return x
end

local configLines = {}
local configOps = {}

io.write("This is the configure script built for shotodol\n")
configLines["PLATFORM"] = "linux"

-- LUA_INCLUDE=-I/usr/include/lua5.1
-- LUA_LIB=-L/usr/lib/ -llua5.1
-- print("QT_HOME="..."/home/ayaskanti/opt/qt/Desktop/Qt/474/gcc")
-- print("ECHO="..."echo -e")
-- use only echo in mac
configLines["ECHO"] = "echo"
local haslfs,lfs = pcall(require,"lfs")
local phome = "";
if haslfs then
	phome = lfs.currentdir()
end
configLines["PROJECT_HOME"] = prompt("Project path " .. phome .. " > " , phome)
configLines["SHOTODOL_HOME"] = configLines["PROJECT_HOME"]
local ahome = string.gsub(configLines["SHOTODOL_HOME"],"shotodol$","aroop")
configLines["VALA_HOME"] = prompt("Aroop path " .. ahome .. " > ", ahome)
configLines["LINUX_BLUETOOTH"] = prompt_yes_no("enable bluetooth ?(y/n) > ")
configLines["LUA_LIB"] = prompt("enable lua library ?(50/5.1/n) > ", "50")
configLines["VALAFLAGS+"] = ""
if configLines["LUA_LIB"] ~= "n" then
	configLines["VALAFLAGS+"] = configLines["VALAFLAGS+"] .. " -D LUA_LIB"
end
configLines["AROOP_VARIANT"] = "_static"
configLines["CFLAGS+"] = ""
if yes_no_to_bool(prompt_yes_no("enable debug (-ggdb3 -DAROOP_OPP_PROFILE -DAROOP_OPP_DEBUG) ?(y/n) > ")) then
	configLines["CFLAGS+"] = configLines["CFLAGS+"] .. " -ggdb3 -DAROOP_OPP_PROFILE -DAROOP_OPP_DEBUG"
	configLines["AROOP_VARIANT"] = "_debug"
end
if yes_no_to_bool(configLines["LINUX_BLUETOOTH"]) then
	configLines["CFLAGS+"] = configLines["CFLAGS+"] .. " -DLINUX_BLUETOOTH"
end
-- configLines["CFLAGS+"] = configLines["CFLAGS+"] .. " -DDYNALIB_ROOT=\\\"$(PROJECT_HOME)/\\\""

local conf = assert(io.open("build/.config.mk", "w"))
for x in pairs(configLines) do
	local op = configOps[x]
	if op == nil then
		op = "="
	end
	conf:write(x .. op .. configLines[x] .. "\n")
end
assert(conf:close())

local shotodol = dofile(configLines["SHOTODOL_HOME"] .. "/build/shotodol.lua")
shotodol.genmake(configLines["PROJECT_HOME"])
