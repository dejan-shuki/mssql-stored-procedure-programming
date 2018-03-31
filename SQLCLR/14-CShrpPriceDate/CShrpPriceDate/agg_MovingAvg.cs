using System;
using System.Data.Sql;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

using System.IO;
using System.Text;
using MyUDTs;


namespace MyAggs
{
    [Serializable]
    [SqlUserDefinedAggregate(
        Format.UserDefined,
        IsInvariantToNulls = true,
        IsInvariantToDuplicates = false,
        IsInvariantToOrder = false,
        MaxByteSize = 8000)
        ]
    public class agg_MovingAvg : IBinarySerialize
    {
        private double sum = 0;
        private DateTime startDt;
        private DateTime endDt;
        private double ma;
        private Int32 count = 1;
        public static readonly int daysNum = 50;

        #region Aggregation Methods
        /// <summary>
        /// Initialize the internal data structures
        /// </summary>
        public void Init()
        {
            startDt = DateTime.Today;
            endDt = startDt.AddDays(-1 * daysNum);
        }

        /// <summary>
        /// Accumulate the next value, nop if the value is null
        /// </summary>
        /// <param name="value">Another value to be aggregated</param>
        public void Accumulate(cudt_PriceDate value)
        {

            if (value.IsNull)
            {
                return;
            }
            if (value.BusinessDay > endDt && value.BusinessDay < this.startDt)
            {
                sum += (double)value.StockPrice;
                count++;

            }
        }

        /// <summary>
        /// Merge the partially computed aggregate with this aggregate
        /// </summary>
        /// <param name="other">Another set of data to be added</param>
        public void Merge(agg_MovingAvg other)
        {
            sum += other.sum;
            count += other.count;
        }

        /// <summary>
        /// Called at the end of aggregation 
        /// to return the results of the aggregation.
        /// </summary>
        /// <returns>the aggregated value</returns>
        public SqlDouble Terminate()
        {
            ma = sum / count;
            return new SqlDouble(ma);
        }

        #endregion

        #region IBinarySerialize
        public void Read(BinaryReader r)
        {
            sum = r.ReadDouble();
            count = r.ReadInt32();
        }

        public void Write(BinaryWriter w)
        {
            w.Write(sum);
            w.Write(count);
        }
        #endregion
    }

}