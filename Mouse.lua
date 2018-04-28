--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓MOUSE↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--
function XMoveMouseRelative(mx,my)
	--尽量不要在宏中单读调用此函数
	if XAbortLoop(abortButton) then
		XAbortMacro()
		return false
	end
	local px,py=GetMousePosition()
	local lastStep=false
	local nextXMove,nextYMove
	if (math.abs(mx)<=mRange and math.abs(my)<=mRange) then lastStep=true end --一次移动即可到达终点,不再递归
	if math.abs(mx)<=mRange then nextXMove=mx else nextXMove=mx*mRange/math.abs(mx) end
	if math.abs(my)<=mRange then nextYMove=my else nextYMove=my*mRange/math.abs(my) end
	--边界判断,不可超出边界
	local nextXPos=px+nextXMove
	local nextYPos=py+nextYMove
	if (nextXPos<0) then nextXPos=0 end
	if (nextXPos>65535) then nextXPos=65535 end
	if (nextYPos<0) then nextYPos=0 end
	if (nextYPos>65535) then nextYPos=65535 end
	MoveMouseTo(nextXPos,nextYPos)
	if lastStep then return end
	if XSleep(mSleep)==false then
		XAbortMacro()
		return false
	end
	if XMoveMouseRelative(mx-nextXMove,my-nextYMove)==false then
		XAbortMacro()
		return false
	end
end

function XMoveMouseTo(dx,dy)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	if (dx==nil or dy==nil or dx<0 or dx>65535 or dy<0 or dy>65535) then
		return false
	end
	local px,py=GetMousePosition()
	local mx,my=dx-px,dy-py
	local lastStep=false
	local nextXMove,nextYMove
	if (math.abs(mx)<=mRange and math.abs(my)<=mRange) then lastStep=true end
	if math.abs(mx)<=mRange then nextXMove=mx else nextXMove=mx*mRange/math.abs(mx) end
	if math.abs(my)<=mRange then nextYMove=my else nextYMove=my*mRange/math.abs(my) end
	if lastStep then 
		--最后一次移动
		return XMoveMouseRelative(nextXMove+XPositionShuffle(),nextYMove+XPositionShuffle()) 
	end
	XMoveMouseRelative(nextXMove,nextYMove) --处于一次移动最小范围内
	if XSleep(mSleep)==false then
		XAbortMacro()
		return false
	end
	if XMoveMouseTo(dx,dy)==false then
		XAbortMacro()
		return false
	end
end

function XPressAndReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	XPressMouseButton(button)
	XSleep(XTimeShuffle())
	XReleaseMouseButton(button) --必须release
	if XSleep(XTimeShuffle())==false then
		XAbortMacro()
		return false
	end
end

function XMoveMouseWheel(range)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	local px,py=GetMousePosition()
	local dy=py-range
	if (dy>65535) then
		dy=65534
	end
	if (dy<0) then
		dy=0
	end
	if XMoveMouseTo(px,dy)==false then
		XAbortMacro()
		return false
	end
	if XPressMouseButton(1)==false then
		XReleaseMouseButton(1) --必须release
		XAbortMacro()
		return false
	end
	if XMoveMouseTo(px,py)==false then
		XReleaseMouseButton(1) --必须release
		XAbortMacro()
		return false
	end
	XReleaseMouseButton(1) --必须release
	return flag
end

function XPressMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	PressMouseButton(button)
end

function XReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
		ReleaseMouseButton(button) --必须release
		XAbortMacro()
		return false
	end
	ReleaseMouseButton(button)
end

--以下为内置函数
XPositionShuffle=function()
	local range=30
	return math.random()*range*2-range
end

XTimeShuffle=function()
	return 50+math.random()*50
end
--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑MOUSE↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--

