using System;
using System.Collections.Generic;
using Engine.BO;
using Engine.UTIL;
using DataService.Oracle;
using System.Data;

namespace Engine.DAL
{
    internal class CommonDAL : OracleDatabase
    {
        #region common
        private Validate validate = null;

        public CommonDAL(string connStringName)
            : base(connStringName)
        {
            validate = Validate.Instance;
        }

        public CommonDAL(string connStringValue, bool isConnString)
            : base(connStringValue, isConnString)
        {
            validate = Validate.Instance;
        }

        public static CommonDAL Instance
        {
            get
            {
                return new CommonDAL(Engine.BO.C.CONNSTR_ILAS);
            }
        }
        #endregion

        #region stringSqlQuery
        internal void executeQueryString(string sSql, List<FieldProp> oLFields, List<List<string>> oLData)
        {
            using (var cmd = CreateCommand(sSql, this.conn, this.txn))
            {
                using (IDataReader reader = cmd.ExecuteReader())
                {
                    int i = 0;
                    while (reader.Read())
                    {
                        if (i == 0)
                        {
                            for (int j = 0; j < reader.FieldCount; j++)
                            {
                                FieldProp oFieldProp = new FieldProp();
                                oFieldProp.fieldname = reader.GetName(j);
                                oFieldProp.datatype = reader.GetFieldType(j).Name;
                                oLFields.Add(oFieldProp);
                            }
                        }
                        List<string> oLRows = new List<string>();
                        for (int j = 0; j < reader.FieldCount; j++)
                        {
                            oLRows.Add(reader[j].ToString());
                        }
                        oLData.Add(oLRows);
                        i++;
                    }
                }
            }
        }

        internal void executeQueryString(string sSql, List<List<string>> oLData)
        {
            using (var cmd = CreateCommand(sSql, this.conn, this.txn))
            {
                using (IDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        List<string> oLRows = new List<string>();
                        for (int j = 0; j < reader.FieldCount; j++)
                        {
                            oLRows.Add(reader[j].ToString());
                        }
                        oLData.Add(oLRows);
                    }
                }
            }
        }

