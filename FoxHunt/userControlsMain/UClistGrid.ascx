<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UClistGrid.ascx.cs" 
    Inherits="FoxHunt.userControlsMain.UClistGrid" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>


	<style>
     .history{
         color:white;
     }
     .headcol{
         text-align:center;
         justify-content:center;
         display:grid;
     }
     
     .formsec{
         text-align:center;
         justify-content:center;
         margin-bottom:5px;
     }
     h1{
         color:black; 
         text-align:center;
     }
     
     .btn-group{
         flex-wrap: wrap;
     }
     
    .hovertext {
  position: relative;
  border-bottom: 1px dotted black;
}

.hovertext:before {
  content: attr(data-hover);
  visibility: hidden;
  opacity: 0;
  width: 250px;
  background-color: black;
  color: #fff;
  text-align: center;
  border-radius: 5px;
  padding: 5px 0;
  transition: opacity 1s ease-in-out;

  position: absolute;
  z-index: 1;
  left: 0;
  top: 110%;
}

.hovertext:hover:before {
  opacity: 1;
  visibility: visible;
}
.updatebar{
    text-align:center;
    display:none;
}
h3{
    margin-left: 15px;
}

/*START List/Grid*/
/*body {
  font-family: 'Helvetica';
  background-color: #0e2439;
}*/

.filter-buttons {
  display: flow-root;  
  margin-bottom: -20px;
}

.viewToggle,
.data-filter-button{
  color: white;
  border: 1px solid white;
  padding: 5px;
  font-size: 14px;
  cursor: pointer;
  border-radius: 3px;
}
/*
.data-filter-button{
  color: white;
  border-left: 1px solid white;
    border-right: 1px solid white;
    border-top: 1px solid white;
  padding: 5px;
  font-size: 14px;
  cursor: pointer;
  border-radius: 3px;
}*/
/*.data-filter-button{
    font-size: smaller;
}*/
.button-bar{
    background-color: lightgray;
    border-top-left-radius: 5px;
    border-top-right-radius: 5px;
    height: auto;
    padding: 10px;
}

.viewToggle:hover,
.data-filter-button:hover{
  background: white;
  color: #0e2439;
}


.list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
}
.btnOpen{
    padding: 0rem .5rem!important;
}
.listItem {
  /*background-color: white;*/
  color: black;
  border-radius: 10px;
  margin-bottom: 5px;
  transition: 0.3s;
  width:100%;
  display:flex;
  flex-wrap: wrap;
  padding: 5px;
}
.listDetail,
.listImage{
  width:175px;
  display:flex;
  text-align:center;
  justify-content: center;
align-content: center;
    flex-wrap: wrap;
}
.insertedImage{
  margin: 10px;
    border-radius: 25px;
}
.listHeader {
    background-color: #1f364d;
    color: white;
    border-radius: 10px;
  height: 55px;
    display: block;
  transition: 0.3s;
  text-align: center;
}


.filterActive{
    background-color:gray;
}
.float-right{
    float:right;
}
.float-left{
    float:left;
}

.hidden{
	display:none;
}

/*NEW STFUFF*/
/*        body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f4f4f4;
}*/

.container {
    padding: 20px;
}

.toolbar {
    margin-bottom: 20px;
}

button {
    padding: 10px 15px;
    margin-right: 10px;
    border: none;
    background-color: #007BFF;
    color: white;
    cursor: pointer;
    border-radius: 5px;
}

button:hover {
    background-color: #0056b3;
}

#content-area {
    display: flex;
    flex-wrap: wrap;
    /*gap: 20px;*/
}

.list-view {
    display: flex;
    flex-direction: column; /* Arrange items vertically */
    gap: 5px; /* Add spacing between items */
}

.list-view .item {
    display: block;
    background: white;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
}


.grid-view .item {
    /*flex: 1 1 calc(33.333% - 20px);*/
    flex: 1 1 calc(25% - 20px);
    background: white;
    padding: 15px;
    border: 1px solid #ddd;
    border-radius: 5px;
    text-align: center;
    justify-content:center;
}

.table-view {
    width: 100%;
}

.table-view table {
    width: 100%;
    border-collapse: collapse;
}

