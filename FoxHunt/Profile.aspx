<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="FoxHunt.Profile" %>
<%@ Register Src="~/Workers/userControls/CheckGroup.ascx" TagPrefix="uc1" TagName="CheckGroup" %>
<%@ Register Src="~/userControlsMain/UCCommentChat.ascx" TagPrefix="uc2" TagName="UCCommentChat" %>
<%@ Register Src="~/Workers/userControls/UCeventAttendance.ascx" TagPrefix="uc3" TagName="UCeventAttendance" %>
<%@ Register Src="~/Workers/userControls/UCassignments.ascx" TagPrefix="uc4" TagName="UCassignments" %>
<%@ Register Src="~/Workers/userControls/UCavailability.ascx" TagPrefix="uc5" TagName="UCavailability" %>
<%@ Register Src="~/Workers/userControls/UCnotifications.ascx" TagPrefix="uc6" TagName="UCnotifications" %>
<%@ Register Src="~/Workers/userControls/UCpayments.ascx" TagPrefix="uc7" TagName="UCpayments" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="pnlNew" runat="server">
        <div class="row gy-4">
                <!-- User Sidebar -->
                <div class="col-xl-4 col-lg-5 col-md-5 order-1 order-md-0">
                  <!-- User Card -->
                  <div class="card mb-4">
                    <div class="card-body">
                      <div class="user-avatar-section">
                        <div class="d-flex align-items-center flex-column">
                          <%--<img class="img-fluid rounded my-4" src="/assets/img/avatars/10.png" height="110" width="110" alt="User avatar">--%>
                            <%=FoxHunt.ExtUserIcon.getUserImg(row,true) %>
                          <div class="user-info text-center">
                            <h5 class="mb-2"><%=FoxHunt.ExtUserIcon.getName(row) %></h5>
                            <span class="badge bg-label-secondary"><%=FoxHunt.ExtUserIcon.getRoles(Data.getVal(row,"RoleIDs","")) %></span>
                          </div>
                        </div>
                      </div>
                      <div class="d-flex justify-content-around flex-wrap my-4 py-3">
                        <div class="d-flex align-items-start me-4 mt-3 gap-3">
                          <span class="badge bg-label-primary p-2 rounded"><i class="bx bx-check bx-sm"></i></span>
                          <div>
                            <h5 class="mb-0">1.23k</h5>
                            <span>Tasks Done</span>
                          </div>
                        </div>
                        <div class="d-flex align-items-start mt-3 gap-3">
                          <span class="badge bg-label-primary p-2 rounded"><i class="bx bx-customize bx-sm"></i></span>
                          <div>
                            <h5 class="mb-0">568</h5>
                            <span>Projects Done</span>
                          </div>
                        </div>
                      </div>
                      <h5 class="pb-2 border-bottom mb-4">Details</h5>
                      <div class="info-container">
                        <ul class="list-unstyled">
                          <li class="mb-3">
                            <span class="fw-bold me-2">Status:</span>
                              <%                    string labelType = "warning";
                    if (row["status"].ToString().ToLower() == "removed" || row["status"].ToString().ToLower() == "denied")
                        labelType = "danger";
                    if (row["status"].ToString().ToLower() == "active")
                        labelType = "success";
                    %>
                           <span class="badge bg-label-<%=labelType %>"><%=row["status"] %></span>
                          </li>
                          <li class="mb-3">
                            <span class="fw-bold me-2">Email:</span>
                            <span><%=row["email"] %></span>
                          </li>

                          <li class="mb-3">
                            <span class="fw-bold me-2">Role:</span>
                            <span>Author</span>
                          </li>
                          <li class="mb-3">
                            <span class="fw-bold me-2">Tax id:</span>
                            <span>Tax-8965</span>
                          </li>
                          <li class="mb-3">
                            <span class="fw-bold me-2">Contact:</span>
                            <span>(123) 456-7890</span>
                          </li>
                          <li class="mb-3">
                            <span class="fw-bold me-2">Languages:</span>
                            <span>French</span>
                          </li>
                          <li class="mb-3">
                            <span class="fw-bold me-2">Country:</span>
                            <span>England</span>
                          </li>
                        </ul>
                        <div class="d-flex justify-content-center pt-3">
                          <a href="javascript:;" class="btn btn-primary me-3" data-bs-target="#editUser" data-bs-toggle="modal">Edit</a>
                          <a href="javascript:;" class="btn btn-label-danger suspend-user">Suspended</a>
                        </div>
                      </div>
                    </div>
                  </div>
                  <!-- /User Card -->


                  <!-- Plan Card -->
                  <div class="card">
                    <div class="card-body">
                      <div class="d-flex justify-content-between align-items-start">
                        <span class="badge bg-label-primary">Standard</span>
                        <div class="d-flex justify-content-center">
                          <sup class="h5 pricing-currency mt-3 mt-sm-4 mb-0 me-1 text-primary">$</sup>
                          <h1 class="display-3 fw-normal mb-0 text-primary">99</h1>
                          <sub class="fs-6 pricing-duration mt-auto mb-4">/month</sub>
                        </div>
                      </div>
                      <ul class="ps-3 g-2 mb-3">
                        <li class="mb-2">10 Users</li>
                        <li class="mb-2">Up to 10 GB storage</li>
                        <li>Basic Support</li>
                      </ul>
                      <div class="d-flex justify-content-between align-items-center mb-1">
                        <h6 class="mb-0">Days</h6>
                        <h6 class="mb-0">65% Completed</h6>
                      </div>
                      <div class="progress mb-1" style="height: 8px">
                        <div class="progress-bar" role="progressbar" style="width: 65%" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                      </div>
                      <span>4 days remaining</span>
                      <div class="d-grid w-100 mt-3 pt-2">
                        <button class="btn btn-primary" data-bs-target="#upgradePlanModal" data-bs-toggle="modal">
                          Upgrade Plan
                        </button>
                      </div>
                    </div>
                  </div>
                  <!-- /Plan Card -->
                </div>
                <!--/ User Sidebar -->

                <!-- User Content -->
                <div class="col-xl-8 col-lg-7 col-md-7 order-0 order-md-1">
                  <!-- User Pills -->
                  <ul class="nav nav-pills flex-column flex-md-row mb-3">
                    <li class="nav-item">
                      <a class="nav-link active" href="javascript:void(0);"><i class="bx bx-user me-1"></i>Account</a>
                    </li>
                    <li class="nav-item">
                      <a class="nav-link" href="app-user-view-security.html"><i class="bx bx-lock-alt me-1"></i>Security</a>
                    </li>
                    <li class="nav-item">
                      <a class="nav-link" href="app-user-view-billing.html"><i class="bx bx-detail me-1"></i>Billing &amp; Plans</a>
                    </li>
                    <li class="nav-item">
                      <a class="nav-link" href="app-user-view-notifications.html"><i class="bx bx-bell me-1"></i>Notifications</a>
                    </li>
                    <li class="nav-item">
                      <a class="nav-link" href="app-user-view-connections.html"><i class="bx bx-link-alt me-1"></i>Connections</a>
                    </li>
                  </ul>
                  <!--/ User Pills -->

                  <!-- Project table -->
                  <div class="card mb-4">
                    <h5 class="card-header">User's Projects List</h5>
                    <div class="table-responsive mb-3">
                      <div id="DataTables_Table_0_wrapper" class="dataTables_wrapper dt-bootstrap5 no-footer"><div class="d-flex justify-content-between align-items-center flex-column flex-sm-row mx-4 row"><div class="col-sm-4 col-12 d-flex align-items-center justify-content-sm-start justify-content-center"><div class="dataTables_length" id="DataTables_Table_0_length"><label>Show <select name="DataTables_Table_0_length" aria-controls="DataTables_Table_0" class="form-select"><option value="7">7</option><option value="10">10</option><option value="25">25</option><option value="50">50</option><option value="75">75</option><option value="100">100</option></select></label></div></div><div class="col-sm-8 col-12 d-flex align-items-center justify-content-sm-end justify-content-center"><div id="DataTables_Table_0_filter" class="dataTables_filter"><label>Search:<input type="search" class="form-control" placeholder="Search Project" aria-controls="DataTables_Table_0"></label></div></div></div><table class="table datatable-project border-top dataTable no-footer dtr-column collapsed" id="DataTables_Table_0" aria-describedby="DataTables_Table_0_info" style="width: 623px;">
                        <thead>
                          <tr><th class="control sorting" tabindex="0" aria-controls="DataTables_Table_0" rowspan="1" colspan="1" style="width: 6px;" aria-label=": activate to sort column ascending"></th><th class="sorting sorting_desc" tabindex="0" aria-controls="DataTables_Table_0" rowspan="1" colspan="1" style="width: 240px;" aria-label="Project: activate to sort column ascending" aria-sort="descending">Project</th><th class="text-nowrap sorting_disabled" rowspan="1" colspan="1" style="width: 94px;" aria-label="Total Task">Total Task</th><th class="sorting" tabindex="0" aria-controls="DataTables_Table_0" rowspan="1" colspan="1" style="width: 85px;" aria-label="Progress: activate to sort column ascending">Progress</th><th class="sorting_disabled dtr-hidden" rowspan="1" colspan="1" style="width: 0px; display: none;" aria-label="Hours">Hours</th></tr>
                        </thead><tbody><tr class="odd"><td class="control" tabindex="0" style=""></td><td class="sorting_1"><div class="d-flex justify-content-left align-items-center"><div class="avatar-wrapper"><div class="avatar avatar-sm me-3"><img src="/assets/img/icons/brands/vue-label.png" alt="Project Image" class="rounded-circle"></div></div><div class="d-flex flex-column"><span class="text-truncate fw-semibold">Vue Admin template</span><small class="text-muted">Vuejs Project</small></div></div></td><td>214/627</td><td><div class="d-flex flex-column"><small class="mb-1">78%</small><div class="progress w-100 me-3" style="height: 6px;"><div class="progress-bar bg-success" style="width: 78%" aria-valuenow="78%" aria-valuemin="0" aria-valuemax="100"></div></div></div></td><td class="dtr-hidden" style="display: none;">88:19h</td></tr><tr class="even"><td class="control" tabindex="0" style=""></td><td class="sorting_1"><div class="d-flex justify-content-left align-items-center"><div class="avatar-wrapper"><div class="avatar avatar-sm me-3"><img src="/assets/img/icons/brands/event-label.png" alt="Project Image" class="rounded-circle"></div></div><div class="d-flex flex-column"><span class="text-truncate fw-semibold">Online Webinar</span><small class="text-muted">Official Event</small></div></div></td><td>12/20</td><td><div class="d-flex flex-column"><small class="mb-1">69%</small><div class="progress w-100 me-3" style="height: 6px;"><div class="progress-bar bg-info" style="width: 69%" aria-valuenow="69%" aria-valuemin="0" aria-valuemax="100"></div></div></div></td><td class="dtr-hidden" style="display: none;">12:12h</td></tr><tr class="odd"><td class="control" tabindex="0" style=""></td><td class="sorting_1"><div class="d-flex justify-content-left align-items-center"><div class="avatar-wrapper"><div class="avatar avatar-sm me-3"><img src="/assets/img/icons/brands/html-label.png" alt="Project Image" class="rounded-circle"></div></div><div class="d-flex flex-column"><span class="text-truncate fw-semibold">Hoffman Website</span><small class="text-muted">HTML Project</small></div></div></td><td>56/183</td><td><div class="d-flex flex-column"><small class="mb-1">43%</small><div class="progress w-100 me-3" style="height: 6px;"><div class="progress-bar bg-warning" style="width: 43%" aria-valuenow="43%" aria-valuemin="0" aria-valuemax="100"></div></div></div></td><td class="dtr-hidden" style="display: none;">76h</td></tr><tr class="even"><td class="control" tabindex="0" style=""></td><td class="sorting_1"><div class="d-flex justify-content-left align-items-center"><div class="avatar-wrapper"><div class="avatar avatar-sm me-3"><img src="/assets/img/icons/brands/sketch-label.png" alt="Project Image" class="rounded-circle"></div></div><div class="d-flex flex-column"><span class="text-truncate fw-semibold">Foodista mobile app</span><small class="text-muted">iPhone Project</small></div></div></td><td>12/86</td><td><div class="d-flex flex-column"><small class="mb-1">49%</small><div class="progress w-100 me-3" style="height: 6px;"><div class="progress-bar bg-warning" style="width: 49%" aria-valuenow="49%" aria-valuemin="0" aria-valuemax="100"></div></div></div></td><td class="dtr-hidden" style="display: none;">45h</td></tr><tr class="odd"><td class="control" tabindex="0" style=""></td><td class="sorting_1"><div class="d-flex justify-content-left align-items-center"><div class="avatar-wrapper"><div class="avatar avatar-sm me-3"><img src="/assets/img/icons/brands/xd-label.png" alt="Project Image" class="rounded-circle"></div></div><div class="d-flex flex-column"><span class="text-truncate fw-semibold">Falcon Logo Design</span><small class="text-muted">UI/UX Project</small></div></div></td><td>9/50</td><td><div class="d-flex flex-column"><small class="mb-1">15%</small><div class="progress w-100 me-3" style="height: 6px;"><div class="progress-bar bg-danger" style="width: 15%" aria-valuenow="15%" aria-valuemin="0" aria-valuemax="100"></div></div></div></td><td class="dtr-hidden" style="display: none;">89h</td></tr><tr class="even"><td class="control" tabindex="0" style=""></td><td class="sorting_1"><div class="d-flex justify-content-left align-items-center"><div class="avatar-wrapper"><div class="avatar avatar-sm me-3"><img src="/assets/img/icons/brands/react-label.png" alt="Project Image" class="rounded-circle"></div></div><div class="d-flex flex-column"><span class="text-truncate fw-semibold">Dojo React Project</span><small class="text-muted">React Project</small></div></div></td><td>234/378</td><td><div class="d-flex flex-column"><small class="mb-1">73%</small><div class="progress w-100 me-3" style="height: 6px;"><div class="progress-bar bg-info" style="width: 73%" aria-valuenow="73%" aria-valuemin="0" aria-valuemax="100"></div></div></div></td><td class="dtr-hidden" style="display: none;">67:10h</td></tr><tr class="odd"><td class="control" tabindex="0" style=""></td><td class="sorting_1"><div class="d-flex justify-content-left align-items-center"><div class="avatar-wrapper"><div class="avatar avatar-sm me-3"><img src="/assets/img/icons/brands/vue-label.png" alt="Project Image" class="rounded-circle"></div></div><div class="d-flex flex-column"><span class="text-truncate fw-semibold">Dashboard Design</span><small class="text-muted">Vuejs Project</small></div></div></td><td>100/190</td><td><div class="d-flex flex-column"><small class="mb-1">90%</small><div class="progress w-100 me-3" style="height: 6px;"><div class="progress-bar bg-success" style="width: 90%" aria-valuenow="90%" aria-valuemin="0" aria-valuemax="100"></div></div></div></td><td class="dtr-hidden" style="display: none;">129:45h</td></tr></tbody>
                      </table><div class="d-flex justify-content-between mx-4 row"><div class="col-sm-12 col-md-6"><div class="dataTables_info" id="DataTables_Table_0_info" role="status" aria-live="polite">Showing 1 to 7 of 11 entries</div></div><div class="col-sm-12 col-md-6"><div class="dataTables_paginate paging_simple_numbers" id="DataTables_Table_0_paginate"><ul class="pagination"><li class="paginate_button page-item previous disabled" id="DataTables_Table_0_previous"><a href="javascript:void(0)" aria-controls="DataTables_Table_0" data-dt-idx="previous" tabindex="0" class="page-link">Previous</a></li><li class="paginate_button page-item active"><a href="javascript:void(0)" aria-controls="DataTables_Table_0" data-dt-idx="0" tabindex="0" class="page-link">1</a></li><li class="paginate_button page-item "><a href="javascript:void(0)" aria-controls="DataTables_Table_0" data-dt-idx="1" tabindex="0" class="page-link">2</a></li><li class="paginate_button page-item next" id="DataTables_Table_0_next"><a href="javascript:void(0)" aria-controls="DataTables_Table_0" data-dt-idx="next" tabindex="0" class="page-link">Next</a></li></ul></div></div></div></div>
                    </div>
                  </div>
                  <!-- /Project table -->

                  <!-- Activity Timeline -->
                  <div class="card mb-4">
                    <h5 class="card-header">User Activity Timeline</h5>
                    <div class="card-body">
                      <ul class="timeline">
                        <li class="timeline-item timeline-item-transparent">
                          <span class="timeline-point timeline-point-primary"></span>
                          <div class="timeline-event">
                            <div class="timeline-header mb-1">
                              <h6 class="mb-0">12 Invoices have been paid</h6>
                              <small class="text-muted">12 min ago</small>
                            </div>
                            <p class="mb-2">Invoices have been paid to the company</p>
                            <div class="d-flex">
                              <a href="javascript:void(0)" class="me-3">
                                <img src="/assets/img/icons/misc/pdf.png" alt="PDF image" width="20" class="me-2">
                                <span class="fw-bold text-body">invoices.pdf</span>
                              </a>
                            </div>
                          </div>
                        </li>
                        <li class="timeline-item timeline-item-transparent">
                          <span class="timeline-point timeline-point-warning"></span>
                          <div class="timeline-event">
                            <div class="timeline-header mb-1">
                              <h6 class="mb-0">Client Meeting</h6>
                              <small class="text-muted">45 min ago</small>
                            </div>
                            <p class="mb-2">Project meeting with john @10:15am</p>
                            <div class="d-flex flex-wrap">
                              <div class="avatar me-3">
                                <img src="/assets/img/avatars/3.png" alt="Avatar" class="rounded-circle">
                              </div>
                              <div>
                                <h6 class="mb-0">Lester McCarthy (Client)</h6>
                                <span>CEO of PIXINVENT</span>
                              </div>
                            </div>
                          </div>
                        </li>
                        <li class="timeline-item timeline-item-transparent">
                          <span class="timeline-point timeline-point-info"></span>
                          <div class="timeline-event">
                            <div class="timeline-header mb-1">
                              <h6 class="mb-0">Create a new project for client</h6>
                              <small class="text-muted">2 Day Ago</small>
                            </div>
                            <p class="mb-2">5 team members in a project</p>
                            <div class="d-flex align-items-center avatar-group">
                              <div class="avatar pull-up" data-bs-toggle="tooltip" data-popup="tooltip-custom" data-bs-placement="top" aria-label="Vinnie Mostowy" data-bs-original-title="Vinnie Mostowy">
                                <img src="/assets/img/avatars/5.png" alt="Avatar" class="rounded-circle">
                              </div>
                              <div class="avatar pull-up" data-bs-toggle="tooltip" data-popup="tooltip-custom" data-bs-placement="top" aria-label="Marrie Patty" data-bs-original-title="Marrie Patty">
                                <img src="/assets/img/avatars/12.png" alt="Avatar" class="rounded-circle">
                              </div>
                              <div class="avatar pull-up" data-bs-toggle="tooltip" data-popup="tooltip-custom" data-bs-placement="top" aria-label="Jimmy Jackson" data-bs-original-title="Jimmy Jackson">
                                <img src="/assets/img/avatars/9.png" alt="Avatar" class="rounded-circle">
                              </div>
                              <div class="avatar pull-up" data-bs-toggle="tooltip" data-popup="tooltip-custom" data-bs-placement="top" aria-label="Kristine Gill" data-bs-original-title="Kristine Gill">
                                <img src="/assets/img/avatars/6.png" alt="Avatar" class="rounded-circle">
                              </div>
                              <div class="avatar pull-up" data-bs-toggle="tooltip" data-popup="tooltip-custom" data-bs-placement="top" aria-label="Nelson Wilson" data-bs-original-title="Nelson Wilson">
                                <img src="/assets/img/avatars/14.png" alt="Avatar" class="rounded-circle">
                              </div>
                            </div>
                          </div>
                        </li>
                        <li class="timeline-item timeline-item-transparent">
                          <span class="timeline-point timeline-point-success"></span>
                          <div class="timeline-event">
                            <div class="timeline-header mb-1">
                              <h6 class="mb-0">Design Review</h6>
                              <small class="text-muted">5 days Ago</small>
                            </div>
                            <p class="mb-0">Weekly review of freshly prepared design for our new app.</p>
                          </div>
                        </li>
                        <li class="timeline-end-indicator">
                          <i class="bx bx-check-circle"></i>
                        </li>
                      </ul>
                    </div>
                  </div>
                  <!-- /Activity Timeline -->

                  <!-- Invoice table -->
                  <div class="card">
                    <div class="table-responsive mb-3">
                      <div id="DataTables_Table_1_wrapper" class="dataTables_wrapper dt-bootstrap5 no-footer"><div class="row mx-4"><div class="col-sm-6 col-12 d-flex align-items-center justify-content-center justify-content-sm-start mb-3 mb-md-0"><div class="dataTables_length" id="DataTables_Table_1_length"><label><select name="DataTables_Table_1_length" aria-controls="DataTables_Table_1" class="form-select"><option value="10">10</option><option value="25">25</option><option value="50">50</option><option value="100">100</option></select></label></div></div><div class="col-sm-6 col-12 d-flex align-items-center justify-content-center justify-content-sm-end"><div class="dt-buttons btn-group flex-wrap"><div class="btn-group"><button class="btn btn-secondary buttons-collection dropdown-toggle btn-label-secondary float-sm-end mb-3 mb-sm-0" tabindex="0" aria-controls="DataTables_Table_1" type="button" aria-haspopup="dialog" aria-expanded="false"><span><i class="bx bx-upload me-2"></i>Export</span><span class="dt-down-arrow"></span></button></div> </div></div></div><table class="table datatable-invoice border-top dataTable no-footer dtr-column" id="DataTables_Table_1" aria-describedby="DataTables_Table_1_info" style="width: 622px;">
                        <thead>
                          <tr><th class="control sorting dtr-hidden" tabindex="0" aria-controls="DataTables_Table_1" rowspan="1" colspan="1" style="width: 0px; display: none;" aria-label=": activate to sort column ascending"></th><th class="sorting sorting_desc" tabindex="0" aria-controls="DataTables_Table_1" rowspan="1" colspan="1" style="width: 61px;" aria-label="ID: activate to sort column ascending" aria-sort="descending">ID</th><th class="sorting" tabindex="0" aria-controls="DataTables_Table_1" rowspan="1" colspan="1" style="width: 42px;" aria-label=": activate to sort column ascending"><i class="bx bx-trending-up"></i></th><th class="sorting" tabindex="0" aria-controls="DataTables_Table_1" rowspan="1" colspan="1" style="width: 59px;" aria-label="Total: activate to sort column ascending">Total</th><th class="sorting" tabindex="0" aria-controls="DataTables_Table_1" rowspan="1" colspan="1" style="width: 111px;" aria-label="Issued Date: activate to sort column ascending">Issued Date</th><th class="sorting_disabled" rowspan="1" colspan="1" style="width: 101px;" aria-label="Actions">Actions</th></tr>
                        </thead><tbody><tr class="odd"><td class="  control" tabindex="0" style="display: none;"></td><td class="sorting_1"><a href="app-invoice-preview.html">#5089</a></td><td><span data-bs-toggle="tooltip" data-bs-html="true" aria-label="<span>Sent<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 05/09/2020</span>" data-bs-original-title="<span>Sent<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 05/09/2020</span>"><span class="badge badge-center rounded-pill bg-label-secondary w-px-30 h-px-30 "><i class="bx bx-mail-send bx-xs"></i></span></span></td><td>$3077</td><td>05/02/2020</td><td><div class="d-flex align-items-center"><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Send Mail" data-bs-original-title="Send Mail"><i class="bx bx-paper-plane mx-1"></i></a><a href="app-invoice-preview.html" class="text-body" data-bs-toggle="tooltip" aria-label="Preview" data-bs-original-title="Preview"><i class="bx bx-show-alt mx-1"></i></a><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Download" data-bs-original-title="Download"><i class="bx bx-download mx-1"></i></a></div></td></tr><tr class="even"><td class="  control" tabindex="0" style="display: none;"></td><td class="sorting_1"><a href="app-invoice-preview.html">#5041</a></td><td><span data-bs-toggle="tooltip" data-bs-html="true" aria-label="<span>Sent<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 11/19/2020</span>" data-bs-original-title="<span>Sent<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 11/19/2020</span>"><span class="badge badge-center rounded-pill bg-label-secondary w-px-30 h-px-30 "><i class="bx bx-mail-send bx-xs"></i></span></span></td><td>$2230</td><td>02/01/2021</td><td><div class="d-flex align-items-center"><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Send Mail" data-bs-original-title="Send Mail"><i class="bx bx-paper-plane mx-1"></i></a><a href="app-invoice-preview.html" class="text-body" data-bs-toggle="tooltip" aria-label="Preview" data-bs-original-title="Preview"><i class="bx bx-show-alt mx-1"></i></a><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Download" data-bs-original-title="Download"><i class="bx bx-download mx-1"></i></a></div></td></tr><tr class="odd"><td class="  control" tabindex="0" style="display: none;"></td><td class="sorting_1"><a href="app-invoice-preview.html">#5027</a></td><td><span data-bs-toggle="tooltip" data-bs-html="true" aria-label="<span>Partial Payment<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 09/25/2020</span>" data-bs-original-title="<span>Partial Payment<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 09/25/2020</span>"><span class="badge badge-center rounded-pill bg-label-success w-px-30 h-px-30"><i class="bx bx-adjust bx-xs"></i></span></span></td><td>$2787</td><td>09/28/2020</td><td><div class="d-flex align-items-center"><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Send Mail" data-bs-original-title="Send Mail"><i class="bx bx-paper-plane mx-1"></i></a><a href="app-invoice-preview.html" class="text-body" data-bs-toggle="tooltip" aria-label="Preview" data-bs-original-title="Preview"><i class="bx bx-show-alt mx-1"></i></a><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Download" data-bs-original-title="Download"><i class="bx bx-download mx-1"></i></a></div></td></tr><tr class="even"><td class="  control" tabindex="0" style="display: none;"></td><td class="sorting_1"><a href="app-invoice-preview.html">#5024</a></td><td><span data-bs-toggle="tooltip" data-bs-html="true" aria-label="<span>Partial Payment<br> <strong>Balance:</strong> -$202<br> <strong>Due Date:</strong> 08/02/2020</span>" data-bs-original-title="<span>Partial Payment<br> <strong>Balance:</strong> -$202<br> <strong>Due Date:</strong> 08/02/2020</span>"><span class="badge badge-center rounded-pill bg-label-success w-px-30 h-px-30"><i class="bx bx-adjust bx-xs"></i></span></span></td><td>$5285</td><td>06/30/2020</td><td><div class="d-flex align-items-center"><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Send Mail" data-bs-original-title="Send Mail"><i class="bx bx-paper-plane mx-1"></i></a><a href="app-invoice-preview.html" class="text-body" data-bs-toggle="tooltip" aria-label="Preview" data-bs-original-title="Preview"><i class="bx bx-show-alt mx-1"></i></a><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Download" data-bs-original-title="Download"><i class="bx bx-download mx-1"></i></a></div></td></tr><tr class="odd"><td class="  control" tabindex="0" style="display: none;"></td><td class="sorting_1"><a href="app-invoice-preview.html">#5020</a></td><td><span data-bs-toggle="tooltip" data-bs-html="true" aria-label="<span>Downloaded<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 12/15/2020</span>" data-bs-original-title="<span>Downloaded<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 12/15/2020</span>"><span class="badge badge-center rounded-pill bg-label-info w-px-30 h-px-30"><i class="bx bx-down-arrow-circle bx-xs"></i></span></span></td><td>$5219</td><td>07/17/2020</td><td><div class="d-flex align-items-center"><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Send Mail" data-bs-original-title="Send Mail"><i class="bx bx-paper-plane mx-1"></i></a><a href="app-invoice-preview.html" class="text-body" data-bs-toggle="tooltip" aria-label="Preview" data-bs-original-title="Preview"><i class="bx bx-show-alt mx-1"></i></a><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Download" data-bs-original-title="Download"><i class="bx bx-download mx-1"></i></a></div></td></tr><tr class="even"><td class="  control" tabindex="0" style="display: none;"></td><td class="sorting_1"><a href="app-invoice-preview.html">#4995</a></td><td><span data-bs-toggle="tooltip" data-bs-html="true" aria-label="<span>Partial Payment<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 06/09/2020</span>" data-bs-original-title="<span>Partial Payment<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 06/09/2020</span>"><span class="badge badge-center rounded-pill bg-label-success w-px-30 h-px-30"><i class="bx bx-adjust bx-xs"></i></span></span></td><td>$3313</td><td>08/21/2020</td><td><div class="d-flex align-items-center"><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Send Mail" data-bs-original-title="Send Mail"><i class="bx bx-paper-plane mx-1"></i></a><a href="app-invoice-preview.html" class="text-body" data-bs-toggle="tooltip" aria-label="Preview" data-bs-original-title="Preview"><i class="bx bx-show-alt mx-1"></i></a><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Download" data-bs-original-title="Download"><i class="bx bx-download mx-1"></i></a></div></td></tr><tr class="odd"><td class="  control" tabindex="0" style="display: none;"></td><td class="sorting_1"><a href="app-invoice-preview.html">#4993</a></td><td><span data-bs-toggle="tooltip" data-bs-html="true" aria-label="<span>Partial Payment<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 10/22/2020</span>" data-bs-original-title="<span>Partial Payment<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 10/22/2020</span>"><span class="badge badge-center rounded-pill bg-label-success w-px-30 h-px-30"><i class="bx bx-adjust bx-xs"></i></span></span></td><td>$4836</td><td>07/10/2020</td><td><div class="d-flex align-items-center"><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Send Mail" data-bs-original-title="Send Mail"><i class="bx bx-paper-plane mx-1"></i></a><a href="app-invoice-preview.html" class="text-body" data-bs-toggle="tooltip" aria-label="Preview" data-bs-original-title="Preview"><i class="bx bx-show-alt mx-1"></i></a><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Download" data-bs-original-title="Download"><i class="bx bx-download mx-1"></i></a></div></td></tr><tr class="even"><td class="  control" tabindex="0" style="display: none;"></td><td class="sorting_1"><a href="app-invoice-preview.html">#4989</a></td><td><span data-bs-toggle="tooltip" data-bs-html="true" aria-label="<span>Past Due<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 08/01/2020</span>" data-bs-original-title="<span>Past Due<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 08/01/2020</span>"><span class="badge badge-center rounded-pill bg-label-danger w-px-30 h-px-30"><i class="bx bx-info-circle bx-xs"></i></span></span></td><td>$5293</td><td>07/30/2020</td><td><div class="d-flex align-items-center"><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Send Mail" data-bs-original-title="Send Mail"><i class="bx bx-paper-plane mx-1"></i></a><a href="app-invoice-preview.html" class="text-body" data-bs-toggle="tooltip" aria-label="Preview" data-bs-original-title="Preview"><i class="bx bx-show-alt mx-1"></i></a><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Download" data-bs-original-title="Download"><i class="bx bx-download mx-1"></i></a></div></td></tr><tr class="odd"><td class="  control" tabindex="0" style="display: none;"></td><td class="sorting_1"><a href="app-invoice-preview.html">#4989</a></td><td><span data-bs-toggle="tooltip" data-bs-html="true" aria-label="<span>Downloaded<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 09/23/2020</span>" data-bs-original-title="<span>Downloaded<br> <strong>Balance:</strong> 0<br> <strong>Due Date:</strong> 09/23/2020</span>"><span class="badge badge-center rounded-pill bg-label-info w-px-30 h-px-30"><i class="bx bx-down-arrow-circle bx-xs"></i></span></span></td><td>$3623</td><td>12/01/2020</td><td><div class="d-flex align-items-center"><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Send Mail" data-bs-original-title="Send Mail"><i class="bx bx-paper-plane mx-1"></i></a><a href="app-invoice-preview.html" class="text-body" data-bs-toggle="tooltip" aria-label="Preview" data-bs-original-title="Preview"><i class="bx bx-show-alt mx-1"></i></a><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Download" data-bs-original-title="Download"><i class="bx bx-download mx-1"></i></a></div></td></tr><tr class="even"><td class="  control" tabindex="0" style="display: none;"></td><td class="sorting_1"><a href="app-invoice-preview.html">#4965</a></td><td><span data-bs-toggle="tooltip" data-bs-html="true" aria-label="<span>Partial Payment<br> <strong>Balance:</strong> $666<br> <strong>Due Date:</strong> 03/18/2021</span>" data-bs-original-title="<span>Partial Payment<br> <strong>Balance:</strong> $666<br> <strong>Due Date:</strong> 03/18/2021</span>"><span class="badge badge-center rounded-pill bg-label-success w-px-30 h-px-30"><i class="bx bx-adjust bx-xs"></i></span></span></td><td>$3789</td><td>09/27/2020</td><td><div class="d-flex align-items-center"><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Send Mail" data-bs-original-title="Send Mail"><i class="bx bx-paper-plane mx-1"></i></a><a href="app-invoice-preview.html" class="text-body" data-bs-toggle="tooltip" aria-label="Preview" data-bs-original-title="Preview"><i class="bx bx-show-alt mx-1"></i></a><a href="javascript:;" class="text-body" data-bs-toggle="tooltip" aria-label="Download" data-bs-original-title="Download"><i class="bx bx-download mx-1"></i></a></div></td></tr></tbody>
                      </table><div class="row mx-4"><div class="col-md-12 col-lg-6 text-center text-lg-start pb-md-2 pb-lg-0"><div class="dataTables_info" id="DataTables_Table_1_info" role="status" aria-live="polite">Showing 1 to 10 of 50 entries</div></div><div class="col-md-12 col-lg-6 d-flex justify-content-center justify-content-lg-end"><div class="dataTables_paginate paging_simple_numbers" id="DataTables_Table_1_paginate"><ul class="pagination"><li class="paginate_button page-item previous disabled" id="DataTables_Table_1_previous"><a href="javascript:void(0)" aria-controls="DataTables_Table_1" data-dt-idx="previous" tabindex="0" class="page-link">Previous</a></li><li class="paginate_button page-item active"><a href="javascript:void(0)" aria-controls="DataTables_Table_1" data-dt-idx="0" tabindex="0" class="page-link">1</a></li><li class="paginate_button page-item "><a href="javascript:void(0)" aria-controls="DataTables_Table_1" data-dt-idx="1" tabindex="0" class="page-link">2</a></li><li class="paginate_button page-item "><a href="javascript:void(0)" aria-controls="DataTables_Table_1" data-dt-idx="2" tabindex="0" class="page-link">3</a></li><li class="paginate_button page-item "><a href="javascript:void(0)" aria-controls="DataTables_Table_1" data-dt-idx="3" tabindex="0" class="page-link">4</a></li><li class="paginate_button page-item "><a href="javascript:void(0)" aria-controls="DataTables_Table_1" data-dt-idx="4" tabindex="0" class="page-link">5</a></li><li class="paginate_button page-item next" id="DataTables_Table_1_next"><a href="javascript:void(0)" aria-controls="DataTables_Table_1" data-dt-idx="next" tabindex="0" class="page-link">Next</a></li></ul></div></div></div></div>
                    </div>
                  </div>
                  <!-- /Invoice table -->
                </div>
                <!--/ User Content -->
              </div>
    </asp:Panel>
    <asp:Panel ID="pnlOld" runat="server" Visible="false">
    <style type="text/css">
        .steps li{
            cursor:pointer;
        }
        .stepcommand {
            display:none;
        }
        .prev, .next {
            position: fixed;
            bottom: 4px;
        }

        .next {
            right: 10px;
        }
        .btncnall{
            margin: 10px;
        }
        .prev {
            left: 10px;
        }

        .btnSave {
            display: none;
        }

        .btnSaveNoCCN {
            display: none;
            margin-right: 200px;
        }

        .fieldset {
            border: solid 1px black;
            margin: 6px;
            position: relative;
            padding: 6px;
            padding-top: 14px;
        }

        .legend {
            border: solid 1px black;
            left: 0.5em;
            top: -0.8em;
            position: absolute;
            font-weight: bold;
            padding: 0 0.25em 0 0.25em;
        }
        .row {
            margin-right: 0;
        }
        .btnRestartOnboarding{
            margin-top:5px;
        }
        .commentblock{
             padding:1px!important;
             height:unset!important;
             min-height:unset!important;
         }
        .previousComments{
            max-height: 200px!important;
            overflow: auto;
            /*flex-direction: column-reverse;
            display: flex;*/
        }
        .pnlComments{
            padding-top: 5px;
            padding-bottom: 5px;
            border: 2px solid;
            border-radius: 5px;
        }
        .specialfeild{
            height:auto!important;
        }
        .formsec{
            text-align:center;
            justify-content:center;
        }
        .lblremovaldate{
            margin-top:20px;
            margin-left: -15px;
            width: 263px;
        }

    </style>
    <%--    <script type="text/javascript" src="js/formToWizard.js"></script>--%>

    <link rel="stylesheet" href="/js/formToWizard.css" />
    <link rel="stylesheet" href="/js/validationEngine.jquery.css" />

    <script src="/js/jquery.formToWizard.js"></script>
    <script src="/js/jquery.validationEngine.js"></script>
    <script src="/js/jquery.validationEngine-en.js"></script>
    <script type="text/javascript" src="/js/tablescroll.js"></script>
    <link href="/js/tableScroll.css" media="screen" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function colorGrid(grid, column, matchValue, color) {
            if (!color) color = 'red';
            var $trLst = grid.find("tr");
            var data = grid.getRowData();
            for (var i = 0; i < data.length; i++) {
                if (data[i][column] == matchValue) {
                    $($trLst[i + 1]).css({ backgroundColor: color });
                }
            }
        }
        function reloadafterwait() {
            setTimeout('window.location.reload()', 1000);
        }
        function addButtons() {
            addButtonsFromFrame({
                'Save': function () {
                    return saveFunction();
                },
                'Delete': function () {
                    var ret = confirm('Are you sure you want to delete this user?');
                    if (ret) {
                        $(".btnDelete").click();
                        setTimeout(function () { window.parent.location.reload(); }, 500);
                        return false;
                    }
                    return true;
                },
                "Cancel": function () { return false; }
            });
        }
        var selectedStep = 1;
        var lname = "";
        var dob = "";
        $(function () {

            //colorGrid(dgAssignments, "Canceled", "True", "#ffe1e1");
            //colorGrid(dgEvents, "Attended", "True", "#e1ffe1");
            //colorGrid(dgEvents, "canceled", "True", "#ffe1e1");
            //$("form").validationEngine();
            $("form").formToWizard({
                submitButton: 'btnSave',
                showStepNo: false,
                validateBeforeNext: function () {
                    return true; //$("form").validationEngine('validate');
                }
            })
            $("#makeWizard").hide();

            if ($('.status').val().trimEnd() != 'Removed')
                $('.removalinfo').hide()
            //else
            //    $('.removalinfo').show()
            //$('.status').val().trimEnd()

            //$(".pnlCheckgroup input").attr("disabled", true);

            //Duplicate Client Check
            if ($("#clientID").val() == -1)
                $(".DOB,.last_name ").blur(function () {
                    if ($(".DOB").val() != "" && $(".last_name").val() != "") {
                        if ($(".DOB").val() != dob || $(".last_name").val() != lname) {
                            ajaxCheckDuplicate($(".last_name").val() + "##" + $(".DOB").val());
                            lname = $(".last_name").val();
                            dob = $(".DOB").val();
                        }
                    }
                });
            //Only allow chars in Fnam and lname
            $(document).on("input change paste", ".alphaOnly", function () {
                var newVal = $(this).val().replace(/[^a-zA-Z]/g, '');
                $(this).val(newVal);
            });

            $("#info").fadeIn(400);
            //if($("#clientID").val() > -1){
            $(".breadcrumb li").click(function () {
                if ($("form").validationEngine('validate')) {
                    var stepno = parseInt($(this).attr('id').replace("stepDesc", ""));
                    $("form").formToWizard('GotoStep', stepno + 1);
                }
            });
            //}

            //$(DTIDataGridAppts).trigger("reloadGrid", [{ current: true}]);
            $('.cbDeceased').click(function () {
                if ($(this).find('input').is(':checked'))
                    $('.Date_Of_Death').fadeIn();
                else
                    $('.Date_Of_Death').fadeOut();
            });
            if ($('.cbDeceased').find('input').is(':checked')) $('.Date_Of_Death').fadeIn();
            $("#stepDesc4").click(function () {
                $('#Workerstable').tableScroll({ height: 150 });
            })

            $(".tbPhone").mask("(999) 999-9999");
            $(".tbCell").mask("(999) 999-9999");

            //if ($(".clientFlags td:contains('Voter Flag')").next().text() == "Not Set" &&
            //	$(".clientFlags td:contains('Voter Ineligible Flag')").next().text() == "Not Set") {
            var setChecks = function (flagname) {
                var a = $("a[flagname='" + flagname + "']");
                if (a.length > 0) {

                    var flagval = a.attr("flagval");
                    var tr = a.parents("tr");
                    var c = $("input[flagname='" + flagname + "'][flagval='" + flagval + "']");
                    $("input[flagname='" + flagname + "']").each(function () {
                        $(this).attr("flagTypeID", a.attr("flagTypeID"));
                    });
                    tr.hide();
                    if (tr.find(".flagdt").length > 0)
                        $("#vrDate").text(tr.find(".flagdt").text());
                    $("input[flagname='" + flagname + "']").change(function () {
                        cb = $(this);
                        $(".tbFlagVal").val(cb.attr("flagval"));
                        if (!this.checked)
                            return removeFlag(cb.attr("flagname"), cb.attr("flagTypeID"));
                        else
                            return setFlag(cb.attr("flagname"), cb.attr("flagTypeID"));
                    });

                    if (c.length > 0) {
                        c.prop("checked", true);
                        return true;
                    }
                }
                return false;
            }

            setTimeout(function () {
                $(getIframe()).parent().parent().find(".ui-dialog-buttonset").children().first().css("margin-right", "530px")
            }, 500);

            $(getIframe()).parent().parent().find(".ui-dialog-title").text("Edit: " + $(".first_name").val() + " " + $(".last_name").val());
            //if (selectedStep > -1) $("#stepDesc" + selectedStep).click();
            //setTimeout("$('#Workerstable').tableScroll({ width: 480, height: 150 });", 2000);
            //$('#Workerstable').tableScroll({ width: 480, height: 150 });
            //setTimeout("$('tablescroll_wrapper').css({ height: '150px',overflowy: 'auto',overflowx: 'hidden' });", 1000);
            var icon = setDlgIcon("/images/Dummy_user.png");
            if (icon) {
                icon.css("max-width", "");
                icon.css("max-height", "25px");
                icon.css("margin-top", "-12px");
                icon.css("margin-bottom", "-12px");
            }
        });

        function fixgrid(grid) {
            /*                var ctmax = (grid.children("tbody").children("tr").length - 1) / 2;
                            for (i = 0; i < ctmax; i++) {
                                grid.children("tbody").children("tr:last").remove()
                            }            
                            grid.parent().parent().height(grid.parent().parent().height() / 2)
                            */
        }
        function doClickNoArgs() {
            //alert(DTIDataGrid1.getCell( id, 'ClientID'));
            searchTarget = window.parent;
            if (parent.targetWindow)
                searchTarget = parent.targetWindow;
            var targetDoc = searchTarget.document;

            var iframe = getIframe();
            $('.Autocomplete1', targetDoc).val($('.last_name').val() + ',' + $('.First_Name').val() + ' ' + $('.Middle_name').val() + ' (' + $('.DOB').val() + ')');
            $('.Autocomplete1', targetDoc).prev().val('1');
            $('.Autocomplete1', targetDoc).prev().prev().val($('#clientID').val());
            //$('.Autocomplete1', window.parent.document).trigger("autocompleteselect");
            searchTarget.clientSelected($('#clientID').val());
        }

        function MakeWizard() {
            $("form").formToWizard({ submitButton: 'SaveAccount' })
            $("#makeWizard").hide();
            $("#info").fadeIn(400);

        }
        var searchTarget = parent;
        function doClick(fname, lname, clientid) {
            if (!clientid)
                return doClickNoArgs();
            //alert(DTIDataGrid1.getCell( id, 'ClientID'));
            searchTarget = window.parent;
            if (parent.targetWindow)
                searchTarget = parent.targetWindow;
            var targetDoc = searchTarget.document;

            var iframe = getIframe();
            $('.Autocomplete1', targetDoc).val(lname + ',' + fname);
            $('.Autocomplete1', targetDoc).parent().find('input[type=hidden]').last().val('1');
            $('.Autocomplete1', targetDoc).parent().find('input[type=hidden]').first().val(clientid);
            //$('.Autocomplete1', window.parent.document).trigger("autocompleteselect");
            searchTarget.clientSelected(clientid);
            closeThis();
        }


        function duplicateReturn(clientList) {
            if (clientList.length == 0) { return; }
            else {
                var newDiv = $("<div style='width:600px;height:300px;'></div>");

                newDiv.html('There are possible duplicates of the current entry. Click one of the items below if the client is in this list:<br/>');
                var clients = clientList.split("#");
                for (i = 0; i < clients.length; i++) {
                    var client = clients[i].split(",");
                    var fname = client[0];
                    var lname = client[1];
                    var clientID = client[2];
                    var dob = client[3];
                    var lastUpdated = client[4];
                    var buttonItm = $('<div style="height:262px;margin: 5px;" class="repClient"><div >' + fname + ' ' + lname + '</div><div>DOB:' + dob + ' </div>  <img class="dlgIcon" src="~/res/Clientcontrols/viewImage.aspx?clientid=' + clientID + '"><div>lastUpdated:' + lastUpdated + '</div></div>')
                    buttonItm = buttonItm.button();
                    buttonItm.data("fname", fname);
                    buttonItm.data("lname", lname);
                    buttonItm.data("clientID", clientID);
                    buttonItm.click(function () { doClick($(this).data("fname"), $(this).data("lname"), $(this).data("clientID")) });
                    newDiv.append(buttonItm);
                    newDiv.append("<br/>");
                }
                newDiv.dialog({ modal: true, width: "600px" });
                //alert("This is a dup!");
            }
        }
    </script>

    <asp:Panel ID="pnlDisableinputs" Visible="false" runat="server">
        <script type="text/javascript">
            $(function () {
                $('select').prop('disabled', true);
                $('input').prop('disabled', true);
            });
        </script>
    </asp:Panel>

    <cc1:AjaxCall ID="ajaxCheckDuplicate" jsReturnFunction="duplicateReturn" runat="server" />

    <div>
        <%--<input id="clientID" value="<%=CurrentClient.clientID %>" type="hidden" hey vesause here where are your fingers?/> --%>



        <fieldset>
            <legend class="hidden" alt='<%=Request.QueryString["id"] %>'>Personal Info ID:<%=row["id"] %></legend>
