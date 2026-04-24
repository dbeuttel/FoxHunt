    <%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UCFilter.ascx.cs" Inherits="FoxHunt.userControlsMain.UCFilter" %>
    <%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>
    <%--<asp:DropDownList width="180px" ID="ddElectionID" runat="server" title="ElectionID" AutoPostBack="True" Value="NULL" OnSelectedIndexChanged="ddElectionID_SelectedIndexChanged" />--%>

    <style>        
        .filterSection{
            background-color: whitesmoke;
            margin-bottom: 10px;
            border-radius: 10px;
            padding: 5px;
        }
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
        .my-auto {
            margin-top:0px!important;
        }
        </style>

    <script type="text/javascript">
        var urlParams = new URLSearchParams(window.location.search);
        var selected = "";
        $(function () {
            

            var searchList = $('#peopleList li');
            $('.filterVal').change(function () {
                var outStr = '';
                var titles = '';
                var searchedItems = $("#peopleList li").toArray();
                $('.filterSection').each(function () {
                    var SearchList = [];
                    $(this).find('.filterVal').each(function () {
                        if ($(this).prop('checked') == true) {
                            SearchList.push($(this).attr('filterVal'));
                        } 
                    })
                    if (SearchList.length > 0)
                        searchedItems = searchArray(searchedItems, SearchList)

                //$('.filterVal').change(function () {
                //var outStr = '';
                //var titles = '';
                //$('.filterVal').each(function () {
                //    if ($(this).prop('checked') == true) {
                //        if (titles.indexOf($(this).attr('title') + ',') === -1)
                //            outStr += '#'
                //        outStr += $(this).attr('filterVal') + ','
                //        titles += $(this).attr('title') + ','
                //    }
                //})

                //$('.searchVals').val(outStr + $('#peopleFilter').val())
                ////doSearch(outStr + $('#peopleFilter').val());
                //search(outStr + $('#peopleFilter').val());
                ////alert(outStr)
                })
                $('#peopleList li').hide()
                searchedItems.forEach((item) => {
                    $(item).show()
                })
                //console.log(searchedItems);
            })
            
                function removeItems(arr, value) {
                    var i = 0;
                    while (i < arr.length) {
                        if (arr[i] === value) {
                            arr.splice(i, 1);
                        } else {
                            ++i;
                        }
                    }
                    return arr;
                }

                function searchArray(itemList, filterList) {
                    var itemsOut = itemList.slice();
                    itemList.forEach((item) => {
                        var removeItem = true;
                        var itemText = $(item   ).text().toLowerCase();
                        filterList.forEach((filter) => {
                            if (itemText.indexOf(filter.toLowerCase()) > -1)
                                removeItem = false;
                        })
                        if (removeItem)
                            itemsOut = removeItems(itemsOut, item);
                    })
                    return itemsOut;
                }

            var Url = window.location.href;
            var locationQS = '';
            locationQS = Url.substring(Url.indexOf('pp:') + 3, Url.indexOf('&selectedDate='))
            if (Url.indexOf('pp%3a') > 0)
                locationQS = Url.substring(Url.indexOf('pp%3a') + 5, Url.indexOf('&selectedDate='))

            $('.filt-' + locationQS).prop('checked', true)

            $('.overrideOption').each(function () {
                var getI = $(this).attr('filterName')
                $(this).attr('filterVal', $('.' + getI).attr('filterVal'))
            })


            function search(searchStr) {
                var targetList = $('#peopleList li');
                var filters = searchStr.split('#').map(function (item) {
                    return item.trim().toLowerCase(); // Clean and lowercase each filter
                });

                // Loop through the items in the target list
                targetList.each(function () {
                    var itemText = $(this).text().toLowerCase(); // Get the text of the current list item
                    var match = true;
                    var matchAnd = false;

                    // Check if the item contains all filters, IF ANYTHING IS NOT FOUND HIDE IT
                    if (filters[0] == '') {
                        matchAnd = true;
                    }
                    else {
                        for (var i = 0; i < filters.length; i++) {
                            if (filters[i] != '') {
                                if(filters)
                                var andOr = filters[i].split('-')[0];
                                var filter = filters[i].split('-')[1];

                                if (andOr == 'o') {
                                    if (itemText.indexOf(filter) > 0) {
                                        matchAnd = true;
                                    }
                                }
                                else {
                                    if (itemText.indexOf(filter) === -1) {
                                        match = false;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                

                    //// Check if the item contains all filters, IF ANYTHING IS NOT FOUND HIDE IT
                    //for (var i = 0; i < filters.length; i++) {
                    //    if (itemText.indexOf(filters[i]) === -1) {
                    //        match = false;
                    //        break;
                    //    }
                    //}

                    // Show or hide the list item based on whether it matches all filters
                    if (matchAnd && match) {
                        $(this).show();
                    } else {
                        $(this).hide();
                    }
                });
            }

            // Event listener for the search button
            $('#searchButton').click(function () {
                var searchStr = $('#searchInput').val(); // Get the comma-delimited search string from input
                var targetList = $('#targetList li'); // Get all list items
                search(targetList, searchStr); // Call the search function
            });

            function doSearch(str) {
                //Move up to listcontainer
                var targetList = $('#peopleList li');
                //find search text within the listcontainer
                var filterList = str.split(',');
                //hide all 'li' elements in the listcontainer
                targetList.hide()
                //foreach over each search param in the comma delimited list
                for (i = 0; i < filterList.length; i++) {
                    //remove empty string at end
                    if (filterList[i] != "") {
                        //search param 
                        var filter = filterList[i];
                        //search through each 'li' element to find any that contain the var filter
                        targetList.each(function () {
                            if ($(this).text().search(new RegExp(filter, "i")) > 0) {
                                //if exists, show it
                                $(this).show()
                            }
                        });
                    }
                }
                //If search bar goes to empty and search is hit, default to all items
                if (filterList == "")
                    targetList.show()
            }

            $(".btnSearch").click(function () {
                createSearchList($(this))

                var targetList = $(this).parent().parent();
                var filterList = targetList.find('.tbSearch').val().split(',');
                var items = [];
                items = targetList.find('ol li');
                var hideOrShow = new Array(items.length).fill(false);

                for (i = 0; i < filterList.length; i++) {
                    if (filterList[i] != "") {
                        var filter = filterList[i];
                        items.each(function (index) {
                            if ($(this).text().search(new RegExp(filter, "i")) > 0) {
                                hideOrShow[index] = (true);
                            }

                        });
                    }
                }

                items.each(function (index) {
                    if (hideOrShow[index] == true)
                        $(this).show()
                    else
                        $(this).hide()
                })


                if (filterList == "")
                    targetList.find('ol li').show()
            });

        
        })    
    </script>

    <asp:Panel runat="server" ID="pnlCommentFeature" Visible="false">
        <script>
            $(function () {
            
            })
        </script>
    </asp:Panel>

   <div class="toggleFilter  formsec" data-bs-toggle="offcanvas" data-bs-target="#offcanvasEnd" aria-controls="offcanvasEnd">
       <i class="menu-icon tf-icons bx bx-filter" style="color:white;"></i>
   </div>


    <div class="offcanvas offcanvas-end " tabindex="-1" id="offcanvasEnd" aria-labelledby="offcanvasEndLabel" aria-modal="true" role="dialog">
        <div class="offcanvas-header formsec">
            <h5 id="offcanvasEndLabel" class="offcanvas-title ">Filters</h5>
            <span class="pull-right"><button type="button" class="btn-close text-reset " data-bs-dismiss="offcanvas" aria-label="Close"></button></span>
        </div>
        <div class="offcanvas-body my-auto mx-0 flex-grow-0">
    
    
    <%--fore var in str list of filters (title,roles,name~title,extuser,party~AM / PM,OVERRIDE,AM#PM)--%>

    <%--<input type="text" class="searchVals" />--%>
    <%--<div class="row">
        <div class="col-12 formsec">
            <h4>Filters</h4>
            <hr />
        </div>
    </div>--%>
    <%foreach(var filter in filterList.Split('~')) {
            string title = filter.Split(',')[0];
            string table = filter.Split(',')[1];
            string column = filter.Split(',')[2];
            %>
    <div class="row <%=column %>">
        <div class="col-12 ">
            <div class="filterSection">
                <div class="row ">
                    <div class="col-12 formsec ">
                        <h4><%=title %></h4>
                    </div>
                    <div class="col-12 ">
                        <%if(table != "OVERRIDE"){ %>
                            <%foreach(System.Data.DataRow r in getData(table,column).Rows ){ 
                                    if(r[column].ToString() != ""){%>
                                <div class="row">
                    
                                    <div class="col-2 formsec "><input type="checkbox" title="<%=title %>" class="filterVal filt-<%=r[column] %>" filterVal="<%=r[column] %>" /></div>
                                    <div class="col-10"><%=r[column] %></div>
                                </div>
                                    <%}
                            } %>
                        <%}else{ %>
                            <%if(column.Split('#').Length > 0){ %>
                                <%foreach(var opt in column.Split('#')){ %>                            
                                    <div class="row">                    
                                        <div class="col-2 formsec" ><input type="checkbox" title="<%=title %>" class="filterVal overrideOption filt-<%=opt %>" table="<%=table %>" filterName="<%=table %>-<%=opt %>"/></div>
                                        <div class="col-10" ><%=opt %></div>
                                    </div>
                                  <%}
                               } %>
                        <%} %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%} %>


        </div>
    </div>


<%--DATA SECTION--%>
<%--<div class="dtTimeslots hidden">
            <%var check = "";
                foreach (System.Data.DataRow r in dtTimeslots.Select("RoleName = 'Assistant Site Coordinator'"))
                {
                    var sDate = DateTime.Parse(r["startDate"].ToString());
                    var eDate = DateTime.Parse(r["endDate"].ToString());
                    if (!check.Contains(r["startDate"].ToString() + ","))
                    {
                    %>
            <span class="dtTimeslots OVERRIDE-<%=sDate.ToString("tt") %>" filterVal="<%=sDate.ToString("h:mm tt") %> - <%=eDate.ToString("h:mm tt") %>" filterName="<%=sDate.ToString("tt") %>"></span>
                        
                        
            <br />
                    <%
                        check += r["startDate"].ToString() + ",";        
                    }
                }%>
        </div>

        <div class="dtLocations hidden">
            <%var checkL = "";
                bool ED = true;
                if (Request.QueryString["site"] != "pp")
                        ED = false;
                foreach (System.Data.DataRow r in Data.getVotingLocation(ED))
                {
                    
                    if (!checkL.Contains(r["lbl"].ToString() + ","))
                    {
                    %>
                        <%if (Request.QueryString["site"] != "pp")
                            { %>
                            <span class="dtTimeslots OVERRIDE-<%=r["lbl"].ToString() %>" checkVal="<%=r["lbl"].ToString() %>" filterVal="<%=r["name"].ToString() %>" filterName="<%=r["lbl"].ToString() %>"></span>
                        <%}else{%>
                            <span class="dtTimeslots OVERRIDE-<%=r["lbl"].ToString() %>" filterVal="<%=r["lbl"].ToString() %>" filterName="<%=r["lbl"].ToString() %>"></span>
                        <%} %>
                        
                        
            <br />
                    <%
                        checkL += r["lbl"].ToString() + ",";        
                    }
                }%>
        </div>--%>