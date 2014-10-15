gRandomKey = 0

function getRandomKey()
	-- body
	gRandomKey = gRandomKey + 1
	return gRandomKey
end

function nullFunc()
			-- body
end
	
function echoError(fmt, ...)
    if (DEBUG>=1) then
        echoLog("ERR", fmt, ...)
        print(debug.traceback("", 2))
    end
end

function echoVerb(...)
    if (DEBUG>=3) then
        echo(string.format("%s", ...));
    end
end

function echoInfo(fmt, ...)
    if (DEBUG>=2) then
        echoLog("INFO", fmt, ...)
    end
end

function tostring64(num)
	if type(num) == "number" then
		local high = math.floor(num/1000000000)
		local low = math.floor(num%1000000000)
		
		if high > 0 then
			local lowStr = tostring(low)
			local i = 9 - lowStr:len()
			for j=1,i do
				lowStr = "0"..lowStr
			end
			return string.format("%s%s", high,lowStr)
		else
			return string.format("%s", low)
		end
    else 
    	print("has error tostring64, num is not number")
    end
end 

function toMonetary(num) 
    local str = nil

    if type(num) == "string" then 
        str = num 
    elseif type(num) == "number" then 
        str = tostring(num)
    else 
        print("has error toMonetary, num is error type")
    end 
    print("toMonetary:"..str)
    local len = #str 
    local j = len%3 
    local tempTable = {} 
    local newstr = "" 
    local i =1 
    if j == 0 then 
    	j = 3 
    end
    while j <= len do 
        print(string.sub(str,i,j))
        table.insert(tempTable, string.sub(str,i,j))
        i = j+1
        j = j+3
    end 
    len = #tempTable
    for k,v in pairs(tempTable) do
        if k == len then 
            newstr = newstr..v
        else
            newstr = newstr..v.."," 
        end
    end   
    print(newstr)
    return newstr
    --local tempTable = {} 
    -- while num ~= 0 do 
    --     local c = num%1000 
    --     print(c)
    --     num = math.floor(num/1000) -- num < 0 ??
    --     print(num)
    --     table.insert(tempTable, c)
    -- end 
    --local newstr = ""
    -- for k,v in pairs(tempTable) do
    --     newstr = newstr..v..","
    --     print(newstr)
    -- end
    -- return string.reverse(newstr)
end 
function removeTableValue(t,v)
    table.foreach(t, function(i, k) 
            if k == v then
                table.remove(t,i) 
            end
        end)
end
function numberChange(num)
	if type(num) == "string" then
		local n = tonumber(num) 
		if nil == n then
			--CCLuaLog(debug.traceback("", 2))
			--error(num.."the value is not a number") 
			return num
	    end
	    num = tonumber(num)
	end 
	local prex = ""
	if num < 0 then 
		num = math.abs(num) 
		prex = "-" 
	end
	if num >= 100000000 then
		local yi = math.floor(num/100000000) 
		--num = string.format("%4.1f",num/100000000)
		num = num - yi*100000000
		local wan = math.floor(num/10000)
		if wan == 0 then 
			return prex..tostring(yi).."亿"
		else 
			return prex..tostring(yi).."亿"..tostring(wan).."万"
		end
	elseif num >= 10000 then 
		num = math.floor(num/10000) 
		return prex..tostring(num).."万"
	else 
		return prex..tostring(num)
	end
	
end

--是否本地文件
function isLocalFile(filename)
	if string.sub(filename,1,4) == "http" then
		return false
	end

	local fFiles = CCFileUtils:sharedFileUtils():fullPathForFilename(filename);
    if io.exists(fFiles) == false then
    	return false
    else 
    	return true
    end
end
--把表写成lua文件
function tableWriteToFile(filename,globlename,pamTable)
	local file = nil
	if globlename ~= nil then
		file = io.open(filename,"w")
		file:write(globlename)
		file:write("={\n")
	else
		file = filename
		file:write("{\n")
	end
	
	
	for k,v in pairs(pamTable) do
		if type(k) == "number"then
			file:write("[")
			file:write(k)
			file:write("]")
		else
			file:write(k)
		end
		file:write("=")
		if type(v) == "number" then
			local n,f = math.modf(v)
			if f == 0 then 
				file:write(string.format("%d",v))
			else
				file:write(string.format("%0.2f",v))
			end
		elseif type(v) == "boolean" then
			if v == true then
				file:write("true")
			else
				file:write("false")
			end
		elseif type(v) == "string" then
			file:write("\"")
			file:write(v)
			file:write("\"")
		elseif type(v) == "table" then
			tableWriteToFile(file,nil,v)
		end
		file:write(",\n")
	end
	file:write("}\n")
	if globlename ~= nil then
		file:write("return ")
		file:write(globlename)
		file:close()
	end
end

--两个表相加
function TwoTableAdd(src,dec)
    for i,v in pairs(src) do
		--CCLuaLog(i)
        local vtyp = type(v);
        if (vtyp == "table") then
            dec[i] = {}
			TwoTableAdd(v,dec[i]);
			
        elseif (vtyp == "thread") then
            dec[i] = v;
        elseif (vtyp == "userdata") then
            dec[i] = v;
        else
            dec[i] = v;
        end
    end
end

function CreatEnumTable(tbl, index) 
    --assert(type(tbl) == "table") 
    local enumtbl = {} 
    local enumindex = index or -1 
    for i, v in ipairs(tbl) do 
        enumtbl[v] = enumindex + i 
    end 
    return enumtbl 
end 

--把一个数组表转换成以某个键值做键的表
function tableTransitionKey(pamTable,key)
	local new_table = {}
	for k,v in pairs(pamTable) do
		new_table[v[key]] = {}
		TwoTableAdd(v,new_table[v[key]])
	end
	return new_table
end

function printx(...)
    local buf = {...}
    for i=1, select("#", ...) do
        buf[i] = tostring(buf[i])
    end
    print(table.concat(buf, "\t") .. "\n")
end

