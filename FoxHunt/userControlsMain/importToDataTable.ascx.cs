using Binding;
using CsvHelper;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net.Mail;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.parser;
using Newtonsoft.Json;

namespace FoxHunt.userControlsMain
{
    public partial class importToDataTable : BaseControl
    {
        //private DataTable _importData;
        #region Classes and Properties
        public DataTable importData
        {
            get
            {
                return (DataTable)Session["importtbl"];
            }
            set
            {
                Session["importtbl"] = value;
            }
        }

        public enum SpecialFunctionType
        {
            None,
            CreateReference,
            ReplaceValues,
            SplitColumn   // NEW
        }
        public class ReplaceConfig
        {
            public string SourceColumn { get; set; }
            public List<ReplaceMapping> Mappings { get; set; }
        }

        public class CreateReferenceConfig
        {
            public string ReferenceTable { get; set; }

            // Import-side
            public string ImportSourceColumn { get; set; }

            // Reference-table side
            public string LookupColumn { get; set; }
            public string ReferenceColumn { get; set; }
            public string ReturnColumn { get; set; }

            public void Validate()
            {
                if (string.IsNullOrWhiteSpace(ReferenceTable))
                    throw new InvalidOperationException("ReferenceTable required");

                if (string.IsNullOrWhiteSpace(ImportSourceColumn))
                    throw new InvalidOperationException("ImportSourceColumn required");

                if (string.IsNullOrWhiteSpace(LookupColumn))
                    throw new InvalidOperationException("LookupColumn required");

                if (string.IsNullOrWhiteSpace(ReturnColumn))
                    throw new InvalidOperationException("ReturnColumn required");
            }
        }

        public class ColumnMap
        {
            public string TargetColumn { get; set; }
            public string SourceColumn { get; set; }
            public SpecialFunctionType SpecialFunction { get; set; }
            public string SpecialJson { get; set; }
        }
        public class SplitColumnConfig
        {
            public string SourceColumn { get; set; }
            public string SplitChar { get; set; }
            public string Side { get; set; } // "Left" or "Right"
        }

        //public class CreateReferenceConfig
        //{
        //    public string ReferenceTable { get; set; }
        //    public string LookupColumn { get; set; }     // column to match on
        //    public string ReturnColumn { get; set; }     // column to return (x)
        //}

        public class ReplaceMapping
        {
            public string Original { get; set; }
            public string Replacement { get; set; }
        }


        private dsShare _ds;
        public dsShare ds
        {
            get
            {
                if(_ds==null)
                    _ds = new dsShare();
                return _ds;
            }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            //tableControl.SourceTable = importData;
            //tableControl.PreviewRowCount = 20;

            if (!IsPostBack)
            {
                // Populate server-side table dropdown
                var tableNames = GetTableNames(new dsShare())
                    .OrderBy(t => t)       // ascending alphabetical
                    .ToList();             // make it a list so DataSource works
                ddTables.DataSource = tableNames;
                ddTables.DataBind();
                ddTables.Items.Insert(0, new ListItem("-- Select --", ""));
            }

            if (importData != null)
            {
                if (!IsPostBack)
                    BindRepeater(importData);
                EmitReplaceValuesData();
                EmitImportColumns();
                EmitTableColumns();
                ulFiles.Visible = false;
                btnCancel.Visible = true;
                btnImport.Visible = false;
                btnRebind.Visible = true;
                pnlMappingHeaders.Visible = true;
                pnlSampleData.Visible = true;
                btnRebind.Visible = true;
                btnSave.Visible = true;
                pnlFirstRow.Visible = false;
            }

        }
        #region "Finalized"
        //public static List<string> GetTableNames(dsShare dataSet)
        //{
        //    return dataSet.Tables
        //        .Cast<DataTable>()
        //        .Select(t => t.TableName)
        //        .ToList();
        //}

