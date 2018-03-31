using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

using System.Diagnostics;
using System.IO;
using System.Globalization;
using System.Text.RegularExpressions;


public partial class CLRModules
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void ap_First()
    {
        // Put your code here
        SqlContext.Pipe.Send("Calculation completed!\n");
    }
    
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void cp_EqType_List()
    {
        using (SqlConnection conn = new SqlConnection("Context Connection=true"))
        {

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;
            cmd.CommandText = @"SELECT * FROM dbo.EqType";

            conn.Open();

            SqlDataReader rdr = cmd.ExecuteReader();
            SqlContext.Pipe.Send(rdr);

            rdr.Close();
        }

    }


[Microsoft.SqlServer.Server.SqlProcedure]
public static void cp_EqType_List2()
{
    using (SqlCommand cmd = new SqlCommand())
    {
        //cmd.Connection = conn;
        cmd.CommandText = @"SELECT * FROM dbo.EqType";

        SqlContext.Pipe.ExecuteAndSend(cmd);
    } 
}



[Microsoft.SqlServer.Server.SqlProcedure]
public static void cp_Eq_List()
{
    using (SqlConnection conn = new SqlConnection("Context Connection=true"))
    {
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandText = "ap_Eq_List";
        cmd.CommandType = CommandType.StoredProcedure;

        conn.Open();

        SqlDataReader rdr = cmd.ExecuteReader();
        SqlContext.Pipe.Send(rdr);

        rdr.Close();
    }
}


[Microsoft.SqlServer.Server.SqlProcedure]
public static int cp_Eq_Insert(string Make, string Model, string EqType)
{
    using (SqlConnection conn = new SqlConnection("Context Connection=true"))
    {

        // ALTER procedure [dbo].[ap_Equipment_Insert] 
        //        @chvMake varchar(50),
        //        @chvModel varchar(50),
        //        @chvEqType varchar(50),
        //        @intEqId int OUTPUT

        
        conn.Open();
        SqlCommand cmd = new SqlCommand("dbo.ap_Equipment_Insert", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@chvMake", Make);
        cmd.Parameters["@chvMake"].Direction = ParameterDirection.Input;

        cmd.Parameters.AddWithValue("@chvModel", Model);
        cmd.Parameters["@chvModel"].Direction = ParameterDirection.Input;

        cmd.Parameters.AddWithValue("@chvEqType", EqType);
        cmd.Parameters["@chvEqType"].Direction = ParameterDirection.Input;

        SqlParameter paramEqId = cmd.Parameters.Add("@intEqId", SqlDbType.Int);
        paramEqId.Direction = ParameterDirection.Output;


        SqlParameter paramRC =
             cmd.Parameters.Add("@return", SqlDbType.Int);
        paramRC.Direction = ParameterDirection.ReturnValue;

        //execute command
        cmd.ExecuteNonQuery();

        //return id
        int returnValue = (int)paramRC.Value;
        int EqId = (int)paramEqId.Value;
        return EqId;
    }
}




    //// Helper routine that logs SqlException details to the 
    //// Application event log
    //private void LogException(SqlException sqlex)
    //{
    //    EventLog el = new EventLog();
    //    el.Source = "CustomAppLog";
    //    string strMessage;
    //    strMessage = "Exception Number : " + sqlex.Number +
    //                 "(" + sqlex.Message + ") has occurred";
    //    el.WriteEntry(strMessage);

    //    foreach (SqlError sqle in sqlex.Errors)
    //    {
    //        strMessage = "Message: " + sqle.Message +
    //                     " Number: " + sqle.Number +
    //                     " Procedure: " + sqle.Procedure +
    //                     " Server: " + sqle.Server +
    //                     " Source: " + sqle.Source +
    //                     " State: " + sqle.State +
    //                     " Severity: " + sqle.Class +
    //                     " LineNumber: " + sqle.LineNumber;
    //        el.WriteEntry(strMessage);
    //    }
    //}

[Microsoft.SqlServer.Server.SqlProcedure]
public static void cp_EqType_GetCommaDelimList(out string EqType)
// returns comma-delimieted list of EqTypes
// example of getting data from a stored procedure that returns result
//exeample of using reader object
{
    using (SqlConnection conn = new SqlConnection("Context Connection=true"))
    {
        EqType = "";

        // Set up the command object used to execute the stored proc
        SqlCommand cmd = new SqlCommand("dbo.ap_EqType_List", conn);
        cmd.CommandType = CommandType.StoredProcedure;
        
        //execute sp
        conn.Open();
        
        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            while (reader.Read()) // Advance one row
            {
                // Return output parameters from returned data stream
                //id = reader.GetInt32(0); // we do not need first column
                EqType = EqType + reader.GetString(1) + ", ";
            }
        }
    }
}


//[Microsoft.SqlServer.Server.SqlProcedure]
//    public static void cp_EqImage_Get(int EqID, out System.Byte[] EqImage)
//{   // return image to the caller
   