--打印表内容不包含函数
function printxTable(pamdata,tabellist)
	--printx("printxTable begin",pamdata)
	if tabellist == nil then
		tabellist = {}
	end
	for k,v in pairs(pamdata) do
		--printx(k,"=",type(v))
		if type(v) == "table" then
			--printx(v)
			for k1,v1 in pairs(tabellist) do
				if v1 == v then
					return
				end
			end
			table.insert(tabellist,v)
			printx(k,"=")
			printxTable(v,tabellist)
		elseif  type(v) == "string" then
			printx(string.format("%s=%s",k,v))
		elseif type(v) == "number" then
			printx(string.format("%s=%d",k,v))
		elseif type(v) == "boolean" then
			if v == false then
				printx(string.format("%s=false",k))
			else
				printx(string.format("%s=true",k))
			end
		else
			printx(v)
		end
	end
end


--路径转换
function pathTransform(path)
	return path
end


function transition.spawn(actions)
    if #actions < 1 then return end
    if #actions < 2 then return actions[1] end

    local prev = actions[1]
    for i = 2, #actions do
        prev = CCSpawn:createWithTwoActions(prev, actions[i])
    end
    return prev
end

function getCCTextureByName(name)
	return CCTextureCache:sharedTextureCache():addImage(name)
end

--解析字符串如0,0|1,1|2,2
--anykey({id,lvl},str)
function anystr(kTable,str)
	local strTabel = {}
	if str == "0" then return {} end
	while string.find(str,"|") ~= nil do
		local i,j = string.find(str,"|")
		table.insert(strTabel,string.sub(str,1,i-1))
		str = string.sub(str,j+1,string.len(str))
	end
	table.insert(strTabel,string.sub(str,1,string.len(str)))
	if kTable == nil then
		return strTabel
	end
	local tempTabel = {}
	for k,v in pairs(strTabel) do
		table.insert(tempTabel,anyKey(kTable,v))
	end
	return tempTabel
end
--解析字符串如1,1kTable表示每个间隔的Ｋey
function anyKey(kTable,str)
	--printx("len =",string.len(str),"anyKey=",str)
	local tempTable = {}
	--printxTable(kTable)
	for k,v in pairs(kTable) do
		--printx(str)
		local i,j = string.find(str,",")
		if i == nil then
			tempTable[v]= tonumber(string.sub(str,1,string.len(str)))
			break
		else
			tempTable[v]= tonumber(string.sub(str,1,i-1))
		 	str = string.sub(str,j+1,string.len(str))
		end

	end
	return tempTable
end

--解析字符串如0-0,1-1,2-2
--anykey({id,lvl},str)
function anystr1(kTable,str)
	local strTabel = {}
	if str == "0" then return {} end
	while string.find(str,",") ~= nil do
		local i,j = string.find(str,",")
		table.insert(strTabel,string.sub(str,1,i-1))
		str = string.sub(str,j+1,string.len(str))
	end
	table.insert(strTabel,string.sub(str,1,string.len(str)))
	if kTable == nil then
		return strTabel
	end
	local tempTabel = {}
	for k,v in pairs(strTabel) do
		table.insert(tempTabel,anyKey1(kTable,v))
	end
	return tempTabel
end
--解析字符串如1,1kTable表示每个间隔的Ｋey
function anyKey1(kTable,str)
	--printx("len =",string.len(str),"anyKey=",str)
	local tempTable = {}
	--printxTable(kTable)
	for k,v in pairs(kTable) do
		--printx(str)
		local i,j = string.find(str,"-")
		if i == nil then
			tempTable[v]= tonumber(string.sub(str,1,string.len(str)))
			break
		else
			tempTable[v]= tonumber(string.sub(str,1,i-1))
		 	str = string.sub(str,j+1,string.len(str))
		end

	end
	return tempTable
end

--解析字符串如1,1 kTable表示每个间隔的Ｋey,key间隔符,
function anyKeyformkey(kTable,str,key)
	--printx("len =",string.len(str),"anyKey=",str)
	local tempTable = {}
	--printxTable(kTable)
	for k,v in pairs(kTable) do
		--printx(str)
		local i,j = string.find(str,key)
		if i == nil then
			tempTable[v]= tonumber(string.sub(str,1,string.len(str)))
			break
		else
			tempTable[v]= tonumber(string.sub(str,1,i-1))
		 	str = string.sub(str,j+1,string.len(str))
		end

	end
	return tempTable
end


--根据传入的string  00:00:00 得到int值
function Time_TranslateStringToInt(stringTime)
		printx("Time_TranslateStringToInt(stringTime)",stringTime)
		local tmpstringTime = stringTime
		local tmpInt = 0
		tmpInt = (tonumber(string.sub(tmpstringTime,1,2)))*3600
		--printx(tmpInt)
		tmpstringTime = string.sub(tmpstringTime,4,-1)
		--printx(tmpstringTime)
		tmpInt = tmpInt + (tonumber(string.sub(tmpstringTime,1,2)))*60
		--printx(tmpInt)
		tmpstringTime = string.sub(tmpstringTime,4,-1)
		--printx(tmpstringTime)
		tmpInt = tmpInt + (tonumber(tmpstringTime))
		--printx(tmpInt)
	return tmpInt
end
--根据传入的int值 得到00:00:00 
function Time_TranslateIntToString(intTimeSecond)
	--printx("Time_TranslateIntToString(intTimeSecond)",intTimeSecond)
	local endString
	local tmpInt = intTimeSecond
	local tmp = tmpInt/3600
	--printx(tmp,math.floor(tmp))
	endString = string.format("%02d",math.floor(tmp)) 
	--printx(endString)
	endString = endString..":"
	tmpInt = tmpInt%3600
	endString = endString..string.format("%02d",math.floor(tmpInt/60))
	--printx(endString)
	endString = endString..":"
	tmpInt = tmpInt%60
	endString = endString..string.format("%02d",tmpInt)
	--printx(endString)
	return endString
