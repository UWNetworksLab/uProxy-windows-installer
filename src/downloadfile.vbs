' Get environment variables
Set wshShell = CreateObject("WScript.Shell")
Set wshShellEnv = wshShell.Environment( "USER" )

fileURL = wshShell.ExpandEnvironmentStrings("%fileURL%")
If fileURL = "%fileURL%" Then
    WScript.Echo "Error: Did not set fileURL correctly"
    Wscript.Quit 1
End if

fileLocation = wshShell.ExpandEnvironmentStrings("%fileLocation%")
If fileLocation = "%fileLocation%" Then
    WScript.Echo "Error: Did not set fileLocation correctly"
    Wscript.Quit 1
End if
    
WScript.Echo "Downloading " & fileURL & " to " & fileLocation & "..."

' Fetch the file
Set objXMLHTTP = CreateObject("MSXML2.ServerXMLHTTP.6.0")
objXMLHTTP.open "GET", fileURL, false
objXMLHTTP.send()

wshShellEnv( "downloadfilestatus" ) = objXMLHTTP.Status

If objXMLHTTP.Status = 200 Then
    WScript.Echo "Status:200 OK "
    Set objADOStream = CreateObject("ADODB.Stream")
    objADOStream.Open
    'adTypeBinary
    objADOStream.Type = 1
    objADOStream.Write objXMLHTTP.ResponseBody
    'Set the stream position to the start
    objADOStream.Position = 0
    
    Set objFSO = Createobject("Scripting.FileSystemObject")
    If objFSO.Fileexists(fileLocation) Then objFSO.DeleteFile fileLocation
    Set objFSO = Nothing

    objADOStream.SaveToFile fileLocation
    objADOStream.Close
    Set objADOStream = Nothing
Else
    WScript.Echo "File download failed with status " & objXMLHTTP.Status
    WScript.Quit 1
End if

Set objXMLHTTP = Nothing
Set wshShell = Nothing