        private void BindRepeater(DataTable importData)
        {
            string selectedTableName = ddTables.SelectedValue;

            if (string.IsNullOrEmpty(selectedTableName))
            {
                lblErrors.Text = "Please select a table first.";
                return;
            }

            if (ds == null)
            {
                lblErrors.Text = "Target dataset not loaded.";
                return;
            }

            if (!ds.Tables.Contains(selectedTableName))
            {
                lblErrors.Text = $"Table '{selectedTableName}' not found in the target dataset.";
                return;
            }

            DataTable selectedTable = ds.Tables[selectedTableName];

            // Bind the repeater to the DataColumn collection
            rptColumnMap.DataSource = selectedTable.Columns.Cast<DataColumn>().ToList();
            rptColumnMap.DataBind();
        }

        private void ClearRepeaterState()
        {
            // Clear ViewState for repeater
            ViewState["rptColumnMap"] = null;

            // Optional: clear Session logic if you moved it there
            Session.Remove("ColumnLogic");
        }

        protected void rptColumnMap_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var lbl = (Label)e.Item.FindControl("lblSourceColumn");
            var ddl = (DropDownList)e.Item.FindControl("ddlTargetColumns");

            DataColumn targetColumn = (DataColumn)e.Item.DataItem;

            // Label text
            lbl.Text = targetColumn.ColumnName;

            // Attach data attribute SAFELY
            ddl.Attributes["data-target"] = targetColumn.ColumnName;

            // Populate dropdown
            var sourceColumns = importData.Columns
                .Cast<DataColumn>()
                .Select(c => c.ColumnName)
                .ToList();

            ddl.DataSource = sourceColumns;
            ddl.DataBind();
            var greyBg = "background-color:#f5f5f5;"; // very subtle light grey

            //ddl.Items.Insert(0, new ListItem("-- Select --", ""));
            ddl.Items.Insert(0, new ListItem("-- NULL --", "__IGNORE__") { Attributes = { ["style"] = greyBg } });

            // Only allow special logic if target column is NOT a primary key
            DataTable targetTable = null;
            if (!string.IsNullOrEmpty(targetColumn.Table?.TableName) && ds.Tables.Contains(targetColumn.Table.TableName))
            {
                targetTable = ds.Tables[targetColumn.Table.TableName];
            }


            bool isTargetPK = targetTable.PrimaryKey.Contains(targetColumn);
            if (!isTargetPK)
            {
                ddl.Items.Insert(1, new ListItem("-- Create Reference --", "__CREATE_REF__") { Attributes = { ["style"] = greyBg } });
                ddl.Items.Insert(2, new ListItem("-- Replace Values --", "__REPLACE__") { Attributes = { ["style"] = greyBg } });
                ddl.Items.Insert(3, new ListItem("-- Split Values --", "__SPLIT__") { Attributes = { ["style"] = greyBg } });
            }
            else
                ddl.Enabled = false;
            //ddl.Items.Insert(1,new ListItem("-- Create Reference --", "__CREATE_REF__") { Attributes = { ["style"] = greyBg } });
            //ddl.Items.Insert(2,new ListItem("-- Replace Values --", "__REPLACE__") { Attributes = { ["style"] = greyBg } });
            //ddl.Items.Insert(3,new ListItem("-- Split Values --", "__SPLIT__") { Attributes = { ["style"] = greyBg } });

            // =============================================
            // Fuzzy matching to preselect the most likely column
            // =============================================

            // Use the FindBestMatch overload that takes a collection
            string bestMatch = FuzzyMatch.FindBestMatch(
                targetColumn.ColumnName, // source column name
                sourceColumns,           // list of import columns
                0.55                     // threshold
            );

            if (!string.IsNullOrEmpty(bestMatch))
            {
                var li = ddl.Items.FindByValue(bestMatch);
                if (li != null)
                {
                    li.Selected = true;
                }
            }
        }

        #endregion

        #region Utility
        protected void EmitReplaceValuesData()
        {
            var dict = new Dictionary<string, List<string>>();
            foreach (DataColumn col in importData.Columns)
            {
                var values = importData.AsEnumerable()
                    .Select(r => r[col.ColumnName]?.ToString())
                    .Where(v => !string.IsNullOrEmpty(v))
                    .Distinct()
                    .OrderBy(v => v)
                    .ToList();
                dict[col.ColumnName] = values;
            }

            string json = JsonConvert.SerializeObject(dict);
            litReplaceValuesData.Text = $"<script>window.replaceValueSource = {json};</script>";
        }