<div class="row">
    <div class="col-sm-6">
            <div class="fieldset ui-corner-all ui-widget-content">
                <div class="legend ui-corner-all ui-widget-content">Account</div>     
    <%if (row["ProfileImageID"] != DBNull.Value)
        { %>
    <%=DTIImageManager.ViewImage.getZoomableThmb((int)row["ProfileImageID"]) %><br />
    <%}
    else
    { %>
    No profile image uploaded.<br />
    <%} %>
    <br />
                <div class="row">
                    <div class="col-12 formsec">
                            <a class="btn btn-primary" href="<%=Data.getSetting("Public URL") %>/AdminLogin.aspx?loginuser=<%=row["email"] %>&extid=<%=row["id"] %>" target="_blank" >Portal Login as User</a>
                                            <%--<br />--%>
                                            <%if(Data.getVal(row,"TrainingPassword","") != ""){ %>
                                <%--<br />--%>
                            <a class="btn btn-primary" href="/Events/LaunchLMSAdmin.aspx?userid=<%=row["id"] %>" target="_blank" >Talent LMS Login as User</a><br />
                                            <%} %>
                        </div>
                </div>

                <hr />
    <%--<div class="row">
        <div class="col-3">Worker Status:</div>
        <div class="col-5"><asp:DropDownList ID="status" runat="server" /></div>
                <div class="col-4" style="text-align:center; justify-content:center;">
            <asp:Button runat="server" ID="btnStatusChnage" OnClientClick="return confirm('This will change the applicant's status and trigger the next step.')" OnClick="btnStatusChnage_Click" Visible="false" Text="Move Along" /><br />
            
            <asp:Button runat="server" ID="btnRestartOnboarding" OnClientClick="return confirm('This will Restart the onboarding process in SAP. \n Do you want to continue?')" OnClick="btnRestartOnboarding_Click" Visible="false" Text="Restart Onboarding" />
        </div>

        </div>


    <div class="row">
        <div class="col-6">Account Active:</div>
        <div class="col-6"><asp:CheckBox ID="Active" runat="server" /></div>
    </div>--%>
                <div class="row">
                        <div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:DropDownList ID="status" runat="server" CssClass="form-control"/>
                                    <label for="PasswordResetDate">Worker Status</label>
                                    
                                    <asp:DropDownList ID="ddremovalReason" runat="server" CssClass="form-control removalinfo">
                                        <asp:ListItem Text="Self-Removal" Value="Self-Removal"></asp:ListItem>
                                        <asp:ListItem Text="Staff Removal" Value="Staff Removal"></asp:ListItem>
                                    </asp:DropDownList>
                                    <label for="ddremovalReason" class="removalinfo">Removal Reason</label>
                                </div>
								<div class="col-12">
									<asp:Button runat="server" ID="btnStatusChnage" OnClientClick="return confirm('This will change the applicant's status and trigger the next step.')" OnClick="btnStatusChnage_Click" Visible="false" Text="Move Along" /><br />           
									<asp:Button runat="server" ID="btnRestartOnboarding" OnClientClick="return confirm('This will Restart the onboarding process in SAP. \n Do you want to continue?')" OnClick="btnRestartOnboarding_Click" Visible="false" Text="Restart Onboarding" />
                                    
                                </div>
                            </div>                            
                        </div>
                    

						<div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:CheckBox ID="Active" runat="server" /><br />
                                    <label for="PasswordResetGuid1">Public Account Active</label>
                                    <asp:TextBox runat="server" CssClass="form-control removalinfo" ID="lblremovaldate" Enabled="false"></asp:TextBox>
                                    <label for="lblremovaldate" class="removalinfo" style="margin-left:-15px">Removal Date</label>
                                </div>
                            </div>                            
                        </div>
		</div>

                <%--<label for="tbPasswordEnry">Password</label>
                <asp:TextBox ID="tbPasswordEntry" CssClass=" alphaOnly" MaxLength="25" TextMode="Password" runat="server" /><br />--%>
               <%-- <label for="PasswordResetDate">Password Reset Expires</label>
                <cc1:DatePicker ID="PasswordResetDate" runat="server" /><br />
                <label for="PasswordResetGuid1">Password Reset Guid</label>
                <asp:Label ID="PasswordResetGuid1" runat="server" /><br />--%>
                <div class="row">
                        <div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="first_name" CssClass=" alphaOnly form-control" MaxLength="25" runat="server"  />
                                    <label for="first_name">First Name</label>
                                </div>
                            </div>
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="middle_name" MaxLength="25" runat="server" CssClass="form-control" />
                                    <label for="middle_name">Middle Name</label>
                                </div>
                            </div>
                        </div>
                    

            <div class="col-6">
                <div class="row infoline">
                    
					<asp:TextBox ID="PreferredName"  MaxLength="25" runat="server" CssClass="form-control" />
                    <label for="PreferredName">Preferred Name</label>
                </div>
                <div class="row infoline">
                    
					<asp:TextBox ID="last_name" CssClass=" alphaOnly form-control" MaxLength="25" runat="server"  />
                    <label for="last_name">Last Name</label>
                </div>
			</div>
		</div>
                <div class="row">
                        <div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<cc1:DatePicker ID="PasswordResetDate" runat="server" CssClass="form-control" />
                                    <label for="PasswordResetDate">Password Reset Expires</label>
                                </div>
                            </div>    
                            <div class="row infoline">
                                <div class="col-12">
									
                                    <asp:TextBox ID="tbPasswordEntry" CssClass="form-control" MaxLength="25" TextMode="Password" runat="server" />									
                                    <label for="tbPasswordEnry">Password Entry</label>
                                </div>
                            </div>                            
                        </div>
                    

						<div class="col-6">
                            <div class="row infoline">
                                <div class="col-12" style="padding:0px;">
									
									<asp:Label ID="PasswordResetGuid1" runat="server" CssClass="form-control specialfeild" />
                                    <label for="PasswordResetGuid1">Password Reset Key</label>
                                </div>
                            </div>                            
                        </div>
		</div>
   </div>
                
              <br />  <%--Race and Birthday Info--%>
        <div class="fieldset ui-corner-all ui-widget-content">
                <div class="legend ui-corner-all ui-widget-content">Demog. Info</div>        

            		

                    <div class="row">
                        <div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
                                
                                <cc1:DatePicker CssClass="" ID="birth_dt" runat="server" ShowDefaultButtonImage="True" ChangeYear="True" ChangeMonth="True" Width="90%" />
                                    <label for="DOB">BirthDate</label>
                                </div>
                            </div>
                        <br />
                            <div class="row infoline">
                                <div class="col-12">
                                <label for="gender_lbl">Gender</label>
                                <asp:DropDownList ID="gender_lbl" runat="server" /><br />
                                </div>
                            </div>
                        </div>
                    

            <div class="col-6">
                <div class="row infoline">
                    
                   
                        <asp:TextBox ID="ethnicity_desc" runat="server" CssClass="form-control" />
                    <label for="ethnicity_desc">Ethnicity Description</label>
                </div>
                <div class="row infoline">
                    
                    
                        <asp:TextBox ID="race_desc" runat="server" CssClass="form-control" />
                    <label for="race_desc">Race Description</label>
                </div>
                </div>
            </div>
        </div>
                
           <%-- <div class="fieldset ui-corner-all ui-widget-content" >
                <div class="legend ui-corner-all ui-widget-content">Password</div>
                
                

            </div>--%>
                <br />
                <div class="fieldset ui-corner-all ui-widget-content">
                    <div class="legend ui-corner-all ui-widget-content">Registration Data</div>
                    		<div class="row">
                        <div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="voter_reg_num" CssClass=" form-control" runat="server"  />
                                    <label for="voter_reg_num">Voter Registration Number</label>
                                </div>
                            </div>
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="status_desc" runat="server" CssClass="form-control" />
                                    <label for="status_desc">Registration Status</label>
                                </div>
                            </div>
							<div class="row infoline">
                                <div class="col-12">
									
									<asp:Label ID="precinct_lbl" runat="server" CssClass="form-control" />
                                    <label for="precinct_lbl">Precinct</label>
                                </div>
                            </div>
							<div class="row infoline">
                                <div class="col-12">
									
									<div class="row infoline">
										<div class="col-7">											
											<asp:TextBox ID="party_desc" runat="server" CssClass="form-control" />
                                            <label for="party_desc">Party</label>
										</div>
										<div class="col-5">
											<asp:TextBox ID="party_lbl" runat="server" CssClass="form-control" />
										</div>
									</div>									
                                </div>
                            </div>
                        </div>
                    

						<div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="ncid" CssClass=" form-control" runat="server"  />
                                    <label for="ncid">NCID</label>
                                </div>
                            </div>
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="status_reason_desc" CssClass=" form-control" runat="server"  />
                                    <label for="status_reason_desc">Status Reason</label>
                                </div>
                            </div>
							<div class="row infoline">
                                <div class="col-12">
									
									<asp:Label ID="pp_name" runat="server" CssClass="form-control specialfeild" />
                                    <label for="pp_name">Polling Place</label>
                                </div>
                            </div>
                        </div>
		</div>
               
                    
                    
                    
                    
                    
                </div>
        <br />
        <div class="fieldset ui-corner-all ui-widget-content">
                    <div class="legend ui-corner-all ui-widget-content">Worker Data</div>
                    		<div class="row">
                        <div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:CheckBox runat="server" ID="cbsenttosap" />
                                    <label for="sentToSAP">Sent to SAP</label>
                                </div>
                            </div>
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="EIDNumber" CssClass=" form-control" runat="server"  />
                                    <label for="EIDNumber">County EID Number</label>
                                </div>
                            </div>
                            
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="tbESkillsAssessmentResult" runat="server" CssClass="form-control" />
                                    <label for="tbESkillsAssessmentResult">ESkills</label>
                                </div>
                            </div>
							<%--<div class="row infoline">
                                <div class="col-12">
									<label for="precinct_lbl">Precinct</label>
									<asp:Label ID="precinct_lbl" runat="server" CssClass="form-control" />
                                </div>
                            </div>--%>
							
                        </div>
                    

						<div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
                                    
                                    <b><label for="performanceAverage">Report Card Average:</label></b>  
                                    <a href="http://localhost:45391/Checklists/ChecklistLookBack.aspx?extuserID=<%=row["id"] %>" target="_blank"><asp:Label runat="server" ID="lblperformanceAverage"></asp:Label>%</a>
                                    <%--<a href="BOELogistics.dconc.gov/Checklists/ChecklistLookBack.aspx?extuserID=<%=row["id"] %>" target="_blank"><asp:Label runat="server" ID="lblperformanceAverage"></asp:Label>%</a>--%>
                                </div>
                                <div class="col-12">
									
									<asp:TextBox ID="referralSource" CssClass=" form-control" runat="server"  />
                                    <label for="ApplicationSource">Application Source</label>
                                </div>
                            </div>
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="DateInserted" CssClass=" form-control" runat="server"  />
                                    <label for="DateInserted">Date Applied</label>
                                </div>
                            </div>
						<%--	<div class="row infoline">
                                <div class="col-12">
									<label for="dateActivated">Date Active</label>
									<asp:Label ID="dateActivated" runat="server" CssClass="form-control" />
                                </div>
                            </div>--%>
                        </div>
		</div>
                </div>
        <br />
        <div class="fieldset ui-corner-all ui-widget-content">
                    <div class="legend ui-corner-all ui-widget-content">Last Edited</div>
            <div class="row">
                        <div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:Label ID="DateUpdated" runat="server" CssClass="form-control"/>
                                    <label for="DateUpdated">Update Date</label>
                                </div>
								
                            </div>                            
                        </div>
                    

						<div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:Label ID="UpdateUsr" runat="server" CssClass="form-control"/>
                                    <label for="UpdateUsr">Update User</label>
                                </div>
                            </div>                            
                        
						
		</div>                   
            </div>
                    <%--                Created: <%=CurrentClient.Create_Date%><br />
                Last updated: <%=CurrentClient.Last_Update_Date%><br />--%>
                <%--By:--%>
                <%--<cli:UserInfo ID="uiLastUpdate" runat="server" />--%>
                </div>
        <div class="row">
            <div class="col-12" style="justify-content:center; text-align:center;">
                <asp:Button runat="server" ID="btnCancelALL" OnClientClick="return confirm('This will cancel/clear all future assignments, events and availability. Are you sure?')" onClick="btnCancelALL_Click" Text="Full Election Cancel" CssClass="btncnall btn btn-danger"/>
            </div>
        </div>
    </div>
        


    <div class="col-sm-6">
            <div style="" class="fieldset ui-corner-all ui-widget-content">
                <div class="legend ui-corner-all ui-widget-content">Notes</div>
                <div class="notesContainer">
                    Internal Notes:<br />
                    <uc2:UCCommentChat runat="server" ID="UCCommentChat" />
                </div>
                
                        <%--Internal Notes:<br />
                        <asp:TextBox Width="80%" Height="200px"  TextMode="MultiLine" ID="InternalNotes" runat="server" />--%>
                </div>
                        <br />
                <div class="fieldset ui-corner-all ui-widget-content">
                    <div class="legend ui-corner-all ui-widget-content">Work Preferences</div>
                        Site Preference(s):<br />
                        <asp:TextBox Width="80%" Height="100px"  TextMode="MultiLine" ID="tbAdditionalSearch" runat="server" />
                <br /><br />Paid Work Interest(s): <br />
                <div class="row">
                    <div class="col-md-6" >
                                <div class="row">
                                   
                                    <div class="col-11">
                                        <asp:CheckBox runat="server" ID="cbED" /> Election Day
                                    </div>
                                </div>
                                <div class="row">
                                    
                                    <div class="col-11">
                                        <asp:CheckBox runat="server" ID="cbOS" /> Early Voting
                                    </div>
                                </div>
                        </div>
                    <div class="col-md-6" >
                                <div class="row">
                                    
                                    <div class="col-11">
                                        <asp:CheckBox runat="server" ID="cbOffice" /> BOE Office
                                    </div>
                                </div>
                                <div class="row">
                                   
                                    <div class="col-11">
                                        <asp:CheckBox runat="server" ID="cbWarehouse" /> BOE Warehouse
                                    </div>
                        </div>
                </div>
        </div>

                <br /><br />Early Voting Eligibility: <br />
                <div class="row">
                    <div class="col-md-6" >
                            <div class="row">                                   
                                <div class="col-11">
                                    <asp:CheckBox runat="server" ID="cbOSIneligible" /> Early Voting Ineligible
                                </div>
                            </div>                                
                                <div class="col-11">
                                    <asp:CheckBox runat="server" ID="cbEDIneligible" /> Election Day Ineligible
                                </div>
                            </div>
                        </div>
                    <div class="col-md-6" >
                        <div class="row">                                   
                                <div class="col-11">
                                    <asp:CheckBox runat="server" ID="cbSCInterest" /> Site Coordinator Interest
                                </div>
                            </div>
                    </div>
                </div>
                    </div>
                <br />
                <div class="fieldset ui-corner-all ui-widget-content">
                    <div class="legend ui-corner-all ui-widget-content">Rolls</div>
                   <uc1:CheckGroup runat="server" ID="cbRolls" />
                </div>
                 <%--<div class="form-group">
      <label for="rolls"><i class="fa fa-cogs"></i> Rolls</label>
         <uc1:CheckGroup runat="server" ID="cbRolls" />
    </div>--%>


            <%--</div>--%> <%--Ends the div with the border--%>
    </div>
