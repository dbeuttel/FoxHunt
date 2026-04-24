<%@ Page Title="" Language="C#" MasterPageFile="~/Site1LoggedOut.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="FoxHunt.ForgotPassword" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <style>
        /*.formsec{
         text-align:center;
         justify-content:center;
         margin-bottom:5px;
        }*/
        .loginimage{
            width:100%;
            border-radius:10px;
        }

        .emailsec{
            margin-top:45px;
        }
        .logincont{
            width:40%; 
            border:solid black 2px; 
            border-radius:10px;
            padding: 40px;
        }

        @media (max-width: 750px) {
            .notransition{
                display:none;
            }
           
            .formlogoimg{
                margin-top:5px;
            }
            .site-menu-toggle{
                display:none;
            }
            .logincont{
                width:90%; 
            }
        }
        .manfooter{
            display:none;
        }
        .center {
              display: flex;
              justify-content: center;
              align-items: center;
        }
        
    </style>

    <script>
        $(function () {
            $(".signinbtndummy").click(function () {
                $(".btnLogin").click();
            })
        })
    </script>
    <script runat="server">
        protected void Page_PreInit(object sender, EventArgs e)
        {
            
        }
    </script>
    <script>
        $(function () {
            $(".sitenav, .headerImg").hide();
        })
    </script>
    <div class="">
    
    <%--<cc2:LoginControl ID="LoginControl" runat="server"></cc2:LoginControl>    --%>
    
    
    <%--<div style="clear: both;">
        <span style="width:100px;float:left;">&nbsp;</span>
        <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />
    </div>--%>
    <%--<cc1:InfoDiv ID="InfoDiv1" Visible="false" isError="true" runat="server">Username or password is incorrect.</cc1:InfoDiv>--%>
        <br />
<%--    <cc2:LoginControl ID="LoginControl" ForgotPasswordText="forgot" runat="server">
    </cc2:LoginControl>--%>
     
<%--    <uc1:TimeEntry runat="server" ID="TimeEntry" />--%>
        </div>

        <div class="row" style="justify-content:center">
            <div class="logincont" >
            <div class="formsec formlogoimg">
                <img src="/images/2016_DCO_BOE_Short_Version.jpg" width="60%" />
            </div>

    <asp:Panel ID="pnlresetPassword" runat="server">            
  <!-- Email input -->
        
  <div class="form-outline mb-4 emailsec">
    <asp:TextBox ID="email" TextMode="Email" Text="" CssClass="form-control" runat="server"/>
    <label class="form-label" for="form2Example1">Email address</label>
  </div>



  <!-- 2 column grid layout for inline styling -->


  <!-- Submit button -->
  <asp:Button ID="sendEmail" CssClass="btn btn-primary btn-block mb-4 signinbtndummy" runat="server" Text="Set Password" OnClick="sendEmail_Click" />
        <div class="hidden">
            
        </div>
        <cc1:InfoDiv ID="InfoDiv1" Visible="false" isError="true" runat="server">Username not found.</cc1:InfoDiv>
    
  <!-- Register buttons -->
  <%--<div class="text-center">
    <p>Not a Precinct Official? <a href="/usersignup.aspx">Sign-Up!</a></p>
    </div>--%>
        
      </asp:Panel>



     <asp:Panel ID="pnlresetPasswordConfirm" Visible="false" runat="server">
         <script>
             $(function () {
                 $(".pwtb").keyup(function () {
                     var tb1 = $(".pwtb1").val();
                     var tb2 = $(".pwtb2").val();
                     if (tb1 == tb2 && tb1.length > 5)
                         $(".btnSetPassword").prop("disabled", false);
                 })
             })

         </script>
          <!-- Password input -->
    <br />
  <div class="form-outline mb-4">
    <asp:TextBox ID="tbPassword" TextMode="Password" Text="Password1234" CssClass="form-control pwtb pwtb1" runat="server"/>
    <label class="form-label" for="form2Example2">Enter Password</label>
  </div>  <!-- Password input -->
  <div class="form-outline mb-4">
    <asp:TextBox ID="tbPasswordConfirm" TextMode="Password" Text="Password1234" CssClass="form-control pwtb pwtb2" runat="server"/>
    <label class="form-label" for="form2Example2">Confirm Password</label>
  </div >
    <div class="form-outline center">
        <p class="text-danger">Password must be at least 6 characters in length</p>
    </div>
         <br />
       <div class="center">
        <asp:Button ID="btnSetPassword" CssClass="btn btn-primary" runat="server" OnClick="btnSetPassword_Click" Text="Set Password" Enabled="false" />
       </div>
    </asp:Panel>



                </div>
            </div>
  

    
   
</asp:Content>
