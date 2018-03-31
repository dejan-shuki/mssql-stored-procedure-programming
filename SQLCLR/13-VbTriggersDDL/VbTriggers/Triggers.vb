Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server

Imports System.Xml
Imports System.Text.RegularExpressions
Imports System.Diagnostics
Imports System.IO

Partial Public Class Triggers

    <SqlTrigger(Name:="ctrd_DDL_PROCEDURE_EVENTS_vb", _
        Target:="DATABASE", _
        Event:="AFTER DDL_PROCEDURE_EVENTS, DDL_FUNCTION_EVENTS")> _
    Public Shared Sub trigger_DDL_PROCEDURE_EVENTS()
        'get info about all procedure modifications in the database

        'get trigger context
        Dim triggerContext As SqlTriggerContext = SqlContext.TriggerContext

        'get event info
        Dim sXml As String = triggerContext.EventData.Value

        'log info
        Using file As New StreamWriter("c:\\sp_change.log", True)
            file.WriteLine(sXml)
            file.Close()
        End Using

    End Sub



End Class
