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
	Sleep(XTimeShuffle()) --睡眠一段时间,防止下次操作直接入列
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
	XSleep(XTimeShuffle()/4)
end

function XWaitShortTime()
	XSleep(XTimeShuffle())
end

function XWaitLongTime()
	XSleep(XTimeShuffle()*5)
end

function XMoveMouseToPosition(tab,sleepFunc)
	if tab==nil then return false end
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	if XMoveMouseTo(tab.px,tab.py)==false then return false end
	if sleepFunc~=nil then
		sleepFunc()
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