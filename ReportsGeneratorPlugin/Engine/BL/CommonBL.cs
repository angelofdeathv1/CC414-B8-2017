using System.Collections.Generic;
using Engine.BO;
using Engine.DAL;
using System.Data;

namespace Engine.BL
{
    public class CommonBL
    {
        public void executeQueryString(string sSql, string sConnectionString, List<FieldProp> oLFields, List<List<string>> oLData)
        {
            using (CommonDAL dal = new CommonDAL(sConnectionString, true))
            {
                dal.executeQueryString(sSql, oLFields, oLData);
            }
        }
        public void executeQueryString(string sSql, string sConnectionString, List<List<string>> oLData)
        {
            using (CommonDAL dal = new CommonDAL(sConnectionString, true))
            {
                dal.executeQueryString(sSql, oLData);
            }
        }
        public void executeQueryString(string sSql, string sConnectionString, List<FieldProp> oLFields)
        {
            using (CommonDAL dal = new CommonDAL(sConnectionString, true))
            {
                dal.executeQueryString(sSql, oLFields);
            }
        }
        public void executeStoredProcedure(string sSql, string[] arrParameters, string sConnectionString, List<FieldProp> oLFields, List<List<string>> oLData, string sOutResponse)
        {
            using (CommonDAL dal = new CommonDAL(sConnectionString, true))
            {
                dal.executeStoredProcedure(sSql, arrParameters, oLFields, oLData, sOutResponse);
            }
        }
        public void executeStoredProcedure(string sSql, string[] arrParameters, string sConnectionString, List<FieldProp> oLFields, string sOutResponse)
        {
            using (CommonDAL dal = new CommonDAL(sConnectionString, true))
            {
                dal.executeStoredProcedure(sSql, arrParameters, oLFields, sOutResponse);
            }
        }
        public void executeStoredProcedure(string sSql, string[] arrParameters, string sConnectionString, List<List<string>> oLData, string sOutResponse)
        {
            using (CommonDAL dal = new CommonDAL(sConnectionString, true))
            {
                dal.executeStoredProcedure(sSql, arrParameters, oLData, sOutResponse);
            }
        }
        public void executeStoredProcedure(string sStoredProcedure, string[] arrParameters, string sConnectionString, DataTable oDataTable)
        {
            using (CommonDAL dal = new CommonDAL(sConnectionString, true))
            {
                string sOutResponse = string.Empty;
                dal.executeStoredProcedure(sStoredProcedure, arrParameters, oDataTable, sOutResponse);
            }
        }
        public void executeStoredProcedure(string sStoredProcedure, string[] arrParameters, string sConnectionString, DataTable oDataTable, string sOutResponse)
        {
            using (CommonDAL dal = new CommonDAL(sConnectionString, true))
            {
                dal.executeStoredProcedure(sStoredProcedure, arrParameters, oDataTable, sOutResponse);
            }
        }
    }
}