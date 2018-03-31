using System;
using System.Data.Sql;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

using System.IO;
using System.Runtime.InteropServices;

namespace MyUDTs
{
    [Serializable]
    [StructLayout(LayoutKind.Sequential)]
    [SqlUserDefinedType(Format.UserDefined,
                        IsByteOrdered = true,
                        MaxByteSize = 4096,
                        IsFixedLength = false)]
    public struct cudt_PriceDate : INullable, IBinarySerialize
    {
        #region Properties
        private Double stockPrice;
        private DateTime businessDay;

        public Double StockPrice
        {
            get
            {
                return this.stockPrice; ;
            }
            set
            {
                stockPrice = value;
            }
        }

        public DateTime BusinessDay
        {
            get
            {
                return this.businessDay;
            }
            set
            {
                businessDay = value;

            }
        }
        #endregion

        #region NULL
        private bool isNull;


        public bool IsNull
        {
            get
            {
                return (isNull);
            }
        }

        public static cudt_PriceDate Null
        {
            get
            {
                cudt_PriceDate h = new cudt_PriceDate();
                h.isNull = true;
                return h;
            }
        }
        #endregion

        #region Default
        public static cudt_PriceDate DefaultValue()
        {
            return cudt_PriceDate.Null;
        }
        #endregion

        #region Conversion Methods
        public override string ToString()
        {
            if (this.IsNull)
                return "NULL";
            else
            {
                return stockPrice + ";" + businessDay.Date;
            }
        }

        public static cudt_PriceDate Parse(SqlString s)
        {
            if (s.IsNull || s.Value.ToLower() == "null")
                return Null;
            cudt_PriceDate st = new cudt_PriceDate();
            string[] xy = s.Value.Split(";".ToCharArray());
            st.stockPrice = Double.Parse(xy[0]);
            st.businessDay = DateTime.Parse(xy[1]);
            return st;
        }

        #endregion
        
        #region Serialization
        public void Read(BinaryReader r)
        {
            stockPrice = r.ReadDouble();
            businessDay = DateTime.Parse(r.ReadString());
        }

        public void Write(BinaryWriter w)
        {
            w.Write(stockPrice);
            w.Write(businessDay.ToString());
        }
        #endregion

        #region Custom Methods
        //The following calculations do not have much mathematical sense.
        //They are simple demonstration of methods in UDT.

        [SqlMethod(
            OnNullCall = false, 
            DataAccess = DataAccessKind.None, 
            IsDeterministic = false, 
            IsMutator = false,
            IsPrecise = false)]
        public static SqlInt32 DiffDate(cudt_PriceDate from, cudt_PriceDate to)
        {
            TimeSpan delta = to.BusinessDay.Subtract(from.BusinessDay);    
            return delta.Days;
        }

        [SqlMethod(OnNullCall = false)]
        public static SqlDouble DiffPrice(cudt_PriceDate from, cudt_PriceDate to)
        {
            return to.StockPrice - from.StockPrice;
        }

        #endregion

    }
}