        internal void executeQueryString(string sSql, List<FieldProp> oLFields)
        {
            using (var cmd = CreateCommand(sSql, this.conn, this.txn))
            {
                using (IDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        for (int j = 0; j < reader.FieldCount; j++)
                        {
                            FieldProp oFieldProp = new FieldProp();
                            oFieldProp.fieldname = reader.GetName(j);
                            oFieldProp.datatype = reader.GetFieldType(j).Name;
                            oLFields.Add(oFieldProp);
                        }
                        break;
                    }
                }
            }
        }
        #endregion

        #region stringStoredProcedure
        internal void executeStoredProcedure(string sStoredProcedure, string[] arrParameters, List<FieldProp> oLFields, string sOutResponse)
        {
            using (var cmd = CreateStoredProcCommand(sStoredProcedure, this.conn, this.txn))
            {
                IDataParameter pCRptData = CreateParameterOutCursor("out_c_rpt_data");
                IDataParameter pSResult = CreateParameterOut("out_s_result", DbType.String, 2000);

                if (arrParameters != null)
                {
                    int nIndex = 0;
                    foreach (string sParameterValue in arrParameters)
                    {
                        cmd.Parameters.Add(CreateParameter("in_param_" + nIndex, sParameterValue));
                        nIndex += 1;
                    }
                }

                cmd.Parameters.Add(pCRptData);
                cmd.Parameters.Add(pSResult);
                try
                {
                    using (IDataReader reader = cmd.ExecuteReader())
                    {
                        sOutResponse = validate.getDefaultIfDBNull(pSResult.Value, TypeCode.String).ToString();
                        while (reader.Read())
                        {
                            for (int j = 0; j < reader.FieldCount; j++)
                            {
                                FieldProp fp = new FieldProp();
                                fp.fieldname = reader.GetName(j);
                                fp.datatype = reader.GetFieldType(j).Name;
                                oLFields.Add(fp);
                            }
                            break;
                        }
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
            }
        }

        internal void executeStoredProcedure(string sStoredProcedure, string[] arrParameters, List<List<string>> oLData, string sOutResponse)
        {
            using (var cmd = CreateStoredProcCommand(sStoredProcedure, this.conn, this.txn))
            {
                IDataParameter pCRptData = CreateParameterOutCursor("out_c_rpt_data");
                IDataParameter pSResult = CreateParameterOut("out_s_result", DbType.String, 2000);

                if (arrParameters != null)
                {
                    int nIndex = 0;
                    foreach (string sParameterValue in arrParameters)
                    {
                        cmd.Parameters.Add(CreateParameter("in_param_" + nIndex, sParameterValue));
                        nIndex += 1;
                    }
                }

                cmd.Parameters.Add(pCRptData);
                cmd.Parameters.Add(pSResult);

                using (IDataReader reader = cmd.ExecuteReader())
                {
                    sOutResponse = validate.getDefaultIfDBNull(pSResult.Value, TypeCode.String).ToString();
                    while (reader.Read())
                    {
                        List<string> aRow = new List<string>();
                        for (int j = 0; j < reader.FieldCount; j++)
                        {
                            aRow.Add(reader[j].ToString());
                        }
                        oLData.Add(aRow);
                    }
                }
            }
        }

        internal void executeStoredProcedure(string sStoredProcedure, string[] arrParameters, List<FieldProp> oLFields, List<List<string>> oLData, string sOutResponse)
        {
            using (var cmd = CreateStoredProcCommand(sStoredProcedure, this.conn, this.txn))
            {
                IDataParameter pCRptData = CreateParameterOutCursor("out_c_rpt_data");
                IDataParameter pSResult = CreateParameterOut("out_s_result", DbType.String, 2000);

                if (arrParameters != null)
                {
                    int nIndex = 0;
                    foreach (string sParameterValue in arrParameters)
                    {
                        cmd.Parameters.Add(CreateParameter("in_param_" + nIndex, sParameterValue));
                        nIndex += 1;
                    }
                }

                cmd.Parameters.Add(pCRptData);
                cmd.Parameters.Add(pSResult);

                using (IDataReader reader = cmd.ExecuteReader())
                {
                    int i = 0;
                    sOutResponse = validate.getDefaultIfDBNull(pSResult.Value, TypeCode.String).ToString();
                    while (reader.Read())
                    {
                        if (i == 0)
                        {
                            for (int j = 0; j < reader.FieldCount; j++)
                            {
                                FieldProp fp = new FieldProp();
                                fp.fieldname = reader.GetName(j);
                                fp.datatype = reader.GetFieldType(j).Name;
                                oLFields.Add(fp);
                            }
                        }
                        List<string> aRow = new List<string>();
                        for (int j = 0; j < reader.FieldCount; j++)
                        {
                            aRow.Add(reader[j].ToString());
                        }
                        oLData.Add(aRow);
                        i++;
                    }
                }
            }
        }

        internal void executeStoredProcedure(string sStoredProcedure, string[] arrParameters, DataTable oDataTable, string sOutResponse)
        {
            using (var cmd = CreateStoredProcCommand(sStoredProcedure, this.conn, this.txn))
            {
                IDataParameter pCRptData = CreateParameterOutCursor("out_c_rpt_data");
                IDataParameter pSResult = CreateParameterOut("out_s_result", DbType.String, 2000);

                if (arrParameters != null)
                {
                    int nIndex = 0;
                    foreach (string sParameterValue in arrParameters)
                    {
                        cmd.Parameters.Add(CreateParameter("in_param_" + nIndex, sParameterValue));
                        nIndex += 1;
                    }
                }

                cmd.Parameters.Add(pCRptData);
                cmd.Parameters.Add(pSResult);

                using (IDataReader reader = cmd.ExecuteReader())
                {
                    List<FieldProp> oLFields = new List<FieldProp>();
                    List<List<string>> oLData = new List<List<string>>();
                    DataRow oDataRow = null;
                    int i = 0;
                    string columnName = string.Empty;
                    sOutResponse = validate.getDefaultIfDBNull(pSResult.Value, TypeCode.String).ToString();

                    while (reader.Read())
                    {
                        oDataRow = oDataTable.NewRow();
                        if (i == 0)
                        {
                            for (int j = 0; j < reader.FieldCount; j++)
                            {
                                columnName = reader.GetName(j);
                                columnName = columnName.Replace(' ', '_');
                                oDataTable.Columns.Add(columnName, reader.GetFieldType(j));
                                columnName = string.Empty;
                            }
                        }

                        for (int j = 0; j < reader.FieldCount; j++)
                        {
                            oDataRow[j] = validate.getDefaultIfDBNull(reader[j], Type.GetTypeCode(reader.GetFieldType(j)));
                        }

                        oDataTable.Rows.Add(oDataRow);

                        i++;
                    }
                }
            }
        }
        #endregion
    }
}