<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ajaxFilter.ascx.cs" Inherits="FoxHunt.userControlsMain.ajaxFilter" %>

<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>


 <style>
     .offcanvas-header{padding-bottom: 0px;}

        .filterSpace{
            width:100%;
            font-size: small;
        }
        h5{text-align:center;}
        .section{
            background-color: white;
            border-radius: 10px;
            padding: 5px 15px 5px 10px;
            margin: 5px;
        }
        .column{
            height: 100%!important;
            /*height: 610px!important;*/
            /*overflow:scroll;
            overflow-x: hidden;*/
        }
        .selector, .clearFilters{cursor:pointer;}
        .toggleFilter{
            right: 0px;
            position: fixed;
            z-index: 100;
            font-size: large;
            height: 40px;
            width: 35px;
            background-color: black;
            top: 50%;
            border-radius: 10px 0px 0px 10px;
            cursor:pointer;
        }
        /* width */
::-webkit-scrollbar {
  width: 10px;
}

/* Track */
::-webkit-scrollbar-track {
  box-shadow: inset 0 0 5px grey; 
  border-radius: 10px;
}
 
/* Handle */
::-webkit-scrollbar-thumb {
  background: #888; 
  border-radius: 10px;
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background: #555; 
}
.my-auto {
            margin-top:0px!important;
        }
        .input{cursor:pointer;}        
    </style>

    <script>
        $(function () {
            var startView = '';
            $('.starter').each(function () {
                startView += $(this).attr('data-id') + ',';
            });


            $('.filterClearer').hide()

            var optSel = false;
            $(".selector").change(function () {
                var section = $(this).parent().parent()
                var outStr = '';
                section.find('.selector').each(function () {
                    if ($(this).prop('checked') == true) {
                        outStr += $(this).attr('id') + ','
                        optSel = true;
                        $('.filterClearer').show()
                    }
                })
                section.find('.sectionText').val(outStr.trim(','))

                if ($('.selector:checked').length < 1)
                    $('.clearFilters').click()
                else
                    aggregateList()
            })

            $('.clearFilters').click(function () {
                $(".selector").each(function () {
                    $(this).prop('checked', false);
                })
                filter(startView);
                $('.filterClearer').hide()
            })

            //setFilters();
        })

        function aggregateList() {
            var tbOut = '';
            $('.sectionText, .staffBoard').each(function () {
                if ($(this).val() != '')
                    tbOut += $(this).attr('section') + '~' + $(this).val() + '|';
            })
            $('.tbOut').val(tbOut.trim('|'));
            ajaxcallSendList(tbOut.trim('|'));
        }

        //function setFilters() {
        //    var filSel = $('.tbOut').val().split('|');
        //    for (i = 0; i < filSel.length; i++) {
        //        var item = filSel[i].toString()
        //        if (item != '') {
        //            var deets = item.split('~');
        //            //alert(deets.split(',')[0])
        //            $('.workspace').find('[section="' + deets[0] + '"]').val(deets[1])
        //        }
        //    }

        //    $('.sectionText, .staffBoard').each(function () {
        //        var ids = $(this).val().split(',')
        //        for (i = 0; i < ids.length; i++) {
        //            var id = ids[i].toString()
        //            if (id != '') {
        //                $(this).parent().find('input').each(function () {
        //                    if ($(this).attr('id') == id)
        //                        $(this).prop('checked', true)
        //                })
        //                //alert(id)                        
        //            }
        //        }
        //    })

        //    var ids = $('.specAdd').val().split(',')
        //    for (i = 0; i < ids.length; i++) {
        //        var id = ids[i].toString()
        //        if (id != '') {
        //            $('.acFindUser').before('<span class="userAdded"><i class="fa fa-times removeUser" id="' + id + '" style="color:red; cursor:pointer;"></i> ' + $('.row' + id).attr('name') + '<br/> </span>')
        //            //alert($('.row'+id).attr('name'))  
        //        }
        //    }

        //    $('.templateSelector').each(function () {
        //        if ($(this).prop('checked') == true) {
        //            var category = $(this).attr('category').toLowerCase()
        //            if (category == 'events') {
        //                $(this).parent().after($('.eventSelector'));
        //                $('.eventSelector').show()
        //            }
        //        }
        //    })

        //    if ($('.eventSelection').val() != '') {
        //        $('.eventSelector').val($('.eventSelection').val())
        //    }
        //}


        //Return Functions, next 2 functions
        function SendListReturn(val) {
            //if (val == 'default')
            //    $('.clearFilters').click()
            //else
            filter(val);
            $(".acFindUser").val('')
            //alert(val)
        }

        function filter(val) {
            $('.extUser').hide();
            var rows = val.split(',');
            for (i = 0; i < rows.length; i++) {
                $('.starter.row' + rows[i]).show()
            }
        }

        //Add Individuals ad hoc
        $(function () {

            $(".acFindUser").bind("autocompleteselect", function (event, ui) {
                //showProfile(ui.item.id);
                var section = $(this).parent().parent()
                var startStr = $('.sectionText').val();
                var outStr = ui.item.id;

                if (startStr != '')
                    startStr = startStr + ',';
                $('.specAdd').val(startStr + outStr)

                aggregateList()

                $(this).before('<span class="userAdded"><i class="fa fa-times removeUser" id="' + ui.item.id + '" style="color:red; cursor:pointer;"></i> ' + ui.item.label + '<br/> </span>')
                //specAdd
                return true;
                //$(this).val('')
            });

            $(".section").on("click", '.removeUser', function () {
                var id = $(this).attr('id');
                var startStr = $('.specAdd').val();
                var outStr = '';
                var inArr = startStr.split(',');
                for (i = 0; i < inArr.length; i++) {
                    if (inArr[i].toString() != id.toString() && inArr[i].toString() != '')
                        outStr += inArr[i] + ',';
                }
                $('.specAdd').val(outStr.trim(','));
                $(this).parent().remove();
                aggregateList()
            })
        })
    </script>

    <cc1:AjaxCall ID="ajaxcallSendList" OncallBack="ajaxcallSendList_callBack" jsReturnFunction="SendListReturn" runat="server">
    </cc1:AjaxCall>

