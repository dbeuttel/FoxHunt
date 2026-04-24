<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Calendar.ascx.cs" Inherits="FoxHunt.userControlsMain.Calendar" %>
<%@ Register Src="~/Workers/userControls/createEvent_Event.ascx" TagPrefix="uc1" TagName="createEvent_Event" %>


<style>
    .flatpickr-prev-month{padding: 7px;}
    .flatpickr-next-month{padding: 7px;}

<<<<<<< HEAD
        let events = [
            
            <%int ct = 0;
        int tot = dtCalendar.Rows.Count;
        foreach(System.Data.DataRow r in dtCalendar.Rows) {
            ct += 1;


%>
                {
                    id: 1,
                    url: '',
                    title: 'Fucking Calendar Setup',
                    start: date,
                    end: new Date(date.getFullYear(), date.getMonth() + 1, -10),
                    allDay: false,
                    extendedProps: {
                        calendar: 'Business'
                    }
                }<%if (ct!=tot) { %>},<%}%>
            <%}%>
            {
                id: 1,
                url: '',
                title: 'Fucking Calendar Setup',
                start: date,
                end: new Date(date.getFullYear(), date.getMonth() + 1, -10),
                allDay: false,
                extendedProps: {
                    calendar: 'Business'
                }
            },
            {
                id: 3,
                url: '',
                title: 'Family Trip',
                allDay: true,
                start: new Date(date.getFullYear(), date.getMonth() + 1, -9),
                end: new Date(date.getFullYear(), date.getMonth() + 1, -7),
                extendedProps: {
                    calendar: 'Holiday'
                }
            },
            {
                id: 4,
                url: '',
                title: "Doctor's Appointment",
                start: new Date(date.getFullYear(), date.getMonth() + 1, -11),
                end: new Date(date.getFullYear(), date.getMonth() + 1, -10),
                extendedProps: {
                    calendar: 'Personal'
                }
            },
            {
                id: 5,
                url: '',
                title: 'Dart Game?',
                start: new Date(date.getFullYear(), date.getMonth() + 1, -13),
                end: new Date(date.getFullYear(), date.getMonth() + 1, -12),
                allDay: true,
                extendedProps: {
                    calendar: 'ETC'
                }
            },
            {
                id: 6,
                url: '',
                title: 'Meditation',
                start: new Date(date.getFullYear(), date.getMonth() + 1, -13),
                end: new Date(date.getFullYear(), date.getMonth() + 1, -12),
                allDay: true,
                extendedProps: {
                    calendar: 'Personal'
                }
            },
            {
                id: 7,
                url: '',
                title: 'Dinner',
                start: new Date(date.getFullYear(), date.getMonth() + 1, -13),
                end: new Date(date.getFullYear(), date.getMonth() + 1, -12),
                extendedProps: {
                    calendar: 'Family'
                }
            },
            {
                id: 8,
                url: '',
                title: 'Product Review',
                start: new Date(date.getFullYear(), date.getMonth() + 1, -13),
                end: new Date(date.getFullYear(), date.getMonth() + 1, -12),
                allDay: true,
                extendedProps: {
                    calendar: 'Business'
                }
            },
            {
                id: 9,
                url: '',
                title: 'Monthly Meeting',
                start: nextMonth,
                end: nextMonth,
                allDay: true,
                extendedProps: {
                    calendar: 'Business'
                }
            },
            {
                id: 10,
                url: '',
                title: 'Monthly Checkup',
                start: prevMonth,
                end: prevMonth,
                allDay: true,
                extendedProps: {
                    calendar: 'Personal'
                }
            }
        ];
=======
    /*.container-xxl{padding-left: 4.875rem;height:100%;}
    .fc-col-header-cell,
    .fc-day {
        height: 30px
    }
    .calContainer{height: 475px;}
    .card.app-calendar-wrapper,
    .fc-col-header,
    .fc-daygrid-body,
    .fc-scrollgrid-sync-table{
        width:100%
    }

    .fc-scrollgrid-sync-table {
        height:unset;
    }*/

</style>
<!-- Vendors JS -->
    <script src="/assets/vendor/libs/fullcalendar/fullcalendar.js"></script>
       
 <%--   <script id="eventJson" type="application/json">
        <%=EventJson %>
