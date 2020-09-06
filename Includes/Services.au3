#include-once

Global Const $SERVICE_PAUSE_CONTINUE = 0x0040

Global Const $SERVICE_CONTROL_PAUSE = 0x00000002
Global Const $SERVICE_CONTROL_CONTINUE = 0x00000003


; #FUNCTION# =======================================================================================================================================================
; Name...........: _ServiceContinue
; Description ...: Continues a paused service.
; Syntax.........: _Service_Pause($hSCManager, $sServiceName)
; Parameters ....: $hSCHandle - Handle to an open SC Manager
;                  $sServiceName - Name of the service.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: rcmaehl (Robert Maehl) based on work by engine
; Modified.......: 09/06/2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================
Func _ServiceContinue($hSCHandle, $sService)
	Local $hService, $iCSR, $iCSRE

	If StringInStr($sService, " ") Then $sService = '"' & $sService & '"'

	$hService = OpenService($hSCHandle, $sServiceName, $SERVICE_PAUSE_CONTINUE)
	$iCSR = ControlService($hService, $SERVICE_CONTROL_CONTINUE)
	If $iCSR = 0 Then $iCSRE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iCSRE, 0, $iCSR)
EndFunc

; #FUNCTION# =======================================================================================================================================================
; Name...........: _ServicePause
; Description ...: Pauses a service.
; Syntax.........: _Service_Pause($hSCManager, $sServiceName)
; Parameters ....: $hSCHandle - Handle to an open SC Manager
;                  $sServiceName - Name of the service.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: rcmaehl (Robert Maehl) based on work by engine
; Modified.......: 09/06/2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================
Func _ServicePause($hSCHandle, $sService)
	Local $hService, $iCSP, $iCSPE

	If StringInStr($sService, " ") Then $sService = '"' & $sService & '"'

	$hService = OpenService($hSC, $sService, $SERVICE_PAUSE_CONTINUE)
	$iCSP = ControlService($hService, $SERVICE_CONTROL_PAUSE)
	If $iCSP = 0 Then $iCSPE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iCSPE, 0, $iCSP)
EndFunc

Func _ServiceStartup($sHostname)
	Local Const $SC_MANAGER_CONNECT = 0x0001

	Local $avOSCM = DllCall("advapi32.dll", "hwnd", "OpenSCManager", _
		"str", $sComputerName, _
		"str", "ServicesActive", _
		"dword", $SC_MANAGER_CONNECT)
	Return $avOSCM[0]
EndFunc

Func _ServiceShutdown($hSCHandle)
	Local $avCSH = DllCall("advapi32.dll", "int", "CloseServiceHandle", "hwnd", $hSCHandle)
	Return $avCSH[0]
EndFunc

Func CloseServiceHandle($hSCObject)
	Local $avCSH = DllCall( "advapi32.dll", "int", "CloseServiceHandle", _
		"hwnd", $hSCObject )
	Return $avCSH[0]
EndFunc ;==> CloseServiceHandle

Func ControlService($hService, $iControl)
	Local $avCS = DllCall("advapi32.dll", "int", "ControlService", _
		"hwnd", $hService, _
		"dword", $iControl, _
		"str", "")
	Return $avCS[0]
EndFunc ;==> ControlService

Func GetLastError()
	Local $aiE = DllCall("kernel32.dll", "dword", "GetLastError")
	Return $aiE[0]
EndFunc ;==> GetLastError

Func OpenService($hSC, $sServiceName, $iAccess)
	Local $avOS = DllCall("advapi32.dll", "hwnd", "OpenService", _
		"hwnd", $hSC, _
		"str", $sServiceName, _
		"dword", $iAccess)
	Return $avOS[0]
EndFunc ;==> OpenService