end
--表的深度拷贝
function deepcopy(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end  -- for
		return setmetatable(new_table, getmetatable(object))
	end  -- function _copy
	return _copy(object)
end  -- function deepcopy 

--
--把数字转换成位表只支持最多8位
bit={data8={}}
for i=1,8 do
    bit.data8[i]=2^(8-i)
end

function bit:d2b(arg)
    local   tr={}
    for i=1,8 do
        if arg >= self.data8[i] then
        tr[9-i]=true
        arg=arg-self.data8[i]
        else
        tr[9-i]=false
        end
    end
    return   tr
end   --bit:d2b

function string_last_of(str,c)
	local k = 0
	while string.find(str,c) ~= nil do
	    local i,j = string.find(str,c)
	    str = string.sub(str,j+1,string.len(str))
	    k = j+k;
	end
	return k, str
end
--从字符串中根据位置获取字符
function getCharFromStrByIndex(str,index)
    local len  = #str
    local left = 1
    local cnt  = 1
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    --printx("leftaaa = ",left)
    while left <= len do
        local tmp = string.byte(str, left)
        --printx("cnt = ",cnt,"tmp=",tmp)
        local i   = #arr
        while arr[i] do
        	--printx("i=",i)
            if tmp >= arr[i] then
            	if cnt == index then
                	return string.sub(str,left,left+i-1)
                end
                left = left + i

                --printx("ddvd=",i,"left=",left)
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
end


--从字符串中提取表情
function anystrface(str)
	local temp = {}
	while string.find(str,"#")~=nil do
		local i,j = string.find(str,"#")
		local child = {}
		child.str = string.sub(str,1,j-1)
		local id = string.sub(str,j+1,j+2)
		child.id = tonumber(id)
		table.insert(temp,child)
		str = string.sub(str,j+3,string.len(str))
	end
	local child = {}
	child.str = str
	child.id = -1
	table.insert(temp,child)
	printxTable(temp)
	return temp
end 

--把数值改成以万为单位,type(value)==number,return a string
function NumberToWan(value)
	local str=value
	if type(str) ~="number" then 
		CCLuaLog(debug.traceback("", 2))
		error("the value is not a number") 
	end
	if str>100000 then
		return tostring(math.floor(str/10000)).."万"
	end
	return tostring(math.floor(str))
end


--一句话中有不同着色的文字
function drawColorWord(param)
	local tw = param.size.width
	local th = param.size.height
	local wordlayer = display.newLayer()
	local x = 0
	local y = th - param.fontsize/2
	for k,v in pairs(param.word) do
		local len = string.utf8len(v.str)
		local w = 0
		local str = ""
		for i=1,len do
			local one = getCharFromStrByIndex(v.str,i)
			local test = ui.newTTFLabel({text=one,x=0,y=0,font=font,size=param.fontsize,color=ccc3(v.color.r,v.color.g,v.color.b)})
			local size = test:getContentSize()
			w = w + size.width
			if x + w > tw then
				--printx("str = ",str,"x=",x,"w=",w)
				local strsprite = ui.newTTFLabel({text=str,x=x,y=y,font=font,size=param.fontsize,color=ccc3(v.color.r,v.color.g,v.color.b)})
				strsprite:setAnchorPoint(ccp(0.0,0.5))
				wordlayer:addChild(strsprite,1,1)
				x = 0
				y = y - 25
				w=0
				str = ""
			end
			str = str..one
		end
		if str ~= "" then
			local strsprite = ui.newTTFLabel({text=str,x=x,y=y,font=font,size=param.fontsize,color=ccc3(v.color.r,v.color.g,v.color.b)})
			strsprite:setAnchorPoint(ccp(0.0,0.5))
			wordlayer:addChild(strsprite,1,1)
			x = x + strsprite:getContentSize().width	
		end
	end
	return wordlayer
end

function split(path,sep)
  local t = {}
  for w in path:gmatch("[^"..(sep or "/").."]+")do
    table.insert(t, w)
  end
  return t
end

function sub_var_dump(data, max_level, prefix)
	local info = "";
	if max_level == nil then
		max_level = 2;
	end
    if type(prefix) ~= "string" then
        prefix = ""
    end
    if type(data) ~= "table" then
        info = info..(prefix .. tostring(data).."  ("..type(data)..")\r\n")
    else
        info = info..(prefix .."".."(table)\r\n")
        if max_level ~= 0 then
            local prefix_next = prefix .. "    "
            info = info..(prefix .. "{\r\n")
            for k,v in pairs(data) do
                info = info..(prefix_next .. k .. " = ")
                if type(v) ~= "table" or (type(max_level) == "number" and max_level <= 1) then
                  
                    info = info..(tostring(v).."  ("..type(v)..")\r\n")
                else
                    info = info..sub_var_dump(v, max_level - 1, prefix_next)
                end
            end
            info = info..(prefix .. "},\r\n")
        end
    end
    return info;
end

function var_dump(data, max_level, prefix)
	local info = "";
	if max_level == nil then
		max_level = 2;
	end
    if type(prefix) ~= "string" then
        prefix = ""
    end
    if type(data) ~= "table" then
        info = info..(prefix .. tostring(data).."  ("..type(data)..")\r\n")
    else
        info = info..(prefix .."".."(table)\r\n")
        if max_level ~= 0 then
            local prefix_next = prefix .. "    "
            info = info..(prefix .. "{\r\n")
            for k,v in pairs(data) do
                info = info..(prefix_next .. k .. " = ")
                if type(v) ~= "table" or (type(max_level) == "number" and max_level <= 1) then
                  
                    info = info..(tostring(v).."  ("..type(v)..")\r\n")
                else
                    if max_level == nil then
                        info = info.. sub_var_dump(v, nil, prefix_next)
                    else
                        info = info.. sub_var_dump(v, max_level - 1, prefix_next)
                    end
                end
            end
            info = info..(prefix .. "},\r\n")
        end
    end
    print(info);
end

-- 合并参数传参，仿jquery
function genParam(target_opt,default_opt)
	if (target_opt == nil) then
		target_opt = {}
	end
	for k,v in pairs(default_opt) do
		if (type(v) == "number" or type(v) == "string" or type(v) == "boolean") then
			if (target_opt[k] == nil) then
				target_opt[k] = v;
			end
		elseif (type(v) == "table") then
			if (target_opt[k] == nil) then
				target_opt[k] = v;
			else
				genParam(target_opt[k],v);
			end
		elseif (type(v) == "function") then
			if (target_opt[k] == nil) then
				target_opt[k] = v;
			else
				genParam(target_opt[k],v);
			end
		else
			if (target_opt[k] == nil) then
				target_opt[k] = v;
			end
		end
	end
end
function getAnimationWithFrameList(sName,srcName,file,list)
  local pAnimation = CCAnimationCache:sharedAnimationCache():animationByName(sName);
  	if (pAnimation) then
    	return pAnimation;
  	else
    	if (pic_table_animation) then
	      	local path;
	      	if file ~= nil then
	        	path = "images/".. file .."/"..pic_table_animation[srcName].strFile
	      	else
	        	path = "images/donghua/"..pic_table_animation[srcName].strFile
	      	end
	    	local pTexture = CCTextureCache:sharedTextureCache():addImage(path);
	      	if (pTexture) then
		        pAnimation = CCAnimation:create();
		        --pAnimation:setName(sName);
		        pAnimation:setDelayPerUnit(pic_table_animation[srcName].nDuration/1000.0);

		        local sRect = pic_table_animation[srcName].sRect;
		        if sRect:equals(CCRectMake(0,0,0,0)) then
		          sRect.size = pTexture:getContentSize();
		        end

		        local num = 0;
		        --for j=0, pic_table_animation[sName].nHFrames - 1 do
		        --  for i=0,pic_table_animation[sName].nWFrames - 1 do
		        local counts = pic_table_animation[srcName].nTotal
		        if list~=nil then
		        	counts = #list
		        end
		        for i = 1, counts do
		        	local thisNum = i
		        	if list ~= nil then
		        		thisNum = list[i]
		        	else 
		        		thisNum = i-1;
		        	end
		            if (thisNum > pic_table_animation[srcName].nTotal) then
		              break;
		            end
		            local size = CCSizeMake(0, 0);
		            size.width = math.floor(sRect.size.width/pic_table_animation[srcName].nWFrames);
		            size.height = math.floor(sRect.size.height/pic_table_animation[srcName].nHFrames);
		            local width = size.width * (thisNum % pic_table_animation[srcName].nWFrames);
		            local height = size.height * math.floor(thisNum / pic_table_animation[srcName].nWFrames);
		            local orgPoint = sRect.origin;
		            local rect = CCRectMake(orgPoint.x + width, orgPoint.y + height, size.width, size.height);
		            pAnimation:addSpriteFrameWithTexture(pTexture, rect);
		        end
		        CCAnimationCache:sharedAnimationCache():addAnimation(pAnimation, sName);
		        return pAnimation;
		    end
    	end
  	end
  	return nil;
end
function getAnimation(sName,file)
	return getAnimationWithFrameList(sName,sName,file)
	-- local pAnimation = CCAnimationCache:sharedAnimationCache():animationByName(sName);

	-- if (pAnimation) then
	-- 	return pAnimation;
 --    else
    	
	-- 	if (pic_table_animation) then
	-- 		local path;
	-- 		if file ~= nil then
	-- 			path = "images/".. file .."/"..pic_table_animation[sName].strFile
	-- 		else
	-- 			path = "images/donghua/"..pic_table_animation[sName].strFile
	-- 		end
	-- 		local filename = CCFileUtils:sharedFileUtils():fullPathForFilename(path)
	--         if io.exists(filename)==false then
	--             path = "images/null.png"
	--         end
	-- 		local pTexture = CCTextureCache:sharedTextureCache():addImage(path);
	-- 		if (pTexture) then
	-- 			pAnimation = CCAnimation:create();
	-- 			--pAnimation:setName(sName);
	-- 			pAnimation:setDelayPerUnit(pic_table_animation[sName].nDuration/1000.0);

	-- 			local sRect = pic_table_animation[sName].sRect;
	-- 			if sRect:equals(CCRectMake(0,0,0,0)) then
	-- 				sRect.size = pTexture:getContentSize();
	-- 			end

	-- 			local num = 0;
	-- 			for j=0, pic_table_animation[sName].nHFrames - 1 do
	-- 				for i=0,pic_table_animation[sName].nWFrames - 1 do
	-- 					num = num + 1
	-- 					if (num > pic_table_animation[sName].nTotal) then
	-- 						break;
	-- 					end
	-- 					local size = CCSizeMake(0, 0);
	-- 					size.width = math.floor(sRect.size.width/pic_table_animation[sName].nWFrames);
	-- 					size.height = math.floor(sRect.size.height/pic_table_animation[sName].nHFrames);
	-- 					local orgPoint = sRect.origin;
	-- 					local rect = CCRectMake(orgPoint.x + i*size.width, orgPoint.y + j*size.height, size.width, size.height);
						
	-- 					pAnimation:addSpriteFrameWithTexture(pTexture, rect);
	-- 				end
	-- 			end
	-- 			CCAnimationCache:sharedAnimationCache():addAnimation(pAnimation, sName);
	-- 			return pAnimation;
	-- 		end
	-- 	end
	-- end
	-- return nil;
end

function getAnimation2(sName,file)
	print("--------------"..sName..":::::::::::::::::::"..file);
	local pAnimation = CCAnimationCache:sharedAnimationCache():animationByName(sName);

	if (pAnimation) then
		return pAnimation;
    else
    	--require("moduleDdz.logic.chatTable")
		if (anipaytable) then
			local path;
			if file ~= nil then
				path = "images/".. file .."/"..sName.."_"
			end

			if path == nil then return end 
			
			pAnimation = CCAnimation:create();
			pAnimation:setDelayPerUnit(anipaytable[sName].nDuration/1000.0);

			for i=0, anipaytable[sName].nTotal -1 do
				pAnimation:addSpriteFrameWithFileName(path..i..anipaytable[sName].fileType)				
			end
			CCAnimationCache:sharedAnimationCache():addAnimation(pAnimation, sName);
			return pAnimation;
			
		end
	end
	return nil;
end

function onBlockUIFail()
	echoError("SceneManager:onBlockUIFail")
	gBaseLogic.sceneManager:unblockUI();
	izxMessageBox("请求服务器失败","网络错误");
end

function izxMessageBox(info,title,maskType,zOrder)
	print("===="..info .. ":::"..title);
	--CCMessageBox(info,title);
	if zOrder ~= nil then
		gBaseLogic:showMessageRstBox({title=title,content=info},maskType,zOrder);
	else
		gBaseLogic:showMessageRstBox({title=title,content=info},maskType,9999);
	end
end
function resolutionFixedWidth(target,dh)
    local winSize = target:getContentSize()
    winSize.height = winSize.height + CCDirector:sharedDirector():getWinSize().height - dh
    return winSize
end 

function createTabView(target,size,type,data,view)
	target:removeAllChildrenWithCleanup(true);
    target.type = type;
    target.data = data;
    --local s1 = CCSizeMake(1136,512)
    print(size.width,size.height)
    local tableView = CCTableView:create(size)
    tableView:setDirection(kCCScrollViewDirectionVertical)
    --tableView:setContentSize(size)
    --tableView:setPosition(ccp(0, 0))
    tableView:setVerticalFillOrder(kCCTableViewFillTopDown)
    --tableView:setClippingToBounds(true);
    --tableView:setBounceable(false);
    tableView:setTag(101)
    target:addChild(tableView)
    --tableView:registerScriptHandler(view.scrollViewDidScroll,CCTableView.kTableViewScroll)
    --tableView:registerScriptHandler(TableViewLayer.scrollViewDidZoom,CCTableView.kTableViewZoom)
    --tableView:registerScriptHandler(TableViewLayer.tableCellTouched,CCTableView.kTableCellTouched)
    tableView:registerScriptHandler(view.cellSizeForTable,CCTableView.kTableCellSizeForIndex)
    tableView:registerScriptHandler(view.tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
    tableView:registerScriptHandler(view.numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView) 
    if (view.onTableViewScroll) then
        tableView:registerScriptHandler(view.onTableViewScroll,CCTableView.kTableViewScroll)
    end
    --tableView:addTouchEventListener(function(event, x, y)
    	-- local tab_x,tab_y = tableView:getPosition();
     --        --print("tablexy",tab_x,tab_y)
     --        if self.spriteContent:boundingBox():containsPoint(CCPoint(x-tab_x,y-tab_y)) == false then 
     --        	print("===========================================")
    	-- 		return false 
    	-- 	end 
    	-- 	print("+++++++++++++++++++++++++++++++++++++")
    	-- 	return true 
    	-- end)
    tableView:reloadData()
end	

function createEditBox(parent,sprite,fcallback,editboxParam)
    --创建输入框
    --parent:父节点
    --strHolder:默认显示文字
    --sprite:背景
    --fcallback:回调函数
    --otherParam:setInputMode:

    genParam(editboxParam,
	    {
	    	inputMode =  kEditBoxInputModeAny,
	    	inputFlag = kEditBoxInputFlagSensitive,
	    	returnType = kKeyboardReturnTypeDone,
	    	maxLen = 12,
	    	cFontSize = 24,
	    	strHolder = '',
	    	tag = 0,
	    	holderColor = ccc3(0,0,0),
	    	fontColor = ccc3(0,0,0),
	    	fontStr = "Helvetica"
		}
    );
    local editsize = parent:getContentSize();
    local EditBox = CCEditBox:create(editsize,sprite)
    --local EditBox = CCEditBox:creatEditBox()
    EditBox:setContentSize(editsize)
    EditBox:setPosition(editsize.width/2, editsize.height/2)
    --var_dump(editboxParam)
    EditBox:setPlaceholderFontColor(editboxParam.holderColor)
    EditBox:setFontColor(editboxParam.fontColor)
    EditBox:setPlaceHolder(editboxParam.strHolder)
    EditBox:setReturnType(editboxParam.returnType)
    --Handler
    EditBox:registerScriptEditBoxHandler(fcallback)

    EditBox:setTag(editboxParam.tag);
    EditBox:setFont(editboxParam.fontStr, editboxParam.cFontSize)
    EditBox:setInputMode(editboxParam.inputMode)
    EditBox:setMaxLength(editboxParam.maxLen)
    EditBox:setInputFlag(editboxParam.inputFlag)

    parent:addChild(EditBox)
    return EditBox;
end

function in_table ( e, t )
	for _,v in pairs(t) do
		if (v==e) then return true end
	end
	return false
end

function trim(str) --去除前后空格
	return string.gsub(str, "^%s*(.-)%s*$", "%1")
end
function supplant(str,listSrc,tableRst)
	for i=1,#listSrc do
		if (tableRst[listSrc[i]]~=nil) then
			str = string.gsub(str, "{".. listSrc[i] .."}", tableRst[listSrc[i]])
		end
	end
	return str
end
--多帧动画
function createAnimation(ani_type,imgList)
	local pAnimation = CCAnimation:create();
	pAnimation:setDelayPerUnit(100/1000.0);
	local frame_= {};   
    for i=1,ani_type+1 do
    	table.insert(frame_,i)
    end
    if #frame_ > 0 then
	    for i=1,#frame_ do    		
			local sprite = CCSprite:create(imgList[frame_[i]])
			pAnimation:addSpriteFrameWithTexture(sprite:getTexture(),sprite:getTextureRect());			
	    end            
	end
	return pAnimation;
end	

function createScreenShotElement(element,fileName,pngOrJpg)
	local size = element:getContentSize();
    local x,y = element:getPosition(); 

    -- //定义一个元素大小的渲染纹理  
    
    local pScreen = CCRenderTexture:create(size.width,size.height, kCCTexture2DPixelFormat_RGBA8888); 
    element:setPosition(size.width/2,size.height/2) ;
    -- //渲染纹理开始捕捉  
    pScreen:begin();  
    -- //当前场景参与绘制  
    element:visit();  
    -- //结束捕捉  
    pScreen:endToLua();  


    element:setPosition(x,y) ;
    local typ;
    if (pngOrJpg == 'png') then
    	typ = kCCImageFormatPNG;
    else 
    	typ = kCCImageFormatJPEG;
    end
    
    return pScreen:saveToFile(fileName, typ);  
end

function getFileExtension(filename)
	return filename:match(".+%.(%w+)$")
end

function getUrlExtension(urlName)
	local ext = urlName:match(".+%.(%w+)%?*.*$");
	if (ext~='jpg' and ext~='png' and ext~='zip') then
		ext = 'unknown';
	end
	return ext ;
end

function hex(s)
 s=string.gsub(s,"(.)",function (x) return string.format("%02X",string.byte(x)) end)
 return s
end

function readFile(path)
    local file = io.open(path, "rb")
    if file then
        local content = file:read("*all")
        io.close(file)
        return content
    end
    return nil
end

function removeFile(path)
    --CCLuaLog("removeFile: "..path)
    io.writefile(path, "")
    os.remove(path);
    -- if device.platform == "windows" then
    --     os.execute("del /F " .. string.gsub(path, '/', '\\'))
    -- else
    --     os.execute("rm -f " .. path)
    -- end
end

function renameFile(name1, name2)

   if device.platform == "windows" then
      local cmd=string.gsub("move /Y "..name1.." "..name2, '/', '\\')
      os.execute(cmd)
   else
      
      os.execute("mv -f "..name1.." "..name2)
   end
end

function checkDirOK( path )
    require "lfs"
    local oldpath = lfs.currentdir()
    echoInfo("old path------> "..oldpath)

     if lfs.chdir(path) then
        lfs.chdir(oldpath)
        echoInfo("path check OK------> "..path)
        return true
     end

     if lfs.mkdir(path) then
        echoInfo("path make OK------> "..path)
        return true
     end
     return false;
end

function checkDirExists(path)
	require "lfs"
    local oldpath = lfs.currentdir()
    echoInfo("old path------> "..oldpath)

    if lfs.chdir(path) then
        lfs.chdir(oldpath)
        echoInfo("path check OK------> "..path)
        return true
    end
	return false;
end

function rmDir(path)

	-- local result,err = lfs.rmdir(path);
	-- echoInfo("rmDir!!!!!!!!!!!"..path);
	-- var_dump(result);
	-- var_dump(err);
	local lfs = require "lfs";		
	local resultOK, errorMsg;
	local oldpath = lfs.currentdir()
    echoInfo("old path------> "..oldpath)

    if (checkDirExists(path)~=true) then
    	return
    end
	--remove files from directory
	for file in lfs.dir(path) do
		echoInfo("do rm for %s", file);
		if (file~="." and file~="..") then
			local theFile = path.."/"..file;

			if (lfs.attributes(theFile, "mode") ~= "directory") then
				resultOK, errorMsg = os.remove(theFile);

				if (resultOK) then
					echoVerb(file.." removed");
				else
					echoError("Error removing file: "..file..":"..errorMsg);
				end
			else

				rmDir(theFile);
			end
		end
	end
	
	-- remove directory
	resultOK, errorMsg = os.remove(path);

	if (resultOK) then
		echoInfo(path.." dir removed");
	else
		echoError("Error removing file: "..path..":"..errorMsg);
	end
end

function HTTPPostRequest(rst_url,pdata,cback)
	--local url = self.httpClient_url .. rst_url
	local url = rst_url
	print("HTTPPostRequest==ack"..url)

    function callback(event)
    	
	    local ok = (event.name == "completed")
	    local request = event.request

	    if not ok then
	    	if (event.name == "inprogress") then
	    		return
	    	end
	    	print("HTTPPostRequest==ack11"..url..":"..event.name)
	        echoInfo("HTTP ERROR %s %s %s %s",rst_url,event.name,request:getErrorCode(), request:getErrorMessage())
	        if cback then cback(nil) end
	    else
	    	print("HTTPPostRequest==ack11"..url..":"..event.name)
	    	local code = request:getResponseStatusCode()
	    	echoVerb("request %s returns %d",rst_url,code);
		    if code ~= 200 then
		        if cback then cback(nil) end
		    else
		    	local response = request:getResponseString()
		    	if (DEBUG>=3) then
			    	print("----HTTP getResponseString---- data for:"..rst_url);
			    	var_dump(pdata);
			    	print("----HTTP getResponseString response----");
			    	var_dump(response);
			    	print("----HTTP getResponseString---end");
			    end
		    	--解析成table
		    	local table = json.decode(response)
		    	--返回table数据
		    	if cback then cback(table) end
		    end
	    end
	end
	local request = network.createHTTPRequest(callback, url, "POST")
	if pdata then--add key,value
		for k,v in pairs(pdata) do
			request:addPOSTValue(k, v)
		end
	end
	request:setTimeout(20);
	request:start()
end

function unsigned_ten2two(a)
    --print "unsigned_ten2two"
    --print("a = "..a)
    local n,k = math.modf(a)
    if n <= 0  or k ~= 0 then
        return a
    end
    local str = ""
    local i = a
    local j = 0
    while i ~= 1 do
        i,j = math.modf(i/2)
        j = (j ~= 0 and 1 or 0)
        str = str..j
    end
    str = str..1
    str = string.reverse(str)
    return str
end

function unsigned_andop(a,b)
    --print "unsigned_andop"
    --print("a = "..a..", b = "..b)
    if a == 0 or b == 0 then
        return 0
    end

    local n,k = math.modf(a)
    if n < 0  or k ~= 0 then
        return 0
    end
    n,k = math.modf(b)
    if n < 0  or k ~= 0 then
        return 0
    end

    local a2 = unsigned_ten2two(a)
    local b2 = unsigned_ten2two(b)
    --print("a2 = "..a2..", b2 = "..b2)

    local a2len = a2:len()
    local b2len = b2:len()
    --print("a2len = "..a2len..", b2len = "..b2len)
    local len = (a2len <= b2len and a2len or b2len)
    --print("len = "..len)
    a2 = string.sub(a2, -len)
    b2 = string.sub(b2, -len)
    --print("a2 = "..a2..", b2 = "..b2)
    if tonumber(a2) == 0 or tonumber(b2) == 0 then
        return 0
    end
    local function get1index(a)
        local tbl = {}
        local len = a:len()
        tbl.first1 = 0
        local i = 1
        while true do
            local x = string.find(a,"1",i)
            if nil ~= x then
                if tbl.first1 == 0 then
                    tbl.first1 = x
                end
                tbl[x] = len - x
                if i+1 > len then
                    break
                else
                    i = i+1
                end 
            else
                break
            end
        end
        return tbl
    end
    local a2tbl = get1index(a2)
    local b2tbl = get1index(b2)

    --var_dump(a2tbl)
    --var_dump(b2tbl)

    local mintbl
    local maxtbl
    if a2tbl.first1 >= b2tbl.first1 then
        mintbl,maxtbl = a2tbl,b2tbl
    else
        mintbl,maxtbl = b2tbl,a2tbl
    end

    local value10 = 0
    for key,value in pairs(mintbl) do 
        --print(key,value)
        if maxtbl[key] ~= nil and key ~= "first1" then
            value10 = value10 + math.pow(2,value)
        end
    end
    local value2 = unsigned_ten2two(value10)
    return value10,value2
end

function round(mult,idp)
	local mult = 10^(idp or 0)
  	return math.floor(num * mult + 0.5) / mult
end

function ShowNoContentTip(node,msg)
	-- 
	node:removeAllChildrenWithCleanup(true);
    local label = CCLabelTTF:create(msg, "Helvetica", 56.0)
    node:addChild(label)
    label:setPosition(node:getContentSize().width/2,node:getContentSize().height/2);
    label:setDimensions(CCSize(node:getContentSize().width*0.8, node:getContentSize().height))
    label:setAnchorPoint(ccp(0.5,0.5))
    -- label:setHorizontalAlignment(kCCVerticalTextAlignmentCenter)
    label:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    label:setColor(ccc3(220, 220, 220))
end

function openWebview(lt,rb,url,isLocalUrl,params,onJSCallback)
	if (device.platform=="ios") then
		if (isLocalUrl) then
			local htmlFile = CCFileUtils:sharedFileUtils():fullPathForFilename(url);
		    htmlFile = string.gsub(htmlFile, "assets/", "/android_asset/") 
		    url = "file://"..htmlFile;
		end
		local param = json.encode(params);
	    local args = {
	    	url = url,
	    	x = lt.x,
	    	y = lt.y,
	    	w = (rb.x- lt.x),
	    	h = (rb.y-lt.y),
	    	param = param,
	    	fun = function(event)
                onJSCallback(event);                 
       	end
	    }

	    luaoc.callStaticMethod("LuaObjc", "showWebView", args)
	elseif (device.platform=="android") then
		if (isLocalUrl) then
			local htmlFile = CCFileUtils:sharedFileUtils():fullPathForFilename(url);
		    htmlFile = string.gsub(htmlFile, "assets/", "/android_asset/") 
		    url = "file://"..htmlFile;
		end
		
	    local param = json.encode(params);

	    -- call Java method
	    local javaClassName = "com.izhangxin.utils.luaj"
	    local javaMethodName = "showWebView"
	    local javaParams = {
	                url,
	                param,
	                lt.x,lt.y,(rb.x- lt.x),(rb.y-lt.y),
	                function(event)
	                    onJSCallback(event);                 
	                end
	    }
	    local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;FFFFI)V"
	    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig);

	elseif (device.platform=="windows") then
		echoError("Windows not support webview now!");

	end
