using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using Binding;

namespace FoxHunt
{
    public class BaseEditPage : BasePage
    {
            public String TableName;

            public BaseEditPage()
            {
                this.Load += BasePage_Load;
            }
            public new Data Data { get { return (Data)base.Data; } }
            private DataRow _row;
            public DataRow row
            {
                get
                {
                    if (_row == null && TableName != null)
                    {
                        setRowFromID();
                        if (_row == null)
                        {
                            var dt = sqlHelper.FillDataTable("select top 1 * from " + TableName);
                            _row = dt.NewRow();
                            dt.Rows.Add(row);
                        }
                    }
                    return _row;
                }
                set { _row = value; }
            }

            public long id
            {
                get
                {
                    if (Request.QueryString["id"] != null)
                        return long.Parse(Request.QueryString["id"]);
                    return 0;
                }
            }

            public bool setRowFromID()
            {
                if (Request.QueryString["id"] != null)
                    return setRowFromID(id);
                return false;
            }

            public bool setRowFromID(long id)
            {
                var dt = sqlHelper.FillDataTable("select top 1 * from " + TableName + " where id = @id", id);
                if (dt.Rows.Count > 0)
                {
                    _row = dt.Rows[0];
                    return true;
                }
                return false;
            }

            protected void BasePage_Load(object sender, EventArgs e)
            {
                foreach (DropDownList dd in BaseClasses.Spider.spidercontrolforAllOfType(this, typeof(DropDownList)))
                {
                    Data.ddDt = null;
                    Data.setDDFromDDList(dd);
                }
                if (row != null)
                    this.autoBind(row);

                //this.labelize();
            }


            public virtual void saveRow()
            {
                //this.setRowValues(row);
                //Data.setUpdateVals(row);
                //Data.setUserData(row, null, true);
                sqlHelper.Update(row.Table);

            }

        }
    }