>>>>>>> f4f6d6580b34d3d6181b527a4e5981c23a852426
    </script>

    <script>
        var jsonText = document.getElementById('eventJson').textContent;
        var eventObj = JSON.parse(jsonText);

        // Convert date strings to Date objects
        eventObj.start = new Date(eventObj.start);
        eventObj.end = new Date(eventObj.end);

        //let eventData = eventObj;
    </script>--%>

<!-- Layout wrapper -->
    <div class="layout-wrapper layout-navbar-full layout-horizontal layout-without-menu">
      <div class="layout-container">
        
        <!-- Layout container -->
        <div class="layout-page">
          <!-- Content wrapper -->
          <div class="content-wrapper">
            <!-- Content -->

            <div class="container-xxl flex-grow-1 container-p-y" style="">
              <div class="card app-calendar-wrapper">
                <div class="row g-0 calContainer">
                  <!-- Calendar Sidebar -->
                  <div class="col app-calendar-sidebar" id="app-calendar-sidebar">
                    <div class="border-bottom p-4 my-sm-0 mb-3">
                      <div class="d-grid">
                        <button
                          class="btn btn-primary btn-toggle-sidebar"
                          data-bs-toggle="offcanvas"
                          data-bs-target="#addEventSidebar"
                          aria-controls="addEventSidebar">
                          <i class="bx bx-plus me-1"></i>
                          <span class="align-middle">Add Event</span>
                        </button>
                      </div>
                    </div>
                    <div class="p-4">
                      <!-- inline calendar (flatpicker) -->
                      <div class="ms-n2">
                        <div class="inline-calendar"></div>
                      </div>

                      <hr class="container-m-nx my-4" />

                      <!-- Filter -->
                    <div class="calendar-filters">  
                          <div class="mb-4">
                            <small class="text-small text-muted text-uppercase align-middle">Filter</small>
                          </div>

                    
                          <div class="form-check mb-2">
                            <input
                              class="form-check-input select-all"
                              type="checkbox"
                              id="selectAll"
                              data-value="all"
                              checked />
                            <label class="form-check-label" for="selectAll">View All</label>
                          </div>

                          <div class="app-calendar-events-filter">
                            <div class="form-check form-check-danger mb-2">
                              <input
                                class="form-check-input input-filter"
                                type="checkbox"
                                id="select-election"
                                data-value="election"
                                checked />
                              <label class="form-check-label" for="select-election">Election</label>
                            </div>
                            <div class="form-check mb-2">
                              <input
                                class="form-check-input input-filter"
                                type="checkbox"
                                id="select-event"
                                data-value="event"
                                checked />
                              <label class="form-check-label" for="select-event">Event</label>
                            </div>
                            <div class="form-check form-check-warning mb-2">
                              <input
                                class="form-check-input input-filter"
                                type="checkbox"
                                id="select-family"
                                data-value="family"
                                checked />
                              <label class="form-check-label" for="select-family">Family</label>
                            </div>
                            <div class="form-check form-check-success mb-2">
                              <input
                                class="form-check-input input-filter"
                                type="checkbox"
                                id="select-holiday"
                                data-value="holiday"
                                checked />
                              <label class="form-check-label" for="select-holiday">Holiday</label>
                            </div>
                            <div class="form-check form-check-info">
                              <input
                                class="form-check-input input-filter"
                                type="checkbox"
                                id="select-etc"
                                data-value="etc"
                                checked />
                              <label class="form-check-label" for="select-etc">ETC</label>
                            </div>
                          </div>
                      </div>
                    </div>
                  </div>
                  <!-- /Calendar Sidebar -->

                  <!-- Calendar & Modal -->
                  <div class="col app-calendar-content">
                    <div class="card shadow-none border-0">
                      <div class="card-body pb-0">


                        <!-- FullCalendar -->
                        <div id="calendar"></div>
                      </div>
                    </div>
                    <div class="app-overlay"></div>



                    <!-- FullCalendar Offcanvas -->
                    <div
                      class="offcanvas offcanvas-end event-sidebar"
                      tabindex="-1"
                      id="addEventSidebar"
                      aria-labelledby="addEventSidebarLabel">
                      <div class="offcanvas-header border-bottom">
                        <h6 class="offcanvas-title" id="addEventSidebarLabel">Add Event</h6>
                        <button
                          type="button"
                          class="btn-close text-reset"
                          data-bs-dismiss="offcanvas"
                          aria-label="Close"></button>
                      </div>
                      <div class="offcanvas-body">
                        <form class="event-form pt-0" id="eventForm" onsubmit="return false">
                          <div class="mb-3">
                            <label class="form-label" for="eventTitle">Title</label>
                            <input
                              type="text"
                              class="form-control"
                              id="eventTitle"
                              name="eventTitle"
                              placeholder="Event Title" />
                          </div>
                          <div class="mb-3">
                            <label class="form-label" for="eventLabel">Label</label>
                            <select class="select2 select-event-label form-select" id="eventLabel" name="eventLabel">
                              <option data-label="primary" value="Business" selected>Event</option>
                              <option data-label="danger" value="Personal">Election</option>
                              <option data-label="warning" value="Family">Family</option>
                              <option data-label="success" value="Holiday">Holiday</option>
                              <option data-label="info" value="ETC">ETC</option>
                            </select>
                          </div>
                          <div class="mb-3">
                            <label class="form-label" for="eventStartDate">Start Date</label>
                            <input
                              type="text"
                              class="form-control"
                              id="eventStartDate"
                              name="eventStartDate"
                              placeholder="Start Date" />
                          </div>
                          <div class="mb-3">
                            <label class="form-label" for="eventEndDate">End Date</label>
                            <input
                              type="text"
                              class="form-control"
                              id="eventEndDate"
                              name="eventEndDate"
                              placeholder="End Date" />
                          </div>
                          <div class="mb-3">
                            <label class="switch">
                              <input type="checkbox" class="switch-input allDay-switch" />
                              <span class="switch-toggle-slider">
                                <span class="switch-on"></span>
                                <span class="switch-off"></span>
                              </span>
                              <span class="switch-label">All Day</span>
                            </label>
                          </div>
                          <div class="mb-3">
                            <label class="form-label" for="eventURL">Event URL</label>
                            <input
                              type="url"
                              class="form-control"
                              id="eventURL"
                              name="eventURL"
                              placeholder="https://www.google.com" />
                          </div>
                          <div class="mb-3 select2-primary">
                            <label class="form-label" for="eventGuests">Add Guests</label>
                            <select
                              class="select2 select-event-guests form-select"
                              id="eventGuests"
                              name="eventGuests"
                              multiple>
                              <option data-avatar="1.png" value="Jane Foster">Jane Foster</option>
                              <option data-avatar="3.png" value="Donna Frank">Donna Frank</option>
                              <option data-avatar="5.png" value="Gabrielle Robertson">Gabrielle Robertson</option>
                              <option data-avatar="7.png" value="Lori Spears">Lori Spears</option>
                              <option data-avatar="9.png" value="Sandy Vega">Sandy Vega</option>
                              <option data-avatar="11.png" value="Cheryl May">Cheryl May</option>
                            </select>
                          </div>
                          <div class="mb-3">
                            <label class="form-label" for="eventLocation">Location</label>
                            <input
                              type="text"
                              class="form-control"
                              id="eventLocation"
                              name="eventLocation"
                              placeholder="Enter Location" />
                          </div>
                          <div class="mb-3">
                            <label class="form-label" for="eventDescription">Description</label>
                            <textarea class="form-control" name="eventDescription" id="eventDescription"></textarea>
                          </div>
                          <div class="mb-3 d-flex justify-content-sm-between justify-content-start my-4">
                            <div>
                              <button type="submit" class="btn btn-primary btn-add-event me-sm-3 me-1">Add</button>
                              <button
                                type="reset"
                                class="btn btn-label-secondary btn-cancel me-sm-0 me-1"
                                data-bs-dismiss="offcanvas">
                                Cancel
                              </button>
                            </div>
                            <div><button class="btn btn-label-danger btn-delete-event d-none">Delete</button></div>
                          </div>
                        </form>
                      </div>
                    </div>
                  </div>
                  <!-- /Calendar & Modal -->
                </div>
              </div>
            </div>
            <!--/ Content -->          

            <div class="content-backdrop fade"></div>
          </div>
          <!--/ Content wrapper -->
        </div>

        <!--/ Layout container -->
      </div>
    </div>

    <!-- Overlay -->
    <div class="layout-overlay layout-menu-toggle"></div>

    <!-- Drag Target Area To SlideIn Menu On Small Screens -->
    <div class="drag-target"></div>


