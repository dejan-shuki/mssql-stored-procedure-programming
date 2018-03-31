Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server

Imports System.Transactions


Partial Public Class StoredProcedures
    <Microsoft.SqlServer.Server.SqlProcedure()> _
    Public Shared Sub cp_LeasedAsset_Insert( _
        ByVal EqId As Integer, ByVal LocId As Integer, _
        ByVal StatusId As Integer, ByVal LeaseId As Integer, _
        ByVal LeaseScheduleId As Integer, ByVal OwnerId As Integer, _
        ByVal LeaseAmount As Decimal, ByVal AcqTypeId As Integer)

        Dim Cmd1 As String = "insert Inventory(EqId, LocationId, " + _
             "StatusId,            LeaseId, " + _
             "LeaseScheduleId,     OwnerId, " + _
             "Lease,               AcquisitionTypeID)" + _
             "values (" + EqId.ToString() + ", " + LocId.ToString() + ", " + _
             StatusId.ToString() + " , " + LeaseId.ToString() + " , " + _
             LeaseScheduleId.ToString() + ", " + OwnerId.ToString() + ", " + _
             LeaseAmount.ToString() + " , " + AcqTypeId.ToString() + ")"

        Dim Cmd2 As String = "update dbo.LeaseSchedule " + _
            "Set PeriodicTotalAmount = PeriodicTotalAmount + " _
            + LeaseAmount.ToString() + _
            "where LeaseId = " + LeaseId.ToString()

        Dim options As TransactionOptions = New TransactionOptions()
        options.IsolationLevel = Transactions.IsolationLevel.ReadCommitted
        options.Timeout = TransactionManager.DefaultTimeout

        Using TxScope As TransactionScope = _
            New TransactionScope(TransactionScopeOption.Required, options)

            Using Con As New SqlConnection("Context Connection=true")
                Con.Open()

                Dim Cmd As SqlCommand = New SqlCommand(Cmd1, Con)
                Cmd.ExecuteNonQuery()

                'I will reuse the same connection and command object 
                'for next segment of operation.
                Cmd.CommandText = Cmd2
                Cmd.ExecuteNonQuery()

                ' commit/complete transaction
                TxScope.Complete()
            End Using 'connection is implicitly closed
        End Using 'transaction is implicitly closed or rolled back

    End Sub




    <Microsoft.SqlServer.Server.SqlProcedure()> _
    Public Shared Sub cp_LeasedAsset_InsertDistributed( _
        ByVal EqId As Integer, ByVal LocId As Integer, _
        ByVal StatusId As Integer, ByVal LeaseId As Integer, _
        ByVal LeaseScheduleId As Integer, ByVal OwnerId As Integer, _
        ByVal LeaseAmount As Decimal, ByVal AcqTypeId As Integer)

        Dim Cmd1 As String = "insert Inventory(EqId, LocationId, " + _
             "StatusId,            LeaseId, " + _
             "LeaseScheduleId,     OwnerId, " + _
             "Lease,               AcquisitionTypeID)" + _
             "values (" + EqId.ToString() + ", " + LocId.ToString() + ", " + _
             StatusId.ToString() + " , " + LeaseId.ToString() + " , " + _
             LeaseScheduleId.ToString() + ", " + OwnerId.ToString() + ", " + _
             LeaseAmount.ToString() + " , " + AcqTypeId.ToString() + ")"

        Dim Cmd2 As String = "update dbo.LeaseSum " + _
            "Set PeriodicTotalAmount = PeriodicTotalAmount + " _
            + LeaseAmount.ToString() + _
            "where LeaseId = " + LeaseId.ToString()

        Dim ConString1 As String = "Context Connection=true"

        Dim ConString2 As String = _
            "Data Source=lg/DW;Initial Catalog=Asset5DW;" + _
            "Integrated Security=True"

        Using TxScope As TransactionScope = New TransactionScope()

            Using Con As New SqlConnection(ConString1)
                Con.Open()

                Dim Cmd As SqlCommand = New SqlCommand(Cmd1, Con)
                Cmd.ExecuteNonQuery()

            End Using

            Using Con As New SqlConnection(ConString2)
                'Creation of second connection automaticaly promotes 
                'the transaction to distributed.
                Con.Open()

                Dim Cmd As SqlCommand = New SqlCommand(Cmd2, Con)
                Cmd.ExecuteNonQuery()

            End Using 'connection is implicitly closed

            'commit/complete transaction
            TxScope.Complete()

        End Using 'transaction is implicitly closed or rolled back

    End Sub



    <Microsoft.SqlServer.Server.SqlProcedure()> _
    Public Shared Sub cp_LeasedAsset_InsertDeclarative( _
            ByVal EqId As Integer, ByVal LocId As Integer, _
            ByVal StatusId As Integer, ByVal LeaseId As Integer, _
            ByVal LeaseScheduleId As Integer, ByVal OwnerId As Integer, _
            ByVal LeaseAmount As Decimal, ByVal AcqTypeId As Integer)

        Dim sCmd1 As String = "insert Inventory(EqId, LocationId, " + _
             "StatusId,            LeaseId, " + _
             "LeaseScheduleId,     OwnerId, " + _
             "Lease,               AcquisitionTypeID)" + _
             "values (" + EqId.ToString() + ", " + LocId.ToString() + ", " + _
             StatusId.ToString() + " , " + LeaseId.ToString() + " , " + _
             LeaseScheduleId.ToString() + ", " + OwnerId.ToString() + ", " + _
             LeaseAmount.ToString() + " , " + AcqTypeId.ToString() + ")"

        Dim sCmd2 As String = "update dbo.LeaseSum " + _
            "Set PeriodicTotalAmount = PeriodicTotalAmount + " _
            + LeaseAmount.ToString() + _
            "where LeaseId = " + LeaseId.ToString()

        ' declare here because try and catch have different scope
        Dim trans As SqlTransaction = Nothing
        Dim connection As SqlConnection = _
          New SqlConnection("Context Connection=true")

        connection.Open()
        Try
            trans = connection.BeginTransaction

            Dim command As SqlCommand = _
                New SqlCommand(sCmd1, connection, trans)

            command.ExecuteNonQuery()

            command.CommandText = sCmd2
            command.ExecuteNonQuery()

            trans.Commit()

        Catch ex As Exception
            trans.Rollback()

            ' nothing else you can do here, so re-throw exception
            Throw ex
        Finally
            ' called every time
            connection.Close()
        End Try

    End Sub

End Class