end

function closeWebview()
	if (device.platform=="ios") then         
	    luaoc.callStaticMethod("LuaObjc", "closeWebView")

	elseif (device.platform=="android") then
		local javaClassName = "com.izhangxin.utils.luaj"
	    local javaMethodName = "closeWebView"
	    local javaParams = {}
	    local javaMethodSig = "(Ljava/lang/String;FFFF)V"
	    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

function formatSize(input)
	local output = "";
	if (input>1000000000) then
		output = string.format("%.3fG",input/1000000000);
	elseif (input>1000000) then
		output = string.format("%.2fM",input/1000000);
	elseif (input>1000) then
		output = string.format("%.1fK",input/1000);
	else
		output = string.format("%d",input);
	end
	return output;
end

function formatSizeK(input,withK)
	local format = "%.1f";
	if (withK) then
		format = "%.1fK";
	end
	return string.format(format,input/1000);
end
--CCContrlButton title change
function reSetControlButtonTitle(ControlButton,title)
	local tempString = CCString:create(title.."");
	ControlButton:setTitleForState(tempString,CCControlStateNormal);
end

function flowerAutoRemove(sender)
	-- body
	print "flowerAutoRemove"
	local node = tolua.cast(sender,"CCNode");
	node:removeFromParentAndCleanup(true)
