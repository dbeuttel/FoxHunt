using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Binding;
using System.Web.UI.WebControls;

namespace FoxHunt
{
	public class BaseControl : BaseClasses.BaseSecurityUserControl
	{
		public BaseControl()
		{
			this.Load += BasePage_Load;
		}
		public new Data Data { get { return (Data)base.Data; } }
		private DataRow _row;
		public DataRow row { get {
				if (_row == null && TableName != null)
				{
					var dt = sqlHelper.FillDataTable("select top 1 * from " + TableName);
					_row = dt.NewRow();
					dt.Rows.Add(row);
				}
				return _row;
			}
			set { _row = value; }
		}
		public String TableName;
		//public dsShare.dssUsersRow CurrentUser { get { return Data.CurrentUser; } set { Data.CurrentUser=value;} }
		//public dsShare.ApplicationRow CurrentApp { get { return Data.CurrentApp; } set { Data.CurrentApp=value;} }

		public bool setRowFromID() {
			if (Request.QueryString["id"] != null)
				return setRowFromID(int.Parse(Request.QueryString["id"]));
			return false;
		}


		public string urlNoAjax()
		{
			if (Request.QueryString["ajaxCtrl"] == null)
				return Request.Url.PathAndQuery;
			var url = Request.Url.PathAndQuery;
			return url.Substring(0, url.IndexOf("ajaxCtrl") - 1);
		}

		public bool setRowFromID(int id)
		{
			var dt = sqlHelper.FillDataTable("select top 1 * from " + TableName + " where id = @id",id);
			if(dt.Rows.Count > 0)
			{
				row = dt.Rows[0];
				return true;
			}
			return false;
		}

		protected void BasePage_Load(object sender, EventArgs e)
		{
			foreach(DropDownList dd in BaseClasses.Spider.spidercontrolforAllOfType(this, typeof(DropDownList))){
				Data.ddDt = null;
				Data.setDDFromDDList(dd);
			}
			if (row != null)
				this.autoBind(row);
			Data.setCssClasstoId(this);
			//this.labelize();
		}


		public void saveRow()
		{
			this.setRowValues(row);
			//Data.setUpdateVals(row);
			//Data.setUserData(row, null, true);
			sqlHelper.Update(row.Table);
			
		}

	}
}