<script>
    
    
    /**
 * App Calendar
 */

    /**
     * ! If both start and end dates are same Full calendar will nullify the end date value.
     * ! Full calendar will end the event on a day before at 12:00:00AM thus, event won't extend to the end date.
     * ! We are getting events from a separate file named app-calendar-events.js. You can add or remove events from there.
     *
     **/

    'use strict';

    let direction = 'ltr';

    //if (isRtl) {
    //    direction = 'rtl';
    //}

    document.addEventListener('DOMContentLoaded', function () {
        (function () {
            const calendarEl = document.getElementById('calendar'),
                appCalendarSidebar = document.querySelector('.app-calendar-sidebar'),
                addEventSidebar = document.getElementById('addEventSidebar'),
                appOverlay = document.querySelector('.app-overlay'),
                calendarsColor = {
                    Event: 'primary',
                    Assignment: 'success',
                    Election: 'danger',
                    Timeslot: 'warning',
                    ETC: 'info'
                },
                offcanvasTitle = document.querySelector('.offcanvas-title'),
                btnToggleSidebar = document.querySelector('.btn-toggle-sidebar'),
                btnSubmit = document.querySelector('button[type="submit"]'),
                btnDeleteEvent = document.querySelector('.btn-delete-event'),
                btnCancel = document.querySelector('.btn-cancel'),
                eventTitle = document.querySelector('#eventTitle'),
                eventStartDate = document.querySelector('#eventStartDate'),
                eventEndDate = document.querySelector('#eventEndDate'),
                eventUrl = document.querySelector('#eventURL'),
                eventLabel = $('#eventLabel'), // ! Using jquery vars due to select2 jQuery dependency
                eventGuests = $('#eventGuests'), // ! Using jquery vars due to select2 jQuery dependency
                eventLocation = document.querySelector('#eventLocation'),
                eventDescription = document.querySelector('#eventDescription'),
                allDaySwitch = document.querySelector('.allDay-switch'),
                selectAll = document.querySelector('.select-all'),
                filterInput = [].slice.call(document.querySelectorAll('.input-filter')),
                inlineCalendar = document.querySelector('.inline-calendar');

            let eventToUpdate,
                //currentEvents = eve, // Assign app-calendar-events.js file events (assume events from API) to currentEvents (browser store/object) to manage and update calender events
                isFormValid = false,
                inlineCalInstance;

            // Init event Offcanvas
            const bsAddEventSidebar = new bootstrap.Offcanvas(addEventSidebar);

            //! TODO: Update Event label and guest code to JS once select removes jQuery dependency
            // Event Label (select2)
            if (eventLabel.length) {
                function renderBadges(option) {
                    if (!option.id) {
                        return option.text;
                    }
                    var $badge =
                        "<span class='badge badge-dot bg-" + $(option.element).data('label') + " me-2'> " + '</span>' + option.text;

                    return $badge;
                }
                eventLabel.wrap('<div class="position-relative"></div>').select2({
                    placeholder: 'Select value',
                    dropdownParent: eventLabel.parent(),
                    templateResult: renderBadges,
                    templateSelection: renderBadges,
                    minimumResultsForSearch: -1,
                    escapeMarkup: function (es) {
                        return es;
                    }
                });
            }

            // Event Guests (select2)
            if (eventGuests.length) {
                function renderGuestAvatar(option) {
                    if (!option.id) {
                        return option.text;
                    }
                    var $avatar =
                        "<div class='d-flex flex-wrap align-items-center'>" +
                        "<div class='avatar avatar-xs me-2'>" +
                        "<img src='" +
                        assetsPath +
                        'img/avatars/' +
                        $(option.element).data('avatar') +
                        "' alt='avatar' class='rounded-circle' />" +
                        '</div>' +
                        option.text +
                        '</div>';

                    return $avatar;
                }
                eventGuests.wrap('<div class="position-relative"></div>').select2({
                    placeholder: 'Select value',
                    dropdownParent: eventGuests.parent(),
                    closeOnSelect: false,
                    templateResult: renderGuestAvatar,
                    templateSelection: renderGuestAvatar,
                    escapeMarkup: function (es) {
                        return es;
                    }
                });
            }

            // Event start (flatpicker)
            if (eventStartDate) {
                var start = eventStartDate.flatpickr({
                    enableTime: true,
                    altFormat: 'Y-m-dTH:i:S',
                    onReady: function (selectedDates, dateStr, instance) {
                        if (instance.isMobile) {
                            instance.mobileInput.setAttribute('step', null);
                        }
                    }
                });
            }

            // Event end (flatpicker)
            if (eventEndDate) {
                var end = eventEndDate.flatpickr({
                    enableTime: true,
                    altFormat: 'Y-m-dTH:i:S',
                    onReady: function (selectedDates, dateStr, instance) {
                        if (instance.isMobile) {
                            instance.mobileInput.setAttribute('step', null);
                        }
                    }
                });
            }

            // Inline sidebar calendar (flatpicker)
            if (inlineCalendar) {
                inlineCalInstance = inlineCalendar.flatpickr({
                    monthSelectorType: 'static',
                    inline: true
                });
            }

            // Event click function
            function eventClick(info) {
                eventToUpdate = info.event;
                if (eventToUpdate.url) {
                    info.jsEvent.preventDefault();
                    window.open(eventToUpdate.url, '_blank');
                }
                bsAddEventSidebar.show();
                // For update event set offcanvas title text: Update Event
                if (offcanvasTitle) {
                    offcanvasTitle.innerHTML = 'Update Event';
                }
                btnSubmit.innerHTML = 'Update';
                btnSubmit.classList.add('btn-update-event');
                btnSubmit.classList.remove('btn-add-event');
                btnDeleteEvent.classList.remove('d-none');

                eventTitle.value = eventToUpdate.title;
                start.setDate(eventToUpdate.start, true, 'Y-m-d');
                eventToUpdate.allDay === true ? (allDaySwitch.checked = true) : (allDaySwitch.checked = false);
                eventToUpdate.end !== null
                    ? end.setDate(eventToUpdate.end, true, 'Y-m-d')
                    : end.setDate(eventToUpdate.start, true, 'Y-m-d');
                eventLabel.val(eventToUpdate.extendedProps.calendar).trigger('change');
                eventToUpdate.extendedProps.location !== undefined
                    ? (eventLocation.value = eventToUpdate.extendedProps.location)
                    : null;
                eventToUpdate.extendedProps.guests !== undefined
                    ? eventGuests.val(eventToUpdate.extendedProps.guests).trigger('change')
                    : null;
                eventToUpdate.extendedProps.description !== undefined
                    ? (eventDescription.value = eventToUpdate.extendedProps.description)
                    : null;

                // // Call removeEvent function
                // btnDeleteEvent.addEventListener('click', e => {
                //   removeEvent(parseInt(eventToUpdate.id));
                //   // eventToUpdate.remove();
                //   bsAddEventSidebar.hide();
                // });
            }

            // Modify sidebar toggler
            function modifyToggler() {
                const fcSidebarToggleButton = document.querySelector('.fc-sidebarToggle-button');
                fcSidebarToggleButton.classList.remove('fc-button-primary');
                fcSidebarToggleButton.classList.add('d-lg-none', 'd-inline-block', 'ps-0');
                while (fcSidebarToggleButton.firstChild) {
                    fcSidebarToggleButton.firstChild.remove();
                }
                fcSidebarToggleButton.setAttribute('data-bs-toggle', 'sidebar');
                fcSidebarToggleButton.setAttribute('data-overlay', '');
                fcSidebarToggleButton.setAttribute('data-target', '#app-calendar-sidebar');
                fcSidebarToggleButton.insertAdjacentHTML('beforeend', '<i class="bx bx-menu bx-sm"></i>');
            }

            // Filter events by calender
            function selectedCalendars() {
                let selected = [],
                    filterInputChecked = [].slice.call(document.querySelectorAll('.input-filter:checked'));

                filterInputChecked.forEach(item => {
                    selected.push(item.getAttribute('data-value'));
                });

                return selected;
            }

            // --------------------------------------------------------------------------------------------------
            // AXIOS: fetchEvents
            // * This will be called by fullCalendar to fetch events. Also this can be used to refetch events.
            // --------------------------------------------------------------------------------------------------
            function fetchEvents(info, successCallback) {
                // Fetch Events from API endpoint reference
                //$('table').hide()
                var URL = window.location.href;
                if (URL.indexOf('?') < 0)
                    URL += '?'
                else
                    URL += '&'
                URL += 'getData=y&start='+info.startStr+'&end='+info.endStr
                 $.ajax(
                  {
                    url: URL,
                    type: 'GET',
                    success: function (result) {
                      // Get requested calendars as Array
                      var calendars = selectedCalendars();
          
                      //return [result.events.filter(event => calendars.includes(event.extendedProps.calendar))];
                        //return [JSON.parse(result).filter(event => calendars.includes(event.extendedProps.calendar))];
                        //return JSON.parse(result);
                        var filteredData = JSON.parse(result).filter(event => calendars.includes(event.extendedProps.calendar.toLowerCase()));
                        successCallback(filteredData);
                        //$('table').show()
                    },
                    error: function (error) {
                      console.log(error);
                    }
                  }
                ); 
                //alert('Got Data.');
                //let calendars = selectedCalendars();
                //// We are reading event object from app-calendar-events.js file directly by including that file above app-calendar file.
                //// You should make an API call, look into above commented API call for reference
                //let selectedEvents = currentEvents.filter(function (event) {
                //    // console.log(event.extendedProps.calendar.toLowerCase());
                //    return calendars.includes(event.extendedProps.calendar.toLowerCase());
                //});
                // if (selectedEvents.length > 0) {
                
                // }
            }

            // Init FullCalendar
            // ------------------------------------------------
            let calendar = new Calendar(calendarEl, {
                innerHeight: 'auto',
                outerHeight: 'auto',
                initialView: 'dayGridMonth',
                events: fetchEvents,
                plugins: [dayGridPlugin, interactionPlugin, listPlugin, timegridPlugin],
                editable: true,
                dragScroll: true,
                dayMaxEvents: 2,
                eventResizableFromStart: true,
                customButtons: {
                    sidebarToggle: {
                        text: 'Sidebar'
                    }
                },
                headerToolbar: {
                    start: 'sidebarToggle, prev,next, title',
                    end: 'dayGridMonth,timeGridWeek,timeGridDay,listMonth'
                },
                direction: direction,
                initialDate: new Date(),
                navLinks: true, // can click day/week names to navigate views
                eventClassNames: function ({ event: calendarEvent }) {
                    const colorName = calendarsColor[calendarEvent._def.extendedProps.calendar];
                    // Background Color
                    return ['fc-event-' + colorName];
                },
                dateClick: function (info) {
                    let date = moment(info.date).format('YYYY-MM-DD');
                    resetValues();
                    bsAddEventSidebar.show();

                    // For new event set offcanvas title text: Add Event
                    if (offcanvasTitle) {
                        offcanvasTitle.innerHTML = 'Add Event';
                    }
                    btnSubmit.innerHTML = 'Add';
                    btnSubmit.classList.remove('btn-update-event');
                    btnSubmit.classList.add('btn-add-event');
                    btnDeleteEvent.classList.add('d-none');
                    eventStartDate.value = date;
                    eventEndDate.value = date;
                },
                eventClick: function (info) {
                    eventClick(info);
                },
                datesSet: function () {
                    modifyToggler();
                },
                viewDidMount: function () {
                    modifyToggler();
                }
            });

            // Render calendar
            calendar.render();
            // Modify sidebar toggler
            modifyToggler();

            const eventForm = document.forms[0];
            const fv = FormValidation.formValidation(eventForm, {
                fields: {
                    eventTitle: {
                        validators: {
                            notEmpty: {
                                message: 'Please enter event title '
                            }
                        }
                    },
                    eventStartDate: {
                        validators: {
                            notEmpty: {
                                message: 'Please enter start date '
                            }
                        }
                    },
                    eventEndDate: {
                        validators: {
                            notEmpty: {
                                message: 'Please enter end date '
                            }
                        }
                    }
                },
                plugins: {
                    trigger: new FormValidation.plugins.Trigger(),
                    bootstrap5: new FormValidation.plugins.Bootstrap5({
                        // Use this for enabling/changing valid/invalid class
                        eleValidClass: '',
                        rowSelector: function (field, ele) {
                            // field is the field name & ele is the field element
                            return '.mb-3';
                        }
                    }),
                    submitButton: new FormValidation.plugins.SubmitButton(),
                    // Submit the form when all fields are valid
                    // defaultSubmit: new FormValidation.plugins.DefaultSubmit(),
                    autoFocus: new FormValidation.plugins.AutoFocus()
                }
            })
                .on('core.form.valid', function () {
                    // Jump to the next step when all fields in the current step are valid
                    isFormValid = true;
                })
                .on('core.form.invalid', function () {
                    // if fields are invalid
                    isFormValid = false;
                });

            // Sidebar Toggle Btn
            if (btnToggleSidebar) {
                btnToggleSidebar.addEventListener('click', e => {
                    btnCancel.classList.remove('d-none');
                });
            }

            // Add Event
            // ------------------------------------------------
            function addEvent(eventData) {
                // ? Add new event data to current events object and refetch it to display on calender
                // ? You can write below code to AJAX call success response

                currentEvents.push(eventData);
                calendar.refetchEvents();

                // ? To add event directly to calender (won't update currentEvents object)
                // calendar.addEvent(eventData);
            }

            // Update Event
            // ------------------------------------------------
            function updateEvent(eventData) {
                // ? Update existing event data to current events object and refetch it to display on calender
                // ? You can write below code to AJAX call success response
                eventData.id = parseInt(eventData.id);
                currentEvents[currentEvents.findIndex(el => el.id === eventData.id)] = eventData; // Update event by id
                calendar.refetchEvents();

                // ? To update event directly to calender (won't update currentEvents object)
                // let propsToUpdate = ['id', 'title', 'url'];
                // let extendedPropsToUpdate = ['calendar', 'guests', 'location', 'description'];

                // updateEventInCalendar(eventData, propsToUpdate, extendedPropsToUpdate);
            }

            // Remove Event
            // ------------------------------------------------

            function removeEvent(eventId) {
                // ? Delete existing event data to current events object and refetch it to display on calender
                // ? You can write below code to AJAX call success response
                currentEvents = currentEvents.filter(function (event) {
                    return event.id != eventId;
                });
                calendar.refetchEvents();

                // ? To delete event directly to calender (won't update currentEvents object)
                // removeEventInCalendar(eventId);
            }

            // (Update Event In Calendar (UI Only)
            // ------------------------------------------------
            const updateEventInCalendar = (updatedEventData, propsToUpdate, extendedPropsToUpdate) => {
                const existingEvent = calendar.getEventById(updatedEventData.id);

                // --- Set event properties except date related ----- //
                // ? Docs: https://fullcalendar.io/docs/Event-setProp
                // dateRelatedProps => ['start', 'end', 'allDay']
                // eslint-disable-next-line no-plusplus
                for (var index = 0; index < propsToUpdate.length; index++) {
                    var propName = propsToUpdate[index];
                    existingEvent.setProp(propName, updatedEventData[propName]);
                }

                // --- Set date related props ----- //
                // ? Docs: https://fullcalendar.io/docs/Event-setDates
                existingEvent.setDates(updatedEventData.start, updatedEventData.end, {
                    allDay: updatedEventData.allDay
                });

                // --- Set event's extendedProps ----- //
                // ? Docs: https://fullcalendar.io/docs/Event-setExtendedProp
                // eslint-disable-next-line no-plusplus
                for (var index = 0; index < extendedPropsToUpdate.length; index++) {
                    var propName = extendedPropsToUpdate[index];
                    existingEvent.setExtendedProp(propName, updatedEventData.extendedProps[propName]);
                }
            };

            // Remove Event In Calendar (UI Only)
            // ------------------------------------------------
            function removeEventInCalendar(eventId) {
                calendar.getEventById(eventId).remove();
            }

            // Add new event
            // ------------------------------------------------
            btnSubmit.addEventListener('click', e => {
                if (btnSubmit.classList.contains('btn-add-event')) {
                    if (isFormValid) {
                        let newEvent = {
                            id: calendar.getEvents().length + 1,
                            title: eventTitle.value,
                            start: eventStartDate.value,
                            end: eventEndDate.value,
                            startStr: eventStartDate.value,
                            endStr: eventEndDate.value,
                            display: 'block',
                            extendedProps: {
                                location: eventLocation.value,
                                guests: eventGuests.val(),
                                calendar: eventLabel.val(),
                                description: eventDescription.value
                            }
                        };
                        if (eventUrl.value) {
                            newEvent.url = eventUrl.value;
                        }
                        if (allDaySwitch.checked) {
                            newEvent.allDay = true;
                        }
                        addEvent(newEvent);
                        bsAddEventSidebar.hide();
                    }
                } else {
                    // Update event
                    // ------------------------------------------------
                    if (isFormValid) {
                        let eventData = {
                            id: eventToUpdate.id,
                            title: eventTitle.value,
                            start: eventStartDate.value,
                            end: eventEndDate.value,
                            url: eventUrl.value,
                            extendedProps: {
                                location: eventLocation.value,
                                guests: eventGuests.val(),
                                calendar: eventLabel.val(),
                                description: eventDescription.value
                            },
                            display: 'block',
                            allDay: allDaySwitch.checked ? true : false
                        };

                        updateEvent(eventData);
                        bsAddEventSidebar.hide();
                    }
                }
            });

            // Call removeEvent function
            btnDeleteEvent.addEventListener('click', e => {
                removeEvent(parseInt(eventToUpdate.id));
                // eventToUpdate.remove();
                bsAddEventSidebar.hide();
            });

            // Reset event form inputs values
            // ------------------------------------------------
            function resetValues() {
                eventEndDate.value = '';
                eventUrl.value = '';
                eventStartDate.value = '';
                eventTitle.value = '';
                eventLocation.value = '';
                allDaySwitch.checked = false;
                eventGuests.val('').trigger('change');
                eventDescription.value = '';
            }

            // When modal hides reset input values
            addEventSidebar.addEventListener('hidden.bs.offcanvas', function () {
                resetValues();
            });

            // Hide left sidebar if the right sidebar is open
            btnToggleSidebar.addEventListener('click', e => {
                if (offcanvasTitle) {
                    offcanvasTitle.innerHTML = 'Add Event';
                }
                btnSubmit.innerHTML = 'Add';
                btnSubmit.classList.remove('btn-update-event');
                btnSubmit.classList.add('btn-add-event');
                btnDeleteEvent.classList.add('d-none');
                appCalendarSidebar.classList.remove('show');
                appOverlay.classList.remove('show');
            });

            // Calender filter functionality
            // ------------------------------------------------
            if (selectAll) {
                selectAll.addEventListener('click', e => {
                    if (e.currentTarget.checked) {
                        document.querySelectorAll('.input-filter').forEach(c => (c.checked = 1));
                    } else {
                        document.querySelectorAll('.input-filter').forEach(c => (c.checked = 0));
                    }
                    calendar.refetchEvents();
                });
            }

            if (filterInput) {
                filterInput.forEach(item => {
                    item.addEventListener('click', () => {
                        document.querySelectorAll('.input-filter:checked').length < document.querySelectorAll('.input-filter').length
                            ? (selectAll.checked = false)
                            : (selectAll.checked = true);
                        calendar.refetchEvents();
                    });
                });
            }

            // Jump to date on sidebar(inline) calendar change
            inlineCalInstance.config.onChange.push(function (date) {
                calendar.changeView(calendar.view.type, moment(date[0]).format('YYYY-MM-DD'));
                modifyToggler();
                appCalendarSidebar.classList.remove('show');
                appOverlay.classList.remove('show');
            });
        })();
    });

</script>

<script>
    $(function () {
        var urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get("popup") == 'y') {
            $('.calendar-filters').hide()
            $('.fc-day').css('height', '60px')

            //$('.fc-col-header-cell.fc-day').css('height', '30px')
            //$('.card.app-calendar-wrapper').css('width', '1000px;')
            //$('.fc-col-header ').css('width', '100%;')
            //$('.fc-daygrid-body').css('width', '100%')
            //$('.fc-scrollgrid-sync-table').css('width', '100%')
            //$('.fc-scrollgrid-sync-table').css('height', 'unset')
        }

    });
</script>