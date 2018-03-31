using System;
using System.Data.Sql;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

using System.Runtime.InteropServices;
using System.Collections;
using System.IO;
using System.Text;

namespace MyAggs
{
    [Serializable]
    [SqlUserDefinedAggregate(
        Format.UserDefined,
        IsInvariantToNulls = true,
        IsInvariantToDuplicates = false,
        MaxByteSize = 8000)
     ]

    public class MedianDouble : IBinarySerialize
    {
        private double[] arr;
        double median;
        private int count = 0;

        public void Init()
        {
            arr = new double[100];
        }

        public void Accumulate(SqlDouble value)
        {
            arr[count] = value.Value;
            count++;
        }

        public void Merge(MedianDouble group)
        {
            foreach (double mem in group.arr)
            {
                arr[count] = mem;
                count++;
            }
        }

        public SqlDouble Terminate()
        {
            Array.Resize(ref arr, count);
            Array.Sort(arr);

            int n = count / 2;
            
            if (n * 2 == count)
                median = (arr[n + 1] + arr[n]) / 2;
            else
                median = arr[n + 1];
            
            return median;
        }

        public void Read(BinaryReader r)
        {
            count = r.ReadInt32();
            
            arr = new double[count];
            
            for (int i = 1; i < count; i++)
                arr[i] = r.ReadDouble();

        }

        public void Write(BinaryWriter w)
        {
            w.Write(count);
            
            foreach (double m in arr)
                w.Write(m);

        }
    }
}
