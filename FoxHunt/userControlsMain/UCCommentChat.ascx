<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UCCommentChat.ascx.cs" Inherits="FoxHunt.userControlsMain.UCCommentChat" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>
<%--<asp:DropDownList width="180px" ID="ddElectionID" runat="server" title="ElectionID" AutoPostBack="True" Value="NULL" OnSelectedIndexChanged="ddElectionID_SelectedIndexChanged" />--%>

    <style>        
         /*      .updatebar{
            text-align:center;
            display:none;
        }*/
        .commententry{
            max-width:850px;
            height:35px;
        }
        .commentbutton{
            width:100px!important;
            height:35px!important;
            margin-top:5px;
        }.commentblock{
             padding:6px;
             background-color:white;
             min-height:100px;
         }
         .commentbox{
        /*     border:2px solid black;*/
             border-radius:10px;
             padding:6px;
             margin:6px;
             background-color:white;
             box-shadow: rgb(0 0 0 / 25%) 0px 2px 5px 2px;
         }
         .self{
             float:right;
             justify-content:right;
             width: 80%;
             background-color:lightblue;
         }
         .other{
     
             text-align:left;
             justify-content:left;
             width: 80%;
             background-color:whitesmoke;
         }
         .previousComments{
            /*flex-direction: column-reverse;
            display: flex;*/
         }
         .deleteComment {
             color:red;
             cursor:pointer;
         }
         .editComment{
             cursor:pointer;
         }
        .commentHR{
            margin: 0px;
            width: 80%;
            justify-self: center;
        }
        .refernceComment{
            padding-left:20px;
            padding-right:20px;
            text-align:left;
            background-color:whitesmoke;
            box-shadow: rgb(0 0 0 / 25%) 0px 2px 5px 2px;
            border-radius:10px;
        }

        .commentbox {
    position: relative;
}

.comment-actions-tray {
    position: absolute;
    top: -20px;
    right: 10px;
    display: none;
    /*display: inline-block;*/
    z-index: 10;
    background: white;
    padding: 2px 5px;
    border-radius: 5px;
    box-shadow: 0 0 3px rgba(0,0,0,0.1);
}

.commentbox:hover .comment-actions-tray {
    display: inline-block;
}

.comment-actions-tray i {
    /*margin-left: 6px;*/
    cursor: pointer;
    color: #555;
}

.comment-actions-tray i:hover {
    color: #000;
}

       .mention-list {
    /*position: absolute;*/
    background-color: white;
    border: 1px solid #ccc;
    z-index: 1000;
    display: none;
    max-height: 150px;
    overflow-y: auto;
    padding: 5px 0;
    border-radius: 4px;
    font-size: 14px;
    max-width:50%;
}

.mention-item {
    padding: 5px 10px;
    cursor: pointer;
}

.mention-item:hover,
.mention-item.active {
    background-color: #f0f0f0;
}

    </style>

<script type="text/javascript">
    var urlParams = new URLSearchParams(window.location.search);
    var selected = "";

    function removeReply() {
        $('.refernceComment').remove();
        $(".tbDeleteID").val();
    }

    $(function () {

        //$(".commentblock").each(function () {
        //    if ($(this).contents().text().length > 100)
        //        $(this).height(30 + $(this).contents().text().length / 5)
        //})
        
        selected = urlParams.get('selected');

        $(".reply").on('click', function () {
            $('.refernceComment').remove();
            var refPerson = $(this).parent().parent().parent().find(".commentername").text().replace('\n', '').trim()
            var refComment = $(this).parent().parent().parent().find(".commentitself").text().replace('\n', '').trim()
            $('.tbcomment').before('<div class="refernceComment" ><span><b>Replying to ' + refPerson +':</b></span><span class="pull-right"><i onclick="removeReply()" class="fa fa-times cancelReply" aria-hidden="true" ></i></span><br><i>'+refComment+'</i></div>')
            $(".tbDeleteID").val($(this).attr("refID"));
            //$(".btnDeleteComment").click();
        })

        $(".deleteComment").on('click', function () {
            if (confirm("Do you want to delete this comment?")) {
                $(".tbDeleteID").val($(this).attr("id"));
                $(".btnDeleteComment").click();
            }
                
        })

        $(".editComment").on('click', function () {            
            $(".tbEditID").val($(this).attr("editid"));
            $(".tbcomment").val($(this).parent().parent().parent().find(".commentitself").text().replace('\n', '').trim())
            //$(".btnDeleteComment").click();            

        })
        //$('.commentbox')
            //setupDateClick()
     })    

    
</script>

<asp:Panel runat="server" ID="pnlCommentFeature" Visible="false">
    <script>
        $(function () {
            $(".commentbox").removeClass("self")
            $(".commentbox").removeClass("other")
        })
    </script>
