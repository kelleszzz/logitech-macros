function LoopAbort()
	return IsMouseButtonPressed(4)
end

function XPressKeys(msg)
	if msg==nil then
		return
	end
	for i=1,#msg do
		XPressKey(string.sub(msg,i,i))
	end
end

function XPressKey(letter)
	if LoopAbort() then
		return
	end
	if letter==nil or #letter>1 then
		return
	end
	--大写字母
	if string.byte(letter,1)>=string.byte("A",1) and string.byte(letter,1)<=string.byte("Z",1) then
		PressKey(42)
		PressKey(letter)
		ReleaseKey(letter)
		ReleaseKey(42)
		return
	end
	--其它字符
	PressKey(letter)
	ReleaseKey(letter)
end
