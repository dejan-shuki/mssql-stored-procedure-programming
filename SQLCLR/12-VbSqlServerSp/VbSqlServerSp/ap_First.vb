Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server


Partial Public Class StoredProcedures
    <Microsoft.SqlServer.Server.SqlProcedure()> _
    Public Shared Sub ap_FirstVB()
        ' Add your code here
        SqlContext.Pipe.Send("Hello world!\n")

    End Sub


    <Microsoft.SqlServer.Server.SqlProcedure()> _
    Public Shared Sub cp_EqTypeListVB()
        ' Add your code here
        SqlContext.Pipe.Send("Hello world!\n")
        Using conn As New SqlConnection("Context Connection=true")
            Dim cmd As New SqlCommand()
            cmd.Connection = conn
            cmd.CommandText = "select * from dbo.EqType"
            cmd.CommandType = CommandType.Text

            conn.Open()

            Dim rdr As SqlDataReader
            rdr = cmd.ExecuteReader()
            SqlContext.Pipe.Send(rdr)

            rdr.Close()
        End Using



    End Sub



End Class



