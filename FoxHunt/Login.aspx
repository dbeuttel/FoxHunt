<%@ Page Title="" Language="C#" MasterPageFile="~/Site1LoggedOut.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="FoxHunt.Login" %>
<%@ Register Assembly="DTIControls" Namespace="DTIAdminPanel" TagPrefix="cc2" %>
<%@ Register assembly="DTIControls" namespace="JqueryUIControls" tagprefix="cc1" %>

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
/*        .logincont{
            width:40%; 
            border:solid black 2px; 
            border-radius:10px;
            padding: 40px;
        }*/

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
                <img src="/images/logo.png" width="60%" />
            </div>
            
    <form>
  <!-- Email input -->
        <cc1:InfoDiv ID="InfoDiv1" Visible="false" isError="true" runat="server">Username or password is incorrect.</cc1:InfoDiv>
  <div class="form-outline mb-4 emailsec">
    <asp:TextBox ID="tbUsername" Text="" CssClass="form-control" runat="server"/>
    <label class="form-label" for="form2Example1">Email address</label>
  </div>

  <!-- Password input -->
  <div class="form-outline mb-4">
    <asp:TextBox ID="tbPassword" TextMode="Password" Text="" CssClass="form-control" runat="server"/>
    <label class="form-label" for="form2Example2">Password</label>
  </div>

  <!-- 2 column grid layout for inline styling -->


  <!-- Submit button -->
  <div class="row">
      <div class="col-12 formsec">
          <button type="button" class="btn btn-primary btn-block mb-4 signinbtndummy" >Sign in</button>
      </div>
  </div>
        <p style="width: 100%; text-align: center; margin-bottom: 20px;">Not a current Precinct Official?<br /><a href="/usersignup.aspx">Sign-Up!</a></p>
        <%--<a href="/usersignup.aspx" class="btn btn-primary btn-block mb-4" style="text-decoration:none">Sign-Up!</a>--%>
        <div class="hidden">
            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />
        </div>
          <div class="row formsec">
      <a href="ResetPassword.aspx">Forgot password?</a>
  </div>
    
  <!-- Register buttons -->
<%--  <div class="text-center">
    <p>Not a Precinct Official? <a href="/usersignup.aspx">Sign-Up!</a></p>
    </div>--%>
        
  
</form>
                </div>
            </div>
  

  
</asp:Content>