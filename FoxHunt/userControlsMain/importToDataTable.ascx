<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="importToDataTable.ascx.cs" Inherits="FoxHunt.userControlsMain.importToDataTable" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc20" %>
<%@ Register Assembly="DTIGrid" Namespace="DTIGrid" TagPrefix="cc21" %>
<%@ Register Src="~/userControlsMain/tableControl.ascx" TagPrefix="uc1" TagName="tableControl" %>


<asp:Panel runat="server" ID="pnlSampleData" Visible="false">
    <style>
        /* --- THEME 1: OBSIDIAN (Professional Dark) --- */
        .theme-obsidian {
            --bg-main: #0f172a;
            --bg-card: #1e293b;
            --bg-row-alt: #334155;
            --text-main: #f8fafc;
            --text-dim: #94a3b8;
            --header-bg: #020617;
            --header-text: #f8fafc;
            --accent: #38bdf8;
            --border: #334155;
            --btn-bg: #0f172a;
        }

        /* --- THEME 2: RADICAL 90s (Neon/Memphis) --- */
        .theme-90s {
            --bg-main: #000000;
            --bg-card: #1a1a1a;
            --bg-row-alt: #2a2a2a;
            --text-main: #39ff14; /* Neon Green */
            --text-dim: #ffff00; /* Yellow */
            --header-bg: #ff00ff; /* Hot Magenta */
            --header-text: #000000;
            --accent: #00ffff; /* Electric Cyan */
            --border: #ff00ff;
            --btn-bg: #0000ff; /* Power Blue */
            font-family: "Comic Sans MS", "Arial Black", sans-serif !important;
        }

        .table-container-main {
            position: relative;
            border-radius: 12px;
            background: var(--bg-card);
            padding: 12px;
            border: 2px solid var(--border);
            box-shadow: 0 10px 40px rgba(0,0,0,0.6);
            transition: all 0.3s ease;
            margin-bottom: 10px;
        }

        .table-wrapper {
            width: 100%;
            position: relative;
            overflow: hidden; 
            border-radius: 6px;
        }

        /* 5.5 Rows Height Logic */
        .table-wrapper.scale-off {
            height: 235px; 
            border-bottom: 1px solid var(--border);
        }

        .table-wrapper.scaling-active {
            overflow: visible !important;
            height: auto !important;
        }

        .table-scale-inner {
            transform-origin: top left;
            transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* Table Styling */
        .responsive-table {
            border-collapse: separate;
            border-spacing: 0;
            width: 100%;
            background: var(--bg-card);
        }

        .responsive-table th {
            background: var(--header-bg);
            color: var(--header-text);
            padding: 10px 12px;
            text-transform: uppercase;
            font-size: 11px;
            font-weight: 800;
            text-align: left;
            position: sticky;
            top: 0;
            z-index: 10;
            border-bottom: 2px solid var(--accent);
        }

        .responsive-table td {
            padding: 8px 12px;
            border-bottom: 1px solid var(--border);
            color: var(--text-main);
            font-size: 13px;
        }

        .responsive-table tr:nth-child(even) td { background: var(--bg-row-alt); }

        /* Zoom Cell */
        .zoom-cell { transition: all 0.25s ease; position: relative; z-index: 1; }

        .scaling-active .zoom-cell:hover {
            transform: scale(2.2);
            z-index: 1000;
            box-shadow: 0 10px 30px rgba(0,0,0,0.8);
            background: var(--btn-bg) !important;
            color: var(--accent);
            outline: 2px solid var(--accent);
            border-radius: 4px;
        }

        /* Footer Grid */
        .table-footer {
           /* display: grid;
            grid-template-columns: 1fr auto 1fr;*/
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 5px;
            gap: 15px;
        }

        .row-label { color: var(--text-dim); font-size: 12px; font-weight: 600; }

        /* Scroll Buttons */
        .scroll-controls { display: none; gap: 6px; }
        .scale-off-active .scroll-controls { display: flex; }

        .nav-btn {
            width: 34px;
            height: 34px;
            border-radius: 6px;
            background: var(--btn-bg);
            color: var(--accent);
            border: 1px solid var(--accent);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: 0.2s;
        }
        .nav-btn:hover { background: var(--accent); color: var(--bg-main); }

        /* Action Buttons */
        .button-group { display: flex; gap: 10px; justify-content: flex-end; }

        .action-btn {
            padding: 8px 14px;
            border-radius: 6px;
            border: 1px solid var(--accent);
            background: transparent;
            color: var(--accent);
            cursor: pointer;
            font-weight: bold;
            font-size: 11px;
            text-transform: uppercase;
        }
        .action-btn:hover { background: var(--accent); color: var(--bg-main); }

        .fade-overlay {
            position: absolute;
            bottom: 0; left: 0; right: 0; height: 40px;
            background: linear-gradient(to top, var(--bg-card), transparent);
            pointer-events: none; display: none; z-index: 5;
        }
        .scale-off-active .fade-overlay { display: block; }
    </style>
    
<h2 style="">Sample Data</h2>
    <div id="<%= ClientID %>_Main" class="theme-obsidian">
        <div class="table-container-main">
            <div class="table-wrapper scaling-active" id="<%= ClientID %>_Wrap">
                <div class="table-scale-inner">
                    <table class="responsive-table">
                        <thead>
                            <tr>
                                <% int colIndex = 1; foreach (System.Data.DataColumn col in importData.Columns) { %>
                                    <th class="zoom-cell col-<%= colIndex %>"><%= col.ColumnName %></th>
                                <% colIndex++; } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% int rowCount = 0; foreach (System.Data.DataRow row in importData.Rows) { if (rowCount >= 20) break; %>
                                <tr>
                                    <% int cellIndex = 1; foreach (var cell in row.ItemArray) { %>
                                        <td class="zoom-cell col-<%= cellIndex %>"><%= cell %></td>
                                    <% cellIndex++; } %>
                                </tr>
                            <% rowCount++; } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="fade-overlay"></div>
        </div>

        <div class="table-footer">
            <label class="row-label">RECORDS: 20 / <%=importData.Rows.Count %></label>
            
            <div class="scroll-controls">
                <button class="nav-btn" onclick="manualScroll('<%= ClientID %>_Wrap', 'left')">←</button>
                <button class="nav-btn" onclick="manualScroll('<%= ClientID %>_Wrap', 'up')">↑</button>
                <button class="nav-btn" onclick="manualScroll('<%= ClientID %>_Wrap', 'down')">↓</button>
                <button class="nav-btn" onclick="manualScroll('<%= ClientID %>_Wrap', 'right')">→</button>
            </div>

            <div class="button-group">
                <button type="button" class="action-btn" onclick="toggleTheme()">Switch Theme</button>
                <button type="button" class="action-btn" id="scaleBtn" onclick="toggleScale()">Disable Scaling</button>
            </div>
        </div>
    </div>

    <script>
        function toggleTheme() {
            const el = document.getElementById("<%= ClientID %>_Main");
            if (el.classList.contains('theme-obsidian')) {
                el.classList.replace('theme-obsidian', 'theme-90s');
            } else {
                el.classList.replace('theme-90s', 'theme-obsidian');
            }
        }

        function toggleScale() {
            const main = document.getElementById("<%= ClientID %>_Main");
            const wrap = document.getElementById("<%= ClientID %>_Wrap");
            const inner = wrap.querySelector(".table-scale-inner");
            const btn = document.getElementById("scaleBtn");

            const isOff = wrap.classList.toggle("scale-off");
            main.classList.toggle("scale-off-active");
            
            if (isOff) {
                wrap.classList.remove("scaling-active");
                inner.style.transform = "none";
                inner.style.height = "auto";
                btn.innerText = "Enable Scaling";
            } else {
                wrap.classList.add("scaling-active");
                btn.innerText = "Disable Scaling";
                runScaling();
            }
        }

        function manualScroll(id, dir) {
            const w = document.getElementById(id);
            const amt = 80;
            if (dir === 'left') w.scrollLeft -= amt;
            if (dir === 'right') w.scrollLeft += amt;
            if (dir === 'up') w.scrollTop -= amt;
            if (dir === 'down') w.scrollTop += amt;
        }

        function runScaling() {
            const wrap = document.getElementById("<%= ClientID %>_Wrap");
            const inner = wrap.querySelector(".table-scale-inner");
            const table = inner.querySelector("table");
            if (wrap.classList.contains("scale-off")) return;
            inner.style.transform = "scale(1)";
            const s = wrap.clientWidth / table.offsetWidth;
            if (s < 1) {
                inner.style.transform = "scale(" + s + ")";
                inner.style.height = (table.offsetHeight * s) + "px";
            } else {
                inner.style.transform = "none";
                inner.style.height = "auto";
            }
        }

        window.addEventListener("load", runScaling);
        window.addEventListener("resize", runScaling);
    </script>
</asp:Panel>
<%--<uc1:tableControl runat="server" ID="tableControl" />--%>

<hr />
<h2 style="display:none;">Column Mapping</h2>
<div class="row">
    
    <div class="col-md-10">
        <div class="card">
            <asp:Panel runat="server" ID="pnlMappingHeaders" CssClass="row" Visible="false">
                <script>$(function () { $('h2').show()})</script>
                <div class="col-md-6"><h4>Target Columns</h4></div>
                <div class="col-md-6"><h4>Incomming Columns</h4></div>
            </asp:Panel>
        
            <asp:Repeater ID="rptColumnMap" runat="server" OnItemDataBound="rptColumnMap_ItemDataBound">
                <ItemTemplate>
                    <div class="row mb-2 repeater-item">
                        <div class="col-md-6">
                            <asp:Label ID="lblSourceColumn" runat="server" CssClass="form-label fw-bold lblSourceColumn" />
                        </div>
                        <div class="col-md-6">
                            <asp:DropDownList ID="ddlTargetColumns" runat="server" CssClass="form-select ddl-target-columns" />
                        </div>
                        <asp:HiddenField ID="hfSpecialLogic" runat="server" />
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <cc20:Uploader uploadPath="uploads" buttonText="Browse for .csv, .xls, .xlsx" fileTypes="xlsx" dropAreaText="Drop File Here" ID="ulFiles" style="width:100%; height:75%; padding:0px;" runat="server" />
        </div>
    </div>
    <div class="col-md-2">
        <div class="card">

            <asp:Panel runat="server" ID="pnlFirstRow" CssClass="w-100" Style="justify-content:space-between; display: flex; align-items: center;">
                <label>First Row Contains <br /> Column Names</label>
                <asp:CheckBox runat="server" ID="cbFirstRowContainsColumnNames" />
            </asp:Panel>
            <asp:DropDownList runat="server" ID="ddTables" CssClass="form-control"></asp:DropDownList>
            <label>Target Table</label>
            <hr />
            <%--Import the file to importData--%>
            <asp:Button runat="server" ID="btnImport" Text="Import" CssClass="btn btn-primary importerButton" OnClientClick="return veryifySelection()" OnClick="btnImport_Click" />

            <%--Save and finish import--%>
            <asp:Button runat="server" ID="btnSave" Text="Save" OnClick="btnSave_Click"  Visible="false" CssClass="btn btn-primary mb-2"/>

            <%--Change target table binding--%>
            <asp:Button ID="btnRebind" runat="server" Text="Rebind" OnClientClick="clearRepeaterClientState();" OnClick="btnRebind_Click" Visible="false" CssClass="btn btn-secondary mb-2"/>

            <%--Cancel and clear everything--%>
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" Visible="false" CssClass="btn btn-danger "/>
            
            <%--Errors--%>
            <asp:Label ID="lblErrors" ForeColor="Red" runat="server" Text="" />

            <asp:Literal ID="Output" runat="server" />
            <!-- REPLACE VALUES MODAL -->
            <asp:Literal ID="litReplaceValuesData" runat="server" />
        </div>
    </div>
</div>




<!-- CREATE REFERENCE MODAL -->
<div class="modal fade" id="createRefModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Create Reference</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="createRefTargetColumn" />
                <div class="mb-3">
                    <label class="form-label">Reference Table</label>
                    <select id="refTable" class="form-select"></select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Lookup Column (Table)</label>
                    <select id="refLookupColumn" class="form-select"></select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Reference Column (Import)</label>
                    <select id="refReferenceColumn" class="form-select"></select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Return Column (x)</label>
                    <input type="text" id="refReturnColumn" class="form-control" value="ID" />
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary save-create-ref">Save</button>
            </div>
        </div>
    </div>
</div>

<!-- Replace Value MODAL -->
<div class="modal fade" id="replaceValuesModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Replace Values (x = y)</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="replaceTargetColumn" />
                <div class="mb-3">
                    <label class="form-label">Import Column (x)</label>
                    <select id="replaceSourceColumn" class="form-select mb-3">
                        <option value="">-- Select Column --</option>
                    </select>
                </div>
                <div id="replaceContainer"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary save-replace">Save</button>
            </div>
        </div>
    </div>
</div>

<!-- SPLIT COLUMN MODAL -->
<div class="modal fade" id="splitColumnModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-md">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title">Split Column</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">

        <input type="hidden" id="splitTargetColumn" />

        <div class="mb-3">
          <label class="form-label">Source Column</label>
          <select id="splitSourceColumn" class="form-select">
            <option value="">-- Select Column --</option>
          </select>
        </div>

        <div class="mb-3">
          <label class="form-label">Split Character</label>
          <input type="text" id="splitChar" class="form-control" maxlength="1" placeholder="Enter a single character (e.g., space, comma, @)" />
        </div>

        <div class="mb-3">
          <label class="form-label">Which side to save?</label>
          <select id="splitSide" class="form-select">
            <option value="Left">Left</option>
            <option value="Right">Right</option>
          </select>
        </div>

      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary save-split">Save</button>
      </div>

    </div>
  </div>
</div>

<script>

    function veryifySelection() {
        if ($('#upload ul li').length == '0') {
            alert('You must select a file to upload. \n\n Either Drag a file into the Drop area or Click to Browse for a file.')
            return false;
        }

        if ($('.ddTables').val() == '' || $('.ddTables').val() == undefined) {
            alert('You must select a Target Table in the Dropdown.')
            return false;
        }
        
        return true;
    }
</script>

<script>
    $(function () {
        $('#drop a').addClass('btn btn-primary').css('color', 'white')
        // -------------------------------
        // MAIN DROPDOWN CHANGE HANDLER
        // -------------------------------
        $(document).on('change', '.ddl-target-columns', function () {
            var ddl = $(this);
            var value = ddl.val();
            var targetColumn = ddl.data('target');

            if (!value) return;

            if (value === "__CREATE_REF__") {
                $('#createRefTargetColumn').val(targetColumn);
                initCreateRefModal();
                new bootstrap.Modal(document.getElementById('createRefModal')).show();
            }

            if (value === "__REPLACE__") {
                $('#replaceTargetColumn').val(targetColumn);
                buildReplaceColumnSelector();
                new bootstrap.Modal(document.getElementById('replaceValuesModal')).show();
            }

            if (value === "__SPLIT__") {
                $('#splitTargetColumn').val(targetColumn);
                buildSplitColumnSelector();
                new bootstrap.Modal(document.getElementById('splitColumnModal')).show();
            }
        });


        // -------------------------------
        // SAVE CREATE REFERENCE
        // -------------------------------
        $(document).on('click', '.save-create-ref', function () {
            // Gather configuration from modal
            var config = {
                Type: "CreateReference",
                ReferenceTable: $('#refTable').val(),
                LookupColumn: $('#refLookupColumn').val(),
                ReferenceColumn: $('#refReferenceColumn').val(),
                ReturnColumn: $('#refReturnColumn').val()
            };

            // Save special logic
            var targetColumn = $('#createRefTargetColumn').val();
            saveSpecialLogic(targetColumn, config);

            // Update dropdown text (leave value alone)
            $('.ddl-target-columns').each(function () {
                if ($(this).data('target') === targetColumn) {
                    var displayText = `Import Data : ${config.ReferenceColumn} -> ${config.ReferenceTable} : ${config.LookupColumn} (${config.ReturnColumn})`;
                    $(this).find('option:selected').text(displayText);
                }
            });

            // Close modal
            bootstrap.Modal.getInstance(document.getElementById('createRefModal')).hide();
        });


        // -------------------------------
        // SAVE REPLACE VALUES
        // -------------------------------
        $(document).on('click', '.save-replace', function () {
            var targetColumn = $('#replaceTargetColumn').val();
            var mappings = [];
            var outStr = '';

            $('#replaceContainer .replace-row').each(function () {
                var orig = $(this).find('.original').text().trim();
                var repl = $(this).find('.replacement').val();

                mappings.push({
                    Original: orig,
                    Replacement: repl
                });

                outStr += orig + ' = ' + repl + ', ';
            });

            // Remove trailing comma and space
            outStr = outStr.slice(0, -2);

            // Save special logic
            saveSpecialLogic(targetColumn, {
                Type: "ReplaceValues",
                SourceColumn: $('#replaceSourceColumn').val(),
                Mappings: mappings
            });

            // Update dropdown text (leave value alone)
            $('.ddl-target-columns').each(function () {
                if ($(this).data('target') === targetColumn) {
                    $(this).find('option:selected').text(outStr);
                }
            });

            bootstrap.Modal.getInstance(
                document.getElementById('replaceValuesModal')
            ).hide();
        });


        // -------------------------------
        // SAVE TO REPEATER
        // -------------------------------
        function saveSpecialLogic(targetColumn, data) {
            $('.repeater-item').each(function () {
                var lbl = $(this).find('.lblSourceColumn').text().trim();
                if (lbl === targetColumn) {
                    $(this).find('input[id$="hfSpecialLogic"]').val(JSON.stringify(data));
                }
            });
        }

        // -------------------------------
        // POPULATE CREATE REF MODAL
        // -------------------------------
        function initCreateRefModal() {
            // Populate reference column immediately from importData
            populateReferenceColumnDropdown();

            // Hide fields until table selected
            $('#refLookupColumn, #refReturnColumn, #refReferenceColumn').closest('.mb-3').hide();

            // Populate table dropdown
            var refTable = $('#refTable');
            refTable.empty();
            refTable.append('<option value=""> -- Select -- </option>');
            $('.ddTables option').each(function () {
                var val = $(this).val();
                if (val) refTable.append('<option value="' + val + '">' + val + '</option>');
            });

            refTable.trigger('change');
        }

        //function populateReferenceColumnDropdown() {
        //    var reference = $('#refReferenceColumn');
        //    reference.empty().append('<option value="">-- select --</option>');

        //    if (window.importColumns && window.importColumns.length > 0) {
        //        window.importColumns.forEach(function (col) {
        //            reference.append('<option value="' + col + '">' + col + '</option>');
        //        });
        //    }
        //}

        // -------------------------------
        // TABLE CHANGE → LOAD LOOKUP COLUMNS
        // -------------------------------
        $(document).on('change', '#refTable', function () {
            var table = $(this).val();
            var lookup = $('#refLookupColumn');
            lookup.empty().append('<option value="">-- select --</option>');

            if (!table || !window.tableColumns || !window.tableColumns[table]) return;

            window.tableColumns[table].forEach(function (col) {
                lookup.append('<option value="' + col + '">' + col + '</option>');
            });

            // Show the previously hidden fields
            $('#refLookupColumn, #refReferenceColumn, #refReturnColumn').closest('.mb-3').show();
        });

        // -------------------------------
        // REPLACE VALUES HELPERS
        // -------------------------------
        function buildReplaceColumnSelector() {
            var ddl = $('#replaceSourceColumn');
            ddl.empty().append('<option value="">-- Select Column --</option>');

            if (!window.replaceValueSource) return;
            Object.keys(window.replaceValueSource).forEach(function (col) {
                ddl.append('<option value="' + col + '">' + col + '</option>');
            });

            $('#replaceContainer').empty();
        }

        $(document).on('change', '#replaceSourceColumn', function () {
            buildReplaceUI($(this).val());
        });

        function buildReplaceUI(sourceColumn) {
            var container = $('#replaceContainer');
            container.empty();

            if (!sourceColumn || !window.replaceValueSource[sourceColumn]) {
                container.append('<div class="text-muted">No values found.</div>');
                return;
            }

            container.append('<div class="row fw-bold mb-2"><div class="col-md-5">Import Value</div><div class="col-md-7">Replace With</div></div>');

            window.replaceValueSource[sourceColumn].forEach(function (val) {
                container.append('<div class="row mb-2 replace-row"><div class="col-md-5 original">' + val + '</div><div class="col-md-7"><input type="text" class="form-control replacement" /></div></div>');
            });
        }
        /* ===============================
       Build Split Column dropdown
       =============================== */
        function buildSplitColumnSelector() {
            var ddl = $('#splitSourceColumn');
            ddl.empty().append('<option value="">-- Select Column --</option>');

            if (!window.importColumns || window.importColumns.length === 0) return;

            window.importColumns.forEach(function (col) {
                ddl.append('<option value="' + col + '">' + col + '</option>');
            });

            $('#splitChar').val('');  // reset
            $('#splitSide').val('Left'); // default
        }

        /* ===============================
           Save SPLIT CONFIG
           =============================== */
        $(document).on('click', '.save-split', function () {
            var targetColumn = $('#splitTargetColumn').val();
            var sourceColumn = $('#splitSourceColumn').val();
            var splitChar = $('#splitChar').val();
            var side = $('#splitSide').val();

            if (!sourceColumn || !splitChar) {
                alert('Please select a source column and enter a split character.');
                return;
            }

            var config = {
                Type: "SplitColumn",
                SourceColumn: sourceColumn,
                SplitChar: splitChar,
                Side: side
            };

            saveSpecialLogic(targetColumn, config);

            // Update dropdown text, leave value alone
            $('.ddl-target-columns').each(function () {
                if ($(this).data('target') === targetColumn) {
                    var displayText = sourceColumn + ' split on "' + splitChar + '" → ' + side;
                    $(this).find('option:selected').text(displayText);
                }
            });

            bootstrap.Modal.getInstance(document.getElementById('splitColumnModal')).hide();
        });
    });
</script>
<script>
    // Make it global
    window.populateReferenceColumnDropdown = function () {
        var reference = $('#refReferenceColumn');
        reference.empty().append('<option value="">-- select --</option>');

        if (window.importColumns && window.importColumns.length > 0) {
            window.importColumns.forEach(function (col) {
                reference.append('<option value="' + col + '">' + col + '</option>');
            });
        }
    };
</script>


<%--Kill Hidden Fields--%>
<script>
    function clearRepeaterClientState() {
        $('.repeater-item').each(function () {
            $(this).find('input[id$="hfSpecialLogic"]').val('');
            $(this).find('.ddl-target-columns').prop('selectedIndex', 0);
        });
    }
</script>