end
function echoLogFile(content)
	local file = io.open(superLogFile,"w");
	if (file==nil) then
		print("where is the file?"..superLogFile);
	else
	
		file:write(content);
		file:write("\n");
		file:close();
	end
		end

function echoError(fmt, ...)
    print(getLog("ERR", fmt, ...))
    print(debug.traceback("", 2))
    if (superLogFile~=nil) then
    	echoLogFile(os.time()..":"..getLog("ERR", fmt, ...));
    	echoLogFile(debug.traceback("", 2));
	end
end

function echoInfo(fmt, ...)
	print(getLog("INFO", fmt, ...))
    if (superLogFile~=nil) then
    	echoLogFile(os.time()..":"..getLog("INFO", fmt, ...));
    end
	end
function flowerExplosion(sender)
	-- body
	print "flowerExplosion"
	local node = tolua.cast(sender,"CCNode");
	local rotation = node:getRotation()
	local length = node:getContentSize().height
	local disX = math.sin(math.rad(rotation))*length
	local disY = math.cos(math.rad(rotation))*length
	local pos = ccp(node:getPositionX()+disX, node:getPositionY()+disY)
	math.randomseed(getRandomKey())
	local len = math.random(10,20)
	
	for i=1,30 do
		math.randomseed(getRandomKey())	
		local srcScaleY = math.random(10,15)/10
		local remain = i%4
		math.randomseed(getRandomKey())	
		if remain == 0 then 
			dstScaleY = math.random(30,40)/10
		elseif remain == 1 then 
			dstScaleY = math.random(10,20)/10
		elseif remain == 2 then 
			dstScaleY = math.random(10,20)/10
		elseif remain == 3 then 
			dstScaleY = math.random(10,30)/10
		end

		createFlowerAndAction({
				parent = node:getParent(),
				pos = pos,
				rotation = i*18, 
				length = len,
				delay = 0,
				srcScaleY = srcScaleY,
				dstScaleY = dstScaleY,
				}
			)
	end
