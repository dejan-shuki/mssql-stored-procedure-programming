using System;
using System.Data;
using System.Data.Sql;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

using System.Management;
using System.Collections;
using System.Collections.Generic;


internal struct LogicalDriveList
{
    public int DriveId;
    public string DriveLogicalName;
    public Int64 DriveFreeSpace;
    public string DriveType;
    public LogicalDriveList(int driveId, string driveLogicalName, string driveType, int driveFreeSpace)
    {
        DriveId = driveId;
        this.DriveLogicalName = driveLogicalName;
        this.DriveType = driveType;
        this.DriveFreeSpace = driveFreeSpace;
    }
}

public class GetDrives
{

    [Microsoft.SqlServer.Server.SqlFunctionAttribute(FillRowMethodName = "FillRow", 
        TableDefinition = "i int, DriveLogicalName nvarchar(255), DriveType nvarchar(255), DriveFreeSpace bigint")]
    public static IEnumerable clrtvf_GetLogicalDrives()
    {

        List<LogicalDriveList> drs = new List<LogicalDriveList>();
        ManagementObjectCollection queryCollection = getDrives();
        const int Removable = 2;
        const int LocalDisk = 3;
        const int Network = 4;
        const int CD = 5;
        int count = 0;
        string driveType = string.Empty;
        foreach (ManagementObject mo in queryCollection)
        {
            count++;
            switch (int.Parse(mo["DriveType"].ToString()))
            {
                case Removable: //removable drives 
                    driveType = "Removable";
                    break;
                case LocalDisk: //Local drives 
                    driveType = "LocalDisk";
                    break;
                case CD: //CD rom drives 
                    driveType = "CD";
                    break;
                case Network: //Network drives 
                    driveType = "Network";
                    break;
                default: //defalut to folder 
                    driveType = "UnKnown";
                    break;
            }

            LogicalDriveList a = new LogicalDriveList();
            a.DriveId = count;
            a.DriveLogicalName = mo["Name"].ToString();
            a.DriveType = driveType;
            if (mo["FreeSpace"] != null)
                a.DriveFreeSpace = Int64.Parse(mo["FreeSpace"].ToString());
            else
                a.DriveFreeSpace = 0;
            drs.Add(a);
        }
        return drs;
    }
    
    
    protected static ManagementObjectCollection getDrives()
    {
        //get drive collection 
        ManagementObjectSearcher query = new
            ManagementObjectSearcher("SELECT * From Win32_LogicalDisk ");
        ManagementObjectCollection queryCollection = query.Get();
        return queryCollection;
    }
    
    
    public static void FillRow(Object obj, 
        out int i, 
        out string DriveLogicalName, 
        out string DriveType, 
        out Int64 DriveFreeSpace)
    {

        LogicalDriveList ld = (LogicalDriveList)obj;
        DriveLogicalName = ld.DriveLogicalName;
        i = ld.DriveId;
        DriveType = ld.DriveType;
        DriveFreeSpace = ld.DriveFreeSpace;
    }
}



