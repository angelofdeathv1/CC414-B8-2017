using System;
using System.Collections.Generic;
using System.Data;

namespace Engine.BL
{
    public static class Extensions
    {
        //public static DateTime ToDate(this String sDate, string sFormat)
        //{
        //    DateTime dDate = DateTime.MinValue;
        //    if (string.IsNullOrWhiteSpace(sDate)) return dDate;

        //    switch (sFormat.ToUpper())
        //    {
        //        case "MM-DD-YYYY":
        //            {
        //                dDate = UTIL.Util.isDate(sDate);
        //                break;
        //            }
        //        case "YYYY-MM-DD":
        //            {
        //                dDate = UTIL.Util.isDate2(sDate);
        //                break;
        //            }
        //        case "YYYYMMDD":
        //            {
        //                dDate = UTIL.Util.isDate3(sDate);
        //                break;
        //            }
        //        default: throw new NotImplementedException("Engine.BL.Extensions.ToDate Format[" + sFormat + "] Not Implemented");
        //    }

        //    return dDate;
        //}

        public static string DefaultFormat(this DateTime dDate)
        {
            return string.Format("{0:dd-MM-yyyy}", dDate);
        }

        public static string ToDateTimeString(this DateTime dDate)
        {
            return string.Format("{0:dd-MM-yyyy HH:mm}", dDate);
        }

        public static string Format1(this DateTime dDate)
        {
            return string.Format("{0:dd-MMM-yyyy}", dDate);
        }

        public static string Format1_Time(this DateTime dDate)
        {
            return string.Format("{0:dd-MMM-yyyy HH:mm}", dDate);
        }

        public static DateTime ToDate(this DateTime date)
        {
            return date.AddHours(23).AddMinutes(59).AddSeconds(59).AddMilliseconds(999);
        }

        public static string Money(this double dvalue)
        {
            return string.Format("{0:C}", dvalue);
        }

        public static string DefaultFormat(this double dvalue)
        {
            return string.Format("{0:N2}", dvalue);
        }

        public static string IntValue(this double dvalue)
        {
            return string.Format("{0:0}", dvalue);
        }

        public static string ToDayTimeShort(this DateTime dDate)
        {
            return string.Format("{0:dd-MMM HH:mm}", dDate);
        }

        public static double DateGetTime(this DateTime TheDate)
        {
            DateTime d1 = new DateTime(1970, 1, 1);
            DateTime d2 = TheDate.ToUniversalTime();
            TimeSpan ts = new TimeSpan(d2.Ticks - d1.Ticks);

            return ts.TotalMilliseconds;
        }

        public static DataTable TransposeIntegerColumnIntoColumns(this DataTable dt, int indexColumnToEstablishDuplicateRows, int integerColumnIdToTranspose, string transposedColumnName)
        {
            //Protection if the column to transpose is not an integer or doesn't exist
            if (integerColumnIdToTranspose >= dt.Columns.Count) return null;
            var columnDataType = dt.Columns[integerColumnIdToTranspose].DataType;
            if (columnDataType != typeof(decimal)) return null;

            //Get max sessions number
            decimal maxColumnNumber=0;
            List<decimal> test = new List<decimal>();

           DataTable dtTest= dt.DefaultView.ToTable(true, dt.Columns[integerColumnIdToTranspose].ColumnName);
            foreach (DataRow dr in dtTest.Rows)
            {

               // decimal number = dr.Field<decimal>(integerColumnIdToTranspose);
                /*if (number != null)
                {
                 
                    maxColumnNumber = Math.Max(maxColumnNumber, number);

                }*/
                test.Add(dr.Field<decimal>(0));
                
            }
            maxColumnNumber = test.Count;
            //Protection if there are zero rows or the maxColumnNumber is 0
            if (dt.Rows.Count == 0 || maxColumnNumber == 0) return null;

            //Make a copy of the table so we can remove duplicate rows and add the transposed columns
            DataTable result = dt.Copy();
            
            //foreach 
            //Add columns to store the session_ids
            for (int i = 0; i < maxColumnNumber; i++)
            {
                DataColumn dc = new DataColumn(transposedColumnName + test[i].ToString(), typeof(decimal));
                dc.DefaultValue = 0;
                //Possibly make an overloaded method that supports inserting columns
                result.Columns.Add(dc);
            }

            //Remove rows with duplicated employees
            for (int i = 0; i < result.Rows.Count; i++)
            {
                int duplicateRow = GetRowIndexById(result, indexColumnToEstablishDuplicateRows, result.Rows[i][indexColumnToEstablishDuplicateRows].ToString(), i + 1);
                if (duplicateRow > -1)
                {
                    result.Rows.RemoveAt(duplicateRow);
                }
            }

            //Populate the transposed columns with values in the integer Column To Transpose
            foreach (DataRow dr in dt.Rows)
            {
                decimal? sessionNumber = dr.Field<decimal?>(integerColumnIdToTranspose);
                if (sessionNumber == null) continue;
                int rowIndex = GetRowIndexById(result, indexColumnToEstablishDuplicateRows, dr[indexColumnToEstablishDuplicateRows].ToString(), 0);

                result.Rows[rowIndex][transposedColumnName + sessionNumber.ToString()] = 1; //or +=1 if you want to increment the number
            }

            //Remove the integerColumnIdToTranspose (again overload this method if you want to keep this column)
            result.Columns.RemoveAt(integerColumnIdToTranspose);

            return result;
        }

        //Net 4 implementation with optional parameter
        //private static int GetRowIndexById(DataTable dt, int indexColumnToEstablishDuplicateRows, string id, int startLookAtRow = 0)
        private static int GetRowIndexById(DataTable dt, int indexColumnToEstablishDuplicateRows, string id, int startLookAtRow)
        {
            for (int i = startLookAtRow; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i][indexColumnToEstablishDuplicateRows].ToString() == id) return i;
            }
            return -1;
        }
    }
}
