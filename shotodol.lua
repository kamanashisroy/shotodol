
function rehash() 
	OutputStream.write("Rehashing lua modules\n")
	return "luaGoodLuck"
end

function exten_luaGoodLuck(x) 
	local msg =  "Good luck from lua.\n"
	OutputStream.write(msg)
	return(msg)
end
