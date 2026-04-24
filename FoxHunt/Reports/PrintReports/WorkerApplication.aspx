<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="WorkerApplication.aspx.cs" Inherits="FoxHunt.Workers.PrintReports.WorkerApplication" %>

<%@ Register Src="~/userControls/UCPrecinctMini.ascx" TagPrefix="uc1" TagName="UCPrecinctMini" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<style>
    @media print {
        .d-print-none {
            display: none !important;
        }

        .pagebreak {
            page-break-after: always;
        }
    }
     .footnote{
         color:red;
     }
     .formsec{
         text-align:center;
         justify-content:center;
         margin-bottom:5px;
     }
     .reportheader{
         /*border:solid 5px black;*/
         margin-left: 0px;
         margin-right: 0px;
         background-color:black;
         padding-top:40px;
         margin-top: -55px!important;
     }

</style>

    <div class=" p-2 printButton">
    <input class="printlaunch d-print-none" style="float:right" id="Button1" type="button" value="Print" onclick="window.print();" />
    </div>

    <div class="row reportheader">
            <div class="col-3 formsec">
                <image src="/images/2018_DCO_Modified_Logo.png" height="100px;"></image>
            </div>
            <div class="col-6 formsec">
                <h3 style="width:100%; color:white;">Precinct Official Application</h3>
            </div>
            <div class="col-3 formsec">
                <image src="/images/2018_DCO_Modified_Logo.png" height="100px;"></image>
                <%--<p style="width:100%;  margin-bottom:0px!important; margin-top: 10px; color:white;">Election Date: <asp:Label runat="server" ID="lblTerm"></asp:Label></p>
                <p style="width:100%; margin-bottom:0px!important; color:white;">Board Meeting: <asp:Label runat="server" ID="lblabsmeeting"></asp:Label></p>--%>
            </div>
        </div>
 
    <div class="row">
            <div class="col-md-12">
                <div class="col-md-12" style="border: solid 1px; padding-bottom: 10px; padding-top: 10px; border-radius: 5px;">
                <h3 style="text-align: center;"><b>NC Voter Registration Record</b></h3>
                <hr />
                    <div class="row">
                <div class="col-md-6">
                    <div class="row">
                        <div class="col">You are: </div>
                        <div class="col"><%=r["first_name"] %> <%=r["middle_name"] %> <%=r["last_name"] %> </div>
                    </div>
                    <div class="row">
                        <div class="col">Birth Year: </div>
                        <div class="col"><%=((DateTime)vr["birthday"]).ToString("yyyy") %> </div>
                    </div>
                    <div class="row">
                        <div class="col">Race: </div>
                        <div class="col"><%=r["race_desc"] %> </div>
                    </div>
                    <div class="row">
                        <div class="col">Ethnicity: </div>
                        <div class="col"><%=r["ethnicity_desc"] %> </div>
                    </div>
                    </div>
                        <div class="col-md-6">
                    <div class="row">
                        <div class="col">Physical Address:</div>
                        <div class="col"><%=r["address"]%>
                            </div>
                    </div>
                    <div class="row">
                        <div class="col">Mailing Address:</div>
                        <div class="col"><%=r["mailaddr1"]%> <br /> <%=r["mail_city"]%>, <%=r["mail_state"]%> <%=r["mail_zip"]%></div>
                    </div>
                    <div class="row">
                        <div class="col">Party Registration: </div>
                        <div class="col"><%=r["party_desc"] %></div>
                    </div>
                </div>
                        
                        </div>
                    <hr />
                    <div class="row">
                <div class="col-md-6">
                    <div class="row">
                        <div class="col">VR Number: </div>
                        <div class="col"><%=r["voter_reg_num"] %></div>
                    </div>
                    <div class="row">
                        <div class="col">Home Precinct:</div>
                        <div class="col"><%=r["precinct_lbl"]%></div>
                    </div>
                    <div class="row">
                        <div class="col">Registration Status:</div>
                        <div class="col"><%=r["status_desc"]%></div>
                    </div>
                    </div>
                    <div class="col-md-6">
                        <%--<a type="button" class="btn btn-primary hovertext" data-hover="Click here to update your voter registion online through the DMV" href="https://payments.ncdot.gov/" target="_blank" style="background-color: #ebebeb; color: black">Update<br />
                            Registration</a>--%>
                    </div>
                    
                    <hr />
                   
                </div>
            </div>
                </div>
            </div>
