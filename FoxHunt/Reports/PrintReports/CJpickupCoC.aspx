<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="CJpickupCoC.aspx.cs" Inherits="FoxHunt.Workers.CJpickupCoC" %>

<%@ Register Src="~/userControlsMain/UCPrecinctMini.ascx" TagPrefix="uc1" TagName="UCPrecinctMini" %>
<%--<%@ Register Src="~/userControlsMain/UCPacklist.ascx" TagPrefix="uc1" TagName="UCPacklist" %>--%>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

   <%-- <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>--%>
  
       <style>
           .programPg{
               width:1155px!important;
           }
           .listitem{
          background-color:lightgray;
          padding-left:75px;
            }
            .listitem:nth-child(odd){
              background-color:white;
            }
            body{
                font-size:12pt;
            }
            .form-control1{
                width:350px;
            }
            .form-control2{
                width: 400px;
                margin-left: 30px;
            }
            .form-control3{
                width:175px;
            }
            .vercb{
                margin-left: 10px!important;
                margin-right: 10px!important;
            }
            .formsec{
         text-align:center;
         justify-content:center;
         margin-bottom:5px;
     }
       </style>


  
        <%--Cluster above here--%>

    <div class="row ">
        <div class="col-3 formsec">
                <image src="/images/2018_DCO_Modified_Logo.png" height="100px;"></image>
            </div>
        <div class="col-6 formsec">
            <h1 class="" style="color:black;"><asp:Label runat="server" ID="lblCJName"></asp:Label></h1>
            <h3 class="" style="color:black; "><asp:Label runat="server" ID="lblprecinct"></asp:Label></h3>
        </div>
        <div class="col-3 formsec">
                <image src="/images/2018_DCO_Modified_Logo.png" height="100px;"></image>
            </div>
    </div>
          <br />
        <div class="row">
            <div class="col-12" style="color:white; background-color:black; text-align:center; vertical-align:middle;"><h4>Arrival Verification</h4></div>
            <%--<div class="col-7"></div>--%>
        </div>
    <div class="row">
            <div class="col-6" style="line-height:3.5rem;">
                <%--<input type="text" class="form-control" />--%>
                <div class="row" style="padding-left: 15px;">
                    Pick-Up Date/Time: <asp:Label runat="server" ID="lblpudt" CssClass="form-control form-control2"></asp:Label><%--<input type="text" class="form-control1" />--%>
                </div>
                
                Picture ID Verified?   <input type="checkbox" class="vercb" /> Photo Taken?   <input type="checkbox" class="vercb" /> EMERG Info   <input type="checkbox" class="vercb" />
            </div>
            <div class="col-6">
                <div class="row">
                    <div class="col-4" style="line-height:3.5rem;">
                        Precinct: <br />
                        Pick-Up Person: <br />
                        Pick-Up Time: 
                    </div>
                    <div class="col-8" style="line-height:3.5rem;">
                         <asp:Label runat="server" ID="lblPct" CssClass="form-control form-control1"></asp:Label>
                         <input type="text" class="form-control1" /><br />
                         <input type="text" class="form-control1" />
                    </div>
                </div>
                <%--Precinct: <input type="text" class="form-control1" /><br />
                Pick-Up Person: <input type="text" class="form-control1" /><br />
                Pick-Up Time: <input type="text" class="form-control1" />--%>
            </div>
        </div>
    
          <br />

        <div class="row">
            <div class="col-12" style="color:white; background-color:black; text-align:center; vertical-align:middle;"><h4>Oath</h4></div>
            <%--<div class="col-7"></div>--%>
        </div>
    <div class="row">
            <div class="col-12" >
                <p>
                    “I __[name]__, do solemnly swear (or affirm) that I will support the
Constitution of the United States; that I will be faithful and bear true
allegiance to the State of North Carolina, and to the constitutional
powers and authorities which are or may be established for the
government thereof; that I will endeavor to support, maintain and
defend the Constitution of said State not inconsistent with the
Constitution of the United States; that I will administer the duties of my
office as [chief judge of, assistant in, judge of election in] __[precinct]__,
Durham County, without fear or favor; that I will not in any manner
request or seek to persuade or induce any voter to vote for or against
any particular candidate or proposition; and that I will not keep or
make any memorandum of anything occurring within a voting booth,
unless I am called to testify in a judicial proceeding for a violation of
the election laws of this State; so help me, God.
                </p>
            </div>
            <%--<div class="col-7"></div>--%>
        </div>
    
          <br />
        <div class="row">
            <div class="col-4" style="color:white; background-color:black; text-align:center; vertical-align:middle;"><h4>Chief Judge Supply Tote</h4></div>
            <div class="col-4" style="color:white; background-color:black; text-align:center; vertical-align:middle;"><h4>Chief Judge Admin Binder</h4></div>            
            <div class="col-4" style="color:white; background-color:black; text-align:center; vertical-align:middle;"><h4>Discussion Items</h4></div>
        </div>
        <%--<div class="row listing">
            <div class="col-4 list">
                 <%foreach(System.Data.DataRow br in dtbag.Rows )
                     { 
                         string item = br["name"].ToString();
                         if(item !="") {%>
                <div class="listitem">
                    <input type="checkbox" /> <%=item %><br />
                    </div>
                <%}} %>
            </div>

            <div class="col-4 list">
                <%foreach(System.Data.DataRow br in dtbinder.Rows )
                     { 
                         string item = br["name"].ToString();
                         if(item !="") {%>
                    <div class="listitem">
                    <input type="checkbox" /> <%=item %><br />
                    </div>
                <%}} %>
            </div>
            
            <div class="col-4 list">
                <%foreach(System.Data.DataRow br in dtdiscussion.Rows )
                     { 
                         string item = br["name"].ToString();
                         if(item !="") {%>
                    <div class="listitem">
                    <input type="checkbox" /> <%=item %><br />
                    </div>
                <%}} %>
            </div>
        </div>--%>


        
   
          <br />
        <div class="row">
            <div class="col-12" style="color:white; background-color:black; text-align:center; vertical-align:middle;"><h4>Confirmation of Receipt and Transfer of Custody </h4></div>
            <%--<div class="col-7"></div>--%>
            <p>The Chief Judge or designated official has verified and understands the aforementioned information and received all of the materials provided for herein.</p>
        </div>

        <div class="row" style="width:100%;">
            <div class="col-6">
                BOE Supply Pick-Up Coordinator: <input type="text" class="form-control" style="border:1px solid red;"/>
            </div>
            <div class="col-6">
                Chief Judge or Designated Official: <input type="text" class="form-control" style="border:1px solid red;"/>
            </div>
        </div>  



</asp:Content>