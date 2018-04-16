--¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ýPURCHASEBASIC¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý¡ý--
PRESS_WANTED_CATEGORY,PRESS_REFRESH_TOKEN,PRESS_WANTED_ITEM,PRESS_BUYING_ITEM,ADD_NUMBER,PURCHASE,PURCHASE_CONFIRM,CANCEL_SUBSTITUTION=1,2,3,4,5,6,7,8
pressWantedCategory={px=9665,py=22898}
pressRefreshToken={px=9801,py=30125}
pressWantedItem={px=31623,py=23566}
pressBuyingItem={px=31555,py=24052}
addNumber={px=38658,py=32919}
purchase={px=32750,py=45188}
purchaseConfirm={px=42927,py=45067}
cancelSubstitution={px=22744,py=44824}
buyingNumber=3 --Ò»´ÎÂò3¸ö
function SwiftBuying()
	positionValid=true
	if (CheckPositionValid(pressBuyingItem)==false) then positionValid=false end
	if (CheckPositionValid(addNumber)==false) then positionValid=false end
	if (CheckPositionValid(purchase)==false) then positionValid=false end
	if (CheckPositionValid(purchaseConfirm)==false) then positionValid=false end
	if (CheckPositionValid(cancelSubstitution)==false) then positionValid=false end
	if (positionValid==true) then
		XMoveMouseToPosition(pressBuyingItem,XWaitShortTime)
		XPressAndReleaseMouseButton(1)
		XMoveMouseToPosition(addNumber,XWaitShortTime)
		for t=1,(buyingNumber-1) do
			XPressAndReleaseMouseButton(1)
		end
		XMoveMouseToPosition(purchase,XWaitShortTime)
		XPressAndReleaseMouseButton(1)
		XMoveMouseToPosition(purchaseConfirm,XWaitShortTime)
		XPressAndReleaseMouseButton(1)	
		XMoveMouseToPosition(cancelSubstitution,XWaitShortTime)
		XPressAndReleaseMouseButton(1)
	else
		OutputLogMessage("Not all the positions are valid.\n")
	end
end

function XWaitMicroTime()
	Sleep(XTimeShuffle()/4)
end

function XWaitShortTime()
	Sleep(XTimeShuffle())
end

function XWaitLongTime()
	Sleep(XTimeShuffle()*5)
end

function XMoveMouseToPosition(tab,sleepFunc)
	if tab==nil then return end
	XMoveMouseTo(tab.px,tab.py)
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
--¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡üPURCHASEBASIC¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü¡ü--