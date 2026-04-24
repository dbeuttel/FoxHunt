using JqueryUIControls;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt.userControlsMain
{
    public partial class selectExtUser : BaseControl
    {

        public int extUserid
        {
            get
            {
                int outInt = -1;
                int.TryParse(acFindUser.Value, out outInt);
                return outInt;
            }
        }

        public dsShare.ExtUsersRow extUser
        {
            get { return Data.getUser(extUserid); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            acFindUser.setSelectAutocomplete(@"
--declare @name varchar(10) = 'mi'
select top 20 * from (
    select first_name + ' ' + last_name as name,
    last_name + ',' + first_name as name1,* from ExtUsers
) e
where first_name like @name 
or last_name like @name 
or voter_reg_num like '%0' + @name 
--or eidNumber like '%' + @name 
or email like @name 
or birth_dt like @name 
or name like @name 
or name1 like @name 
            ", "name","id");

            //this.acFindUser.Focus();
        }
    }
}