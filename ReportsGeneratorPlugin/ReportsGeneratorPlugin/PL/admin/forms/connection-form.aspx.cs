using System;

namespace ReportsGeneratorPlugin.PL.admin.forms
{
    public partial class connection_form : System.Web.UI.Page
    {
        protected string JSON_RAW_URI { get; set; }
        protected string JSON_RAW_CONTROLLER { get; set; }
        protected string JSON_RAW_PARAMETERS { get; set; }
        protected string sConnectionID;
        protected void Page_Load(object sender, EventArgs e)
        {
            string sReporterURL = "../..";
            JSON_RAW_URI = sReporterURL + "/Controller.aspx?sAction=getRawData&nReportID={ID}&sParameters={PARAMS}";
            JSON_RAW_CONTROLLER = sReporterURL + "/Controller.aspx";
            JSON_RAW_PARAMETERS = "sAction=getRawData&sReportUUID={ID}&sParameters={PARAMS}";

            sConnectionID = Request["sConnectionID"];
        }
    }
}