//    using (SqlConnection conn = 
//        new SqlConnection("Context Connection=true"))
//    {
//        conn.Open();
//        SqlCommand command = conn.CreateCommand();

//        // Setup the command to execute the stored procedure.
//        command.CommandText = "ap_EqImage_Get";
//        command.CommandType = CommandType.StoredProcedure;

//        // Set up the input parameter.
//        SqlParameter paramID =
//            new SqlParameter("@EqID", SqlDbType.Int);
//        paramID.Value = EqID;
//        command.Parameters.Add(paramID);

//        // Set up the output parameter to retrieve the image.
//        SqlParameter paramEqImage =
//            new SqlParameter("@EqImage", SqlDbType.VarBinary, -1);
//        paramEqImage.Direction = ParameterDirection.Output;
//        command.Parameters.Add(paramEqImage);

//        // Execute the stored procedure.
//        command.ExecuteNonQuery();

//        EqImage = (System.Byte[])paramEqImage.Value;

//        return;
//    }
//}

[Microsoft.SqlServer.Server.SqlProcedure]
public static void cp_EqImage_Save(int EqID, string FileName)
{
    //save vabinary(max) returned by stored procedure to the file

    const int bufferSize = 8000;

    // The BLOB byte[] buffer to be filled by GetBytes.
    byte[] outbyte = new byte[bufferSize];
    using (SqlConnection conn =
        new SqlConnection("Context Connection=true"))
    {
        conn.Open();
        SqlCommand command = conn.CreateCommand();

        // Setup the command to execute the stored procedure.
        command.CommandText = "dbo.ap_EqImage_List";
        command.CommandType = CommandType.StoredProcedure;

        // Set up the input parameter.
        SqlParameter paramID =
            new SqlParameter("@EqID", SqlDbType.Int);
        paramID.Value = EqID;
        command.Parameters.Add(paramID);

        // Execute the stored procedure.
        command.ExecuteNonQuery();

        using (SqlDataReader reader = 
            command.ExecuteReader(CommandBehavior.SequentialAccess))
        {
            while (reader.Read())
            {
                //SqlContext.Pipe.Send("reader read");

                //define the file (stream)
                using (FileStream fileStream =
                new FileStream(FileName,
                               FileMode.OpenOrCreate,
                               FileAccess.Write))
                {
                    //SqlContext.Pipe.Send("file stream created.");

                    //Define a writer that will stream BLOB 
                    //to the file (FileStream).
                    using (BinaryWriter binaryWriter =
                        new BinaryWriter(fileStream))
                    {
                        //SqlContext.Pipe.Send("BinaryWriter created");
                        //The starting position in the BLOB output.
                        long startIndex = 0;

                        //Read the bytes into outbyte[] array.
                        //Get number of bytes that were read.
                        long retval = reader.GetBytes(0,
                            startIndex, outbyte, 0, bufferSize);

                        //SqlContext.Pipe.Send("outbyte filled.");

                        //While number of bytes read is equal 
                        // to size of bufer, 
                        //continue reading
                        while (retval == bufferSize)
                        {
                            //write to stream
                            binaryWriter.Write(outbyte);
                            //SqlContext.Pipe.Send("outbyte written.");

                            //write to file
                            binaryWriter.Flush();

                            //SqlContext.Pipe.Send("writer flushed.");

                            // Reposition the start index 
                            startIndex += bufferSize;
                            //Read number of records again 
                            //and fill the buffer.
                            retval = reader.GetBytes(
                                0, startIndex, outbyte, 0, bufferSize);
                        }

                        //SqlContext.Pipe.Send("outbyte last time.");
                        // Write the remainder to the file
                        binaryWriter.Write(outbyte);
                        //write to file
                        binaryWriter.Flush();
                        //SqlContext.Pipe.Send("flushed last time.");
                    }
                }
            }
        }
        return;
    }
}


[Microsoft.SqlServer.Server.SqlProcedure]
public static void cp_EqImage_Update(int EqID, string FileName)
{
    //read image from the file and put it in varbinary(max)

    //define the file (stream)
    using (FileStream fileStream =
    new FileStream(FileName,
                   FileMode.Open,
                   FileAccess.Read))
    {
        //SqlContext.Pipe.Send("file stream created.");

        //Define a writer that will stream BLOB 
        //to the file (FileStream).
        using (BinaryReader binaryReader =
            new BinaryReader(fileStream))
        {
            //SqlContext.Pipe.Send("BinaryWriter created");
            byte[] blob=binaryReader.ReadBytes((int)fileStream.Length);

            using (SqlConnection conn =
                new SqlConnection("Context Connection=true"))
            {
                conn.Open();
                SqlCommand command = conn.CreateCommand();

                // Setup the command to execute the stored procedure.
                command.CommandText = "ap_EqImage_Update";
                command.CommandType = CommandType.StoredProcedure;

                // Set up the input parameter.
                SqlParameter paramID =
                    new SqlParameter("@EqID", SqlDbType.Int);
                paramID.Value = EqID;
                command.Parameters.Add(paramID);

                // Set up the output parameter to retrieve the image.
                SqlParameter paramEqImage =
                    new SqlParameter("@EqImage",SqlDbType.VarBinary,-1);
                paramEqImage.Value = blob;
                command.Parameters.Add(paramEqImage);

                // Execute the stored procedure.
                command.ExecuteNonQuery();

            }

        }
    }
    return;
 }

