using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace FoxHunt
{

    [ServiceContract]
    public class PollCountService
    {
        public PollCountService()
        {
        }

        public BaseClasses.BaseHelper sqlHelper
        {
            get
            {
                return BaseClasses.DataBase.getHelper();
            }
        }

        //[OperationContract]
        //bool AddCountRow(VibeBaseProjectData.dsShare.PollingPlaceCountDataTable dtcount) {
        //    var row = dtcount[0];
        //    if (row.RowState == DataRowState.Added)
        //        row.DateInserted = DateTime.Now;

        //    row.DateUpdated = DateTime.Now;
        //    sqlHelper.Update(row.Table);
        //    return true;
        //}

        //[OperationContract]
        //public dsElectionData.POLLING_PLACEDataTable getPollPlaces()
        //{
        //    var dt = new dsElectionData.POLLING_PLACEDataTable();
        //    sqlHelper.FillDataTable(@"SELECT * FROM POLLING_PLACE ", dt);
        //    return dt;
        //}


    }
}
