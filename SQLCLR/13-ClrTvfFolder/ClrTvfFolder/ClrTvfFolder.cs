using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

using System.IO;
using System.Collections;



public partial class UserDefinedFunctions
{
    [SqlFunction(FillRowMethodName = "FillRow", 
        TableDefinition = "fileName nvarchar(max), size bigint")]

    public static IEnumerable ClrTvfFolderList(string folder)
    {
        ArrayList fileArray = new ArrayList();
        
        // loop through files in the folder 
        foreach (string file in Directory.GetFiles(folder,
            "*.*", SearchOption.TopDirectoryOnly))
        {
            FileInfo fi = new FileInfo(file);

            object[] row = new object[2];
            row[0] = fi.FullName;
            row[1] = fi.Length;

            fileArray.Add(row);
        }

        return fileArray;
    }

    public static void FillRow(object obj, out string fileName, out long size)
    {
        Object[] row = (object[])obj;
        
        // get data from obj
        fileName = (string)row[0];
        size = (long)row[1];
    }
};

