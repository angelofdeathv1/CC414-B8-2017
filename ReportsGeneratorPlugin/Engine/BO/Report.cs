using System;

namespace Engine.BO
{
    [Serializable]
    public class Report
    {
        public int nConnectionID { get; set; }
        public int nReportID { get; set; }
        public string sReportUUID { get; set; }
        public string sFormat { get; set; }
        public string sConnectionName { get; set; }
        public string sConnectionString { get; set; }
        public string sQuery { get; set; }
        public string sQueryColumns { get; set; }
    }
}
