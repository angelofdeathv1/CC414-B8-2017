using System;
using System.Data;
using System.Configuration;
using System.Reflection;
using Oracle.DataAccess.Client;
using DataService.Interfaces;

namespace DataService.Oracle
{

    // =====================================================================================================
    // Oracle Implementation
    // Apr-2013, Ing Felipe Cruz
    // =====================================================================================================

    public class OracleDatabase : Database, IDisposable
    {
        public OracleDatabase(string connStringName)
        {
            this.SetConnectionString(connStringName);
            this.CreateOpenConnection();
        }

        public OracleDatabase(string connStringValue, bool isConnStrVal)
        {
            this.SetConnectionStringValue(connStringValue);
            this.CreateOpenConnection();
        }

        public override IDbConnection CreateConnection()
        {
            return new OracleConnection(base.connectionString);
        }

        public override IDbCommand CreateCommand()
        {
            return new OracleCommand();
        }

        public override IDbConnection CreateOpenConnection()
        {
            base.conn = (OracleConnection)CreateConnection();
            base.conn.Open();

            return base.conn;
        }

        public override IDbCommand CreateCommand(string commandText, IDbConnection connection)
        {
            OracleCommand command = (OracleCommand)CreateCommand();

            command.CommandText = commandText;
            command.Connection = (OracleConnection)connection;
            command.CommandType = CommandType.Text;

            return command;
        }

        public override IDataParameter CreateParameter(string parameterName, object parameterValue)
        {
            return new OracleParameter(parameterName, parameterValue);
        }

        public IDataParameter CreateParameterXML(string parameterName, object parameterValue)
        {
            OracleParameter p = new OracleParameter();
            p.OracleDbType = OracleDbType.XmlType;
            p.ParameterName = parameterName;
            p.Value = parameterValue;
            return p;
        }

        public override IDbCommand CreateStoredProcCommand(string procName, IDbConnection connection, IDbTransaction transaction)
        {
            OracleCommand command = (OracleCommand)CreateCommand();

            command.CommandText = procName;
            command.Connection = (OracleConnection)connection;
            command.CommandType = CommandType.StoredProcedure;
            if (transaction != null)
            {
                //   command.Transaction = (OracleTransaction)transaction;
            }
            return command;
        }

        public override IDbCommand CreateCommand(string commandText, IDbConnection connection, IDbTransaction transaction)
        {
            OracleCommand command = (OracleCommand)CreateCommand();

            command.CommandText = commandText;
            command.Connection = (OracleConnection)connection;
            command.CommandType = CommandType.Text;
            //command.Transaction = (OracleTransaction)transaction;

            return command;
        }

        public override void SetConnectionString(string connStringName)
        {
            var ostr = ConfigurationManager.ConnectionStrings[connStringName];
            if (ostr == null) throw new Exception("Connection string " + connStringName + " not found");
            try
            {
                base.connectionString = ostr.ConnectionString;
            }
            catch (Exception exe)
            {
                throw new Exception("Error al leer el ConnectionString [" + connStringName + "], contacte al administrador del sistema. Detalles:" + exe.Message);
            }
        }

        void IDisposable.Dispose()
        {
            if (conn != null) { conn.Close(); conn.Dispose(); }

            if (txn != null) { txn.Dispose(); }
        }

        public override IDataParameter CreateParameterOut(string parameterName)
        {
            OracleParameter p = new OracleParameter(parameterName, string.Empty);
            p.Direction = ParameterDirection.Output;
            return p;
        }

        public override IDataParameter CreateParameterOut(string parameterName, DbType dbType, int iSize)
        {
            OracleParameter p = new OracleParameter(parameterName, string.Empty);
            p.Direction = ParameterDirection.Output;
            p.DbType = dbType;
            p.Size = iSize;
            return p;
        }

        public override IDataParameter CreateParameterInOut(string parameterName, object parameterValue, DbType dbType, int iSize)
        {
            OracleParameter p = new OracleParameter(parameterName, parameterValue);
            p.Direction = ParameterDirection.InputOutput;
            p.DbType = dbType;
            p.Size = iSize;
            return p;
        }

        public IDataParameter CreateParameterOutCursor(string parameterName)
        {
            OracleParameter p = new OracleParameter(parameterName, string.Empty);
            p.Direction = ParameterDirection.Output;
            p.OracleDbType = OracleDbType.RefCursor;
            return p;
        }


        public override DataTable GetDataTable(IDbCommand cmd)
        {
            OracleDataAdapter adapter = new OracleDataAdapter((OracleCommand)cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);
            return dt;
        }

        public override void SetConnectionStringValue(string connStringValue)
        {
            base.connectionString = connStringValue;
        }
    }


}