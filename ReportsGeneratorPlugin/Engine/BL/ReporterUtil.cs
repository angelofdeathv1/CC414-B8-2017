using Engine.BO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace Engine.BL
{
    public class ReporterUtil
    {
        public object getJQStructure(List<FieldProp> oLFields, string sReportID,string sParameters, string sNewSearch, string sHeight, string bUserData, string sCallback, int nRowsByPage, string sHostURL)
        {
            JqGridStructure oJQGridStructure = new JqGridStructure();
            List<JqGridModel> oLColModel = new List<JqGridModel>();
            JqGridModel oColModel;

            string[] arrDataTitle;
            int nIndex = 0;

            arrDataTitle = new string[oLFields.Count];
            foreach (FieldProp oFieldProp in oLFields)
            {
                oColModel = new JqGridModel();

                arrDataTitle[nIndex] = oFieldProp.fieldname;
                oColModel.align = "right";
                oColModel.width = 100;
                if (oFieldProp.datatype.Equals("String"))
                {
                    oColModel.align = "left";
                    oColModel.width = 180;
                }
                oColModel.name = oFieldProp.fieldname;
                oColModel.index = nIndex.ToString();
                oColModel.sortable = true;
                oLColModel.Add(oColModel);
                nIndex += 1;
            }

            oJQGridStructure.colNames = arrDataTitle;
            oJQGridStructure.colModel = oLColModel;
            oJQGridStructure.shrinkToFit = false;
            oJQGridStructure.rowNum = nRowsByPage;

            string[] arrHostURL = sHostURL.Split('?');
            string sURLParameters = "sAction=getDataGrid&nReportID="+ sReportID+ "&sParameters=" + sParameters + "&sNewSearch=" + sNewSearch + "&bUserData=" + bUserData;

            if (!string.IsNullOrEmpty(sCallback))
            {
                oJQGridStructure.datatype = "jsonp";
                sURLParameters += "&callback=" + sCallback;
            }

            oJQGridStructure.url = arrHostURL[0] + "?" + sURLParameters;
            oJQGridStructure.caption = "";
            oJQGridStructure.autowidth = true;

            oJQGridStructure.height = string.IsNullOrEmpty(sHeight) ? oJQGridStructure.height : Convert.ToInt32(sHeight);
            return oJQGridStructure;
        }
        public object getJQStructure(List<FieldProp> oLFields, string sReportID, string sReportUUID, string sParameters, string sNewSearch, string sHeight, string bUserData, string sCallback, int nRowsByPage, string sHostURL)
        {
            JqGridStructure oJQGridStructure = new JqGridStructure();
            List<JqGridModel> oLColModel = new List<JqGridModel>();
            JqGridModel oColModel;

            string[] arrDataTitle;
            int nIndex = 0;

            arrDataTitle = new string[oLFields.Count];

            foreach (FieldProp oFieldProp in oLFields)
            {
                oColModel = new JqGridModel();
               
                arrDataTitle[nIndex] = oFieldProp.fieldname;
                oColModel.align = "right";
                oColModel.width = 100;
                if (oFieldProp.datatype.Equals("String"))
                {
                    oColModel.align = "left";
                    oColModel.width = 180;
                }
                oColModel.name = oFieldProp.fieldname;
                oColModel.index = nIndex.ToString();
                oColModel.sortable = true;
                oLColModel.Add(oColModel);
                nIndex += 1;
            }

            oJQGridStructure.colNames = arrDataTitle;
            oJQGridStructure.colModel = oLColModel;
            oJQGridStructure.shrinkToFit = false;
            oJQGridStructure.rowNum = nRowsByPage;

            string[] arrHostURL = sHostURL.Split('?');
            string sURLParameters = "sAction=getDataGrid&";

            if (string.IsNullOrEmpty(sReportID))
            {
                sURLParameters += "sReportUUID=" + sReportUUID;
            }
            else
            {
                sURLParameters += "nReportID=" + sReportID;
            }
            sURLParameters += "&sParameters=" + sParameters + "&sNewSearch=" + sNewSearch + "&bUserData=" + bUserData;

            if (!string.IsNullOrEmpty(sCallback))
            {
                oJQGridStructure.datatype = "jsonp";
                sURLParameters += "&callback=" + sCallback;
            }

            oJQGridStructure.url = arrHostURL[0] + "?" + sURLParameters;
            oJQGridStructure.caption = " ";
            oJQGridStructure.autowidth = true;

            oJQGridStructure.height = string.IsNullOrEmpty(sHeight) ? oJQGridStructure.height : Convert.ToInt32(sHeight);
            return oJQGridStructure;
        }

        public object getJQGridData(List<List<string>> oLData, int iPage, int nRowsPerPage = JqGridData.ROWS_PER_PAGE)
        {
            int iTotalRows = oLData == null ? 0 : oLData.Count;
            int init_index;
            int final_index;
            int ipagestotal;
            int nIndex = 0;
            int nCount = 0;
            JqGridData.calcula_pagina(iTotalRows, iPage, nRowsPerPage, out init_index, out final_index, out ipagestotal);
            string[] arrDataColumns;

            JqGridData oJQGridData = new JqGridData();
            JqGridDetail oJQGridDetail = null;

            oJQGridData.page = iPage.ToString();
            oJQGridData.total = ipagestotal.ToString();
            oJQGridData.records = iTotalRows.ToString();
            oJQGridData.rows = new List<JqGridDetail>();

            for (int i = init_index; i < final_index; i++)
            {
                var o = oLData[i];

                nCount = o.Count;
                nIndex = 0;
                arrDataColumns = new string[nCount];

                oJQGridDetail = new JqGridDetail();
                oJQGridDetail.id = i.ToString();

                foreach (var oElement in o)
                {
                    arrDataColumns[nIndex] = oElement.ToString();
                    nIndex += 1;
                }

                oJQGridDetail.cell = arrDataColumns;
                oJQGridData.rows.Add(oJQGridDetail);
                oJQGridDetail = null;
            }
            return oJQGridData;
        }

        public object getJQGridData(DataTable oDataTable, int iPage, bool bDataTable, int nRowsPerPage = JqGridData.ROWS_PER_PAGE)
        {
            int iTotalRows = oDataTable == null ? 0 : oDataTable.Rows.Count;
            int init_index;
            int final_index;
            int ipagestotal;
            JqGridData.calcula_pagina(iTotalRows, iPage, nRowsPerPage, out init_index, out final_index, out ipagestotal);

            JqGridData oJQGridData = new JqGridData();
            JqGridDetail oJQGridDetail = null;

            oJQGridData.page = iPage.ToString();
            oJQGridData.total = ipagestotal.ToString();
            oJQGridData.records = iTotalRows.ToString();
            oJQGridData.rows = new List<JqGridDetail>();

            if (bDataTable)
            {
                Dictionary<string, string> oDUserData = new Dictionary<string, string>();
                object sumObject;

                if (!itIsNumeric(oDataTable.Columns[0]))
                {
                    oDUserData.Add(oDataTable.Columns[0].ColumnName, "Total");
                }

                foreach (DataColumn col in oDataTable.Columns)
                {
                    if (itIsNumeric(col))
                    {
                        sumObject = oDataTable.Compute("Sum(" + col.ColumnName + ")", "");
                        oDUserData.Add(col.ColumnName, sumObject.ToString());
                    }
                }

                oJQGridData.userdata = oDUserData;
            }

            for (int i = init_index; i < final_index; i++)
            {
                var rowAsString = oDataTable.Rows[i].ItemArray;
                oJQGridDetail = new JqGridDetail();
                oJQGridDetail.id = i.ToString();
                oJQGridDetail.cell = Array.ConvertAll(rowAsString, x => x.ToString()); ;
                oJQGridData.rows.Add(oJQGridDetail);
                oJQGridDetail = null;
            }
            return oJQGridData;
        }

        public bool itIsNumeric(DataColumn col)
        {
            if (col == null)
            {
                return false;
            }
            var numericTypes = new[] { typeof(Byte), typeof(Decimal), typeof(Double),
            typeof(Int16), typeof(int), typeof(Int64), typeof(SByte),
            typeof(Single), typeof(UInt16), typeof(UInt32), typeof(UInt64)};
            return numericTypes.Contains(col.DataType);
        }
        public string[] setQueryParameters(string sParameters)
        {
            return sParameters.Split(';');
        }

        public string DecodeUrlString(string url)
        {
            string newUrl;
            while ((newUrl = Uri.UnescapeDataString(url)) != url)
            {
                url = newUrl;
            }
            return newUrl;
        }

        public string setQueryParameters(string sSqlQueryBase, string sParameters)
        {
            if (!string.IsNullOrEmpty(sParameters))
            {
                List<KeyValue> oLKeyValues = new List<KeyValue>();
                string sLocalParameterValue;
                string[] arrParameters = sParameters.Split(';');
                int nParameterIndex = 1;

                foreach (string sParameterValue in arrParameters)
                {
                    sLocalParameterValue = Encoding.UTF8.GetString(Convert.FromBase64String(sParameterValue));
                    sLocalParameterValue = sLocalParameterValue.Replace(",", @"','");
                    sLocalParameterValue = @"'" + sLocalParameterValue + @"'";

                    oLKeyValues.Add(new KeyValue { sKey = ":" + Convert.ToString(nParameterIndex), sValue = sLocalParameterValue });

                    nParameterIndex += 1;
                    sLocalParameterValue = "";
                }

                foreach (KeyValue val in oLKeyValues)
                {
                    sSqlQueryBase = System.Text.RegularExpressions.Regex.Replace(sSqlQueryBase, val.sKey, val.sValue);
                }
            }
            return sSqlQueryBase;
        }
      
    }
}