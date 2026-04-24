using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace FoxHunt
{
    public class Global : System.Web.HttpApplication
    {
        
        public BaseClasses.BaseHelper sqlLiteHelper
        {
            get
            {
                return Data.createHelper("sqlLite");
            }
        }

        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            DTIControls.Share.initializePathProvider();

            sqlLiteHelper.checkAndCreateAllTables(new dsShare());

            InitializeFoxHuntSchema();
        }

        private void InitializeFoxHuntSchema()
        {
            string schemaPath = System.Web.Hosting.HostingEnvironment.MapPath("~/Scripts/Sql/CreateFoxHuntSchema.sql");
            string seedPath   = System.Web.Hosting.HostingEnvironment.MapPath("~/Scripts/Sql/SeedBands.sql");

            if (schemaPath != null && System.IO.File.Exists(schemaPath))
            {
                sqlLiteHelper.ExecuteNonQuery(System.IO.File.ReadAllText(schemaPath));
            }

            object existing = sqlLiteHelper.FetchSingleValue("select count(*) from Band");
            int bandCount = 0;
            int.TryParse(existing == null ? "0" : existing.ToString(), out bandCount);
            if (bandCount == 0 && seedPath != null && System.IO.File.Exists(seedPath))
            {
                sqlLiteHelper.ExecuteNonQuery(System.IO.File.ReadAllText(seedPath));
            }
        }

        void Application_End(object sender, EventArgs e)
        {
            //  Code that runs on application shutdown

        }

        void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs
            if (!Server.GetLastError().Message.Contains("File does not exist"))
            {
                try
                {
                    Session["LastError"] = Server.GetLastError();
                    Session["errorRequest"] = Request;
                }
                catch (Exception ex)
                {
                    Application["LastError"] = Server.GetLastError();
                    Application["errorRequest"] = Request;
                }
            }
        }

        void Session_Start(object sender, EventArgs e)
        {
            // Code that runs when a new session is started
            
        }

        void Session_End(object sender, EventArgs e)
        {
            // Code that runs when a session ends. 
            // Note: The Session_End event is raised only when the sessionstate mode
            // is set to InProc in the Web.config file. If session mode is set to StateServer 
            // or SQLServer, the event is not raised.

        }

    }
}
