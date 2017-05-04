using Engine.BL;
using Engine.BO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;

namespace ReportsGeneratorPlugin.PL
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]

    public class Controller_Ext1 : WebService
    {
        private ReporterUtil oUtil = new ReporterUtil();

        [WebMethod]
        public DataSet getRawData(int nReportID, string sParameters)
        {
            CommonBL oCommonBL = new CommonBL();
            ReportBL oReportBL = new ReportBL();
            Report oReport;
            DataTable oDataTable = null;

            string sOutResponse = string.Empty;

            oReport = oReportBL.getReportConfiguration(nReportID);

            if (oReport == null)
            {
                throw new Exception("Report ID: " + nReportID + " does not exist.");
            }

            if (!string.IsNullOrEmpty(oReport.sConnectionString) && !string.IsNullOrEmpty(oReport.sQuery))
            {
                try
                {
                    oDataTable = new DataTable();
                    string[] arrParameters = null;
                    if (!string.IsNullOrEmpty(sParameters))
                    {
                        arrParameters = setQueryParameters(sParameters);
                    }
                    oCommonBL.executeStoredProcedure(oReport.sQuery, arrParameters, oReport.sConnectionString, oDataTable);
                }
                catch (Exception e)
                {
                    throw new DataServiceException(e.Message) { ref1 = oReport.sQuery };
                }
            }

            DataSet ds = new DataSet();
            ds.Tables.Add(oDataTable);

            return ds;
        }

        [WebMethod]
        public ResultXML getRawDataExt(int nReportID, string sParameters)
        {
            CommonBL oCommonBL = new CommonBL();
            ReportBL oReportBL = new ReportBL();
            Report oReport;
            DataTable oDataTable = null;
            string sOutResponse = string.Empty;

            try
            {
                oReport = oReportBL.getReportConfiguration(nReportID);

                if (oReport == null)
                {
                    throw new Exception("Report ID: " + nReportID + " does not exist.");
                }
                if (!string.IsNullOrEmpty(oReport.sConnectionString) && !string.IsNullOrEmpty(oReport.sQuery))
                {
                    try
                    {
                        oDataTable = new DataTable();
                        string[] arrParameters = null;
                        if (!string.IsNullOrEmpty(sParameters))
                        {
                            arrParameters = setQueryParameters(sParameters);
                        }
                        oCommonBL.executeStoredProcedure(oReport.sQuery, arrParameters, oReport.sConnectionString, oDataTable);
                    }
                    catch (Exception e)
                    {
                        throw new DataServiceException(e.Message) { ref1 = oReport.sQuery };
                    }

                }
                DataSet ds = new DataSet();
                ds.Tables.Add(oDataTable);

                ResultXML oResult = new ResultXML { result = "OK", error = "", data = ds };
                return oResult;
            }
            catch (DataServiceException ee)
            {
                ResultXML oResult = new ResultXML { result = "FAIL", error = "Source - " + ee.ref1 + "; Message - " + ee.Message };
                return oResult;
            }
            catch (Exception ee)
            {
                ResultXML oResult = new ResultXML { result = "FAIL", error = "Source - ReporterGeneratorPlugin; Message - " + ee.Message };
                return oResult;
            }
        }
        public string[] setQueryParameters(string sParameters)
        {
            List<string> oLParameters = new List<string>();
            string[] arrTemp = sParameters.Split(';');
            foreach (string sParameterValue in arrTemp)
            {
                oLParameters.Add(HttpUtility.UrlDecode(sParameterValue));
            }
            return oLParameters.ToArray();
        }
    }
}