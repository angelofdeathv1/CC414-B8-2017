using System;
using DataService.Oracle;
using Engine.UTIL;
using Engine.BO;
using System.Data;
using Engine.BL;

namespace Engine.DAL
{
    internal class ReportDAL : OracleDatabase
    {
        private Validate validate = null;

        private ReportDAL(string connStringName)
            : base(connStringName)
        {
            validate = Validate.Instance;
        }

        public ReportDAL(string connStringValue, bool isConnValue)
            : base(connStringValue, isConnValue)
        {
            validate = Validate.Instance;
        }

        public static ReportDAL Instance
        {
            get
            {
                return new ReportDAL(C.CONNSTR_ILAS);
            }
        }

        internal Report getReportConfiguration(int nReportID)
        {
            string sResult = string.Empty;
            string sStoredProcedure = DatabaseConstant.GET_REPORT_CONFIGURATION;
            Report oReport = null;

            using (var cmd = CreateStoredProcCommand(sStoredProcedure, this.conn, this.txn))
            {
                IDataParameter pSResult = CreateParameterOut("out_s_result", DbType.String, 2000);
                IDataParameter pCRptData = CreateParameterOutCursor("out_c_rpt_data");

                cmd.Parameters.Add(CreateParameter("in_n_rpt_id", nReportID));
                cmd.Parameters.Add(pSResult);
                cmd.Parameters.Add(pCRptData);
                try
                {
                    using (IDataReader reader = cmd.ExecuteReader())
                    {

                        sResult = validate.getDefaultIfDBNull(pSResult.Value, TypeCode.String).ToString();

                        if (string.IsNullOrEmpty(sResult))
                        {
                            throw new DataServiceException("No result returned.") { ref1 = sStoredProcedure };
                        }

                        if (sResult != "OK")
                        {
                            throw new DataServiceException(sResult) { ref1 = sStoredProcedure };
                        }

                        if (reader.Read())
                        {
                            oReport = new Report();
                            oReport.nConnectionID = Convert.ToInt32(validate.getDefaultIfDBNull(reader["ID_CONNECTION"], TypeCode.Int32));
                            oReport.nReportID = Convert.ToInt32(validate.getDefaultIfDBNull(reader["ID_RPT"], TypeCode.Int32));
                            oReport.sConnectionName = Convert.ToString(validate.getDefaultIfDBNull(reader["NAME"], TypeCode.String));
                            oReport.sConnectionString = Convert.ToString(validate.getDefaultIfDBNull(reader["CONNECTION_STRING"], TypeCode.String));
                            oReport.sFormat = Convert.ToString(validate.getDefaultIfDBNull(reader["RPT_DATASOURCE_FORMAT"], TypeCode.String));
                            oReport.sQuery = Convert.ToString(validate.getDefaultIfDBNull(reader["RPT_DATASOURCE_QRY"], TypeCode.String));
                        }
                    }
                    return oReport;
                }
                catch (Exception ee)
                {
                    throw new DataServiceException(ee.Message) { ref1 = sStoredProcedure };
                }
            }
        }

        internal Report getReportConfiguration(int nReportID,string sReportUUID)
        {
            string sResult = string.Empty;
            string sStoredProcedure = DatabaseConstant.GET_REPORT_CONFIGURATION;
            Report oReport = null;

            using (var cmd = CreateStoredProcCommand(sStoredProcedure, conn, txn))
            {
                IDataParameter pSResult = CreateParameterOut("out_s_result", DbType.String, 2000);
                IDataParameter pCRptData = CreateParameterOutCursor("out_c_rpt_data");

                cmd.Parameters.Add(CreateParameter("in_n_rpt_id", nReportID));
                cmd.Parameters.Add(CreateParameter("in_s_rpt_uuid", sReportUUID));
                cmd.Parameters.Add(pSResult);
                cmd.Parameters.Add(pCRptData);
                try
                {
                    using (IDataReader reader = cmd.ExecuteReader())
                    {
                        sResult = validate.getDefaultIfDBNull(pSResult.Value, TypeCode.String).ToString();

                        if (string.IsNullOrEmpty(sResult))
                        {
                            throw new DataServiceException("No result returned.") { ref1 = sStoredProcedure };
                        }

                        if (sResult != "OK")
                        {
                            throw new DataServiceException(sResult) { ref1 = sStoredProcedure };
                        }

                        if (reader.Read())
                        {
                            oReport = new Report();
                            oReport.nConnectionID = Convert.ToInt32(validate.getDefaultIfDBNull(reader["ID_CONNECTION"], TypeCode.Int32));
                            oReport.nReportID = Convert.ToInt32(validate.getDefaultIfDBNull(reader["ID_RPT"], TypeCode.Int32));
                            oReport.sReportUUID= Convert.ToString(validate.getDefaultIfDBNull(reader["UUID_RPT"], TypeCode.String));
                            oReport.sConnectionName = Convert.ToString(validate.getDefaultIfDBNull(reader["NAME"], TypeCode.String));
                            oReport.sConnectionString = Convert.ToString(validate.getDefaultIfDBNull(reader["CONNECTION_STRING"], TypeCode.String));
                            oReport.sFormat = Convert.ToString(validate.getDefaultIfDBNull(reader["RPT_DATASOURCE_FORMAT"], TypeCode.String));
                            oReport.sQuery = Convert.ToString(validate.getDefaultIfDBNull(reader["RPT_DATASOURCE_QRY"], TypeCode.String));
                        }
                    }
                    return oReport;
                }
                catch (Exception ee)
                {
                    throw new DataServiceException(ee.Message) { ref1 = sStoredProcedure };
                }
            }
        }
    }
}
