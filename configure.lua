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

function promptOptions(greet,options,xval)
	local x = xval
	local i = 0
	local mygreet = greet
	while true do
		if options[i] == nil then break end
		mygreet = mygreet .. "\r\n#" .. i .. " (" .. options[i] ..")"
		i = i + 1
	end
	mygreet = mygreet .. "\r\n>"
	repeat
		io.write(mygreet)
		io.flush()
		x=io.read()
	until x=="" or tonumber(x)~=nil
	if x == "" then
		return xval
	end
	return x
end


local configLines = {}
local configOps = {}

io.write("This is the configure script built for shotodol\n")
local platforms = {}
platforms[0] = "linux"
platforms[1] = "raspberrypi_bare_metal"
platforms[2] = "raspberrypi"
local pindex = promptOptions("Platform >" , platforms, 0)
configLines["PLATFORM"] = platforms[tonumber(pindex)]


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
configLines["PROJECT_HOME"] = prompt("Current/working path: " .. phome .. " > " , phome)
configLines["SHOTODOL_HOME"] = configLines["PROJECT_HOME"]
local shotodol = dofile(configLines["SHOTODOL_HOME"] .. "/build/shotodol.lua")
local ahome = os.getenv("AROOPC")
-- if ahome == nil then
-- 	local whereis = shotodol.capture("whereis aroopc", false)
-- 	if whereis ~= "" then
-- 		ahome = whereis
-- 	end
-- end
if ahome == nil then
	ahome = shotodol.capture("pkg-config --variable=aroopc libaroop-0.1.0", false)
end
if ahome == nil  then
	ahome = "/usr/bin/aroopc"
end
if ahome == "" then
	ahome = "/usr/bin/aroopc"
end
-- configLines["VALA_HOME"] = prompt("Aroop source path: " .. ahome .. " > ", ahome)
configLines["AROOPC"] = prompt("aroopc : " .. ahome .. " > ", ahome)
configLines["VALAFLAGS+"] = ""
configLines["AROOP_VARIANT"] = "_static"
configLines["CFLAGS+"] = ""
if yes_no_to_bool(prompt_yes_no("enable debug (-ggdb3 -DAROOP_OPP_PROFILE -DAROOP_OPP_DEBUG -DSHOTODOL_FORK_DEBUG -DSHOTODOL_FD_DEBUG) ?(y/n) > ")) then
	configLines["CFLAGS+"] = configLines["CFLAGS+"] .. " -ggdb3 -DAROOP_OPP_PROFILE -DAROOP_OPP_DEBUG "
	configLines["VALAFLAGS+"] = configLines["VALAFLAGS+"] .. " -D SHOTODOL_FORK_DEBUG -D SHOTODOL_FD_DEBUG "
	configLines["AROOP_VARIANT"] = "_debug"
end
-- configLines["CFLAGS+"] = configLines["CFLAGS+"] .. " -DDYNALIB_ROOT=\\\"$(PROJECT_HOME)/\\\""


if configLines["PLATFORM"] == "raspberrypi" then
	configLines["ARMGNU?"] = configLines["PROJECT_HOME"] .. "/tools-master/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf"
	configLines["AFLAGS"] = " --warn --fatal-warnings -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mcpu=arm1176jzf-s $(DEBUGFLAG)"

	configLines["CFLAGS+"] = configLines["CFLAGS+"] .. " -O2 -nostdlib -nostartfiles -ffreestanding -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s"
	configLines["CFLAGS+"] = configLines["CFLAGS+"] .. " -Wall"
	configLines["CFLAGS+"] = configLines["CFLAGS+"] .. " -DRASPBERRY_PI -DAROOP_BASIC "
	configLines["CC"] = configLines["ARMGNU?"] .. "-gcc"
	configLines["PLATFORM"] = "linux" -- redirect to linux
	local raspberry_note = "Welcome to raspberry pi compilation script.\r\n================================================\r\nTo compile the application you neet to get the raspberry pi compiler and put that in tools-master directory inside the project directory(current directory). Otherwise you can do a `wget -N https://github.com/raspberrypi/tools/archive/master.zip;unzip master.zip` command to download it from internet.\r\nGood luck\r\n"
	io.write(raspberry_note)
	io.flush()
end


local conf = assert(io.open("build/.config.mk", "w"))
for x in pairs(configLines) do
	local op = configOps[x]
	if op == nil then
		op = "="
	end
	conf:write(x .. op .. configLines[x] .. "\n")
end
assert(conf:close())

shotodol.genmake(configLines["PROJECT_HOME"])
