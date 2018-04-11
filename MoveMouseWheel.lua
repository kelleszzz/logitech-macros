function OnEvent(event, arg)
	--配置
	mRange=1000
	mSleep=5
	--逻辑
	if (event == "MOUSE_BUTTON_PRESSED" and arg == 4) then --当鼠标返回键按下时
		if XPlayMacro("MoveMouseWheel")==false then return end
		abortButton=-4
		while IsMouseButtonPressed(4) do
			if (IsMouseButtonPressed(4)) then
				--下滑
				XMoveMouseWheel(-4000)
				Sleep(XTimeShuffle())
			end
		end
		abortButton=nil
		XAbortMacro()
	end
	if (event == "MOUSE_BUTTON_PRESSED" and arg == 5) then --当鼠标前进键按下时
		if XPlayMacro("MoveMouseWheel")==false then return end
		abortButton=-5
		while IsMouseButtonPressed(5) do
			if (IsMouseButtonPressed(5)) then
				--上滑
				XMoveMouseWheel(4000)
				Sleep(XTimeShuffle())
			end
		end
		abortButton=nil
		XAbortMacro()
	end
	if (event == "MOUSE_BUTTON_PRESSED" and arg == 3) then --当鼠标中键按下时
		PrintPosition()
	end
end


--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓BASIC↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--
abortButton=5 --为正数时,表示按下则停止;为负数时,表示放开则停止
mRange=1000
mSleep=5
mRunning=false
funcDoClear=nil
math.randomseed(GetDate("%I%M%S")+0)
function XPlayMacro(macro)
	if mRunning then
		return false
	end
	mRunning=true
	PlayMacro(macro)
	OutputLogMessage("XPlayMacro "..GetDate().."\n")
end
function XAbortMacro()
	AbortMacro()
	mRunning=false
	if (funcDoClear~=nil) then 
		funcDoClear() 
	end
	--OutputLogMessage("XAbortMacro "..GetDate().."\n")
end
function XAbortLoop(button)
	local doAbort
	if mRunning==false then doAbort=true end
	if (button~=nil and button>0) then
		if IsMouseButtonPressed(button) then doAbort=true end
	end
	if (button~=nil and button<0) then
		if IsMouseButtonPressed(-button)==false then doAbort=true end
	end
	if doAbort then
		--此函数只进行判断,真正跳出宏需要再次调用XAbortMacro
		OutputLogMessage("XAbortLoop "..GetDate().."\n")
		return true
	end
end
function PrintPosition()
	local px,py=GetMousePosition()
	OutputLogMessage("(%s,%s) %s\n",""..px,""..py,GetDate().."")
end
--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑BASIC↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--
--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓MOVEMOUSE↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--
function XMoveMouseRelative(mx,my)
	--尽量不要在宏中单读调用此函数
	if XAbortLoop(abortButton) then
		XAbortMacro()
		return
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
	Sleep(mSleep)
	XMoveMouseRelative(mx-nextXMove,my-nextYMove)
end

function XMoveMouseTo(dx,dy)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return
	end
	if (dx<0 or dx>65535 or dy<0 or dy>65535) then
		return
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
		XMoveMouseRelative(nextXMove+XPositionShuffle(),nextYMove+XPositionShuffle()) 
		return 
	end
	XMoveMouseRelative(nextXMove,nextYMove) --处于一次移动最小范围内
	Sleep(mSleep)
	XMoveMouseTo(dx,dy)
end

function XPressAndReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return
	end
	PressMouseButton(button)
	Sleep(XTimeShuffle())
	ReleaseMouseButton(button)
	Sleep(XTimeShuffle())
end

function XPressAndReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return
	end
	PressMouseButton(button)
	Sleep(XTimeShuffle()/2)
	ReleaseMouseButton(button)
	Sleep(XTimeShuffle())
end

function XMoveMouseWheel(range)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return
	end
	local px,py=GetMousePosition()
	local dy=py-range
	if (dy>65535) then
		dy=65534
	end
	if (dy<0) then
		dy=0
	end
	XMoveMouseTo(px,dy)
	XPressMouseButton(1)
	XMoveMouseTo(px,py)
	ReleaseMouseButton(1) --必须release
end

function XPressMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return
	end
	PressMouseButton(button)
end

function XReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return
	end
	ReleaseMouseButton(button)
end

--以下为内置函数
function XPositionShuffle()
	local range=30
	return math.random()*range*2-range
end

function XTimeShuffle()
	return 50+math.random()*50
end
--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑MOVEMOUSE↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--

