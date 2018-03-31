using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;


public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]

    public static void ap_First()
    {
        // Put your code here
        SqlContext.Pipe.Send("Hello world!\n");
    }


    [Microsoft.SqlServer.Server.SqlProcedure]
    // returning value from stored procedures
    public static System.Int32 ap_First_2()
    {
        // Put your code here
        SqlContext.Pipe.Send("Hello world!\n");
        return 0;
    }
};
