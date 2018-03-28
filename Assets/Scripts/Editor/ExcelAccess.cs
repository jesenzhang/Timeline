using UnityEngine;
using UnityEditor;
using Excel;
using System.Data;
using System.IO;
using System.Collections.Generic;
using OfficeOpenXml;

public class ExcelAccess
{
    private static Dictionary<string, DataSet> TempDataDict = new Dictionary<string, DataSet>();

    /// <summary>
    /// 读取 Excel 需要添加 Excel; System.Data;
    /// <returns></returns>
    public static DataRowCollection ReadExcel(string ExcelName,string sheet)
    {
        string filepath = FilePath(ExcelName);
        if (TempDataDict.ContainsKey(filepath))
        {
            return TempDataDict[filepath].Tables[sheet].Rows;
        }
        FileStream stream = File.Open(filepath, FileMode.Open, FileAccess.Read, FileShare.Read);
        IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
        DataSet result = excelReader.AsDataSet();
        TempDataDict.Add(filepath, result);
        stream.Dispose();
        return result.Tables[sheet].Rows;
    }

    /// <summary>
    /// 读取 Excel 需要添加 OfficeOpenXml;
    /// </summary>
     static void WriteExcel(string outputDir)
    {
        //string outputDir = EditorUtility.SaveFilePanel("Save Excel", "", "New Resource", "xlsx");
        FileInfo newFile = new FileInfo(outputDir);
        if (newFile.Exists)
        {
            newFile.Delete();  // ensures we create a new workbook
            newFile = new FileInfo(outputDir);
        }
        using (ExcelPackage package = new ExcelPackage(newFile))
        {
            // add a new worksheet to the empty workbook
            ExcelWorksheet worksheet = package.Workbook.Worksheets.Add("Sheet1");
            //Add the headers
            worksheet.Cells[1, 1].Value = "ID";
            worksheet.Cells[1, 2].Value = "Product";
            worksheet.Cells[1, 3].Value = "Quantity";
            worksheet.Cells[1, 4].Value = "Price";
            worksheet.Cells[1, 5].Value = "Value";

            //Add some items...
            worksheet.Cells["A2"].Value = 12001;
            worksheet.Cells["B2"].Value = "Nails";
            worksheet.Cells["C2"].Value = 37;
            worksheet.Cells["D2"].Value = 3.99;

            worksheet.Cells["A3"].Value = 12002;
            worksheet.Cells["B3"].Value = "Hammer";
            worksheet.Cells["C3"].Value = 5;
            worksheet.Cells["D3"].Value = 12.10;

            worksheet.Cells["A4"].Value = 12003;
            worksheet.Cells["B4"].Value = "Saw";
            worksheet.Cells["C4"].Value = 12;
            worksheet.Cells["D4"].Value = 15.37;

            //save our new workbook and we are done!
            package.Save();
        }
    }
    public static string FilePath(string name)
    {
        return Application.dataPath + "/" + name;
    }

}

