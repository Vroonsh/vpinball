'Last Updated in VBS v3.36

Option Explicit
LoadCore
Private Sub LoadCore
	On Error Resume Next
	If VPBuildVersion < 0 Or Err Then
		Dim fso : Set fso = CreateObject("Scripting.FileSystemObject") : Err.Clear
		ExecuteGlobal fso.OpenTextFile("core.vbs", 1).ReadAll    : If Err Then MsgBox "Can't open ""core.vbs""" : Exit Sub
		ExecuteGlobal fso.OpenTextFile("VPMKeys.vbs", 1).ReadAll : If Err Then MsgBox "Can't open ""vpmkeys.vbs""" : Exit Sub
	Else
		ExecuteGlobal GetTextFile("core.vbs")    : If Err Then MsgBox "Can't open ""core.vbs"""    : Exit Sub
		ExecuteGlobal GetTextFile("VPMKeys.vbs") : If Err Then MsgBox "Can't open ""vpmkeys.vbs""" : Exit Sub
	End If
End Sub
'-------------------------
' Inder Data
'-------------------------
' Cabinet switches
Const swCoin1          = 50
Const swCoin2          = 51
Const swCoin3          = 51
Const swTilt           = 53
Const swStartButton    = 54
Const swSelfTest       = 57
Const swCPUDiag        = 56
Const swSoundDiag      = 55
Const swLRFlip         = 151
Const swLLFlip         = 153

' Help Window
vpmSystemHelp = "Inder MPUx00 keys:" & vbNewLine &_
  vpmKeyName(keyInsertCoin1) & vbTab & "Insert Coin #1"   & vbNewLine &_
  vpmKeyName(keyInsertCoin2) & vbTab & "Insert Coin #2"   & vbNewLine &_
  vpmKeyName(keyInsertCoin3) & vbTab & "Insert Coin #3"   & vbNewLine &_
  vpmKeyName(keySelfTest)    & vbTab & "Test function"    & vbNewLine &_
  vpmKeyName(keyCPUDiag)     & vbTab & "Bookkeep function"& vbNewLine &_
  vpmKeyName(keySoundDiag)   & vbTab & "Reset audits"
'  vpmKeyName(keySlamDoorHit) & vbTab & "Slam Tilt"

'Dip Switch / Options Menu
Private Sub InderShowDips
	If Not IsObject(vpmDips) Then ' First time
		Set vpmDips = New cvpmDips
		With vpmDips
			.AddForm 150, 245, "DIP switches"
			.AddFrame  0,0, 60, "", 0,_
			  Array("DIP  1",&H00000001,"DIP  2",&H00000002,"DIP  3",&H00000004,"DIP  4",&H00000008,_
			        "DIP  5",&H00000010,"DIP  6",&H00000020,"DIP  7",&H00000040,"DIP  8",32768,_
			        "DIP  9",&H00000100,"DIP 10",&H00000200,"DIP 11",&H00000400,"DIP 12",&H00000800,_
			        "DIP 13",&H00001000,"DIP 14",&H00002000,"DIP 15",&H00004000,"DIP 16",&H00008000)
			.AddFrame 80,0, 60, "", 0,_
			   Array("DIP 17",&H00010000,"DIP 18",&H00020000,"DIP 19",&H00040000,"DIP 20",&H00080000,_
			         "DIP 21",&H00100000,"DIP 22",&H00200000,"DIP 23",&H00400000,"DIP 24",&H00800000,_
			         "DIP 25",&H01000000,"DIP 26",&H02000000,"DIP 27",&H04000000,"DIP 28",&H08000000,_
			         "DIP 29",&H10000000,"DIP 30",&H20000000,"DIP 31",&H40000000,"DIP 32",&H80000000)
		End With
	End If
	vpmDips.ViewDips
End Sub
Set vpmShowDips = GetRef("InderShowDips")
Private vpmDips

' Keyboard handlers
Function vpmKeyDown(ByVal keycode)
	On Error Resume Next
	vpmKeyDown = True ' Assume we handle the key
	With Controller
		If keycode = RightFlipperKey Then .Switch(swLRFlip) = True
		If keycode = LeftFlipperKey  Then .Switch(swLLFlip) = True
		Select Case keycode
			Case keyInsertCoin1  vpmTimer.AddTimer 750,"vpmTimer.PulseSw swCoin1'" : Playsound SCoin
			Case keyInsertCoin2  vpmTimer.AddTimer 750,"vpmTimer.PulseSw swCoin2'" : Playsound SCoin
			Case keyInsertCoin3  vpmTimer.AddTimer 750,"vpmTimer.PulseSw swCoin3'" : Playsound SCoin
			Case StartGameKey    .Switch(swStartButton) = True
			Case keySelfTest     .Switch(swSelfTest)    = True
			Case keyCPUDiag      .Switch(swCPUDiag)     = True
			Case keySoundDiag    .Switch(swSoundDiag)   = True
			Case keyBangBack     vpmNudge.DoNudge   0, 6
			Case LeftTiltKey     vpmNudge.DoNudge  75, 2
			Case RightTiltKey    vpmNudge.DoNudge 285, 2
			Case CenterTiltKey   vpmNudge.DoNudge   0, 2
			Case keyVPMVolume    vpmVol
			Case Else            vpmKeyDown = False
		End Select
	End With
	On Error Goto 0
End Function

Function vpmKeyUp(ByVal keycode)
	On Error Resume Next
	vpmKeyUp = True ' Assume we handle the key
	With Controller
		If keycode = RightFlipperKey Then .Switch(swLRFlip) = False
		If keycode = LeftFlipperKey  Then .Switch(swLLFlip) = False
		Select Case keycode
			Case StartGameKey    .Switch(swStartButton) = False
			Case keySelfTest     .Switch(swSelfTest)    = False
			Case keyCPUDiag      .Switch(swCPUDiag)     = False
			Case keySoundDiag    .Switch(swSoundDiag)   = False
			Case keyShowOpts     .Pause = True : .ShowOptsDialog GetPlayerHWnd : .Pause = False
			Case keyShowKeys     .Pause = True : vpmShowHelp : .Pause = False
			Case keyAddBall      .Pause = True : vpmAddBall  : .Pause = False
			Case keyReset        .Stop : .Run : vpmTimer.Reset
			Case keyFrame        .LockDisplay = Not .LockDisplay
			Case keyDoubleSize   .DoubleSize  = Not .DoubleSize
			Case keyShowDips     If IsObject(vpmShowDips) Then .Pause = True : vpmShowDips : .Pause = False
			Case keyReset        .Stop : BeginModal : .Run : vpmTimer.Reset : EndModal
			Case Else            vpmKeyUp = False
		End Select
	End With
End Function