.table-view th, .table-view td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: left;
}

.table-view th {
    background-color: #007BFF;
    color: white;
}
.viewToggle{
    background-color: lightgray;
    border: 1px white solid;
    margin: unset;
    width: 50px;
}
</style>

<script type="text/javascript">
    $(document).ready(function () {
        // Cache the original items
        const originalItems = $("#content-area").html();
        //const gridItems = originalItems.find('.removable').removeClass();

        function renderListView() {
            const contentArea = $("#content-area");
            contentArea.removeClass().addClass("list-view");
            contentArea.html(originalItems); // Restore original items
        }

        function renderGridView() {
            const contentArea = $("#content-area");
            contentArea.removeClass().addClass("grid-view");
            
            contentArea.html(originalItems); // Restore original items
            $('.removable').removeClass()
        }

        function renderTableView() {
            const contentArea = $("#content-area");
            contentArea.removeClass().addClass("table-view");

            // Generate table content dynamically
            let table = `
    <table>
        <thead>
            <tr>
                <th>Item</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            ${$(".item").map(function () {
                return `
                    <tr>
                        <td contenteditable="true">${$(this).text()}</td>
                        <td><button class="delete-btn">Delete</button></td>
                    </tr>
                `;
            }).get().join("")}
        </tbody>
    </table>
`;

            contentArea.html(table);

            // Handle delete actions
            $(".delete-btn").on("click", function () {
                $(this).closest("tr").remove();
            });
        }

        // Initial Render
        renderListView();

        // Button click handlers
        $("#list-view-btn").on("click", function (event) {
            event.preventDefault();
            renderListView();
        });

        $("#grid-view-btn").on("click", function (event) {
            event.preventDefault();
            renderGridView();
        });

        $("#table-view-btn").on("click", function (event) {
            event.preventDefault();
            renderTableView();
        });
    });
        //End View Management

    $(function () {
        //Data Management - Change what is displayed using filter buttons or open text in search

        $(".filter-buttons").on("click", '.filterInactive', function () {
            $(this).removeClass('filterInactive')
            $(this).addClass('filterActive')
            $(".btnSearch").click()
            //searchList($(this))
        });

        $(".filter-buttons").on("click", '.filterActive', function () {
            $(this).removeClass('filterActive')
            $(this).addClass('filterInactive')
            //searchList($(this))
            $(".btnSearch").click()
        });

        //Hidden Search Button that actually does the searching
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

        //Optional Search Bar, transfer data to the hidden elements and click the search button
        $(".btnSearchDummy").click(function () {
            $(this).parent().parent().parent().parent().parent().find('.btnSearch').click();
        });

        //change enter key to hit the search button
        $(window).keydown(function (event) {
            if (event.keyCode == 13) {
                event.preventDefault();
                $(".btnSearch").click();
                return false;
            }
        });
    })

    /*Adds selected (filterActive) filter buttons to the hidden search bar in a comma delimited list
     * , clicks search each time, optimized to only search within its own listcontainer*/
    //function searchList(obj) {
    //    var outStr = "";
    //    var dummyStr = obj.parent().parent().parent().find('.tbSearchDummy').val();
    //    if (dummyStr == undefined)
    //        dummyStr = '';
    //    obj.parent().find('.filterActive').each(function () {
    //        outStr += $(this).text() + ',';
    //    })
    //    $(obj).parent().parent().parent().find('.tbSearch').val(outStr + dummyStr)
    //    $(obj).parent().parent().parent().find(".btnSearch").click();
    //}

    function createSearchList(obj) {
        var applicableList = obj.parent().parent();
        var outStr = "";
        var dummyStr = applicableList.find('.tbSearchDummy').val();

        if (dummyStr == undefined)
            dummyStr = '';

        applicableList.find('.filterActive').each(function () {
            outStr += $(this).text() + ',';
        })
        applicableList.find('.tbSearch').val(outStr + dummyStr)
        //$(obj).parent().parent().parent().find(".btnSearch").click();
    }


    /*Search over 'li' elements for any text that exists in the comma delimited list*/
    //Runs a little slow with large numbers of 'li' elements on the page...
    function doSearch(obj) {
        //Move up to listcontainer
        var targetList = obj.parent().parent();
        //find search text within the listcontainer
        var filterList = targetList.find('.tbSearch').val().split(',');
        //hide all 'li' elements in the listcontainer
        targetList.find('.item').hide()
        //foreach over each search param in the comma delimited list
        for (i = 0; i < filterList.length; i++) {
            //remove empty string at end
            if (filterList[i] != "") {
                //search param 
                var filter = filterList[i];
                //search through each 'li' element to find any that contain the var filter
                targetList.find('.item').each(function () {
                    if ($(this).text().search(new RegExp(filter, "i")) > 0) {
                        //if exists, show it
                        $(this).show()
                    }
                });
            }
        }
        //If search bar goes to empty and search is hit, default to all items
        if (filterList == "")
            targetList.find('ol li').show()
    }

