using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Data;
using System.Drawing;
using System.IO;

namespace Engine.UTIL
{
    public class ExcelEPP
    {
        public byte[] GenerateExcel2007(DataTable oDataTable)
        {
            using (ExcelPackage objExcelPackage = new ExcelPackage())
            {
                oDataTable.TableName = "Data";
                ExcelWorksheet objWorksheet = objExcelPackage.Workbook.Worksheets.Add(oDataTable.TableName);

                objWorksheet.Cells["A1"].LoadFromDataTable(oDataTable, true, OfficeOpenXml.Table.TableStyles.Light16);
                objWorksheet.Cells.AutoFitColumns();

                using (ExcelRange objRange = objWorksheet.Cells["A1:XFD1"])
                {
                    objRange.Style.Font.Bold = true;
                    objRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    objRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    objRange.Style.Fill.PatternType = ExcelFillStyle.Solid;
                    objRange.Style.Fill.BackgroundColor.SetColor(Color.LightGray);
                }

                return objExcelPackage.GetAsByteArray();
               
            }
        }

        public void GenerateExcel2007(string sPath, DataTable oDataTable)
        {
            using (ExcelPackage objExcelPackage = new ExcelPackage())
            {
                oDataTable.TableName = "Data";
                ExcelWorksheet objWorksheet = objExcelPackage.Workbook.Worksheets.Add(oDataTable.TableName);

                objWorksheet.Cells["A1"].LoadFromDataTable(oDataTable, true, OfficeOpenXml.Table.TableStyles.Light16);
                objWorksheet.Cells.AutoFitColumns();

                using (ExcelRange objRange = objWorksheet.Cells["A1:XFD1"])
                {
                    objRange.Style.Font.Bold = true;
                    objRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    objRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    objRange.Style.Fill.PatternType = ExcelFillStyle.Solid;
                    objRange.Style.Fill.BackgroundColor.SetColor(Color.LightGray);
                }

                if (File.Exists(sPath))
                {
                    File.Delete(sPath);
                }

                FileStream objFileStrm = File.Create(sPath);
                objFileStrm.Close();

                File.WriteAllBytes(sPath, objExcelPackage.GetAsByteArray());
            }
        }

        public void GenerateExcel2007(string sPath, DataSet oDataSet, bool bIsDataSet = true)
        {
            using (ExcelPackage objExcelPackage = new ExcelPackage())
            {
                foreach (DataTable dtSrc in oDataSet.Tables)
                {
                    ExcelWorksheet objWorksheet = objExcelPackage.Workbook.Worksheets.Add(dtSrc.TableName);

                    objWorksheet.Cells["A1"].LoadFromDataTable(dtSrc, true, OfficeOpenXml.Table.TableStyles.Light16);
                    objWorksheet.Cells.AutoFitColumns();

                    using (ExcelRange objRange = objWorksheet.Cells["A1:XFD1"])
                    {
                        objRange.Style.Font.Bold = true;
                        objRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        objRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        objRange.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        objRange.Style.Fill.BackgroundColor.SetColor(Color.LightGray);
                    }
                }

                if (File.Exists(sPath))
                {
                    File.Delete(sPath);
                }

                FileStream objFileStrm = File.Create(sPath);
                objFileStrm.Close();

                File.WriteAllBytes(sPath, objExcelPackage.GetAsByteArray());
            }
        }
    }
}