//1234567890123456789012345678901234567890123456789012345678901234567890


[Microsoft.SqlServer.Server.SqlProcedure]
public static void cp_Lease_Calc()
{
    SqlMetaData[] fields = new SqlMetaData[5];
    fields[0] = new SqlMetaData("LeaseId", SqlDbType.Int);
    fields[1] = new SqlMetaData("LeaseVendor", SqlDbType.NVarChar, 50);
    fields[2] = new SqlMetaData("LeaseNumber", SqlDbType.NVarChar, 50);
    fields[3] = new SqlMetaData("ContactDate", SqlDbType.DateTime);
    fields[4] = new SqlMetaData("TotalAmount", SqlDbType.Money);

    // calculate values

    // set record
    SqlDataRecord record = new SqlDataRecord(fields);

    //set data
    record.SetInt32(0, 1001);
    record.SetString(1, "LeaseLeaseLease Inc.");
    record.SetString(2, "123-456-7890");
    record.SetDateTime(3, DateTime.Now);
    record.SetSqlMoney(4, 2000);
    
    // send record (set)
    SqlContext.Pipe.Send(record);

    //set data
    record.SetInt32(0, 1002);
    record.SetString(1, "LeaseLeaseLease Inc.");
    record.SetString(2, "123-456-7891");
    record.SetDateTime(3, DateTime.Now);
    record.SetSqlMoney(4, 4000);

    // send record (set)
    SqlContext.Pipe.Send(record);



    return;
    
}

[Microsoft.SqlServer.Server.SqlProcedure]
public static void cp_Lease_Calc2()
{
    SqlMetaData[] fields = new SqlMetaData[5];
    fields[0] = new SqlMetaData("LeaseId", SqlDbType.Int);
    fields[1] = new SqlMetaData("LeaseVendor", SqlDbType.NVarChar, 50);
    fields[2] = new SqlMetaData("LeaseNumber", SqlDbType.NVarChar, 50);
    fields[3] = new SqlMetaData("ContactDate", SqlDbType.DateTime);
    fields[4] = new SqlMetaData("TotalAmount", SqlDbType.Money);

    // calculate values

    // set record
    SqlDataRecord record = new SqlDataRecord(fields);

    // start record set
    SqlContext.Pipe.SendResultsStart(record);

    //assemble first record
    record.SetInt32(0, 1001);
    record.SetString(1, "LeaseLeaseLease Inc.");
    record.SetString(2, "123-456-7890");
    record.SetDateTime(3, DateTime.Now);
    record.SetSqlMoney(4, 2000);

    // send row
    SqlContext.Pipe.SendResultsRow(record);


    // assemble second record
    record.SetInt32(0, 1002);
    record.SetString(1, "LeaseLeaseLease Inc.");
    record.SetString(2, "123-456-7891");
    record.SetDateTime(3, DateTime.Now);
    record.SetSqlMoney(4, 4000);

    // send row
    SqlContext.Pipe.SendResultsRow(record);

    // send record set
    SqlContext.Pipe.SendResultsEnd();

    return;

}


[SqlFunction]
public static String cf_DateConv(DateTime dt, string format)
{
        return dt.ToString(format);
    
}

[SqlFunction]
public static String cf_DateConv_DtFmtCult(string dt, string format, string culture)
{
    CultureInfo MyCultureInfo = new CultureInfo(culture); 
    DateTime MyDateTime = DateTime.Parse(dt, MyCultureInfo);

    return MyDateTime.ToString(format);     
}

[SqlFunction(DataAccess = DataAccessKind.Read)]
public static int cf_OrderCount()
{
    using (SqlConnection sqlConn
        = new SqlConnection("context connection=true"))
    {
        sqlConn.Open();
        SqlCommand sqlCmd = new SqlCommand(
            "SELECT COUNT(*) AS 'Order Count' FROM dbo.OrderHeader", sqlConn);
        return (int)sqlCmd.ExecuteScalar();
    }
}

[SqlFunction(DataAccess = DataAccessKind.Read)]
public static bool cf_IsValidEmail(string email)
{
        //Is it a valid email address:
        return Regex.IsMatch(email, @"^([\w-]+\.)*?[\w-]+@[\w-]+\.([\w-]+\.)*?[\w]+$");
}




};