</script>
 


<div class="listcontainer">
    <%--Optional Search Bar, Toggle with bool in Code Behind, Works by copying content to hidden search bar and running search--%>
    <asp:Panel runat="server" ID="pnlSearchBar" Visible="false">
        <div class="row">
            <div class="col-12">
                <div class="float-right" style="margin-bottom: 5px;">
                <input name="tbSearchDummy" type="text" id="tbSearchDummy" class="tbSearchDummy ui-corner-all ui-widget-content" style="height:28px;" autocomplete="off" uithemed="uithemed">&nbsp
                <button id="btnSearchDummy" style="Height:40px;" type="button" class="btnSearchDummy">Search</button>
            </div>
            </div>
        </div>
    </asp:Panel>
    
    
    <%--Hidden Search Bar, MUST REMAIN IN listcontainer, Accepts input from Filter Buttons (filter-buttons) and Optional Search Bar (tbSearchDummy)--%>
    <div class="float-right hidden">
            <input name="tbSearch" type="text" id="tbSearch" class="tbSearch ui-corner-all ui-widget-content" style="height:28px;" autocomplete="off" uithemed="uithemed">&nbsp
            <button id="bnSearch" style="Height:28px;" type="button" class="btnSearch">Search</button>
        </div>

    <%--Data Filters--%>
    <span class="filter-buttons" >
            <%if (filterList != "") { %>
                <span class="button-bar float-left toolbar" >
                     <%foreach (var filter in filterList.Split(','))
                         { %>
                            <%if (filter != "")
                                { %>
                                <input type="button" class="data-filter-button viewToggle leftsideButton filterInactive" value="<%=filter %>"/>
                              <%} %> 
                    <%} %>                    
                </span>
            <%} %>

        <span class="button-bar float-right toolbar" >
            <button id="list-view-btn" class="viewToggle">List</button>
            <button id="grid-view-btn" class="viewToggle">Grid</button>
            <button id="table-view-btn" class="viewToggle">Table</button>
        </span>
    </span>
    

    <%--Option one with up to 6 headers, group items under each, not default--%>
    <%if (withHeaders)
        { %>
            <ol class="adjustableView list header list-view-filter">
                <%foreach (System.Data.DataRow row in dtHeader.Rows)
                    { %>
                    <li class="">
                        <span class="listHeader"><%=row[headerColumn] %></span>
                        <%foreach (var r in dtListing.Select("responsibleParties = " + row["id"]))
                            {
                                var status = "Status";
                                var lastUsed = "Last";
                             %>
                             <span class="listItem item">
                         <%if (image != "")
                             {
                                 //if (row[image].ToString() != "")
                                 //{
                          %>
                                <%--int.Parse(row[image].ToString()), 120, 150--%>
                                <span class="listImage"><%=FoxHunt.Data.getZoomNail(151, 50, 50) %></span>
                                <%--<span class="listDetail"><%=row[image] %></span>--%>
                        <%//}
                            } %>
                                <span class="listDetail">
                                    <%if (lineOneOptOne != "") {%><%=r[lineOneOptOne].ToString()%> <%}
                                        if (lineOneOptTwo != "") { %> <br /><%=r[lineOneOptTwo].ToString()%><%} %>
                                </span>
                                <hr />
                                <span class="listDetail">
                                    <%if (lineTwoOptOne != ""){%><%=r[lineTwoOptOne].ToString()%> <%}
                                        if (lineTwoOptTwo != "") { %> <br /><%=r[lineTwoOptTwo].ToString()%><%} %></span>
                                <span class="listDetail">
                                    <%if (lineThreeOptOne != ""){%><%=r[lineThreeOptOne].ToString()%> <%}
                                          if (lineThreeOptTwo != "") { %> <br /><%=r[lineThreeOptTwo].ToString()%><%} %>
                                </span>
                                <span class="listDetail">
                                    <%if (lineFourOptOne != ""){%><%=r[lineFourOptOne].ToString()%> <%}
                                        if (lineFourOptTwo != "") { %> <br /><%=r[lineFourOptTwo].ToString()%><%} %>
                                </span>
                         <%if (image == ""){ %>
                                <span class="listDetail">
                                    <%if (lineFiveOptOne != ""){%><%=r[lineFiveOptOne].ToString()%> <%}
                                        if (lineFiveOptTwo != "") { %> <br /><%=r[lineFiveOptTwo].ToString()%><%} %>
                                </span>
                         <%} %>
                                <hr />
                                <%if (clickLinkOpen != ""){ %>
                                    <span class="listDetail"><a href="<%=clickLinkOpen %>" target="_blank" class="btn btn-secondary btnOpen">Open</a></span>
                                <%} %>
                    
                            </span>
                        <%} %>
                        <%if (dtListing.Select("responsibleParties = " + row["id"]).Length < 1)
                        { %>    
                                <span class="" style="width:100%; text-align:center; display: block;">N/A</span>
                        <%} %>
                    </li>
                <%} %>
            </ol>


    <%}
        else
        { %>
    <%--Option 2 without headers, creates list of items not organized, default--%>      
                <div id="content-area" class="list-view adjustableView list header">
                <%foreach (System.Data.DataRow row in dtListing.Rows)
                    {
                             %>
                        <div class="listItem item" style="padding-bottom: 0px;" data="<%=row["id"] %>">
                            <div class="row removable" >
                                <div class="col-12 formsec removable">
                         <%if (image != ""){
                                //if (row[image].ToString() != "")
                                //{
                          %>
                                <%--int.Parse(row[image].ToString()), 120, 150--%>
                                <span class="listImage"><%=FoxHunt.Data.getZoomNail(151, 50, 50) %></span>
                                <%--<span class="listDetail"><%=row[image] %></span>--%>
                        <%//}
                            } %>
                                    </div></div>
                                <div class="row removable" >
                                    <div class="col-3 removable"><span class="listDetail"><%=row[lineOneOptOne].ToString()%> <%if (lineOneOptTwo != "") { %> <br /><%=row[lineOneOptTwo].ToString()%><%} %></span></div>
                                    <div class="col-3 removable"><span class="listDetail"><%=row[lineTwoOptOne].ToString()%> <%if (lineTwoOptTwo != "") { %> <br /><%=row[lineTwoOptTwo].ToString()%><%} %></span></div>
                                    <div class="col-3 removable"><span class="listDetail"><%=row[lineThreeOptOne].ToString()%> <%if (lineThreeOptTwo != "") { %> <br /><%=row[lineThreeOptTwo].ToString()%><%} %></span></div>
                                    <div class="col-3 removable"><span class="listDetail"><%=row[lineFourOptOne].ToString()%> <%if (lineFourOptTwo != "") { %> <br /><%=row[lineFourOptTwo].ToString()%><%} %></span></div>
                                
                                <%--<hr />--%>
                                
                                
                                
                        <%-- <%if (image == ""){ %>
                                <span class="listDetail"><%=row[lineFiveOptOne].ToString()%> <%if (lineFiveOptTwo != "") { %> <br /><%=row[lineFiveOptTwo].ToString()%><%} %></span>
                         <%} %>--%>
                                <%--<hr />--%>
                               <%-- <%if (clickLinkOpen != ""){ %>
                                    <span class="listDetail"><a href="<%=clickLinkOpen %>" target="_blank" class="btn btn-secondary btnOpen">Open</a></span>
                                <%} %>--%>
                    
                            </div>                            
                        </div>
                <%} %>
  
            </div>
    <%} %>
                   
            </div>
            
     