<div class="toggleFilter  formsec" data-bs-toggle="offcanvas" data-bs-target="#offcanvasEnd" aria-controls="offcanvasEnd">
       <i class="menu-icon tf-icons bx bx-filter" style="color:white;"></i>
   </div>
    <div class="offcanvas offcanvas-end " tabindex="-1" id="offcanvasEnd" aria-labelledby="offcanvasEndLabel" aria-modal="true" role="dialog">
        <div class="offcanvas-header formsec">
            <h5 id="offcanvasEndLabel" class="offcanvas-title ">Filters</h5>
            <span class="pull-right"><button type="button" class="btn-close text-reset " data-bs-dismiss="offcanvas" aria-label="Close"></button></span>
        </div>
        <div class="offcanvas-body my-auto mx-0 flex-grow-0">

            <asp:TextBox runat="server" ID="tbOut" CssClass="hidden"></asp:TextBox>



            <%--<asp:Panel runat="server" ID="pnlNewShit" Visible="true">--%>




                <div class="filterSpace">
                    <div class="ajaxOuterDiv">
                        <div class="row">
                            <div class="col-12">

                                <div class="column1 column">
                                    <div class="row">
            <div class="col-12 centerContent">
                <%--<h4>Filters</h4>--%>
                <span class=" filterClearer">Clear Filters <i class="fa fa-times clearFilters " style="color:red;"></i></span>
                <hr />
            </div>
        </div>
                                    <asp:Panel runat="server" ID="pnlOverride" Visible="false">
                                        <div class="override section">
                                            <cc1:Autocomplete  ID="acFindUser" runat="server" MinLength="1" CssClass="" ></cc1:Autocomplete><br />
                                            <label>Add Recipient</label>
                                            <input type="text" section="specAdd" class="specAdd sectionText hidden" />
                                        </div>
                                    </asp:Panel>

                                    <asp:Panel runat="server" ID="pnlStatus" Visible="false">
                                        <div class="status section">
                                            <h5>Status</h5>
                                            <%foreach (System.Data.DataRow r in dtStatus.Rows) { %>
                                                <span><input type="checkbox" class="selector" id="'<%=r["status"] %>'" />&nbsp; <span><%=r["status"] %><br /></span></span>
                                            <%} %>
                                            <%--<asp:TextBox runat="server" ID="tbRoles" CssClass="hidden inputInfo"></asp:TextBox>--%>
                                            <input type="text" section="status" class="sectionText hidden" />
                                        </div>
                                    </asp:Panel>

                                    <asp:Panel runat="server" ID="pnlAge" Visible="false">
                                        <div class="age section">
                                            <h5>Age</h5>
                                            <span><input type="checkbox" class="selector" id="1" />&nbsp <span>18 - 24</span></span><br />
                                            <span><input type="checkbox" class="selector" id="2" />&nbsp <span>25 - 34</span></span><br />
                                            <span><input type="checkbox" class="selector" id="3" />&nbsp <span>35 - 44</span></span><br />
                                            <span><input type="checkbox" class="selector" id="4" />&nbsp <span>45 - 54</span></span><br />
                                            <span><input type="checkbox" class="selector" id="5" />&nbsp <span>55 - 64</span></span><br />
                                            <span><input type="checkbox" class="selector" id="6" />&nbsp <span>65+</span></span><br />
                                            <input type="text" section="age" CssClass="selector" class="sectionText hidden" />
                                        </div>
                                    </asp:Panel>

                                    <asp:Panel runat="server" ID="pnlParty" Visible="false">
                                        <div class="party section">
                                            <h5>Party</h5>
                                            <%foreach (System.Data.DataRow p in dtParty.Rows) { %>
                                                <span><input type="checkbox" class="selector" id="'<%=p["party_desc"] %>'" />&nbsp; <%=p["party_desc"] %></span><br />
                                            <%} %>
                                            <%--<asp:TextBox runat="server" ID="tbParty" CssClass="hidden inputInfo"></asp:TextBox>--%>
                                            <input type="text" section="party" class="sectionText hidden" />
                                        </div>
                                    </asp:Panel>

                                    <asp:Panel runat="server" ID="pnlShift" Visible="false">
                                        <div class="techScore section">
                                            <h5>Shift Availability</h5>
                                            <span><input type="checkbox" class="selector" id="'%AM%'" />&nbsp <span>Morning</span></span><br />
                                            <span><input type="checkbox" class="selector" id="'%PM%'" />&nbsp <span>Afternoon</span></span><br />
                                            <input type="text" section="availability" class="sectionText hidden" />
                                        </div>
                                    </asp:Panel>

                                    <asp:Panel runat="server" ID="pnlTechScore" Visible="false">
                                        <div class="techScore section">
                                            <h5>Tech Score</h5>
                                            <%--<%foreach (System.Data.DataRow t in dtTechScore.Rows) { %>--%>
                                            <%foreach (var t in dtTechScore.Split(',')) { %>
                                                <span><input type="checkbox" class="selector" id="'<%=t %>'" />&nbsp; <%=t %></span><br />
                                                <%--<span><input type="checkbox" class="selector" id="'<%=t["score"] %>'" />&nbsp; <%=t["score"] %></span><br />--%>
                                            <%} %>
                                            <%--<asp:TextBox runat="server" ID="tbtechScore" CssClass="hidden inputInfo"></asp:TextBox>--%>
                                            <input type="text" section="score" class="sectionText hidden" />
                                        </div>
                                    </asp:Panel>

                                    <asp:Panel runat="server" ID="pnlInterests" Visible="false">
                                        <div class="interests section">
                                            <h5>Work Interests</h5>
                                            <span><input type="checkbox" class="selector" id="'%ED%'" />&nbsp <span>Election Day</span></span><br />
                                            <span><input type="checkbox" class="selector" id="'%Worker%','%SC%'" />&nbsp <span>Early Voting</span></span><br />                    
                                            <span><input type="checkbox" class="selector" id="'%SC%'" />&nbsp <span>Site Coordinator</span></span><br />
                                            <span><input type="checkbox" class="selector" id="'%BOE Office%'" />&nbsp <span>Office</span></span><br />
                                            <span><input type="checkbox" class="selector" id="'%BOE Warehouse%'" />&nbsp <span>Warehouse</span></span><br />
                                            <input type="text" section="interests" CssClass="selector" class="sectionText hidden" />
                                        </div>
                                    </asp:Panel>

                                    <asp:Panel runat="server" ID="pnlEVSite" Visible="false">
                                        <div class="evSite section">
                                            <h5>Site Preference</h5>
                                            <%foreach (System.Data.DataRow ev in dtSites.Rows) { %>
                                                <span><input type="checkbox" class="selector filt-<%=ev["lbl"] %>" id="'%<%=ev["name"].ToString().Replace("UNITARIAN UNIVERSALIST FELLOWSHIP", "").Replace("KARSH ALUMNI CENTER", "").Replace("DURHAM COUNTY ", "") %>%'" />&nbsp; <%=ev["name"].ToString().Replace("UNITARIAN UNIVERSALIST FELLOWSHIP", "").Replace("KARSH ALUMNI CENTER", "").Replace("DURHAM COUNTY", "") %></span><br />
                                            <%} %>
                                            <%--<asp:TextBox runat="server" ID="tbSites" CssClass="hidden inputInfo"></asp:TextBox>--%>
                                            <input type="text" section="evSite" class="sectionText hidden" />
                                        </div>
                                    </asp:Panel>

                                    <asp:Panel runat="server" ID="pnlPrecincts" Visible="false">
                                        <div class="precincts   section" >
                                            <h5>Home Precincts</h5>
                                                <%foreach (System.Data.DataRow ed in dtPrecincts.Select("lbl <> 'admin'")) { %>
                                                    <span><input type="checkbox" class="selector filt-<%=ed["lbl"] %>" id="'<%=ed["lblID"] %>'" />&nbsp; <%=ed["lbl"] %></span><br />
                                                <%} %>
                                                <%--<asp:TextBox runat="server" ID="tbPrecincts" CssClass="hidden inputInfo"></asp:TextBox>--%>
                                            <input type="text" section="precinct" class="sectionText hidden" />
                                        </div>
                                    </asp:Panel>

                                    <asp:Panel runat="server" ID="pnlRoles" Visible="false">
                                        <div class="roles section">
                                            <h5>Roles</h5>
                    
                                            <%foreach (System.Data.DataRow r in dtRoles.Select("priority > 0 and roleType = 'Election'")) { %>
                                                <span><input type="checkbox" class="selector" id="<%=r["id"] %>"  />&nbsp; <span><%=r["name"] %><br /></span></span>
                                            <%} %><hr />
                                            <%foreach (System.Data.DataRow r in dtRoles.Select("priority > 0 and roleType <> 'Election'")) { %>
                                                <span><input type="checkbox" class="selector" id="<%=r["id"] %>"  />&nbsp; <span><%=r["name"] %><br /></span></span>
                                            <%} %>
                                            <%--<asp:TextBox runat="server" ID="tbRoles" CssClass="hidden inputInfo"></asp:TextBox>--%>
                                            <input type="text" section="roles" class="sectionText hidden" />
                                        </div>
                                    </asp:Panel>

                                    <asp:Panel runat="server" ID="pnlAssignments" Visible="false">
                                        <div class="assignments  section" >
                                            <h5>Assignments</h5>
                                                <%foreach (System.Data.DataRow ev in dtSites.Rows) { %>
                                                    <span><input type="checkbox" class="selector" id="<%=ev["id"].ToString() %>" />&nbsp; <%=ev["lbl"].ToString() %></span><br />
                                                <%} %>
                                            <hr />
                                                <%foreach (System.Data.DataRow ed in dtPrecincts.Rows) { %>
                                                    <span><input type="checkbox" class="selector" id="<%=ed["id"] %>" />&nbsp; <%=ed["lbl"] %></span><br />
                                                <%} %>
                                                <%--<asp:TextBox runat="server" ID="tbPrecincts" CssClass="hidden inputInfo"></asp:TextBox>--%>
                                            <input type="text" section="assignments" class="sectionText hidden" />
                                        </div>
                                    </asp:Panel>

                                    <%--Close Column1 (Scrollable area)--%>
                                    </div>
                        
                            <%--Close the Col--%>
                            </div>
                        <%--Close the Row--%>
                        </div>
                    <%--Close the outerDiv--%>
                    </div>
                <%--Close the workspace--%>
                </div>
        </div>
    </div>

    <%--</asp:Panel>--%>