        protected void EmitImportColumns()
        {
            var importColumns = importData.Columns.Cast<DataColumn>().Select(c => c.ColumnName).ToArray();
            string json = JsonConvert.SerializeObject(importColumns);
            litReplaceValuesData.Text += $"<script>window.importColumns = {json};</script>";
        }

        protected void EmitTableColumns()
        {
            if (ds == null) return;

            // Build dictionary of table names → column names
            var dict = ds.Tables.Cast<DataTable>()
                .ToDictionary(
                    t => t.TableName,
                    t => t.Columns.Cast<DataColumn>()
                              .Select(c => c.ColumnName)
                              .ToList()
                );

            string json = Newtonsoft.Json.JsonConvert.SerializeObject(dict);

            // Emit as JavaScript to the page
            litReplaceValuesData.Text += $"<script>window.tableColumns = {json};</script>";
        }


        public static List<string> GetTableNames(dsShare ds)
        {
            return ds.Tables.Cast<DataTable>().Select(t => t.TableName).ToList();
        }
        #endregion





        #region Spreadsheet Import .csv, .xls, .xlsx, .pdf
        public DataTable ImportToDataTable(List<string> fileList, out string error)
        {
            error = string.Empty;
            DataTable dt = new DataTable();

            if (fileList == null || fileList.Count == 0)
            {
                error = "You have to add a file to import.";
                return dt;
            }

            string fileName = fileList[0];
            string filePath = HttpContext.Current.Server.MapPath("~/uploads/" + fileName);
            string extension = System.IO.Path.GetExtension(filePath).ToLower();

            if (extension == ".csv")
            {
                dt = CsvToDataTable(filePath);
            }
            else if (extension == ".xls" || extension == ".xlsx")
            {
                dt = ExcelToDataTable(filePath);
            }
            //else if (extension == ".pdf")
            //{
            //    dt = PDFToDataTable(filePath);
            //}
            else
            {
                error = "File must be one of the following: .csv, .xls, .xlsx.";
            }

            fileList.Clear();
            return dt;
        }

        //public static DataTable PdfToDataTable(Stream pdfStream, Func<string[], DataTable> tableBuilder, int startPage = 1)
        //{
        //    var allLines = new List<string>();

        //    using (var reader = new PdfReader(pdfStream))
        //    {
        //        for (int page = startPage; page <= reader.NumberOfPages; page++)
        //        {
        //            var text = PdfTextExtractor.GetTextFromPage(
        //                reader,
        //                page,
        //                new SimpleTextExtractionStrategy());

        //            var lines = text
        //                .Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries)
        //                .Select(l => l.Trim())
        //                .Where(l => !string.IsNullOrWhiteSpace(l))
        //                .ToArray();

        //            allLines.AddRange(lines);
        //        }
        //    }

        //    // Let caller decide how to convert lines into DataTable
        //    return tableBuilder(allLines.ToArray());
        //}
    



        public DataTable ExcelToDataTable(string filePath)
        {
            var dt = DataImporter.DataImporter.ConvertExcelToTable(filePath);
            if (dt.Rows.Count > 0)
            {
                foreach (DataColumn col in dt.Columns)
                {
                    col.ColumnName = (string)dt.Rows[0][col.ColumnName];
                }
                dt.Rows[0].Delete();
                dt.AcceptChanges();

                foreach (DataRow row in dt.Rows)
                {
                    foreach (DataColumn col in dt.Columns)
                    {
                        if (row[col] != null && row[col].ToString().Trim().ToUpper() == "NULL")
                        {
                            row[col] = DBNull.Value;
                        }
                    }
                }


            }
            return dt;
        }

        public DataTable CsvToDataTable(string csvFilePath)
        {
            using (var reader = new StreamReader(csvFilePath))
            using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
            {
                using (var dr = new CsvDataReader(csv))
                {
                    var dt = new DataTable();
                    dt.Load(dr);
                    return dt;
                }
            }
        }

        #endregion

