using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

using System.Xml;
using System.Text.RegularExpressions;
using System.Diagnostics;
using System.IO;

public partial class Triggers
{
    // Enter existing table or view for the target and uncomment the attribute line
    [SqlTrigger(
            Name = "dbo.ctr_Contact_iu",
            Target = "Contact",
            Event = "AFTER UPDATE, INSERT")]
    public static void ctr_Contact_iu()
    {
        //get trigger context to access trigger related features
        SqlTriggerContext triggerContext = SqlContext.TriggerContext;
        string action = triggerContext.TriggerAction.ToString();
        string sObj = triggerContext.ToString();
        
        SqlContext.Pipe.Send("Trigger " + sObj + " FIRED on " + action);

        string s = "";
        int iCount = triggerContext.ColumnCount;
        for (int i = 0; i < iCount; i++)
        {
            if (triggerContext.IsUpdatedColumn(i) == true)
                s = s + i.ToString() + ", ";
        }
        SqlContext.Pipe.Send("Trigger updated columns: " + s);
        
        
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

        //list of updated column names
        using (SqlConnection con = new SqlConnection("context connection = true"))
        {
            con.Open();
            using (SqlCommand cmd = con.CreateCommand())
            {
                cmd.CommandText = "SELECT * FROM INSERTED";
                        
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    rdr.Read();

                    if (triggerContext.TriggerAction == TriggerAction.Update)
                    {
                        string sCol = "Updated columns: ";
                        for (int icol = 0; icol < triggerContext.ColumnCount; icol++)
                            if (triggerContext.IsUpdatedColumn(icol) == true)
                                 sCol = sCol + rdr.GetName(icol);
                        SqlContext.Pipe.Send(sCol);
                    }
                }
            }
        }

    
    }

[SqlTrigger(
   Name = "ctrd_DDL_TABLE_EVENTS ",
   Target = "DATABASE",
   Event = "AFTER DDL_TABLE_EVENTS")]
public static void ddl_table()
{
    //get trigger context to access trigger related features
    SqlTriggerContext triggerContext = SqlContext.TriggerContext;
    //read xml with info about event that fired trigger
    string sXml = triggerContext.EventData.Value;
    string login = "";
    string sql = "";

    using (StringReader srXml = new StringReader(sXml))
    {
        using (XmlReader rXml = new XmlTextReader(srXml))
        {
            //loop through nodes to the end of XML
            while (!(rXml.EOF))
            {
                rXml.MoveToContent();
                if (rXml.IsStartElement() 
                      && rXml.Name.Equals("LoginName"))
                    login = rXml.ReadElementString("LoginName");
                else if (rXml.IsStartElement() 
                      && rXml.Name.Equals("CommandText"))
                    sql = rXml.ReadElementString("CommandText");
                
                //move to the next node
                rXml.Read();
            }

            //if the source does not exist create it
            if (!EventLog.SourceExists("Asset5"))
                EventLog.CreateEventSource("Asset5", "Asset5 database");

            //write event info in event log
            EventLog EventLog1 = new 
                  EventLog("Asset5 database", "LG", "Asset5");
            string log = "Login: "+login+" executed: ["+sql+"]";
            EventLog1.WriteEntry(log);
        }
    }
}


}






