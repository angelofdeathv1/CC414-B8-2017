using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace DataService.Interfaces
{
    // =====================================================================================================
    // Abstract Class definition.. hold all the methods
    // =====================================================================================================
    public abstract class Database
    {
        public string connectionString;
        public abstract IDbConnection CreateConnection();
        public abstract IDbCommand CreateCommand();
        public abstract IDbConnection CreateOpenConnection();
        public abstract IDbCommand CreateCommand(string commandText, IDbConnection connection);
        public abstract IDbCommand CreateCommand(string commandText, IDbConnection connection, IDbTransaction transaction);
        public abstract IDbCommand CreateStoredProcCommand(string procName, IDbConnection connection, IDbTransaction transaction);
        public abstract IDataParameter CreateParameter(string parameterName, object parameterValue);
        public abstract void SetConnectionString(string connStringName);
        public abstract void SetConnectionStringValue(string connStringValue);
        public abstract IDataParameter CreateParameterOut(string parameterName);
        public abstract IDataParameter CreateParameterOut(string parameterName, DbType dbType, int iSize);
        public abstract IDataParameter CreateParameterInOut(string parameterName, object parameterValue, DbType dbType, int iSize);
        public abstract DataTable GetDataTable(IDbCommand cmd);

        protected IDbConnection conn = null;
        protected IDbTransaction txn = null;
        public Database SetConnection(IDbConnection prmConn, IDbTransaction prmTxn)
        {
            if (!conn.Equals(prmConn))
            {
                conn.Close();
                conn.Dispose();
                conn = prmConn;
                txn = prmTxn;
            }
            return this;
        }
        public IDbConnection getConnection()
        {
            return conn;
        }
        public IDbTransaction getTransaction()
        {
            return txn;
        }
        public void BeginTransaction()
        {
            txn = conn.BeginTransaction();
        }
        public void CommitTransaction()
        {
            txn.Commit();
        }
        public void RollBackTransaction()
        {
            txn.Rollback();
        }

    }


}
