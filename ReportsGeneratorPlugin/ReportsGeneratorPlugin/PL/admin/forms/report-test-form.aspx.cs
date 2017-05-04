using System;

namespace ReportsGeneratorPlugin.PL.admin.forms
{
    public partial class report_test_form : System.Web.UI.Page
    {
        protected string JSON_RAW_URI { get; set; }
        protected string JSON_RAW_CONTROLLER { get; set; }
        protected string JSON_RAW_PARAMETERS { get; set; }
        protected string JSON_JQGRID_STRUCT_URI { get; set; }
        protected string JSON_JQDATAGRID_URI { get; set; }
        protected string JSON_EXPORT_URI { get; set; }
        protected string sReportUUID;
        protected string sRequestURL;
        protected void Page_Load(object sender, EventArgs e)
        {
            string sReporterURL = "../..";
            JSON_RAW_URI = sReporterURL + "/Controller.aspx?sAction=getRawData&nReportID={ID}&sParameters={PARAMS}";
            JSON_RAW_CONTROLLER = sReporterURL + "/Controller.aspx";
            JSON_RAW_PARAMETERS = "sAction=getRawData&sReportUUID={ID}&sParameters={PARAMS}";
            JSON_JQGRID_STRUCT_URI = "sAction=getJQGridStructure&sReportUUID={ID}&sParameters={PARAMS}&nHeight={H}";
            JSON_JQDATAGRID_URI = "sAction=getDataGrid&sReportUUID={ID}&bUserData={UD}&sParameters={PARAMS}";
            JSON_EXPORT_URI = "sAction=getRawDataExport&sReportUUID={ID}&sParameters={PARAMS}";
            sReportUUID = Request["sReportUUID"];
            sRequestURL = Request.Url.GetLeftPart(UriPartial.Authority);//Request.Url.ToString();
        }
    }
}