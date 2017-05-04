using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportsGeneratorPlugin.masterpages.main
{
    public partial class main : System.Web.UI.MasterPage
    {
        protected string JSON_RAW_URI { get; set; }
        protected string JSON_JQGRID_URI { get; set; }
        protected string JSON_JQDATA_URI { get; set; }
        protected string JSON_EXPORT_URI { get; set; }
        protected string JSON_JQDATAGRID_URI { get; set; }
        protected string JSON_JQGRID_STRUCT_URI { get; set; }
        protected string JSON_JQGRID_STRUCT_JSONP_URI { get; set; }
        protected string AJAX_CONTROLLER { get; set; }
        protected string AJAX_GRID { get; set; }
        /*protected string AJAX_PARAMETER_EXPORT { get; set; }
        protected string AJAX_PARAMETER_JQDATA { get; set; }
        protected string AJAX_PARAMETER_JQDATA_GRID { get; set; }
        protected string AJAX_PARAMETER_JQGRID { get; set; }
        protected string AJAX_PARAMETER_JQGRID_STRUCT_JSON { get; set; }
        protected string AJAX_PARAMETER_JQGRID_STRUCT_JSONP { get; set; }
        protected string AJAX_PARAMETER_RAW { get; set; }*/

        protected void Page_Load(object sender, EventArgs e)
        {
            string sReporterURL= "..";

            JSON_EXPORT_URI = "sAction=getRawDataExport&sReportUUID={ID}&sParameters={PARAMS}";
            JSON_RAW_URI = "sAction=getRawData&sReportUUID={ID}&sParameters={PARAMS}";
            JSON_JQGRID_STRUCT_URI = "sAction=getJQGridStructure&sReportUUID={ID}&sParameters={PARAMS}&nHeight={H}";
            JSON_JQDATAGRID_URI = "sAction=getDataGrid&sReportUUID={ID}&bUserData={UD}&sParameters={PARAMS}";
            JSON_JQGRID_STRUCT_JSONP_URI = "sAction=getJQGridStructureJSONP&sReportUUID={ID}&sParameters={PARAMS}&nHeight={H}";
            JSON_JQDATA_URI = "sReportUUID={ID}&sParameters={PARAMS}";
            JSON_JQGRID_URI = "sReportUUID={ID}&sParameters={PARAMS}&sNewSearch=true&nHeight={H}";
            
            AJAX_CONTROLLER = sReporterURL + "/Controller.aspx";
            AJAX_GRID = sReporterURL + "/GridPage.aspx";
        }
    }
}