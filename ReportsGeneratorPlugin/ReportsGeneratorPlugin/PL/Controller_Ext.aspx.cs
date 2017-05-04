using Engine.BL;
using Engine.BO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace ReportsGeneratorPlugin.PL
{
    public partial class Controller_Ext : Code.PageBase
    {
        ReporterUtil oUtil = new ReporterUtil();
        protected void Page_Load(object sender, EventArgs e)
        {
            string sAction = Request["sAction"];
            try
            {
                if (string.IsNullOrEmpty(sAction))
                {
                    throw new InvalidParameter("sAction is required.");
                }

                switch (sAction)
                {
                    case "getDataGrid":
                        getJQGridData();
                        break;
                    case "getJQGridStructure":
                        getJQGridStructure();
                        break;
                    case "getJQGridStructureJSONP":
                        getJQGridStructure(true);
                        break;
                    case "getRawData":
                        getRawData();
                        break;
                    case "getRawDataExport":
                        getRawDataExport();
                        break;
                    default:
                        throw new NotImplementedException(string.Format("Action {0} not implemented", sAction));
                }
            }
            catch (DataServiceException ee)
            {
                Result ores = new Result { result = "FAIL", error = "Source - " + ee.ref1 + "; Message - " + ee.Message };
                ResponseJsonNewton(ores);
            }
            catch (Exception ee)
            {
                Result ores = new Result { result = "FAIL", error = "Source - ReporterGeneratorPlugin; Message - " + ee.Message };
                ResponseJsonNewton(ores);
            }
        }

        private void getJQGridData()
        {
            CommonBL oCommonBL = new CommonBL();
            Report oReport = null;
            ReportBL oReportBL = new ReportBL();

            List<FieldProp> oLFields = new List<FieldProp>();
            DataTable oDataTable = null;

            string sNewSearch = Request["sNewSearch"] == null ? "false" : Request["sNewSearch"];
            string sPage = Request["page"] == null ? "1" : Request["page"];
            string sParameters = Request["sParameters"] == null ? string.Empty : Request["sParameters"];
            string sReportID = Request["nReportID"] == null ? string.Empty : Request["nReportID"];
            string sReportUUID = Request["sReportUUID"] == null ? string.Empty : Request["sReportUUID"];
            string sUserData = Request["bUserData"] == null ? "0" : Request["bUserData"];
            string sCallback = Request["callback"] == null ? string.Empty : Request["callback"];
            string sRows = Request["rows"] == null ? JqGridData.ROWS_PER_PAGE.ToString() : Request["rows"];
            bool bStandardDate = Request["bStdDate"] == null ? true : false;
            string sContentType = Request["sContentType"] == null ? "text/plain" : Request["sContentType"];
            string sOutResponse = string.Empty;

            int nPage = int.Parse(sPage);
            int nRows = int.Parse(sRows);

            if (sNewSearch.Equals("true"))
            {
                if (string.IsNullOrEmpty(sReportID))
                {
                    oReport = oReportBL.getReportConfiguration(0, sReportUUID);
                    sReportID = sReportUUID;
                }
                else
                {
                    oReport = oReportBL.getReportConfiguration(Convert.ToInt32(sReportID));
                }

                if (oReport == null)
                {
                    throw new Exception("Report ID: " + sReportID + " does not exist.");
                }

                if (!string.IsNullOrEmpty(oReport.sConnectionString) && !string.IsNullOrEmpty(oReport.sQuery))
                {
                    try
                    {
                        oDataTable = new DataTable();
                        string[] arrParameters = null;
                        if (!string.IsNullOrEmpty(Request["sParameters"]))
                        {
                            arrParameters = oUtil.setQueryParameters(sParameters);
                        }

                        oCommonBL.executeStoredProcedure(oReport.sQuery, arrParameters, oReport.sConnectionString, oDataTable);
                    }
                    catch (Exception e)
                    {
                        throw new DataServiceException(e.Message) { ref1 = oReport.sQuery };
                    }
                }

                Session["ReportGenerator_" + sReportID] = oDataTable;
            }
            else
            {
                if (string.IsNullOrEmpty(sReportID))
                {
                    sReportID = sReportUUID;
                }
                oDataTable = (DataTable)Session["ReportGenerator_" + sReportID];
            }

            string sSortIndex = Request["sidx"];
            string sSortOrder = Request["sord"];

            if (!string.IsNullOrEmpty(sSortIndex) && !string.IsNullOrEmpty(sSortOrder) && oDataTable != null && oDataTable.Rows.Count > 0)
            {
                oDataTable = getSortedDataTable(oDataTable, sSortIndex, sSortOrder);
            }

            bool bUserData = false;
            if (sUserData.Equals("1"))
            {
                bUserData = true;
            }

            object oJQGridData = oUtil.getJQGridData(oDataTable, nPage, bUserData, nRows);
            if (string.IsNullOrEmpty(sCallback))
            {
                ResponseJsonNewton(oJQGridData, sContentType, bStandardDate);
            }
            else
            {
                ResponseJsonPNewton(sCallback, oJQGridData, sContentType, bStandardDate);
            }
        }

        private DataTable getSortedDataTable(DataTable oDataTable, string sSortIndex, string sSortOrder)
        {
            int nSortIndex;
            string sSortColumn;
            string[] arrSortColumns = sSortIndex.Split(',');
            DataView oDataView = new DataView(oDataTable);

            if (arrSortColumns.Count() == 1)
            {
                nSortIndex = int.Parse(sSortIndex);
                sSortColumn = oDataTable.Columns[nSortIndex].ColumnName;
                oDataView.Sort = sSortColumn + " " + sSortOrder;
                oDataTable = oDataView.ToTable();
            }
            else if (arrSortColumns.Count() > 1)
            {
                string[] arrSortGroupBy = arrSortColumns[0].Split(' ');
                string sSortGroupByColumn = arrSortGroupBy[0];
                string sSortGroupByDirection = arrSortGroupBy[1];
                string sSortQuery;
                int nSortGroupByIndex = int.Parse(sSortGroupByColumn);

                sSortGroupByColumn = oDataTable.Columns[nSortGroupByIndex].ColumnName;
                sSortQuery = sSortGroupByColumn + " " + sSortGroupByDirection;
                sSortIndex = arrSortColumns[1].Trim();

                if (!string.IsNullOrEmpty(sSortIndex))
                {
                    nSortIndex = int.Parse(sSortIndex);
                    sSortColumn = oDataTable.Columns[nSortIndex].ColumnName;
                    sSortQuery += "," + sSortColumn + " " + sSortOrder;
                }
                oDataView.Sort = sSortQuery;
                oDataTable = oDataView.ToTable();
            }
            return oDataTable;
        }

        private void getJQGridStructure(bool JSONP)
        {
            CommonBL oCommonBL = new CommonBL();
            ReportBL oReportBL = new ReportBL();
            Report oReport;

            List<FieldProp> oLFields = null;

            string sHeight = Request["nHeight"];
            string sNewSearch = Request["sNewSearch"] == null ? "false" : Request["sNewSearch"];
            string sPage = Request["page"] == null ? "1" : Request["page"];
            string sParameters = Request["sParameters"];
            string sReportID = Request["nReportID"] == null ? string.Empty : Request["nReportID"];
            string sReportUUID = Request["sReportUUID"] == null ? string.Empty : Request["sReportUUID"];
            string sUserData = Request["bUserData"] == null ? "0" : Request["bUserData"];
            string sCallback = Request["callback"] == null ? string.Empty : Request["callback"];
            string sRows = Request["rows"] == null ? JqGridData.ROWS_PER_PAGE.ToString() : Request["rows"];
            string sOutResponse = string.Empty;
            string sHostURL = Request.Url.ToString();

            int nRows = int.Parse(sRows);
            if (string.IsNullOrEmpty(sReportID))
            {
                oReport = oReportBL.getReportConfiguration(0, sReportUUID);
            }
            else
            {
                oReport = oReportBL.getReportConfiguration(Convert.ToInt32(sReportID));
            }

            if (oReport == null)
            {
                throw new Exception("Report ID: " + sReportID + " does not exist.");
            }

            if (!string.IsNullOrEmpty(oReport.sConnectionString) && !string.IsNullOrEmpty(oReport.sQuery))
            {
                try
                {
                    oLFields = new List<FieldProp>();
                    string[] arrParameters = null;
                    if (!string.IsNullOrEmpty(Request["sParameters"]))
                    {
                        arrParameters = oUtil.setQueryParameters(sParameters);
                    }
                    oCommonBL.executeStoredProcedure(oReport.sQuery, arrParameters, oReport.sConnectionString, oLFields, sOutResponse);
                }
                catch (Exception e)
                {
                    throw new DataServiceException(e.Message) { ref1 = oReport.sQuery };
                }
            }

            if (string.IsNullOrEmpty(sCallback))
            {
                ResponseJsonNewton(oUtil.getJQStructure(oLFields, sReportID, sReportUUID, sParameters, sNewSearch, sHeight, sUserData, sCallback, nRows, sHostURL));
            }
            else
            {
                ResponseJsonPNewton(sCallback, oUtil.getJQStructure(oLFields, sReportID, sReportUUID, sParameters, sNewSearch, sHeight, sUserData, sCallback, nRows, sHostURL));
            }
        }

        private void getJQGridStructure()
        {
            CommonBL oCommonBL = new CommonBL();
            ReportBL oReportBL = new ReportBL();
            Report oReport;

            List<FieldProp> oLFields = null;

            string sHeight = Request["nHeight"];
            string sNewSearch = Request["sNewSearch"] == null ? "false" : Request["sNewSearch"];
            string sPage = Request["page"] == null ? "1" : Request["page"];
            string sParameters = Request["sParameters"];
            string sReportID = Request["nReportID"] == null ? string.Empty : Request["nReportID"];
            string sReportUUID = Request["sReportUUID"] == null ? string.Empty : Request["sReportUUID"];
            string sUserData = Request["bUserData"] == null ? "0" : Request["bUserData"];
            string sCallback = Request["callback"] == null ? string.Empty : Request["callback"];
            string sRows = Request["rows"] == null ? JqGridData.ROWS_PER_PAGE.ToString() : Request["rows"];
            string sOutResponse = string.Empty;
            string sHostURL = Request.Url.ToString();

            int nRows = int.Parse(sRows);

            if (string.IsNullOrEmpty(sReportID))
            {
                oReport = oReportBL.getReportConfiguration(0, sReportUUID);
            }
            else
            {
                oReport = oReportBL.getReportConfiguration(Convert.ToInt32(sReportID));
            }

            if (oReport == null)
            {
                throw new Exception("Report ID: " + sReportID + " does not exist.");
            }

            if (!string.IsNullOrEmpty(oReport.sConnectionString) && !string.IsNullOrEmpty(oReport.sQuery))
            {
                try
                {
                    oLFields = new List<FieldProp>();
                    string[] arrParameters = null;
                    if (!string.IsNullOrEmpty(Request["sParameters"]))
                    {
                        arrParameters = oUtil.setQueryParameters(sParameters);
                    }
                    oCommonBL.executeStoredProcedure(oReport.sQuery, arrParameters, oReport.sConnectionString, oLFields, sOutResponse);
                }
                catch (Exception e)
                {
                    throw new DataServiceException(e.Message) { ref1 = oReport.sQuery };
                }
            }
            else
            {
                throw new Exception("Verify report settings. ID: " + sReportID + ".");
            }

            ResponseJsonNewton(oUtil.getJQStructure(oLFields, sReportID, sReportUUID, sParameters, sNewSearch, sHeight, sUserData, sCallback, nRows, sHostURL));
        }

        public void getRawData()
        {
            CommonBL oCommonBL = new CommonBL();
            ReportBL oReportBL = new ReportBL();
            Report oReport = null;

            DataTable oDataTable = null;

            string sHeight = Request["nHeight"];
            string sNewSearch = Request["sNewSearch"] == null ? "false" : Request["sNewSearch"];
            string sPage = Request["page"] == null ? "1" : Request["page"];
            string sParameters = Request["sParameters"];
            string sReportID = Request["nReportID"] == null ? string.Empty : Request["nReportID"];
            string sReportUUID = Request["sReportUUID"] == null ? string.Empty : Request["sReportUUID"];
            string sCallback = Request["callback"] == null ? string.Empty : Request["callback"];
            bool bStandardDate = Request["bStdDate"] == null ? true : false;
            string sContentType = Request["sContentType"] == null ? "text/plain" : Request["sContentType"];
            string sOutResponse = string.Empty;

            if (string.IsNullOrEmpty(sReportID))
            {
                oReport = oReportBL.getReportConfiguration(0, sReportUUID);
                sReportID = sReportUUID;
            }
            else
            {
                oReport = oReportBL.getReportConfiguration(Convert.ToInt32(sReportID));
            }

            if (oReport == null)
            {
                throw new Exception("Report ID: " + sReportID + " does not exist.");
            }

            if (!string.IsNullOrEmpty(oReport.sConnectionString) && !string.IsNullOrEmpty(oReport.sQuery))
            {
                try
                {
                    oDataTable = new DataTable();
                    string[] arrParameters = null;
                    if (!string.IsNullOrEmpty(Request["sParameters"]))
                    {
                        arrParameters = oUtil.setQueryParameters(sParameters);
                    }
                    oCommonBL.executeStoredProcedure(oReport.sQuery, arrParameters, oReport.sConnectionString, oDataTable, sOutResponse);
                }
                catch (Exception e)
                {
                    throw new DataServiceException(e.Message) { ref1 = oReport.sQuery };
                }
            }

            string sSortIndex = Request["sidx"];
            string sSortOrder = Request["sord"];

            if (!string.IsNullOrEmpty(sSortIndex) && !string.IsNullOrEmpty(sSortOrder) && oDataTable != null && oDataTable.Rows.Count > 0)
            {
                oDataTable = getSortedDataTable(oDataTable, sSortIndex, sSortOrder);
            }

            List<Dictionary<string, object>> dictionaries = new List<Dictionary<string, object>>();
            DataTableReader reader = oDataTable.CreateDataReader();

            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    Dictionary<string, object> dictionary = Enumerable.Range(0, reader.FieldCount)
                        .ToDictionary(i => reader.GetName(i), i => reader.GetValue(i));

                    dictionaries.Add(dictionary);
                }
            }

            Result oDataResult = new Result { result = "OK", data = oDataTable };
            if (string.IsNullOrEmpty(sCallback))
            {
                ResponseJsonNewton(oDataResult, sContentType, bStandardDate);
            }
            else
            {
                ResponseJsonPNewton(sCallback, oDataResult, sContentType, bStandardDate);
            }
        }

        public void getRawDataExport()
        {
            CommonBL oCommonBL = new CommonBL();
            ReportBL oReportBL = new ReportBL();
            Report oReport;
            DataTable oDataTable = null;

            string sParameters = Request["sParameters"];
            string sReportID = Request["nReportID"] == null ? string.Empty : Request["nReportID"];
            string sReportUUID = Request["sReportUUID"] == null ? string.Empty : Request["sReportUUID"];

            if (string.IsNullOrEmpty(sReportID))
            {
                oReport = oReportBL.getReportConfiguration(0, sReportUUID);
            }
            else
            {
                oReport = oReportBL.getReportConfiguration(Convert.ToInt32(sReportID));
            }

            if (oReport == null)
            {
                throw new Exception("Report ID: " + sReportID + " does not exist.");
            }

            if (!string.IsNullOrEmpty(oReport.sConnectionString) && !string.IsNullOrEmpty(oReport.sQuery))
            {
                try
                {
                    oDataTable = new DataTable();
                    string[] arrParameters = null;
                    if (!string.IsNullOrEmpty(Request["sParameters"]))
                    {
                        arrParameters = oUtil.setQueryParameters(sParameters);
                    }
                    oCommonBL.executeStoredProcedure(oReport.sQuery, arrParameters, oReport.sConnectionString, oDataTable);
                }
                catch (Exception e)
                {
                    throw new DataServiceException(e.Message) { ref1 = oReport.sQuery };
                }
            }
            ExportToExcel(oDataTable);
        }
    }
}