        protected void btnImport_Click(object sender, EventArgs e)
        {
            var sb = new StringBuilder();
            var error = "";
            var dt = ImportToDataTable(ulFiles.fileList, out error);
            //foreach (DataRow ballot in dtImport.Rows)
            //{
            //    sb.Append($"<h3>Ballot {ballot[0]}</h3>");
            //}

            //DataTable dt = DataImporter.DataImporter.ConvertExcelToTable(Server.MapPath("~/uploads/" + ulFiles.fileList[0]));
            if (dt.Rows.Count > 0)
            {
                if (cbFirstRowContainsColumnNames.Checked)
                {
                    foreach (DataColumn col in dt.Columns)
                    {
                        col.ColumnName = (string)dt.Rows[0][col.ColumnName];
                    }
                    dt.Rows[0].Delete();
                    dt.AcceptChanges();
                }
                

                foreach (DataColumn col in dt.Columns)
                    col.ColumnName = col.ColumnName.Trim();
                importData = dt;
                ulFiles.fileList.Clear();
                BindRepeater(dt);
                //BindImportPreview();

                if (importData != null)
                {
                    ulFiles.Visible = false;
                    //DTIGrid1.DataSource = importData;
                    //DTIGrid1.Visible = true;
                    //tableControl.SourceTable = importData;
                    //tableControl.PreviewRowCount = 20;


                    ulFiles.Visible = false;
                    btnCancel.Visible = true;
                    btnImport.Visible = false;
                    btnRebind.Visible = true;
                    pnlMappingHeaders.Visible = true;
                    pnlSampleData.Visible = true;
                    btnRebind.Visible = true;
                    btnSave.Visible = true;
                    pnlFirstRow.Visible = false;
                }
                //Response.Redirect(Request.Url.AbsoluteUri);
                EmitReplaceValuesData();
                EmitImportColumns();
                EmitTableColumns();
                // After importData is filled
                Page.ClientScript.RegisterStartupScript(this.GetType(), "populateReferenceDropdown", "populateReferenceColumnDropdown();", true);
            }
            
            Output.Text += sb.ToString();
            if (error != "") Data.returnJsAlert(error);
            

        }
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Session.Remove("importtbl");
            Response.Redirect(Request.Url.AbsoluteUri);
        }

        protected void btnRebind_Click(object sender, EventArgs e)
        {
            rptColumnMap.DataSource = null;
            rptColumnMap.DataBind();

            ClearRepeaterState();
            BindRepeater(importData);
        }
        private void SaveRepeaterMapping(string tableName)
        {
            // Get empty schema of target table
            DataTable dtTarget = sqlHelper.FillDataTable(
                $"SELECT TOP 0 * FROM {tableName}"
            );

            // Build mapping configuration from repeater
            List<ColumnMap> columnMaps = new List<ColumnMap>();

            foreach (RepeaterItem item in rptColumnMap.Items)
            {
                if (item.ItemType != ListItemType.Item &&
                    item.ItemType != ListItemType.AlternatingItem)
                    continue;

                var lbl = (Label)item.FindControl("lblSourceColumn");
                var ddl = (DropDownList)item.FindControl("ddlTargetColumns");

                if (ddl.SelectedIndex <= 0 ||
                    string.IsNullOrEmpty(ddl.SelectedValue) ||
                    ddl.SelectedValue == "__IGNORE__")
                    continue;

                var hf = (HiddenField)item.FindControl("hfSpecialLogic");

                var map = new ColumnMap
                {
                    TargetColumn = lbl.Text,
                    SourceColumn = ddl.SelectedValue,
                    SpecialFunction = SpecialFunctionType.None,
                    SpecialJson = hf?.Value
                };

                if (ddl.SelectedValue == "__CREATE_REF__")
                {
                    map.SpecialFunction = SpecialFunctionType.CreateReference;
                    map.SourceColumn = null;
                }
                else if (ddl.SelectedValue == "__REPLACE__")
                {
                    map.SpecialFunction = SpecialFunctionType.ReplaceValues;
                    map.SourceColumn = null;
                }
                else if (ddl.SelectedValue == "__SPLIT__")
                {
                    map.SpecialFunction = SpecialFunctionType.SplitColumn;
                    map.SourceColumn = null;
                }

                columnMaps.Add(map);
            }

            // Process rows
            foreach (DataRow importRow in importData.Rows)
            {
                DataRow newRow = dtTarget.NewRow();

                foreach (var map in columnMaps)
                {
                    if (!dtTarget.Columns.Contains(map.TargetColumn))
                        continue;

                    DataColumn targetCol = dtTarget.Columns[map.TargetColumn];

                    // Skip identity columns
                    if (targetCol.AutoIncrement)
                        continue;

                    object finalValue = DBNull.Value;

                    switch (map.SpecialFunction)
                    {
                        //Normal Route, Tested
                        case SpecialFunctionType.None:
                            if (importData.Columns.Contains(map.SourceColumn))
                                finalValue = importRow[map.SourceColumn];
                            break;

                        //Replacements, Tested
                        case SpecialFunctionType.ReplaceValues:
                            if (!string.IsNullOrEmpty(map.SpecialJson))
                            {
                                var config =
                                    JsonConvert.DeserializeObject<ReplaceConfig>(map.SpecialJson);

                                if (config != null &&
                                    importData.Columns.Contains(config.SourceColumn))
                                {
                                    string importVal =
                                        importRow[config.SourceColumn]?.ToString();

                                    var match = config.Mappings?
                                        .FirstOrDefault(x =>
                                            string.Equals(x.Original, importVal,
                                                StringComparison.OrdinalIgnoreCase));

                                    finalValue = match != null
                                        ? (object)match.Replacement
                                        : importRow[config.SourceColumn];
                                }
                            }
                            break;

                        case SpecialFunctionType.CreateReference:
                            if (!string.IsNullOrEmpty(map.SpecialJson))
                            {
                                var config = JsonConvert.DeserializeObject<CreateReferenceConfig>(map.SpecialJson);

                                object importVal = importRow[config.ReferenceColumn];
                                if (importVal == null || importVal == DBNull.Value)
                                    break;

                                //object importVal =
                                //    importRow[config.ImportSourceColumn];

                                // Pull reference table
                                DataTable dtRef = sqlHelper.FillDataTable(
                                    $"SELECT * FROM {config.ReferenceTable}"
                                );

                                string escaped = importVal.ToString().Replace("'", "''");

                                DataRow[] found =
                                    dtRef.Select($"{config.LookupColumn} = '{escaped}'");

                                DataRow refRow;

                                if (found.Length > 0)
                                {
                                    refRow = found[0];
                                }
                                else
                                {
                                    refRow = dtRef.NewRow();
                                    refRow[config.LookupColumn] = importVal;
                                    Data.setUpdateVals(refRow);
                                    dtRef.Rows.Add(refRow);
                                    sqlHelper.Update(dtRef);

                                    DataTable dtReLookup = sqlHelper.FillDataTable(
                                    $"SELECT * FROM {config.ReferenceTable} where {config.LookupColumn} = '{escaped}'");
                                    if (dtReLookup.Rows.Count > 0)
                                        refRow = dtReLookup.Rows[0];
                                }

                                finalValue = refRow[config.ReturnColumn];
                            }
                            break;

                        case SpecialFunctionType.SplitColumn:
                            if (!string.IsNullOrEmpty(map.SpecialJson))
                            {
                                var config = Newtonsoft.Json.JsonConvert.DeserializeObject<SplitColumnConfig>(map.SpecialJson);
                                if (importData.Columns.Contains(config.SourceColumn))
                                {
                                    var val = importRow[config.SourceColumn]?.ToString() ?? string.Empty;
                                    var parts = val.Split(new[] { config.SplitChar }, StringSplitOptions.None);
                                    object finalVal = config.Side == "Left" ? parts.FirstOrDefault() ?? string.Empty
                                                                            : parts.LastOrDefault() ?? string.Empty;
                                    finalValue = finalVal;
                                }
                            }
                            break;

                    }

                    if (finalValue != DBNull.Value)
                        newRow[map.TargetColumn] = finalValue;
                }

                Data.setUpdateVals(newRow);
                dtTarget.Rows.Add(newRow);
            }

            //sqlHelper.Update(dtTarget);
            
        }




        protected void btnSave_Click(object sender, EventArgs e)
        {
            SaveRepeaterMapping(ddTables.SelectedValue);
        }
    }

}