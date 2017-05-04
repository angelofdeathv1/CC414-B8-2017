using System;

namespace ReportsGeneratorPlugin.PL
{
    public partial class GridPage : System.Web.UI.Page
    {
        protected string hfReportID;
        protected string hfReportUUID;
        protected string hfParameters;
        protected string hfNewSearch;
        protected string hfHeight;
        protected string hfRows;
        protected void Page_Load(object sender, EventArgs e)
        {
            hfReportID = Request["nReportID"];
            hfReportUUID = Request["sReportUUID"];
            hfParameters = Request["sParameters"];
            hfNewSearch = Request["sNewSearch"];
            hfHeight = Request["nHeight"];
            hfRows = Request["rows"];
        }
    }
}