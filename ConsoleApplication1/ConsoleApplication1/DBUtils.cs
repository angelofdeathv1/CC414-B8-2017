using Oracle.DataAccess.Client;
using System;
namespace ConsoleApplication1
{
    public class DBUtils
    {
        OracleConnection con;
        public void Connect()
        {
            con = new OracleConnection();
            con.ConnectionString = "User Id=examen02;Password=examen02;Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1521))(CONNECT_DATA=(SID=XE)));";
            con.Open();
            Console.WriteLine("Connected to Oracle" + con.ServerVersion);
        }

        public void Close()
        {
            con.Close();
            con.Dispose();
        }

    }
}
