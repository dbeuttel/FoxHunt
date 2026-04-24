using System;
using System.Web.UI;

namespace FoxHunt
{
    public partial class FoxHuntShell : BaseClasses.MasterBase
    {
        public new Data Data { get { return (Data)base.Data; } }

        protected void Page_Load(object sender, EventArgs e) { }
    }
}