</asp:Panel>


<%--@mention scripts--%>
<script>
    $(document).ready(function () {
        const $commentBox = $('.tbcomment');
        const $mentionList = $('.mention-list');
        let mentionIndex = -1;
        let mentions = []; // Array of { id, name }
        let sendList = new Set(); // Unique IDs

        function fetchMentions(query, callback) {
            $.ajax({
                url: '/Default.aspx', // Your server-side endpoint
                method: 'GET',
                data: { query: query },
                success: function (data) {
                    const results = JSON.parse(data); // Expecting [{ id, name }]
                    callback(results);
                },
                error: function () {
                    callback([]);
                }
            });
        }

        function showMentionList(filtered) {
            const offset = $commentBox.offset();
            const height = $commentBox.outerHeight();

            $mentionList.empty();
            filtered.forEach((person, idx) => {
                $mentionList.append(`<div class="mention-item" data-id="${person.id}" data-name="${person.name}" data-index="${idx}">@${person.name}</div>`);
            });

            mentionIndex = -1;

            $mentionList.css({
                top: offset.top + height,
                left: offset.left,
                display: 'block',
                width: $commentBox.outerWidth()
            });
        }

        function insertMention(name, id) {
            const cursorPos = $commentBox[0].selectionStart;
            const textBefore = $commentBox.val().substring(0, cursorPos);
            const textAfter = $commentBox.val().substring(cursorPos);
            const atIndex = textBefore.lastIndexOf("@");
            const newText = textBefore.substring(0, atIndex) + `@${name} ` + textAfter;

            $commentBox.val(newText).focus();

            // Add to mention list only if not already included
            if (!mentions.find(m => m.id === id)) {
                mentions.push({ id, name });
                sendList.add(id);
            }

            updateSendListOutput();
            $mentionList.hide();
        }


        function updateSendListOutput() {
            // For example purposes � you can update a hidden field
            const ids = Array.from(sendList).join(",");
            console.log("Send List:", ids);
            $("#sendList").val(ids); // optional hidden input
        }

        $commentBox.on('keyup', function (event) {
            const key = event.key;

            if ([38, 40, 13].includes(event.which)) return; // handled in keydown

            const cursorPos = this.selectionStart;
            const text = $(this).val().substring(0, cursorPos);
            const atIndex = text.lastIndexOf("@");

            if (atIndex !== -1 && (atIndex === 0 || /\s/.test(text[atIndex - 1]))) {
                const query = text.substring(atIndex + 1);

                // Hide list if there's a space after the @
                if (/\s/.test(query)) {
                    $mentionList.hide();
                    return;
                }

                fetchMentions(query, function (results) {
                    mentions = results;
                    if (results.length > 0) {
                        showMentionList(results);
                    } else {
                        $mentionList.hide();
                    }
                });
            } else {
                $mentionList.hide();
            }
        });

        $commentBox.on('keydown', function (event) {
            const items = $mentionList.find('.mention-item');

            if ($mentionList.is(':visible')) {
                if (event.which === 40) { // Down
                    mentionIndex = (mentionIndex + 1) % items.length;
                    items.removeClass('active').eq(mentionIndex).addClass('active');
                    event.preventDefault();
                } else if (event.which === 38) { // Up
                    mentionIndex = (mentionIndex - 1 + items.length) % items.length;
                    items.removeClass('active').eq(mentionIndex).addClass('active');
                    event.preventDefault();
                } else if (event.which === 13 && mentionIndex > -1) { // Enter
                    const selected = items.eq(mentionIndex);
                    insertMention(selected.data('name'), selected.data('id'));
                    event.preventDefault();
                } else if (event.which === 32) { // Space
                    $mentionList.hide(); // hide when typing space
                }
            }
        });

        $(document).on('click', '.mention-item', function () {
            insertMention($(this).data('name'), $(this).data('id'));
        });

        $(document).on('click', function (e) {
            if (!$(e.target).closest('.mention-list, .tbcomment').length) {
                $mentionList.hide();
            }
        });

        // Utility: rebuild mentions from text
        function syncMentionsWithText() {
            const currentText = $commentBox.val();
            const matchedNames = [...currentText.matchAll(/@(\w+)/g)].map(m => m[1]);

            // Compare to tracked mentions
            const existingNames = mentions.map(m => m.name);

            // Find removed names
            const removedNames = existingNames.filter(name => !matchedNames.includes(name));

            if (removedNames.length > 0) {
                removedNames.forEach(name => {
                    // Remove from mentions array
                    mentions = mentions.filter(m => m.name !== name);

                    // Remove from sendList Set
                    const removed = Array.from(sendList).find(id =>
                        name === mentions.find(m => m.id === id)?.name
                    );

                    if (removed) sendList.delete(removed);
                });

                updateSendListOutput();
            }
        }

        // Attach to keyup for backspace/delete monitoring
        $commentBox.on('keyup', function (event) {
            if (event.which === 8 || event.which === 46) { // Backspace or Delete
                syncMentionsWithText();
            }
        });

    });
