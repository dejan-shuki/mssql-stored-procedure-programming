using System;
using System.Data;
using System.Data.Sql;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;
using System.Text;
using System.Collections;

namespace Samples.SqlServer
{
    public class stringsplits
    {

        [Microsoft.SqlServer.Server.SqlFunction(
            FillRowMethodName = "FillRow", 
            TableDefinition = "segment nvarchar(max)")]
        public static IEnumerable clrtvf_Split(SqlString str, string splitChar)
        {

            string[] m_strlist;
            if (!str.IsNull)
            {
                m_strlist = str.Value.Split(splitChar.ToCharArray());

                return m_strlist;
            }
            else
                return "";
        }

        public static void FillRow(Object obj, out string segment)
        {
            segment = (string)obj;
        }
    }
};