<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UCPacklist.ascx.cs" Inherits="FoxHunt.userControlsMain.UCPacklist" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>

<%--<h1 style="width: 100%; text-align:center; color:black; text-decoration:underline;">Durham County Board of Elections</h1>--%>

        <style>
        .groupContainer .container{
          background-color:lightgray;
        }
        .groupContainer .container:nth-child(odd){
          background-color:white;
        }
        .groupContainer {
          display: inline-block;
          width: 49%;
          vertical-align: top;
        }
        .columnheader {
        width:100%; 
        text-align:center; 
        display:inline-block;
        font-size:30px;
        }
        .itemsitename {
    width: 90px;
    display:inline-block;
}
        .itemLongCode{
           font-style: italic; 
           font-size: smaller;
        }
        </style>

    <h3 style="text-align:center;"><%=Baskettitle %></h3> 

    <%
        int i = 0;
        foreach (System.Data.DataRow row in itemList.Rows) {
            bool isGroup = (int)row["tableid"] == 0;
            bool isfirst = i == 0;
            i++;
            if (isGroup)
            {
    %>
    <%if (!isfirst){%></div><%} %>
    <div class="groupContainer" >
    <h4 class="columnheader"><%= row["text"]%></h4>
    <%}else{ %>
    <div class="container">
        <div class="row">
            <%--<div class="col-1">
            
            
            </div>--%>
           <%if (row["eqnum"] == DBNull.Value)
                {  %>
            <div class="col-10">
                <%=row["name"]%> 
             
            </div>
            <div class="col-1" >
                <%=row["Count"]%> 
            
            </div>
            <div class="col-1">
                <input type="checkbox"/>
            </div>
            <%}
                else
                {%>

             <div class="col-12">
                <%=row["name"]%> 
             

            <%
               var assetList = row["eqnum"].ToString().Split(',');
                var barcode = row["barcode"].ToString();
                foreach (var assetTag in assetList)
                {
                    var itemlist = assetTag.Split(':');
                    var siteLbl = "";
                    
                    var displayItemStr = assetTag;
                    if (itemlist.Length > 0)
                        barcode = itemlist[0];
                    if (itemlist.Length > 1)
                        displayItemStr = itemlist[1];
                    if (itemlist.Length > 2)
                        siteLbl = itemlist[2];

                    %>
            <div class="row"><div class="col"><b class="itemsitename"><%=siteLbl %></b><span class="itemShortCode"><%=barcode %></span> : <span class="itemLongCode"><%=displayItemStr %></span>

                             </div>
                            <div class="col-1">
                <input tableid="<%=row["id"]%>" barcode="<%=barcode%>" type="checkbox"/>
            </div>
            </div>
                    <%}%>
            </div>              
            <%} %>
        </div>
    </div>
    <%} %>
<%}%>
    </div>
