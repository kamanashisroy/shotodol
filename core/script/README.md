Script module
==============

This module loads lua scripts and registers hook extensions. It is easy to write script module. It has a goal that the 'best API is no API'. Scripts can be used here as metaprogramming tool too.

### Writing a hook extension

To write a hook you need to write a lua function prefixed with "exten\_". For example, the following code will wish you good luck when you swarm on "luaGoodLuck" .

```lua
function rehash() 
	OutputStream.write("Rehashing lua modules\n")
	return "luaGoodLuck"
end

function exten_luaGoodLuck(x) 
	local msg =  "Good luck from lua.\n"
	OutputStream.write(msg)
	return(msg)
end
```
And you can execute the hook using plugin command like the following,

```
plugin -x luaGoodLuck -act
Executing:plugin -x luaGoodLuck -act
<          plugin> -----------------------------------------------------------------
Good luck from lua.
There are 0 extensions in luaGoodLuck directory
<      Successful> -----------------------------------------------------------------
```


