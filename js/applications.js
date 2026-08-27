/* =========================================================
   BURSARYFLOW - MY APPLICATIONS
   ========================================================= */

document.addEventListener("DOMContentLoaded", function () {

    /*
     * =====================================================
     * SAMPLE APPLICATION DATA
     *
     * Later this will come from your ASP.NET backend/database.
     * =====================================================
     */

    let applications = [

        {
            id: 1,
            name: "Motus Mobility Solutions Bursary",
            organisation: "Motus Holdings",
            status: "progress",
            statusText: "In progress",
            progress: 65,
            deadline: "2026-09-15",
            submittedDate: null,
            lastUpdated: "2026-08-25",
            description:
                "Financial support for students pursuing eligible tertiary qualifications."
        },

        {
            id: 2,
            name: "Vodacom Foundation Bursary",
            organisation: "Vodacom",
            status: "submitted",
            statusText: "Submitted",
            progress: 100,
            deadline: "2026-08-30",
            submittedDate: "2026-08-18",
            lastUpdated: "2026-08-18",
            description:
                "A bursary opportunity supporting students in selected fields of study."
        },

        {
            id: 3,
            name: "AECI Bursary Programme",
            organisation: "AECI",
            status: "draft",
            statusText: "Draft",
            progress: 35,
            deadline: "2026-09-30",
            submittedDate: null,
            lastUpdated: "2026-08-21",
            description:
                "A bursary programme designed to support talented students in South Africa."
        },

        {
            id: 4,
            name: "Standard Bank Bursary",
            organisation: "Standard Bank",
            status: "successful",
            statusText: "Successful",
            progress: 100,
            deadline: "2026-08-10",
            submittedDate: "2026-07-28",
            lastUpdated: "2026-08-22",
            description:
                "Bursary funding for qualifying students with strong academic performance."
        },

        {
            id: 5,
            name: "Shoprite Bursary",
            organisation: "Shoprite Group",
            status: "unsuccessful",
            statusText: "Unsuccessful",
            progress: 100,
            deadline: "2026-07-31",
            submittedDate: "2026-07-20",
            lastUpdated: "2026-08-12",
            description:
                "A bursary programme supporting students in selected academic disciplines."
        }

    ];


    let currentStatus = "all";


    /* =====================================================
       ELEMENTS
       ===================================================== */

    const applicationsList =
        document.getElementById("applicationsList");

    const emptyApplications =
        document.getElementById("emptyApplications");

    const emptyMessage =
        document.getElementById("emptyMessage");

    const applicationSearch =
        document.getElementById("applicationSearch");

    const applicationSort =
        document.getElementById("applicationSort");

    const totalApplications =
        document.getElementById("totalApplications");

    const inProgress =
        document.getElementById("inProgress");

    const submitted =
        document.getElementById("submitted");

    const successful =
        document.getElementById("successful");

    const applicationNavCount =
        document.getElementById("applicationNavCount");


    /* =====================================================
       INITIALISE
       ===================================================== */

    updateStatistics();

    renderApplications();

    setupFilters();

    setupSearch();

    setupSorting();

    setupModal();

    setupMobileMenu();


    /* =====================================================
       STATISTICS
       ===================================================== */

    function updateStatistics() {

        if (totalApplications) {

            totalApplications.textContent =
                applications.length;

        }

        if (inProgress) {

            inProgress.textContent =
                applications.filter(function (application) {

                    return application.status === "progress";

                }).length;

        }

        if (submitted) {

            submitted.textContent =
                applications.filter(function (application) {

                    return application.status === "submitted";

                }).length;

        }

        if (successful) {

            successful.textContent =
                applications.filter(function (application) {

                    return application.status === "successful";

                }).length;

        }

        if (applicationNavCount) {

            applicationNavCount.textContent =
                applications.length;

        }

    }


    /* =====================================================
       FILTERS
       ===================================================== */

    function setupFilters() {

        const filters =
            document.querySelectorAll(".application-filter");

        filters.forEach(function (filter) {

            filter.addEventListener("click", function () {

                filters.forEach(function (item) {

                    item.classList.remove("active");

                });

                filter.classList.add("active");

                currentStatus =
                    filter.dataset.status;

                renderApplications();

            });

        });

    }


    /* =====================================================
       SEARCH
       ===================================================== */

    function setupSearch() {

        if (!applicationSearch) {
            return;
        }

        applicationSearch.addEventListener(
            "input",
            function () {

                renderApplications();

            }
        );

    }


    /* =====================================================
       SORTING
       ===================================================== */

    function setupSorting() {

        if (!applicationSort) {
            return;
        }

        applicationSort.addEventListener(
            "change",
            function () {

                renderApplications();

            }
        );

    }


    /* =====================================================
       GET FILTERED APPLICATIONS
       ===================================================== */

    function getFilteredApplications() {

        let result =
            [...applications];


        if (currentStatus !== "all") {

            result =
                result.filter(function (application) {

                    return application.status === currentStatus;

                });

        }


        const searchTerm =
            applicationSearch
                ? applicationSearch.value
                    .trim()
                    .toLowerCase()
                : "";


        if (searchTerm !== "") {

            result =
                result.filter(function (application) {

                    return (

                        application.name
                            .toLowerCase()
                            .includes(searchTerm)

                        ||

                        application.organisation
                            .toLowerCase()
                            .includes(searchTerm)

                        ||

                        application.statusText
                            .toLowerCase()
                            .includes(searchTerm)

                    );

                });

        }


        const sort =
            applicationSort
                ? applicationSort.value
                : "recent";


        if (sort === "name") {

            result.sort(function (a, b) {

                return a.name.localeCompare(b.name);

            });

        }


        if (sort === "deadline") {

            result.sort(function (a, b) {

                return new Date(a.deadline) -
                    new Date(b.deadline);

            });

        }


        if (sort === "progress") {

            result.sort(function (a, b) {

                return b.progress -
                    a.progress;

            });

        }


        if (sort === "recent") {

            result.sort(function (a, b) {

                return new Date(b.lastUpdated) -
                    new Date(a.lastUpdated);

            });

        }


        return result;

    }


    /* =====================================================
       RENDER
       ===================================================== */

    function renderApplications() {

        if (!applicationsList) {
            return;
        }

        const filtered =
            getFilteredApplications();


        applicationsList.innerHTML = "";


        if (filtered.length === 0) {

            applicationsList.classList.add("hidden");

            emptyApplications.classList.remove("hidden");


            if (applicationSearch &&
                applicationSearch.value.trim() !== "") {

                emptyMessage.textContent =
                    "We couldn't find an application matching your search.";

            }
            else if (currentStatus !== "all") {

                emptyMessage.textContent =
                    "You don't have any applications in this category yet.";

            }
            else {

                emptyMessage.textContent =
                    "Start exploring bursaries and save your first application here.";

            }


            refreshIcons();

            return;

        }


        applicationsList.classList.remove("hidden");

        emptyApplications.classList.add("hidden");


        filtered.forEach(function (application) {

            applicationsList.appendChild(
                createApplicationCard(application)
            );

        });


        refreshIcons();

    }


    /* =====================================================
       CREATE CARD
       ===================================================== */

    function createApplicationCard(application) {

        const card =
            document.createElement("article");

        card.className =
            "application-card";


        const initials =
            getInitials(application.organisation);


        const deadline =
            formatDate(application.deadline);


        const deadlineClass =
            getDeadlineClass(
                application.deadline,
                application.status
            );


        const actionButton =
            getPrimaryAction(application);


        card.innerHTML = `

            <div class="application-main">

                <div class="application-logo">
                    ${initials}
                </div>

                <div class="application-name">

                    <h3 title="${escapeHtml(application.name)}">
                        ${escapeHtml(application.name)}
                    </h3>

                    <p>
                        ${escapeHtml(application.organisation)}
                    </p>

                </div>

            </div>


            <div>

                <span class="application-status status-${application.status}">

                    <span class="application-status-dot"></span>

                    ${escapeHtml(application.statusText)}

                </span>

            </div>


            <div class="application-progress">

                <div class="progress-top">

                    <span>
                        Progress
                    </span>

                    <strong>
                        ${application.progress}%
                    </strong>

                </div>

                <div class="progress-track">

                    <div class="progress-bar"
                         style="width:${application.progress}%">
                    </div>

                </div>

            </div>


            <div class="application-deadline">

                <span class="application-deadline-label">
                    DEADLINE
                </span>

                <span class="application-deadline-date ${deadlineClass}">
                    ${deadline}
                </span>

            </div>


            <div class="application-actions">

                ${actionButton}

                <button
                    class="application-action"
                    type="button"
                    title="View application"
                    data-action="view"
                    data-id="${application.id}">

                    <i data-lucide="eye"></i>

                </button>

                ${application.status !== "successful" &&
                application.status !== "unsuccessful"
                ?
                `
                    <button
                        class="application-action danger"
                        type="button"
                        title="Withdraw application"
                        data-action="withdraw"
                        data-id="${application.id}">

                        <i data-lucide="trash-2"></i>

                    </button>
                    `
                :
                ""
            }

            </div>

        `;


        const actionButtons =
            card.querySelectorAll(
                "[data-action]"
            );


        actionButtons.forEach(function (button) {

            button.addEventListener(
                "click",
                function () {

                    handleAction(
                        button.dataset.action,
                        Number(button.dataset.id)
                    );

                }
            );

        });


        return card;

    }


    /* =====================================================
       PRIMARY ACTION
       ===================================================== */

    function getPrimaryAction(application) {

        if (
            application.status === "draft" ||
            application.status === "progress"
        ) {

            return `

                <button
                    class="application-action primary"
                    type="button"
                    title="Continue application"
                    data-action="continue"
                    data-id="${application.id}">

                    <i data-lucide="arrow-right"></i>

                    Continue

                </button>

            `;

        }


        if (application.status === "submitted") {

            return `

                <button
                    class="application-action primary"
                    type="button"
                    data-action="view"
                    data-id="${application.id}">

                    View

                </button>

            `;

        }


        return "";

    }


    /* =====================================================
       ACTION HANDLER
       ===================================================== */

    function handleAction(action, id) {

        const application =
            applications.find(function (item) {

                return item.id === id;

            });


        if (!application) {
            return;
        }


        if (action === "view") {

            openApplicationModal(
                application
            );

        }


        if (action === "continue") {

            /*
             * Later this can become:
             *
             * window.location.href =
             * "/Applications/Edit/" + application.id;
             */

            openApplicationModal(
                application,
                true
            );

        }


        if (action === "withdraw") {

            withdrawApplication(
                application
            );

        }

    }


    /* =====================================================
       WITHDRAW
       ===================================================== */

    function withdrawApplication(application) {

        const confirmed =
            window.confirm(
                "Are you sure you want to withdraw your application for " +
                application.name +
                "?"
            );


        if (!confirmed) {
            return;
        }


        applications =
            applications.filter(function (item) {

                return item.id !== application.id;

            });


        updateStatistics();

        renderApplications();

    }


    /* =====================================================
       MODAL
       ===================================================== */

    function setupModal() {

        const closeButton =
            document.getElementById("modalClose");

        const overlay =
            document.getElementById("modalOverlay");


        if (closeButton) {

            closeButton.addEventListener(
                "click",
                closeApplicationModal
            );

        }


        if (overlay) {

            overlay.addEventListener(
                "click",
                closeApplicationModal
            );

        }


        document.addEventListener(
            "keydown",
            function (event) {

                if (event.key === "Escape") {

                    closeApplicationModal();

                }

            }
        );

    }


    function openApplicationModal(
        application,
        continueMode = false
    ) {

        const modal =
            document.getElementById(
                "applicationModal"
            );

        const content =
            document.getElementById(
                "modalContent"
            );


        if (!modal || !content) {
            return;
        }


        content.innerHTML = `

            <h2 class="modal-title">
                ${escapeHtml(application.name)}
            </h2>

            <p class="modal-subtitle">
                ${escapeHtml(application.organisation)}
            </p>


            <div class="modal-info-grid">

                <div class="modal-info">

                    <span>
                        STATUS
                    </span>

                    <strong>
                        ${escapeHtml(application.statusText)}
                    </strong>

                </div>


                <div class="modal-info">

                    <span>
                        PROGRESS
                    </span>

                    <strong>
                        ${application.progress}%
                    </strong>

                </div>


                <div class="modal-info">

                    <span>
                        DEADLINE
                    </span>

                    <strong>
                        ${formatDate(application.deadline)}
                    </strong>

                </div>


                <div class="modal-info">

                    <span>
                        LAST UPDATED
                    </span>

                    <strong>
                        ${formatDate(application.lastUpdated)}
                    </strong>

                </div>


                <div class="modal-info">

                    <span>
                        SUBMITTED
                    </span>

                    <strong>
                        ${application.submittedDate
                ? formatDate(application.submittedDate)
                : "Not submitted"
            }
                    </strong>

                </div>


                <div class="modal-info">

                    <span>
                        APPLICATION ID
                    </span>

                    <strong>
                        #${application.id}
                    </strong>

                </div>

            </div>


            <div class="modal-description">

                <strong>
                    About this application
                </strong>

                <p>
                    ${escapeHtml(application.description)}
                </p>

            </div>


            ${continueMode
                ?
                `
                <div style="margin-top:20px;">

                    <a
                        href="/Applications/Edit/${application.id}"
                        class="primary-action">

                        Continue application

                        <i data-lucide="arrow-right"></i>

                    </a>

                </div>
                `
                :
                ""
            }

        `;


        modal.classList.remove("hidden");

        refreshIcons();

    }


    function closeApplicationModal() {

        const modal =
            document.getElementById(
                "applicationModal"
            );

        if (modal) {

            modal.classList.add("hidden");

        }

    }


    /* =====================================================
       MOBILE MENU
       ===================================================== */

    function setupMobileMenu() {

        const mobileMenu =
            document.getElementById(
                "mobileMenu"
            );

        const sidebar =
            document.getElementById(
                "sidebar"
            );


        if (!mobileMenu || !sidebar) {
            return;
        }


        mobileMenu.addEventListener(
            "click",
            function () {

                sidebar.classList.toggle(
                    "mobile-open"
                );

            }
        );

    }


    /* =====================================================
       HELPERS
       ===================================================== */

    function getInitials(name) {

        return name
            .split(" ")
            .map(function (word) {

                return word.charAt(0);

            })
            .slice(0, 2)
            .join("")
            .toUpperCase();

    }


    function formatDate(dateString) {

        if (!dateString) {
            return "—";
        }

        const date =
            new Date(
                dateString + "T00:00:00"
            );


        return date.toLocaleDateString(
            "en-ZA",
            {
                day: "2-digit",
                month: "short",
                year: "numeric"
            }
        );

    }


    function getDeadlineClass(
        deadline,
        status
    ) {

        if (
            status === "successful" ||
            status === "unsuccessful"
        ) {

            return "";

        }


        const today =
            new Date();

        today.setHours(
            0,
            0,
            0,
            0
        );


        const deadlineDate =
            new Date(
                deadline + "T00:00:00"
            );


        const difference =
            Math.ceil(
                (
                    deadlineDate -
                    today
                ) /
                (1000 * 60 * 60 * 24)
            );


        if (difference <= 7) {

            return "deadline-danger";

        }


        if (difference <= 21) {

            return "deadline-warning";

        }


        return "";

    }


    function escapeHtml(value) {

        return String(value)
            .replaceAll("&", "&amp;")
            .replaceAll("<", "&lt;")
            .replaceAll(">", "&gt;")
            .replaceAll('"', "&quot;")
            .replaceAll("'", "&#039;");

    }


    function refreshIcons() {

        if (
            typeof lucide !== "undefined"
        ) {

            lucide.createIcons();

        }

    }

});