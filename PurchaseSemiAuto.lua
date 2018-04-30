--刷新坐标点可定制,快速购买坐标点为全屏状态下的不可定制
status=nil
enableSwiftBuying=true
skipBackwardOnce=false --按下前进键刷新时,如果再按下了后退键,后退键也会入队执行一次宏,现在需要将这次不必要的执行跳过
function OnEvent(event, arg)
	--配置
	buyingNumber=4 --一次买3个
	mRange=800
	mSleep=2
	abortButton=nil
	funcDoClear=funcDoClearBasic
	--逻辑
	if (event == "MOUSE_BUTTON_PRESSED" and arg == FORWARD) then --当鼠标前进键按下时
		if XPlayMacro("Refresh")==false then return end
		OutputLogMessage("FORWARD\n")
		--配置
		abortButton=BACKWARD
		funcDoClear=function()
			funcDoClearBasic()
			skipBackwardOnce=true
		end
		while mRunning==true do
			if Refresh()==false then return end
		end
		--XAbortMacro()
	end
	if (event == "MOUSE_BUTTON_PRESSED" and arg == BACKWARD and enableSwiftBuying==true) then --当鼠标返回键按下时
		if skipBackwardOnce==true then
			skipBackwardOnce=false
			return
		end
		if XPlayMacro("Refresh")==false then return end
		OutputLogMessage("BACKWARD\n")
		--配置
		abortButton=-BACKWARD
		while mRunning==true do
			if SwiftBuying()==false then return end
		end
		--XAbortMacro()
	end
	if (event == "MOUSE_BUTTON_PRESSED" and arg == MIDDLE) then --当鼠标中键按下时
		local px,py=GetMousePosition()
		if status==nil then status=PRESS_WANTED_CATEGORY end
		if status==PRESS_WANTED_CATEGORY then 
			pressWantedCategory.px=px
			pressWantedCategory.py=py
			OutputLogMessage("[Wanted Category] = (%s,%s) ----> [Refresh-Token] \n",""..px,""..py)
			status=PRESS_REFRESH_TOKEN 
		elseif status==PRESS_REFRESH_TOKEN then
			pressRefreshToken.px=px
			pressRefreshToken.py=py
			OutputLogMessage("[Refresh-Token] = (%s,%s) ----> [Wanted Item] \n",""..px,""..py)
			status=PRESS_WANTED_ITEM
		elseif status==PRESS_WANTED_ITEM then
			pressWantedItem.px=px
			pressWantedItem.py=py
			OutputLogMessage("[Wanted Item] = (%s,%s) ----> [Restart - Wanted Category] \n",""..px,""..py)
			status=nil
		else
			PrintPosition()
		end
	end
end

