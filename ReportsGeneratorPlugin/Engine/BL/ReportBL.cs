using Engine.BO;
using Engine.DAL;

namespace Engine.BL
{
    public class ReportBL
    {
        public Report getReportConfiguration(int nReportID)
        {
            using (ReportDAL dal = ReportDAL.Instance)
            {
                return dal.getReportConfiguration(nReportID);
            }
        }
        public Report getReportConfiguration(int nReportID, string sReportUUID)
        {
            using (ReportDAL dal = ReportDAL.Instance)
            {
                return dal.getReportConfiguration(nReportID, sReportUUID);
            }
        }
    }
}