<%--END VR INFO, START PERSONAL--%>
    <div class="row">
                            <div class="col-12 formsec">
                                <h3 class="sectiontitle">Personal Information</h3>
                            </div>
                        </div>
     <div class="row">
                    <form id="form1">
                        
                    <div class="col-md-6">
                        Preferred First Name (Optional): 
                        <asp:TextBox ID="tbpreferredname" CssClass="form-control" TextMode="SingleLine" runat="server"></asp:TextBox>
                        <br />

                        Email Address: <span class="required">*</span>
                        <asp:TextBox ID="txtemail" CssClass="form-control" TextMode="Email" runat="server"></asp:TextBox>                        
                </div>
                    <div class="col-md-6">
                        
                    

                     Cell Phone: <span class="required">*</span>    
                        <asp:TextBox runat="server" ID="tbcell" CssClass="form-control"></asp:TextBox>
                        <br />
                                                  
                    Home Phone (Optional):     
                        <asp:TextBox runat="server" ID="tbphone" CssClass="form-control"></asp:TextBox>
                        
                </div>
                
                </div>
    <%--END PERSONAL, START QUESTIONS--%>
    <div class="row">
                    <%--<div class="col-md-3"></div>--%>
                    <div class="col-md-6">
                        <h3 class="sectiontitle">Additional Information</h3>

                        How did you learn about us? <span class="required">*</span>
                            <asp:TextBox runat="server" ID="tbreferralSource" CssClass="form-control"></asp:TextBox>
                            <br />
                        
                        Are you currently employed or have you previously been employed by Durham County? <span class="required">*</span>
                            <asp:TextBox runat="server" ID="tbDCoEMP" CssClass="form-control"></asp:TextBox>                           
                            <br />
                            
                        Have you worked as a Precinct Official in Durham County before? <span class="required">*</span>                        
                            <asp:TextBox runat="server" ID="tbworkedBefore" CssClass="form-control"></asp:TextBox>                             
                            <br />
                            
                        Have you held and Political or Elective Office <span class="required">*</span>
                            <asp:TextBox runat="server" ID="tbpoliticalInvolvement" CssClass="form-control"></asp:TextBox>
                            <br />
                        
                        Are you able to work from as early as 5:30am until approximately 9:00pm on Election Day, as required of all Precinct Officials by the State Board of Elections? <span class="required">*</span>
                                <asp:TextBox runat="server" ID="tbcanWorkED" CssClass="form-control"></asp:TextBox>                            
                        </div>
                   
                    <div class="col-md-6" >
                        <%--style="border-left: solid 1px #80808042;"--%>
                        <h3 class="sectiontitle">Paid Work Interests</h3>
                        <div class="row">
                            <div class="col-1 interetcb">
                                <asp:CheckBox runat="server" ID="cbED" />
                            </div>
                            <div class="col-11">
                                <h4>Interest in Working Election Day</h4>
                                <p>Working Election Day requires arriving at your assigned polling place by 6:00 a.m. and staying until the 
                                    polls close at 7:30 p.m. and closing procedures are completed.</p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-1 interetcb">
                                <asp:CheckBox runat="server" ID="cbOS" />
                            </div>
                            <div class="col-11">
                                <h4>Interest in Working Early Voting</h4>
                                <p>The 17-day Early Voting period, which takes place beginning on the 3rd Thursday prior to Election Day, 
                                    is broken up into shifts and staffed by the same officials who work on Election Day.</p>
                                <%--<hr />--%>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-1 interetcb">
                                <asp:CheckBox runat="server" ID="cbOffice" />
                            </div>
                            <div class="col-11">
                                <h4>Interest in Working at the BOE Office</h4>
                                <p>The responsibilities of working at the Board of Elections offices will be, but not limited to, Absentee-by-mail 
                                    processing, Multi-Partisan Assistant Teams, and general data entry. </p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-1 interetcb">
                                <asp:CheckBox runat="server" ID="cbWarehouse" />
                            </div>
                            <div class="col-11">
                                <h4>Interest in Working at the BOE Warehouse</h4>
                                <p>The responsibilities of working at the Board of Elections Warehouse will be, but are not limited to, unloading and loading 
                                    election equipment and item sorting and packing. Must be able to lift 50 lbs.</p>
                            </div>
                        </div>
                        
                    
                </div>
                
                </div>

</asp:Content>