<%--</div>
    </div>--%>



        </fieldset>

        <fieldset>            
            <legend class="hidden">Contact Info</legend>
            <div class="row">
                <div class="col-sm-6">
           <div class="fieldset ui-corner-all ui-widget-content">
                <div class="legend ui-corner-all ui-widget-content">Contact Info</div>

                 <%--<label for="tbPhone">Home Phone</label>
                <cc1:maskedTextbox ID="tbPhone" maskPreset="Phone" runat="server" /><br />
                <label for="tbcell">Cell Phone</label>
                <cc1:maskedTextbox ID="tbCell" maskPreset="Phone" runat="server" /><br />
                <label for="tbEmail">Email</label>
                <asp:TextBox ID="tbEmail" MaxLength="100" runat="server" /><br />
            </div>


            <div class="fieldset ui-corner-all ui-widget-content" >
                <div class="legend ui-corner-all ui-widget-content">Address</div>
                <div class="row">
                    <div class="col-3">Address:</div>
                    <div class="col-6">
                        <asp:TextBox ID="Address" Height="50px" Width="230px" TextMode="MultiLine" runat="server" /></div>
                </div>
                <div class="row">
                    <div class="col-3">Working Near Relatives:</div>
                    <div class="col-6">
                        <asp:CheckBox ID="WorkingNearRelatives" runat="server" /></div>
                </div>--%>
                <%--<div class="row">
                    <div class="col-3">Early Voting Interest:</div>
                    <div class="col-6">
                        <asp:TextBox ID="EarlyVotingInterest" runat="server" /></div>
                </div>--%>
               <div class="row">
                        <div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<cc1:maskedTextbox ID="tbPhone" maskPreset="Phone" runat="server" CssClass="form-control"/>
                                    <label for="tbPhone">Home Phone</label>
                                </div>
								<div class="col-12">
									
									<asp:TextBox ID="tbEmail" MaxLength="100" runat="server" CssClass="form-control"/>
                                    <label for="tbEmail">Email</label>
                                </div>
                            </div>                            
                        </div>
                    

						<div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<cc1:maskedTextbox ID="tbCell" maskPreset="Phone"  runat="server" CssClass="form-control"/>
                                    <label for="tbCell">Cell Phone</label>
                                </div>
                            </div>                            
                        
						<div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="Address" TextMode="MultiLine"  runat="server" CssClass="form-control"/>
                                    <label for="tbCell">Address</label>
                                </div>
                            </div>  
                        </div>
		</div>
               <%--EMP CONTACT INFO--%>
               <div class="row">
                        <div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<cc1:maskedTextbox ID="tbOfficePhone" maskPreset="Phone" runat="server" CssClass="form-control"/>
                                    <label for="tbOfficePhone">Office Phone</label>
                                </div>
								
                            </div>                            
                        </div>
                    

						<div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<cc1:maskedTextbox ID="tbWorkCell" maskPreset="Phone"  runat="server" CssClass="form-control"/>
                                    <label for="tbWorkCell">Work Cell</label>
                                </div>
                            </div>                            
                       
                        </div>
		</div>
               <%--END--%>
               <hr />
		<div class="row">
                        <div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="mailaddr1" runat="server" CssClass="form-control"/>
                                    <label for="mailaddr1">Mail Address</label>
                                </div>
								<div class="col-12">
									
									<asp:TextBox ID="mail_state" runat="server" CssClass="form-control"/>
                                    <label for="mail_state">Mail State</label>
                                </div>
                            </div>                            
                        </div>
                    

						<div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="mail_city" runat="server" CssClass="form-control"/>
                                    <label for="mail_city">Mail City</label>
                                </div>
                            </div>                            
                        
						<div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="mail_zip" runat="server" CssClass="form-control"/>
                                    <label for="mail_zip"> Mail Zip</label>
                                </div>
                            </div>      
                        </div>
		</div>

                
                   
            <%--    Inserted (Applied):
                <asp:Label ID="DateInserted" runat="server" /><br />--%>
               <%-- Updated:
                <asp:Label ID="UpdateDate" runat="server" /><br />
                <br />--%>
                
               <%-- <div class="row">
                    <div class="col-3">Congressional District:</div>
                    <div class="col-6">
                        <asp:TextBox ID="congressional_district_lbl" runat="server" /></div>
                </div>
                <div class="row">
                    <div class="col-3">Precinct ID:</div>
                    <div class="col-6">
                        <asp:TextBox ID="precinct_id" runat="server" /></div>
                </div>
                <div class="row">
                    <div class="col-3">Mail Addr:</div>
                    <div class="col-6">
                        <asp:TextBox ID="mailaddr1" runat="server" /></div>
                </div>
                <div class="row">
                    <div class="col-3">Mail zip Code:</div>
                    <div class="col-6">
                        <asp:TextBox ID="mail_zip" runat="server" /></div>
                </div>
                <div class="row">
                    <div class="col-3">Mail To State:</div>
                    <div class="col-6">
                        <asp:TextBox ID="mail_state" runat="server" /></div>
                </div>
                <div class="row">
                    <div class="col-3">Mail To City:</div>
                    <div class="col-6">
                        <asp:TextBox ID="mail_city" runat="server" /></div>
                </div>--%>
                <%--<div class="row">
                    <div class="col-3">Election Day Interest:</div>
                    <div class="col-6">
                        <asp:TextBox ID="ElectionDayInterest" runat="server" /></div>
                </div>
                <div class="row">
                    <div class="col-3">General Office Interest:</div>
                    <div class="col-6">
                        <asp:TextBox ID="GeneralOfficeInterest" runat="server" /></div>
                </div>--%>
            </div>
            </div>
                
            <div class="col-sm-6">
                <div class="fieldset ui-corner-all ui-widget-content">
                    <div class="legend ui-corner-all ui-widget-content">Send Email/Notification</div>
                    <div class="row" style="margin-bottom: 10px;">
                        <div class="col-12 formsec">
                            <label for="ddNotificationType">Notification Type</label>
							<asp:DropDownList ID="ddNotificationType" runat="server" CssClass="form-control"/>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-12 formsec">
                            <asp:Button ID="btnSendEmail" CssClass="btn btn-primary" OnClick="btnSendEmail_Click" runat="server" OnClientClick="return confirm('You want to send the selected email?')" Text="Send Email" />
                            
                            <asp:Button ID="btnSendEmailAndNotif" CssClass="btn btn-primary" OnClick="btnSendEmailAndNotif_Click" runat="server" OnClientClick="return confirm('You want to send the selected email and create a notification?')" Text="Send Email and Create Notification" />
                            <asp:Button ID="btnNotify" CssClass="btn btn-secondary" OnClick="btnNotify_Click" runat="server" OnClientClick="return confirm('You want to create a notification?')" Text="Create Notification Record" />
                        </div>
                    </div>
                    
                    
                    <asp:Label ID="lblEmailErrors" ForeColor="Red" runat="server" Text=""/>
                </div>
                <br />

                <div class="fieldset ui-corner-all ui-widget-content">
                <div class="legend ui-corner-all ui-widget-content">Emergency Contact Info</div>

                <%--<label for="tbemergencyName">Emergency Contact</label>
                <asp:TextBox ID="tbemergencyName" MaxLength="100" runat="server" /><br />
                    <label for="tbemergencyRelationship">Relationship</label>
                <asp:TextBox ID="tbemergencyRelationship" MaxLength="100" runat="server" /><br />
                <label for="tbemergencyCellPhone">Cell Phone</label>
                <asp:TextBox ID="tbemergencyCellPhone" MaxLength="100" runat="server" /><br />
                <label for="tbemergencyHomePhone">Home Phone</label>
                <asp:TextBox ID="tbemergencyHomePhone" MaxLength="100" runat="server" /><br />--%>
                    <div class="row">
                        <div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="tbemergencyName" MaxLength="100" runat="server" CssClass="form-control"/>
                                    <label for="tbemergencyName">Contact Name</label>
                                </div>
								<div class="col-12">
									
									<asp:TextBox ID="tbemergencyCellPhone" MaxLength="100" runat="server" CssClass="form-control"/>
                                    <label for="tbemergencyCellPhone">Cell Phone</label>
                                </div>
                            </div>                            
                        </div>
                    

						<div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="tbemergencyRelationship" MaxLength="100" runat="server" CssClass="form-control"/>
                                    <label for="tbemergencyRelationship">Relationship</label>
                                </div>
                            </div>                            
                        <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="tbemergencyHomePhone" MaxLength="100" runat="server" CssClass="form-control"/>
                                    <label for="tbemergencyHomePhone">Home Phone</label>
                                </div>
                            </div>  
						
		</div>                   
            </div>
                
              <%--      <h6 style="color:black;">Vehicle & Driver Info</h6>
                <label for="tbLicenceNum">Lincence Number</label>
                <asp:TextBox ID="tbLicenceNum" MaxLength="100" runat="server" /><br />
                <label for="tbLicencePlate">Lincence Plate</label>
                <asp:TextBox ID="tbLicencePlate" MaxLength="100" runat="server" /><br />
                <label for="tbcarDetails">Car Decription</label>
                <asp:TextBox ID="tbcarDetails" MaxLength="100" runat="server" /><br />--%>
            </div>

                <br />

                <div class="fieldset ui-corner-all ui-widget-content">
                <div class="legend ui-corner-all ui-widget-content">Vehicle & Driver Info</div>

                <div class="row">
                        <div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="tbLicenceNum" MaxLength="100" runat="server" CssClass="form-control"/>
                                    <label for="tbLicenceNum">Lincence Number</label>
                                </div>
								<div class="col-12">
									
									<asp:TextBox ID="tbLicencePlate" MaxLength="100" runat="server" CssClass="form-control"/>
                                    <label for="tbLicencePlate">Lincence Plate</label>
                                </div>
                            </div>                            
                        </div>
                    

						<div class="col-6">
                            <div class="row infoline">
                                <div class="col-12">
									
									<asp:TextBox ID="tbcarDetails" MaxLength="100" runat="server" CssClass="form-control"/>
                                    <label for="tbcarDetails">Car Decription</label>
                                </div>
                            </div>                            
                        
						
		</div>                   
            </div>
                    </div>

                  </div>
            </div>
        </fieldset>
        <fieldset>
            <legend class="hidden">Assignment History</legend>
            
            <div class="row">
                <div class="col-6">
                    <div class="row">
                        <div class="col-12 formsec">
                            <h1>Upcoming Assignments</h1>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 formsec">
                            <uc4:UCassignments runat="server" ID="UCassignments" />
                        </div>
                    </div>
                </div>
                <div class="col-6">
                    <div class="row">
                        <div class="col-12 formsec">
                            <h1>Past Assignments</h1>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 formsec">
                            <uc4:UCassignments runat="server" ID="UCassignments1" />
                        </div>
                    </div>
                </div>
            </div>
            
            

        </fieldset>
        <fieldset>
            <legend class="hidden">Availability</legend>
            <div class="row">
                <div class="col-6">
                    <div class="row">
                        <div class="col-12 formsec">
                            <h1>Election Availability</h1>
                        </div>
                    </div>
                   
                    <div class="row">
                        <div class="col-12 formsec">
                            <uc5:UCavailability runat="server" ID="UCavailability" />
                        </div>
                    </div>
                </div>
                <div class="col-6">
                    <div class="row">
                        <div class="col-12 formsec">
                            <h1>Temp Availability</h1>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 formsec">
                            <uc5:UCavailability runat="server" ID="UCavailability1" />
                        </div>
                    </div>
                </div>
            </div>
        </fieldset>

        <fieldset>
            <legend class="hidden">Events</legend>
            <div class="row">
                <div class="col-12 formsec">
                        <%--<h1>Upcoming Events</h1>--%>
                    <a href="javascript:void(0)" class="btn btn-primary" onclick="createDialogURL('/PrescinctOfficials/AddEvent.aspx?d=y&userid=<%= row["id"] %>', 500, 500,null, 'Events', true);">Add Event Signup</a><br /><br />
                </div>
            </div>

            <div class="row">
                <div class="col-6 formsec">
                    <h1>Upcoming</h1>
                </div>
                <div class="col-6 formsec">
                    <h1>Previous</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-6 formsec">                
                    <uc3:UCeventAttendance runat="server" ID="UCeventAttendance" />
                </div>
                <div class="col-6 formsec">
                    <uc3:UCeventAttendance runat="server" ID="UCeventAttendance1" />
                </div>
            </div>
        </fieldset>
        
        <fieldset>
            <legend class="hidden">Notification History</legend>
            <%@ Register Assembly="DTIGrid" Namespace="DTIGrid" TagPrefix="cc1" %>

            <div class="row">
                <div class="col-12 formsec">
                    <h1>Notifications</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-12 formsec">
                    <uc6:UCnotifications runat="server" ID="UCnotifications" />
                </div>
            </div>
            <%--<cc1:dtidatagrid DataTableName="
				select id,subject,NotificationType,ElectionID,UpdateDate as DateSent, UpdateUsr 
				from NotificationLog 
				where extuserid = @id
                order by UpdateDate desc
                " 
                ColumnWidths="100,300,200,125,90,100,70"
                id="dgNotifications" shrinktofit="false" enableediting="false" EnableAdding="false"
                enablepaging="false" multiselect="False" runat="server"
                />--%>
        </fieldset>

        <fieldset>
            <legend class="hidden">Login History</legend>
            <%@ Register Assembly="DTIGrid" Namespace="DTIGrid" TagPrefix="cc1" %>
            <cc1:dtidatagrid DataTableName="
				select LoginDate,cast(cast(LoginDate as date) as varchar) sortDate from ExtUserLoginLog
				where extuserid = @id
                order by LoginDate desc
                " 
                id="dgLogins" shrinktofit="false" enableediting="false" EnableAdding="false"
                enablepaging="false" multiselect="False" runat="server" SortColumn="sortDate" SortOrder="desc"
                />
        </fieldset>

        <%--Payroll Tab--%>