function Refresh()
	positionValid=true
	if (CheckPositionValid(pressWantedCategory)==false) then positionValid=false end
	if (CheckPositionValid(pressRefreshToken)==false) then positionValid=false end
	if (CheckPositionValid(pressWantedItem)==false) then positionValid=false end
	if (positionValid==true) then
		--开始点击
		if XMoveMouseToPosition(pressRefreshToken,XWaitLongTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XMoveMouseToPosition(pressWantedCategory,XWaitLongTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XMoveMouseToPosition(pressWantedItem,XWaitLongTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XSleep(XTimeShuffle()*2)==false then return false end
	else
		OutputLogMessage("Not all the positions are valid.\n")
		return false
	end
end

--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓PURCHASEBASIC↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--
PRESS_WANTED_CATEGORY,PRESS_REFRESH_TOKEN,PRESS_WANTED_ITEM,PRESS_BUYING_ITEM,ADD_NUMBER,PURCHASE,PURCHASE_CONFIRM,CANCEL_SUBSTITUTION=1,2,3,4,5,6,7,8
pressWantedCategory={px=9665,py=22898}
pressRefreshToken={px=9801,py=30125}
pressWantedItem={px=31623,py=23566}
pressBuyingItem={px=31555,py=24052}
addNumber={px=38658,py=32919}
purchase={px=32750,py=45188}
purchaseConfirm={px=42927,py=45067}
cancelSubstitution={px=22744,py=44824}
buyingNumber=3 --一次买3个
funcDoClearBasic=function()
	status=nil
	Sleep(XTimeShuffle()*2) --睡眠一段时间,防止下次操作直接入列
end
function SwiftBuying()
	positionValid=true
	if (CheckPositionValid(pressBuyingItem)==false) then positionValid=false end
	if (CheckPositionValid(addNumber)==false) then positionValid=false end
	if (CheckPositionValid(purchase)==false) then positionValid=false end
	if (CheckPositionValid(purchaseConfirm)==false) then positionValid=false end
	if (CheckPositionValid(cancelSubstitution)==false) then positionValid=false end
	if (positionValid==true) then
		if XMoveMouseToPosition(pressBuyingItem,XWaitShortTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XMoveMouseToPosition(addNumber,XWaitShortTime)==false then return false end
		for t=1,(buyingNumber-1) do
			if XPressAndReleaseMouseButton(1)==false then return false end
		end
		if XMoveMouseToPosition(purchase,XWaitShortTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XMoveMouseToPosition(purchaseConfirm,XWaitShortTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XMoveMouseToPosition(cancelSubstitution,XWaitShortTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
	else
		OutputLogMessage("Not all the positions are valid.\n")
		return false
	end
end

function XWaitMicroTime()
	return XSleep(XTimeShuffle()/4)
end

function XWaitShortTime()
	return XSleep(XTimeShuffle())
end

function XWaitLongTime()
	return XSleep(XTimeShuffle()*5)
end

function XMoveMouseToPosition(tab,sleepFunc)
	if tab==nil then return false end
	if (XAbortLoop(abortButton)) then
		OutputLogMessage("XAbortMacro while [XMoveMouseToPosition] "..GetDate().."\n")
		XAbortMacro()
		return false
	end
	if XMoveMouseTo(tab.px,tab.py)==false then return false end
	if sleepFunc~=nil then
		return sleepFunc()
	end
end

function ResetPosition(tab)
	if tab==nil then return end
	tab.px=nil
	tab.py=nil
end

function CheckPositionValid(tab)
	if tab~=nil and tab.px~=nil and tab.py~=nil then
		return true
	else
		return false
	end
end
--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑PURCHASEBASIC↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--
--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓MOUSE↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--
function XMoveMouseRelative(mx,my)
	--尽量不要在宏中单读调用此函数
	if XAbortLoop(abortButton) then
		OutputLogMessage("XAbortMacro while [XMoveMouseRelative] "..GetDate().."\n")
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
	if XSleep(mSleep)==false then return false end
	if XMoveMouseRelative(mx-nextXMove,my-nextYMove)==false then return false end
end

function XMoveMouseTo(dx,dy)
	if (XAbortLoop(abortButton)) then
		OutputLogMessage("XAbortMacro while [XMoveMouseTo] "..GetDate().."\n")
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
	--处于一次移动最小范围内
	if XMoveMouseRelative(nextXMove,nextYMove)==false then return false end
	if XSleep(mSleep)==false then return false end
	if XMoveMouseTo(dx,dy)==false then return false end
end

function XPressAndReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
		OutputLogMessage("XAbortMacro while [XPressAndReleaseMouseButton] "..GetDate().."\n")
		XAbortMacro()
		return false
	end
	if XPressMouseButton(button)==false then return false end
	if XSleep(XTimeShuffle())==false then
		XReleaseMouseButton(button) --必须release
		return false
	end
	XReleaseMouseButton(button) --必须release
	if XSleep(XTimeShuffle())==false then return false end
end

function XMoveMouseWheel(range)
	if (XAbortLoop(abortButton)) then
		OutputLogMessage("XAbortMacro while [XMoveMouseWheel] "..GetDate().."\n")
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
	if XMoveMouseTo(px,dy)==false then return false end
	if XPressMouseButton(1)==false then
		XReleaseMouseButton(1) --必须release
		return false
	end
	if XMoveMouseTo(px,py)==false then
		XReleaseMouseButton(1) --必须release
		return false
	end
	XReleaseMouseButton(1) --必须release
end

function XPressMouseButton(button)
	--XAbortMacro元函数,仅调用Logitech API及自身,未调用其它X系列函数
	if (XAbortLoop(abortButton)) then
		OutputLogMessage("XAbortMacro while [XPressMouseButton] "..GetDate().."\n")
		XAbortMacro()
		return false
	end
	PressMouseButton(button)
end

function XReleaseMouseButton(button)
	--XAbortMacro元函数,仅调用Logitech API及自身,未调用其它X系列函数
	ReleaseMouseButton(button) --必须release
end

--以下为内置函数
XPositionShuffle=function()
	local range=30
	return math.random()*range*2-range
end
--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑MOUSE↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--
--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓BASIC↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--
MIDDLE,BACKWARD,FORWARD=3,4,5
abortButton=BACKWARD --为正数时,表示按下则停止;为负数时,表示放开则停止
mRange=1500
mSleep=5
mRunning=false
funcDoClear=nil
funcAbortLoop=nil --定制跳出宏
maxSleepInterval=5
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
	--尽量不要在宏中单独调用此函数;幂等;保证每次退出时,此函数只执行一次
	AbortMacro()
	mRunning=false
	if (funcDoClear~=nil) then 
		funcDoClear() 
	end
	--OutputLogMessage("XAbortMacro "..GetDate().."\n")
end
function XAbortLoop(button)
	local doAbort
	if funcAbortLoop~=nil and funcAbortLoop()==true then
		doAbort=true
	end
	if mRunning==false then 
		doAbort=true 
	end
	if (button~=nil and button>0) then
		if IsMouseButtonPressed(button) then doAbort=true end
	end
	if (button~=nil and button<0) then
		if IsMouseButtonPressed(-button)==false then doAbort=true end
	end
	if doAbort then
		--此函数只进行判断,真正跳出宏需要再次调用XAbortMacro
		--OutputLogMessage("XAbortLoop "..GetDate().."\n")
		return true
	end
end
function PrintPosition()
	local px,py=GetMousePosition()
	OutputLogMessage("(%s,%s) %s\n",""..px,""..py,GetDate().."")
end
function XSleep(millis)
	--XAbortMacro元函数,仅调用Logitech API及自身,未调用其它X系列函数
	if (XAbortLoop(abortButton)) then
		OutputLogMessage("XAbortMacro while [XSleep] "..GetDate().."\n")
		XAbortMacro()
		return false
	end
	if (millis>maxSleepInterval) then
		Sleep(maxSleepInterval)
		return XSleep(millis-maxSleepInterval)
	end
	Sleep(millis)
end
XTimeShuffle=function()
	return 50+math.random()*50
end
--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑BASIC↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--