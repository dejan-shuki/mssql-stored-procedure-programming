using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

using System.Text.RegularExpressions;


public partial class Triggers
{
    [SqlTrigger(Name = "dbo.ctr_Contact_iu_Email",
                Target = "Contact",
                Event = "AFTER UPDATE, INSERT")]
    public static void ctr_Contact_iu_Email()
    {
        //get trigger context to access trigger related features
        SqlTriggerContext triggerContext = SqlContext.TriggerContext;


        //test validity of email 
        using (SqlConnection con = new SqlConnection("context connection = true"))
        {
            con.Open();
            using (SqlCommand cmd = con.CreateCommand())
            {
                if (triggerContext.TriggerAction == TriggerAction.Insert)
                {
                    cmd.CommandText = "SELECT * FROM INSERTED";
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {

                            string email = rdr.GetValue(5).ToString();

                            if (Regex.IsMatch(email, @"^([\w-]+\.)*?[\w-]+@[\w-]+\.([\w-]+\.)*?[\w]+$") == false)
                            {
                                SqlContext.Pipe.Send("Not a valid email!");
                                //Transaction.Current.Rollback();
                            }
                        }

                    }
                }
            }
        }



    }
}