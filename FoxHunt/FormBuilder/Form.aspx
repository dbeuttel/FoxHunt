<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Form.aspx.cs" Async="true" Inherits="FoxHunt.Form" EnableEventValidation="false"%>
<%@ Register Assembly="Reporting" Namespace="Reporting" TagPrefix="DTI" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>
<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <style>
.quiz-question {
    background: #fff;
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 15px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.quiz-question label {
    font-weight: 600;
    display: block;
    margin-bottom: 10px;
}

.quiz-question .short-text,
.quiz-question .long-text,
.quiz-question .number-text {
    width: 100%;
    padding: 8px;
    border-radius: 5px;
    border: 1px solid #ccc;
    font-size: 14px;
}

.quiz-question select,
.quiz-question input[type="number"] {
    width: 100%;
    padding: 8px;
    border-radius: 5px;
    border: 1px solid #ccc;
}

/* --- Button-style RadioButtonList --- */
.rbl-buttonlist {
    display: flex;
    gap: 10px;
}

.rbl-buttonlist input[type="radio"] {
    display: none; /* hide the actual radio buttons */
}

.rbl-buttonlist label {
    padding: 10px 20px;
    border-radius: 5px;
    border: 1px solid #007bff;
    background-color: #fff;
    color: #007bff;
    cursor: pointer;
    transition: all 0.2s;
    user-select: none;
}

.rbl-buttonlist label:hover {
    background-color: #007bff;
    color: #fff;
}

.rbl-buttonlist input[type="radio"]:checked + label {
    background-color: #007bff;
    color: #fff;
    border-color: #0056b3;
}
.rbl-buttonlist.ui-state-default{
    display:none!important;
}
.multi-dropdown ul.dropdown-menu {
    max-height: 200px; /* scroll if too many options */
    overflow-y: auto;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}


/* Add shadow/delineation to each <li> */
.multi-dropdown ul.dropdown-menu li {
    padding: 0.4rem 0.5rem;
    margin-bottom: 0.25rem;
    border-radius: 5px;
    background-color: #fff;
    box-shadow: 0 1px 2px rgba(0,0,0,0.08);
    transition: all 0.2s;
}

/* Optional: hover highlight for clarity */
.multi-dropdown ul.dropdown-menu li:hover {
    background-color: #f0f0f0;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.labelCompletion{
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.btn - listbox + .btn - group button {
        min - width: 80px;
        flex: 1; /* make buttons fill width equally */
    }

.btn - listbox + .btn - group {
        display: flex;
        gap: 5px;
    }

.btn - listbox + .btn - group button.active {
        color: #fff;
        background - color: #0d6efd; /* Bootstrap primary color */
        border - color: #0d6efd;
    }

/* Button group styling */
.btn-group .btn {
    flex: 1;           /* buttons fill width equally */
    transition: all 0.2s;
    margin: 2px;
}

/* Active button */
.btn-group .btn.active {
    background-color: #0b5ed7!important;  /* slightly darker than btn-primary */
    border-color: #0b5ed7;
    color: #fff;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15); /* subtle shadow to pop */
}

/* Optional: hover effect on inactive buttons */
.btn-group .btn:not(.active):hover {
    background-color: #0d6efd; /* default Bootstrap primary */
    color: #fff;
}
</style>


<script>
    function verifySubmission() {

    }

    


    $(document).ready(function () {
        // Transform hidden selects with class 'btn-listbox' into button groups
        $('select.btn-listbox').each(function () {
            var $select = $(this);
            var $options = $select.find('option');
            if ($options.length === 0) return;

            // Create Bootstrap button group wrapper
            var $wrapper = $('<div class="btn-group w-100 mb-2" role="group"></div>');

            $options.each(function () {
                var $option = $(this);
                var activeClass = $option.is(':selected') ? 'active' : '';
                var $btn = $('<button type="button" class="btn btn-primary ' + activeClass + '">' + $option.text() + '</button>');

                // Button click handler
                $btn.on('click', function () {
                    // Deselect all options in the select
                    $options.prop('selected', false);

                    // Remove active class from all buttons
                    $wrapper.find('button').removeClass('active');

                    // Activate clicked button and select option
                    $btn.addClass('active');
                    $option.prop('selected', true);

                    // Trigger change event if needed
                    $select.trigger('change');
                });

                $wrapper.append($btn);
            });

            // Insert button group after hidden select
            $select.after($wrapper);
            $select.hide(); // hide original ListBox
        });
    });



    ////Checkbox version
    //$(document).ready(function () {
    //    $('.quiz-question table').each(function () {
    //        var $table = $(this);

    //        // Create the dropdown wrapper
    //        var $dropdown = $('<div class="multi-dropdown position-relative w-100"></div>');
    //        var $button = $('<button type="button" class="btn btn-outline-secondary w-100">Select...</button>');
    //        var $list = $('<ul class="dropdown-menu p-2" style="display:none; position:absolute; top:100%; left:0; z-index:1000; width:100%;"></ul>');

    //        // Populate the dropdown list
    //        $table.find('input[type=checkbox]').each(function () {
    //            var $cb = $(this);
    //            var text = $cb.next('label').text();
    //            var $li = $('<li><label class="d-block"><input type="checkbox" value="' + $cb.val() + '"> ' + text + '</label></li>');

    //            // Preserve pre-checked state
    //            if ($cb.is(':checked')) $li.find('input').prop('checked', true);

    //            $list.append($li);
    //        });

    //        // Assemble dropdown
    //        $dropdown.append($button).append($list);
    //        $table.after($dropdown).hide();

    //        // Toggle dropdown visibility
    //        $button.click(function (e) {
    //            e.stopPropagation();
    //            $list.toggle();
    //        });

    //        // Close dropdown when clicking outside
    //        $(document).click(function () {
    //            $list.hide();
    //        });

    //        // Sync checkbox selection with original table
    //        $list.find('input[type=checkbox]').change(function () {
    //            var values = [];
    //            $list.find('input:checked').each(function () {
    //                values.push($(this).val());
    //            });
    //            $table.find('input[type=checkbox]').each(function () {
    //                $(this).prop('checked', values.includes($(this).val()));
    //            });
    //        });
    //    });
    //});

    $(document).ready(function () {
        $('select[multiple]').each(function () {
            var $select = $(this);

            // Create dropdown wrapper
            var $dropdown = $('<div class="multi-dropdown position-relative w-100"></div>');
            var $button = $('<button type="button" class="btn btn-outline-secondary w-100">Select...</button>');
            var $list = $('<ul class="dropdown-menu p-2" style="display:none; position:absolute; top:100%; left:0; z-index:1000; width:100%;"></ul>');

            // Populate dropdown list from <select> options
            $select.find('option').each(function () {
                var $option = $(this);
                var $li = $('<li><label class="d-block"><input type="checkbox" value="' + $option.val() + '"> ' + $option.text() + '</label></li>');

                if ($option.is(':selected')) $li.find('input').prop('checked', true);
                $list.append($li);
            });

            // Assemble dropdown
            $dropdown.append($button).append($list);
            $select.after($dropdown).hide();

            // Toggle dropdown
            $button.click(function (e) {
                e.stopPropagation();
                $list.toggle();
            });

            // Close when clicking outside
            $(document).click(function (e) {
                if (!$dropdown.is(e.target) && $dropdown.has(e.target).length === 0) {
                    $list.hide();
                }
            });

            // Sync checkbox selection with <select>
            $list.find('input[type=checkbox]').change(function () {
                var values = [];
                $list.find('input:checked').each(function () {
                    values.push($(this).val());
                });

                $select.find('option').each(function () {
                    $(this).prop('selected', values.includes($(this).val()));
                });

                // Update button text to show selected values
                if (values.length === 0) {
                    $button.text('Select...');
                } else {
                    $button.text(values.join(', '));
                }
            });

            // Initialize button text for pre-selected options
            var initialSelected = $select.find('option:selected').map(function () { return $(this).val(); }).get();
            if (initialSelected.length > 0) {
                $button.text(initialSelected.join(', '));
            }
        });
    });


</script>

    <div class="row">
        <div class="col-md-10">
            
            <asp:Repeater ID="rptQuestions" runat="server" OnItemDataBound="rptQuestions_ItemDataBound">
                <ItemTemplate>
                    <div class="quiz-question mb-3">

                        <div class="labelCompletion">
                        <!-- Question label -->
                        <label class="mb-0"><%# Eval("QuestionText") %></label>

                        <!-- Single inline checkbox (hidden by default) -->
                        <asp:CheckBox ID="chkCompletion" runat="server" CssClass="ms-2" Visible="false" AutoPostBack="false"/>
                        </div>

                        <!-- Single choice dropdown -->
                        <asp:DropDownList ID="ddlSingleChoice" runat="server" Visible="false" AutoPostBack="false"></asp:DropDownList>

                        <!-- Multi-choice listbox -->
                        <asp:ListBox ID="lstMultiChoice" runat="server" SelectionMode="Multiple" Visible="false" AutoPostBack="false" CssClass="selectpicker"></asp:ListBox>

                        <!-- Hidden RadioButtonList fallback -->
                        <%--<asp:RadioButtonList ID="rblYesNo" runat="server" RepeatDirection="Horizontal" CssClass="rbl-buttonlist" Visible="false" AutoPostBack="false"></asp:RadioButtonList>--%>

                        <!-- Bootstrap Yes/No buttons -->
                        <asp:ListBox ID="lstYesNo" runat="server"
                         SelectionMode="Single"
                         Visible="false"
                         CssClass="btn-listbox">
            </asp:ListBox>

                        <!-- Short, long, number inputs -->
                        <asp:TextBox ID="txtShort" runat="server" CssClass="short-text" Visible="false" AutoPostBack="false"></asp:TextBox>
                        <asp:TextBox ID="txtLong" runat="server" TextMode="MultiLine" CssClass="long-text" Visible="false" AutoPostBack="false"></asp:TextBox>
                        <asp:TextBox ID="txtNumber" runat="server" TextMode="Number" CssClass="number-text" Visible="false" AutoPostBack="false"></asp:TextBox>

                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="col-md-2">
            <div class="card">
                <asp:Button runat="server" ID="btnSave" Text="Submit" CssClass="btn btn-primary w-100" OnClientClick="return verifySubmission()" OnClick="btnSave_Click1" />
            </div>
        </div>
    </div>

</asp:Content>