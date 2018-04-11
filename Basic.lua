--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓BASIC↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--
MIDDLE,BACKWARD,FORWARD=3,4,5
abortButton=BACKWARD --为正数时,表示按下则停止;为负数时,表示放开则停止
mRange=1000
mSleep=5
mRunning=false
funcDoClear=nil
funcAbortLoop=nil --定制跳出宏
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
		OutputLogMessage("XAbortLoop "..GetDate().."\n")
		return true
	end
end
function PrintPosition()
	local px,py=GetMousePosition()
	OutputLogMessage("(%s,%s) %s\n",""..px,""..py,GetDate().."")
end
function XSleep(millis)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	Sleep(millis)
end
--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑BASIC↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--