<fieldset>
            <legend class="hidden">Payments</legend>
            <%@ Register Assembly="DTIGrid" Namespace="DTIGrid" TagPrefix="cc1" %>
    

    <%--   <%@ Register Src="~/userControls/UCComments.ascx" TagPrefix="uc1" TagName="UCComments" %>
    <%@ Register Src="~/userControls/UCeventAttendance.ascx" TagPrefix="uc1" TagName="UCeventAttendance" %>
    <%@ Register Src="~/userControls/UCavailability.ascx" TagPrefix="uc1" TagName="UCavailability" %>
    <%@ Register Src="~/userControls/UCnotifications.ascx" TagPrefix="uc1" TagName="UCnotifications" %>
    <%@ Register Src="~/userControls/UCpayments.ascx" TagPrefix="uc1" TagName="UCpayments" %>--%>


    <div class="row">
                <div class="col-6 formsec">
                    <h1>Election Day</h1>
                </div>
                <div class="col-6 formsec">
                    <h1>General</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-6 formsec">
                    <uc7:UCpayments runat="server" ID="UCpayments" />
                </div>
                <div class="col-6 formsec">
                    <uc7:UCpayments runat="server" ID="UCpayments1" />
                </div>
            </div>


<%--    <h3>Election Day and Events</h3>
    <cc1:dtidatagrid DataTableName="
                select election_dt, reason, amount, submitted
                from payroll p
                left outer join LK_ELECTION e on e.id = p.electionid
                where extuserid = @id and isnull(payCode,'Training') <> 'OSBonus' and timesheetID is null
                " 
                ColumnWidths="75,320,90,80,100,100,57,200,1,1,100"
                id="Dtidatagrid1" shrinktofit="false" enableediting="false" EnableAdding="false"
                enablepaging="false" multiselect="False" runat="server"
                />
    <hr />
    <h3>Early Voting</h3>
    <cc1:dtidatagrid DataTableName="
                select election_dt, reason, serviceDate, hours, amount, submitted, submissionDate
                from payroll p
                left outer join LK_ELECTION e on e.id = p.electionid
                where extuserid = @id and timesheetID is not null
        order by serviceDate
                " 
                ColumnWidths="75,320,90,90,90,90,90,200,1,1,100"
                id="Dtidatagrid9" shrinktofit="false" enableediting="false" EnableAdding="false"
                enablepaging="false" multiselect="False" runat="server"
                />--%>
        </fieldset>
        <div class="nothidden">
        <asp:Button ID="btnhiddenSave" runat="server" Text="Save"  OnClick="btnSave_Click" />
        <asp:Button ID="btnSaveNoEmail" runat="server" Text="Save Without Emailing" OnClick="btnSave_Click" />
            <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClick="btnDelete_Click" />
            <input type="button" class="btnSave" value="Save" />
            <cc1:AjaxCall ID="ajaxCheckUser" OncallBack="ajaxCheckUser_callBack" jsReturnFunction="ajaxCheckUserReturn" runat="server"/>
            </div>
    </div>
    <script type="text/javascript" language="javascript">
        <%if (row.RowState == System.Data.DataRowState.Added) {%>
        var isNew = true;
        <%} else {%>
        var isNew = false;
        <%}%>
        function ajaxCheckUserReturn(val) {
            if (val == "") {
                var grid = $(".DTIGrid:visible");
                if (grid.length > 0) {
                    grid.find("input[value='Save']").click();
                } else {
                    $(".btnhiddenSave").click();
                }
            } else {
                alert(val);
                return false;
            }

        }

        function saveFunction() {
            ajaxCheckUser($(".tbEmail").val() + "#" + $(".voter_reg_num").val() + "#" + isNew + "#" + $(".EIDNumber").val());
            return true;
        }

        $(document).ready(function () {
            $('form').on('keydown', function (ev) {
                if (ev.key === "Enter" && !$(ev.target).is('textarea')) {
                    ev.preventDefault(); // Don't trigger form submit
                }
            });
        });

        document.querySelectorAll('form').forEach(function (i) { i.setAttribute('autocomplete', 'off'); })
        document.querySelectorAll('input[type=text]').forEach(function (i) {
            i.setAttribute('autocomplete', 'off');
            i.setAttribute('tmpname', i.getAttribute('name'));
            i.onfocus = function () { i.setAttribute("name", i.getAttribute('name') + Math.random()); }
            i.onblur = function () { i.setAttribute("name", i.getAttribute('tmpname')); }
        })
    </script>

        </asp:Panel>

</asp:Content>
