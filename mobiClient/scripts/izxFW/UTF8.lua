local UTF8 = {}

function UTF8.chSize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end


function UTF8.sub(str, startChar, numChars)
  	local startIndex = 1
    if (startChar==nil) then
      startChar = 1;
    end
    if (numChars==nil) then
      numChars = 7;
    end;
  	while startChar > 1 do
	      local char = string.byte(str, startIndex)
	      startIndex = startIndex + UTF8.chSize(char)
	      startChar = startChar - 1
  	end
 
  	local currentIndex = startIndex
 
  	while numChars > 0 and currentIndex <= #str do
    	local char = string.byte(str, currentIndex)
    	currentIndex = currentIndex + UTF8.chSize(char)
    	numChars = numChars -1
  	end
  	return str:sub(startIndex, currentIndex - 1)
end

function UTF8.length(str)
	local length = 0;
	local currentIndex = 1;
	while currentIndex <= #str do
    	local char = string.byte(str, currentIndex)
    	currentIndex = currentIndex + UTF8.chSize(char)
    	length = length + 1
  	end
  	return length;
end

return UTF8;