end

function createFlowerAndAction(param)
	-- body
	local colorArray = {}
	colorArray[1] = ccc3(222, 71, 222)
	colorArray[2] = ccc3(6, 242, 242)
	colorArray[3] = ccc3(150, 255, 255)
	colorArray[4] = ccc3(184, 238, 37)
	colorArray[5] = ccc3(25, 102, 240)
	colorArray[6] = ccc3(255, 149, 156)
	colorArray[7] = ccc3(228, 240, 240)

	local flower = CCSprite:create("images/flower.png")
	param.parent:addChild(flower)
	
	local disX = math.sin(math.rad(param.rotation))*param.length
	local disY = math.cos(math.rad(param.rotation))*param.length

	flower:setPosition(param.pos)
	math.randomseed(getRandomKey())
	local diffLen = math.random(1,40)
	local diffX = math.sin(math.rad(param.rotation))*diffLen
	local diffY = math.cos(math.rad(param.rotation))*diffLen
	flower:setPosition(ccp(flower:getPositionX()+diffX, flower:getPositionY()+diffY))

	flower:setAnchorPoint(ccp(0.5,0))
	flower:setRotation(param.rotation)
	flower:setScaleY(param.srcScaleY)
	math.randomseed(getRandomKey())	
	flower:setColor(colorArray[math.random(1,#colorArray)])
	--flower:setColor(ccc3(230,130,182))

	local disPos = ccp(flower:getPositionX()+disX, flower:getPositionY()+disY)

	if param.isExplosion then
		flower:runAction(transition.sequence({CCHide:create(),
			CCDelayTime:create(param.delay),
			CCShow:create(),
			CCSpawn:createWithTwoActions(CCScaleTo:create(0.5,1.0), CCMoveTo:create(0.5, disPos)),
			CCHide:create(),
			CCCallFuncN:create(flowerExplosion),
			CCCallFuncN:create(flowerAutoRemove)}))
	else
		local arr = CCArray:create()
    	arr:addObject(CCMoveTo:create(1.0, disPos))
    	arr:addObject(CCScaleTo:create(1.0,1,param.dstScaleY))
    	arr:addObject(CCFadeOut:create(1.0))

		flower:runAction(transition.sequence({CCHide:create(),
			CCDelayTime:create(param.delay),
			CCShow:create(),
			-- CCSpawn:createWithTwoActions(CCScaleTo:create(moveTime,math.random(80,100)/100), CCMoveTo:create(moveTime, disPos)),
			--CCScaleTo:create(moveTime,1,1),
			--CCSpawn:createWithTwoActions(CCMoveTo:create(1.0, disPos), CCFadeOut:create(1.0)),
			CCSpawn:create(arr),
			--CCDelayTime:create(1.0),
			CCCallFuncN:create(flowerAutoRemove)}))
	end
end

function deleteNotifyByTS(ts)
	echoInfo("deleteNotifyByTS %d",ts);

	if (device.platform=="ios") then
		echoError("ios not support deleteNotifyByTS now!");
	elseif (device.platform=="android") then

	    -- call Java method
	    local javaClassName = "com.izhangxin.utils.luaj"
	    local javaMethodName = "deleteNotifyByTS"
	    local javaParams = {
	                ts
	    }
	    local javaMethodSig = "(I)V"
	    local ret = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig);
	    if (ret) then
			echoInfo("call successful");
	    else
	    	echoError("call deleteNotifyByTS android failed!!!!");
	    end

	elseif (device.platform=="windows") then
		echoError("Windows not support deleteNotifyByTS now!");

	end

end
-- sendNotifyByAfter(10,"XXXX","FUCK!!!!!!!!!!!");
-- sendNotifyByTS(1234444444,"XXXX","DDDDDDDD");
function sendNotifyByTS(ts,title,info)
	echoInfo("sendNotifyByTS %d %s %s",ts,title,info);

	if (device.platform=="ios") then
		echoError("ios not support sendNotifyByTS now!");
	elseif (device.platform=="android") then

	    -- call Java method
	    local javaClassName = "com.izhangxin.utils.luaj"
	    local javaMethodName = "sendNotifyByTS"
	    local javaParams = {
	                title,
	                info,
	                ts
	    }
	    local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;I)V"
	    local ret = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig);
	    if (ret) then
			echoInfo("call successful");
	    else
	    	echoError("call sendNotifyByTS android failed!!!!");
	    end

	elseif (device.platform=="windows") then
		echoError("Windows not support sendNotifyByTS now!");

	end
