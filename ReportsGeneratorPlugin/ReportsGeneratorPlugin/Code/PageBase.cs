using System;
using System.Web.UI;
using Newtonsoft.Json;
using System.Data;
using Engine.UTIL;
using Engine.BO;
using System.IO;

namespace ReportsGeneratorPlugin.Code
{
    public class PageBase : Page
    {
        protected string GetJson(object oObject)
        {
            System.Web.Script.Serialization.JavaScriptSerializer ser = new System.Web.Script.Serialization.JavaScriptSerializer();
            return ser.Serialize(oObject);
        }

        protected void ResponseTextPlain(string sString)
        {
            Response.Clear();
            Response.ContentType = "text/plain";
            Response.Write(sString);
        }

        protected void ResponseJsonNewton(object oObject)
        {

            Response.BufferOutput = true;
            Response.Clear();
            Response.ContentType = "text/plain";
            Response.AppendHeader("Access-Control-Allow-Origin", "*");
            JsonSerializerSettings microsoftDateFormatSettings = new JsonSerializerSettings
            {
                DateFormatHandling = DateFormatHandling.MicrosoftDateFormat
            };

            Response.Write(JsonConvert.SerializeObject(oObject, microsoftDateFormatSettings));
        }

        protected void ResponseJsonNewton(object oObject, string sContentType = "text/plain", bool bMicrosoftDate = true)
        {
            string sResponse = "";
            Response.BufferOutput = true;
            Response.Clear();
            Response.ContentType = sContentType;
            Response.AppendHeader("Access-Control-Allow-Origin", "*");

            if (bMicrosoftDate)
            {
                JsonSerializerSettings microsoftDateFormatSettings = new JsonSerializerSettings
                {
                    DateFormatHandling = DateFormatHandling.MicrosoftDateFormat
                };
                sResponse = JsonConvert.SerializeObject(oObject, microsoftDateFormatSettings);
            }
            else
            {
                JsonSerializerSettings standardDateFormatSettings = new JsonSerializerSettings
                {
                    DateTimeZoneHandling = DateTimeZoneHandling.Local
                };
                sResponse = JsonConvert.SerializeObject(oObject, standardDateFormatSettings);
            }

            Response.Write(sResponse);
        }

        protected void ResponseJsonPNewton(string sCallback, object oObject)
        {
            Response.BufferOutput = true;
            Response.Clear();
            Response.ContentType = "text/plain";
            Response.AppendHeader("Access-Control-Allow-Origin", "*");
            JsonSerializerSettings microsoftDateFormatSettings = new JsonSerializerSettings
            {
                DateFormatHandling = DateFormatHandling.MicrosoftDateFormat
            };
            Response.Write(sCallback + "(" + JsonConvert.SerializeObject(oObject, microsoftDateFormatSettings) + ")");
        }

        protected void ResponseJsonPNewton(string sCallback, object oObject, string sContentType = "text/plain", bool bMicrosoftDate = true)
        {
            string sResponse = "";
            Response.BufferOutput = true;
            Response.Clear();
            Response.ContentType = sContentType;
            Response.AppendHeader("Access-Control-Allow-Origin", "*");

            if (bMicrosoftDate)
            {
                JsonSerializerSettings microsoftDateFormatSettings = new JsonSerializerSettings
                {
                    DateFormatHandling = DateFormatHandling.MicrosoftDateFormat
                };
                sResponse = JsonConvert.SerializeObject(oObject, microsoftDateFormatSettings);
            }
            else
            {
                JsonSerializerSettings standardDateFormatSettings = new JsonSerializerSettings
                {
                    DateTimeZoneHandling = DateTimeZoneHandling.Local
                };
                sResponse = JsonConvert.SerializeObject(oObject, standardDateFormatSettings);
            }

            Response.Write(sCallback + "(" + sResponse + ")");
        }

        protected void ResponseJson(object oObject)
        {
            ResponseTextPlain(GetJson(oObject));
        }

        protected void ExportToExcel(object oDataTable)
        {
            DataTable oData = (DataTable)oDataTable;
            ExcelEPP oEP = new ExcelEPP();

            string sFileName = "Export_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xlsx";
            //string sRelativePath="";
            //string sFilePath = Path.Combine(getFilePathTemporal(out sRelativePath), sFileName);
            byte[] oFile = oEP.GenerateExcel2007(oData);

            Response.Clear();
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;  filename=" + sFileName);
            Response.BinaryWrite(oFile);

        }

        public string getFilePathTemporal(out string relativepath)
        {
            relativepath = C.FILES_RELATIVE_PATH + DateTime.Now.ToString("yyyy") + "/Temp";
            string path = Server.MapPath(relativepath);
            if (!Directory.Exists(path)) Directory.CreateDirectory(path);
            return path;
        }

    }
}