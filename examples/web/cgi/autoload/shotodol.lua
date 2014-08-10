
function rehash() 
	return "page/example"
end

function exten_page_example(x) 
	local msg =  "Congratulations!, it works.\n"
	OutputStream.write(msg)
	print(msg);
	return(msg)
end