end

function sendNotifyByAfter(diffTime,title,info)
	local tsNow = os.time();
	sendNotifyByTS(tsNow+diffTime,title,info);
end

function getLog(tag, fmt, ...)
    return (string.format("[%s] %s", string.upper(tostring(tag)), string.format(tostring(fmt), ...)))
end

function cleanCopy(src)
	local target;
	if (type(src)=="table") then
		target = {};
		for k,v in pairs(src) do
			if (type(src)=="table") then
				target[k] = cleanCopy(src[k]);
			else
				target[k] = v;
			end
		end
	else
		target = src;
	end
	return target;
end

function get00ofday(day)
	if day==nil then
		day = os.time();
	end
	return os.time({year=os.date("%Y",day), month=os.date("%m",day), day=os.date("%d",day), hour=0})
end

function trans_plist_to_lua_table(plistPath)
	local target = {};
	local plistDic=CCDictionary:createWithContentsOfFile(plistPath)
    plistDic = tolua.cast(plistDic, "CCDictionary")

    local allKeys = plistDic:allKeys();
    for i=1,allKeys:count() do
    	local key = allKeys:objectAtIndex(i-1);
    	key = tolua.cast(key, "CCString")
    	local myKey = key:getCString();
    	
    	local items = plistDic:objectForKey(myKey);
    	items = tolua.cast(items, "CCArray");

    	target[myKey] = {};

    	for j=1,items:count() do
    		local targetItem = {};
	    	local item = items:objectAtIndex(j-1);
	    	item = tolua.cast(item, "CCDictionary")
	    	local allItemKeys = item:allKeys();
	    	for i=1,allItemKeys:count() do
		    	local keyItem = allItemKeys:objectAtIndex(i-1);
		    	keyItem = tolua.cast(keyItem, "CCString")
		    	local myKeyItem = keyItem:getCString();
		    	targetItem[myKeyItem] = item:valueForKey(myKeyItem):getCString();
		    end
		    table.insert(target[myKey],targetItem);
	    end
    	

    end
    return target;
end