
function trim1(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function compilePlatform(s)
	return (s:gsub("OS_PLATFORM", "linux"))
end

function depend(pkg,p)
	local x = pkg
	local fpath = p .. "/" .. pkg;
	if pkg == "." then
		fpath = "."
		x = ""
	end
	local f = assert(io.open(fpath .. "/pkg.depend", "r"))
	if f == nil then
		return
	end

	
	while true do
		local line = f:read("*line")
		if line == nil then break end
		local pkgline = trim1(line)
		local otherpkg = compilePlatform(pkgline)
		if otherpkg ~= "" then
			x = x .. " " .. depend(otherpkg,p)
		end
	end
	f:close()
	return x;
end

print(depend(arg[1],arg[2]))
