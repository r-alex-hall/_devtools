SetWorkingDir %A_ScriptDir%
#NoEnv
	;NOTE: The below relies on a value (a file name) being passed to this script/compiled executable.
FileGetTime, fileCreationTime, %1%, M

		;DEPRECATED block.
			;Reference: http://www.autohotkey.com/board/topic/79372-date-math/
			;MsgBox, value of fileCreationTime is %fileCreationTime%
		;fileCreationTime += -56, days
			;MsgBox, value of fileCreationTime is now %fileCreationTime%

	;MsgBox, Will modify file modied time stampt to: %fileCreationTime% . . .
FileSetTime , %fileCreationTime%, %1%, C