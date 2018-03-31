using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

using System.IO;


public partial class Triggers
{
    [SqlTrigger(Name = "citr_OrderItem_D", Target = "OrderItem", Event = "INSTEAD OF DELETE")]
    public static void TriggerDelete()
    {
        string lines;

        //create a new file or append an existing
        using (StreamWriter file = new StreamWriter("c:\\Audit.txt", true))
        {
            using (SqlConnection con = new SqlConnection("context connection = true"))
            {
                con.Open();
                using (SqlCommand cmd = con.CreateCommand())
                {

                    cmd.CommandText = "select   system_user as [user], "
                        + " GetDate() as [time], 'OrderItem' as [table],"
                        + " ItemId from deleted for xml raw";

                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        // there could be multiple records
                        while (rdr.Read())
                        {
                            lines = rdr.GetValue(0).ToString();
                            //SqlContext.Pipe.Send(lines);
                            file.WriteLine(lines);
                            file.WriteLine();
                        }
                    }
                }
            }
            file.Close();
        }
    }
}
