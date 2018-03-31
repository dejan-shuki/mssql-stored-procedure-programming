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
    public class stringsplit
    {

        internal struct SplitParts
        {
            // structure that will be used to store parts
            public int id;
            public string result;
            public SplitParts(int splitId, string split)
            {
                id = splitId;
                this.result = split;
            }
        }

        [Microsoft.SqlServer.Server.SqlFunctionAttribute(FillRowMethodName = "FillRow", TableDefinition = "str nvarchar(max), ind int")]
        public static IEnumerable clrtvf_Split1(SqlString str, string splitChar)
        {
            // split str using delimiter in splitChar 
            //and return it as table valued function
            // in format: segment varchar(max), row_number int 

            string[] m_strlist;
            SplitParts[] a;
            if (!str.IsNull)
            {
                m_strlist = str.Value.Split(splitChar.ToCharArray());
                int count = m_strlist.GetUpperBound(0);
                a = new SplitParts[count + 1];
                for (int i = 0; i < m_strlist.GetUpperBound(0) + 1; i++)
                {
                    a[i] = new SplitParts(i, m_strlist[i]); ;
                }
                return a;
            }
            else
                return "";
        }

        public static void FillRow(Object obj, out string segment, out int i)
        {

            SplitParts ab = (SplitParts)obj;
            segment = ab.result;
            i = ab.id;
        }
    }
}



