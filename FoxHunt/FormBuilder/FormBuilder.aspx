<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="FormBuilder.aspx.cs" Async="true" Inherits="FoxHunt.FormBuilderPage" EnableEventValidation="false"%>
<%@ Register Assembly="Reporting" Namespace="Reporting" TagPrefix="DTI" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>
<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <style>
        .fcOverride{
            margin-top:0px!important;
        }
        .form-container {
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
        }

        .field-item {
            padding: 10px;
            margin-bottom: 5px;
            border: 1px dashed #888;
            background: #f9f9f9;
            cursor: move;
        }

        .subform-container {
            margin-left: 20px;
            border-left: 2px solid #aaa;
            padding-left: 10px;
        }

        .drop-hover {
            border-color: #3498db !important;
            background: #eaf4ff;
        }
    </style>

   <script>
       $(function () {
           $(".form-container").sortable({
               items: ".field-item",
               placeholder: "drop-hover",
               stop: function (event, ui) {
                   var order = [];
                   $(".field-item").each(function () {
                       order.push($(this).data("id"));
                   });

                   // Set hidden field value
                   $("#<%= hfQuestionOrder.ClientID %>").val(order.join(","));
                console.log("New order: " + order.join(","));

                // Optional: auto-save on drag
                __doPostBack('<%= btnSaveOrder.UniqueID %>', '');
            }
        });
    });
   </script>



    <div class="row">
        <div class="col-md-10">

            <!-- Hidden field to track order -->
        <asp:HiddenField ID="hfQuestionOrder" runat="server" />
<div class="form-container">
<asp:Repeater ID="rptQuestions" runat="server" OnItemDataBound="rptQuestions_ItemDataBound">
    <ItemTemplate>
        <div class="quiz-card field-item"" data-id='<%# Eval("Id") %>' style="margin-bottom:10px; padding:10px; border-radius:8px; box-shadow:0 2px 5px rgba(0,0,0,0.1); background:#fff;">
            
            <div class="row">
                <div class="col-md-8">
                <!-- Question Textbox -->
                    <asp:TextBox ID="txtQuestionText" runat="server" Text='<%# Eval("QuestionText") %>' Style="flex:0 0 70%; padding:6px; font-size:14px;" CssClass="form-control "></asp:TextBox>
                    
                </div>

                <div class="col-md-3 align-content-center">
                <!-- Question Type Dropdown -->
                    <asp:DropDownList ID="ddlQuestionType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlQuestionType_SelectedIndexChanged" CssClass="form-control"
                                      Style="flex:0 0 20%;">
                        <asp:ListItem Text="SingleChoice" Value="SingleChoice"></asp:ListItem>
                        <asp:ListItem Text="MultiChoice" Value="MultiChoice"></asp:ListItem>
                        <asp:ListItem Text="YesNo" Value="YesNo"></asp:ListItem>
                        <asp:ListItem Text="LongText" Value="LongText"></asp:ListItem>
                        <asp:ListItem Text="Number" Value="Number"></asp:ListItem>
                        <asp:ListItem Text="Checkbox" Value="Checkbox"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="col-md-1">
                    <!-- Delete Question Button -->
                    <asp:Button ID="btnDeleteQuestion" runat="server" Text="X" CssClass="btn btn-danger" OnClick="btnDeleteQuestion_Click" Style="flex:0 0 10%; margin-top:15px;" />
                </div>
            </div>
            
                    <!-- Options panel for choice questions -->
                    <asp:Panel ID="pnlOptions" runat="server" Visible="false" Style="margin-top:10px;">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-10"><h5 style="margin:5px 0;">Options</h5></div>
                        </div>
                        <asp:Repeater ID="rptOptions" runat="server">
                            <ItemTemplate>

                                <div class="row">
                                    <div class="col-md-1"></div>
                                    <div class="col-md-9">
                                        <asp:TextBox ID="txtOption" runat="server" Text='<%# Container.DataItem %>' CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="col-md-1 centerContent">
                                        <asp:Button ID="btnDeleteOption" runat="server" Text="X" CssClass="btn btn-danger btn-sm" OnClick="btnDeleteOption_Click" Style="margin-top:15px;" />
                                    </div>
                                </div>

                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Button ID="btnAddOption" runat="server" Text="Add Option" OnClick="btnAddOption_Click" Style="margin-top:5px;" />
                    </asp:Panel>
                    <!-- END Options panel for choice questions -->

        </div>
    </ItemTemplate>
</asp:Repeater>
    <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" OnClick="btnAddQuestion_Click" Style="margin-bottom:15px;" />
    </div>




        </div>

        <div class="col-md-2">
            <div class="card">
                <%--<asp:Button runat="server" ID="btnSave" Text="Submit" CssClass="btn btn-primary w-100" OnClientClick="return verifySubmission()" OnClick="btnSave_Click" />--%>
                <asp:Button ID="btnSaveOrder" runat="server" OnClick="btnSaveOrder_Click" Style="display:none;" />

            </div>
        </div>
    </div>

</asp:Content>