</script>



    
    <cc1:AjaxCall ID="ajaxDeleteAvail" OncallBack="ajaxDeleteAvail_callBack" jsReturnFunction="DeleteAvailReturn" runat="server">
    </cc1:AjaxCall>

<asp:panel runat="server" id="pnlComments" Visible="true">
                <%--<div class="formsec"><h3>Comments</h3></div>--%>
          <div class="previousComments">
                    <%foreach (System.Data.DataRow r in dtcomments.Rows)
                        { 
                            String commenter = "";
                            string commentDateStr = "";
                            DateTime commentDate = new DateTime();
                            DateTime lastDate = new DateTime();
                            
                            DateTime.TryParse(r["commentDate"].ToString(),out commentDate);
                            if(commentDate.Year == DateTime.Now.Year)
                                commentDateStr = commentDate.ToString("MM/dd")+" "+commentDate.ToShortTimeString();
                            else 
                                commentDateStr = commentDate.ToString("MM/dd/yyyy")+" "+commentDate.ToShortTimeString();

                            if(Data.currentUser.ID == int.Parse(r["insertUser"].ToString()))
                                commenter = "self";
                            else
                                commenter = "other";
                        %>
              <%if(lastDate != commentDate){ %><div class="formsec w-100"><%--<%=commentDate.ToString("MM/dd") %>--%><hr class="commentHR" /></div><%} %>
                    <div class="commentblock">
                        <div class="commentbox <%=commenter %>">
                            <div class="commenttitle" style="text-align:left!important;">
                                <span class="commentername" > <b><%=r["lname"].ToString().ToUpper() %>, <%=r["fname"].ToString().ToUpper() %></b></span><span class="commentdatetime pull-right"> <%=commentDateStr %> <i><%=r["edit"] %></i></span>
                                <div class="comment-actions-tray">
                                    <i class="bx bx-reply reply" aria-hidden="true" refID="<%=r["id"] %>" data-bs-toggle="tooltip" data-bs-html="true" data-bs-placement="bottom" title="Reply"></i> 
                                    <i class="bx bx-pencil editComment" aria-hidden="true" editid="<%=r["id"] %>" data-bs-toggle="tooltip" data-bs-html="true" data-bs-placement="bottom" title="Edit"></i> 
                                    <%--<i class="bx bx-envelope markUnread" aria-hidden="true" id="<%=r["id"] %>" data-bs-toggle="tooltip" data-bs-html="true" data-bs-placement="bottom" title="Mark Unread"></i>--%> |
                                    <i class="bx bx-trash deleteComment" aria-hidden="true" id="<%=r["id"] %>" data-bs-toggle="tooltip" data-bs-html="true" data-bs-placement="bottom" title="Delete"></i>
                                </div>
                                <hr class="commentHR" />

                                <%--<span class="commentEdit pull-right"><i class="fa fa-pencil-square-o editComment" aria-hidden="true" editid="<%=r["id"] %>"></i> 
                                    <i class="fa fa-times deleteComment" aria-hidden="true" id="<%=r["id"] %>"></i></span>--%>
                                
                            </div>
                            <div class="commentitself">
                                <%=r["comment"] %>
                            </div>
                        </div>
                    </div>

                    <%lastDate=commentDate;} %>
        </div>          
                <%--<hr />--%>
                <div class="row formsec">
                    <div class="col-12">
                        <asp:TextBox ID="tbcomment" runat="server" CssClass="form-control commententry" TextMode="MultiLine" placeholder="Type a new comment..."></asp:TextBox>
                        <div class="mention-list"></div>
                        <asp:TextBox runat="server" ID="tbEditID" CssClass="hidden"></asp:TextBox>
                        <asp:TextBox runat="server" ID="sendList" name="sendList" CssClass="hidden1"></asp:TextBox>
                        <asp:Button ID="Button4" runat="server" Text="Save" style="justify-content:center" OnClick="SaveComment" CssClass="btn btn-primary commentbutton pull-right"/>
                    </div>
                </div>
                <%--<label class="reclabel">Reorder Quantity:</label>&nbsp
                    <asp:TextBox runat="server" ID="TextBox17"></asp:TextBox><br />--%>
    <div class="hidden">
        <asp:TextBox runat="server" ID="tbDeleteID"></asp:TextBox>            
        <asp:Button runat="server" ID="btnDeleteComment" OnClick="btnDeleteComment_Click" />
    </div>
                </asp:Panel>


