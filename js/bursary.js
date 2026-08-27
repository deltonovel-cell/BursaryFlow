let allBursaries = [];


/* =========================================================
   START
========================================================= */

document.addEventListener("DOMContentLoaded", () => {

    loadBursaries();

    setupSearch();

    setupFilters();

    setupMobileMenu();

    setupMatchButton();

    setupClearFilters();

    setupRetry();

});


/* =========================================================
   LOAD BURSARIES
========================================================= */

async function loadBursaries() {

    showLoading();

    try {

        const response =
            await fetch("/api/Bursary");


        if (!response.ok) {

            throw new Error(
                "API returned " + response.status
            );

        }


        const result =
            await response.json();


        console.log("Bursary API:", result);


        if (Array.isArray(result)) {

            allBursaries = result;

        }
        else if (Array.isArray(result.data)) {

            allBursaries = result.data;

        }
        else if (Array.isArray(result.bursaries)) {

            allBursaries = result.bursaries;

        }
        else {

            allBursaries = [];

        }


        updateCounts();

        renderBursaries(allBursaries);

    }
    catch (error) {

        console.error(
            "Failed to load bursaries:",
            error
        );

        showError();

    }

}


/* =========================================================
   RENDER
========================================================= */

function renderBursaries(bursaries) {

    const grid =
        document.getElementById(
            "bursaryGrid"
        );

    const empty =
        document.getElementById(
            "emptyState"
        );

    const loading =
        document.getElementById(
            "loadingState"
        );


    loading.classList.add("hidden");


    if (!bursaries.length) {

        grid.innerHTML = "";

        empty.classList.remove("hidden");

        updateVisibleCount(0);

        return;

    }


    empty.classList.add("hidden");


    grid.innerHTML =
        bursaries
            .map(
                bursary =>
                    createBursaryCard(
                        bursary
                    )
            )
            .join("");


    updateVisibleCount(
        bursaries.length
    );

}


/* =========================================================
   CREATE CARD
========================================================= */

function createBursaryCard(bursary) {

    const id =
        bursary.bursaryID ??
        bursary.BursaryID;


    const name =
        bursary.bursaryName ??
        bursary.BursaryName ??
        "Bursary Opportunity";


    const provider =
        bursary.provider ??
        bursary.Provider ??
        "Verified Provider";


    const description =
        bursary.description ??
        bursary.Description ??
        "This bursary provides financial support to eligible students.";


    const studyLevel =
        bursary.studyLevel ??
        bursary.StudyLevel ??
        "Various";


    const studyFields =
        bursary.studyFields ??
        bursary.StudyFields ??
        "";


    const minimumAverage =
        bursary.minimumAverage ??
        bursary.MinimumAverage;


    const householdIncome =
        bursary.maximumHouseholdIncome ??
        bursary.MaximumHouseholdIncome;


    const verified =
        bursary.isVerified ??
        bursary.IsVerified ??
        false;


    const website =
        bursary.websiteURL ??
        bursary.WebsiteURL;


    const applicationUrl =
        bursary.applicationURL ??
        bursary.ApplicationURL;


    const initials =
        getInitials(provider);


    const tags = [];


    if (studyLevel) {

        tags.push(
            studyLevel
        );

    }


    if (studyFields) {

        const firstField =
            studyFields
                .split(",")[0]
                .trim();

        if (firstField) {

            tags.push(
                firstField
            );

        }

    }


    if (
        minimumAverage !== null &&
        minimumAverage !== undefined
    ) {

        tags.push(
            minimumAverage + "% minimum"
        );

    }


    const funding =
        getFundingDescription(
            bursary
        );


    return (

        "<article class=\"bursary-card\">" +

        "<div class=\"card-top\">" +

        "<div class=\"provider-logo\">" +

        escapeHtml(initials) +

        "</div>" +


        "<div class=\"card-title\">" +

        (
            verified
                ?
                "<div class=\"verified\">" +
                "✓ Verified opportunity" +
                "</div>"
                :
                ""
        ) +


        "<h3>" +
        escapeHtml(name) +
        "</h3>" +


        "<p class=\"provider-name\">" +
        escapeHtml(provider) +
        "</p>" +

        "</div>" +


        "<div class=\"match-score\">" +

        (
            verified
                ? "Verified"
                : "Opportunity"
        ) +

        "</div>" +

        "</div>" +


        "<p class=\"card-description\">" +

        escapeHtml(
            truncate(
                description,
                155
            )
        ) +

        "</p>" +


        "<div class=\"card-tags\">" +

        tags
            .map(
                tag =>
                    "<span class=\"card-tag\">" +
                    escapeHtml(tag) +
                    "</span>"
            )
            .join("") +

        "</div>" +


        "<div class=\"card-footer\">" +

        "<div class=\"funding-info\">" +

        "<span>" +
        "Funding" +
        "</span>" +

        "<strong>" +
        escapeHtml(funding) +
        "</strong>" +

        "</div>" +


        "<div class=\"card-actions\">" +

        "<a " +
        "href=\"/BursaryPage/Details/" +
        id +
        "\" " +
        "class=\"details-button\">" +

        "Details" +

        "</a>" +


        (
            applicationUrl
                ?
                "<a " +
                "href=\"" +
                escapeAttribute(applicationUrl) +
                "\" " +
                "target=\"_blank\" " +
                "rel=\"noopener noreferrer\" " +
                "class=\"apply-button\">" +

                "Apply →" +

                "</a>"
                :
                "<a " +
                "href=\"/Application/Create?bursaryId=" +
                id +
                "\" " +
                "class=\"apply-button\">" +

                "Apply →" +

                "</a>"
        ) +

        "</div>" +

        "</div>" +

        "</article>"

    );

}


/* =========================================================
   FUNDING
========================================================= */

function getFundingDescription(bursary) {

    const funding = [];


    if (
        bursary.tuitionIncluded ??
        bursary.TuitionIncluded
    ) {

        funding.push(
            "Tuition"
        );

    }


    if (
        bursary.booksIncluded ??
        bursary.BooksIncluded
    ) {

        funding.push(
            "Books"
        );

    }


    if (
        bursary.accommodationIncluded ??
        bursary.AccommodationIncluded
    ) {

        funding.push(
            "Accommodation"
        );

    }


    if (
        bursary.livingAllowanceIncluded ??
        bursary.LivingAllowanceIncluded
    ) {

        funding.push(
            "Living allowance"
        );

    }


    if (!funding.length) {

        return "Financial support";

    }


    return funding
        .slice(0, 2)
        .join(" + ");

}


/* =========================================================
   SEARCH
========================================================= */

function setupSearch() {

    const globalSearch =
        document.getElementById(
            "searchInput"
        );


    const directorySearch =
        document.getElementById(
            "directorySearch"
        );


    globalSearch?.addEventListener(
        "input",
        () => {

            if (directorySearch) {

                directorySearch.value =
                    globalSearch.value;

            }

            filterBursaries();

        }
    );


    directorySearch?.addEventListener(
        "input",
        () => {

            if (globalSearch) {

                globalSearch.value =
                    directorySearch.value;

            }

            filterBursaries();

        }
    );

}


/* =========================================================
   FILTERS
========================================================= */

function setupFilters() {

    document
        .getElementById("studyLevelFilter")
        ?.addEventListener(
            "change",
            filterBursaries
        );


    document
        .getElementById("fieldFilter")
        ?.addEventListener(
            "change",
            filterBursaries
        );


    document
        .getElementById("sortFilter")
        ?.addEventListener(
            "change",
            filterBursaries
        );

}


function filterBursaries() {

    const search =
        document
            .getElementById(
                "directorySearch"
            )
            .value
            .trim()
            .toLowerCase();


    const level =
        document
            .getElementById(
                "studyLevelFilter"
            )
            .value
            .toLowerCase();


    const field =
        document
            .getElementById(
                "fieldFilter"
            )
            .value
            .toLowerCase();


    const sort =
        document
            .getElementById(
                "sortFilter"
            )
            .value;


    let filtered =
        allBursaries.filter(
            bursary => {

                const name =
                    String(
                        bursary.bursaryName ??
                        bursary.BursaryName ??
                        ""
                    ).toLowerCase();


                const provider =
                    String(
                        bursary.provider ??
                        bursary.Provider ??
                        ""
                    ).toLowerCase();


                const description =
                    String(
                        bursary.description ??
                        bursary.Description ??
                        ""
                    ).toLowerCase();


                const fields =
                    String(
                        bursary.studyFields ??
                        bursary.StudyFields ??
                        ""
                    ).toLowerCase();


                const studyLevel =
                    String(
                        bursary.studyLevel ??
                        bursary.StudyLevel ??
                        ""
                    ).toLowerCase();


                /*
                 * SEARCH
                 *
                 * Searches:
                 * - Bursary name
                 * - Provider
                 * - Description
                 * - Study fields
                 * - Study level
                 */

                const matchesSearch =
                    !search ||
                    name.includes(search) ||
                    provider.includes(search) ||
                    description.includes(search) ||
                    fields.includes(search) ||
                    studyLevel.includes(search);


                const matchesLevel =
                    !level ||
                    studyLevel.includes(level);


                const matchesField =
                    !field ||
                    fields.includes(field);


                return (
                    matchesSearch &&
                    matchesLevel &&
                    matchesField
                );

            }
        );


    /* =====================================================
       SORT
    ===================================================== */

    if (sort === "verified") {

        filtered.sort(
            (a, b) =>
                Number(
                    b.isVerified ??
                    b.IsVerified ??
                    false
                )
                -
                Number(
                    a.isVerified ??
                    a.IsVerified ??
                    false
                )
        );

    }


    else if (sort === "average") {

        filtered.sort(
            (a, b) => {

                const averageA =
                    a.minimumAverage ??
                    a.MinimumAverage ??
                    0;


                const averageB =
                    b.minimumAverage ??
                    b.MinimumAverage ??
                    0;


                return averageA - averageB;

            }
        );

    }


    else {

        filtered.sort(
            (a, b) => {

                const nameA =
                    a.bursaryName ??
                    a.BursaryName ??
                    "";


                const nameB =
                    b.bursaryName ??
                    b.BursaryName ??
                    "";


                return nameA.localeCompare(
                    nameB
                );

            }
        );

    }


    renderBursaries(filtered);

}


/* =========================================================
   MATCH BUTTON
========================================================= */

function setupMatchButton() {

    document
        .getElementById("matchButton")
        ?.addEventListener(
            "click",
            () => {

                window.location.href =
                    "/Profile";

            }
        );

}


/* =========================================================
   COUNTS
========================================================= */

function updateCounts() {

    const total =
        document.getElementById(
            "totalCount"
        );


    if (total) {

        total.textContent =
            allBursaries.length;

    }


    updateVisibleCount(
        allBursaries.length
    );

}


function updateVisibleCount(count) {

    const element =
        document.getElementById(
            "visibleCount"
        );


    if (element) {

        element.textContent =
            count;

    }

}


/* =========================================================
   LOADING
========================================================= */

function showLoading() {

    document
        .getElementById(
            "loadingState"
        )
        .classList.remove(
            "hidden"
        );


    document
        .getElementById(
            "bursaryGrid"
        )
        .innerHTML = "";


    document
        .getElementById(
            "emptyState"
        )
        .classList.add(
            "hidden"
        );


    document
        .getElementById(
            "errorState"
        )
        .classList.add(
            "hidden"
        );

}


/* =========================================================
   ERROR
========================================================= */

function showError() {

    document
        .getElementById(
            "loadingState"
        )
        .classList.add(
            "hidden"
        );


    document
        .getElementById(
            "errorState"
        )
        .classList.remove(
            "hidden"
        );

}


function setupRetry() {

    document
        .getElementById(
            "retryButton"
        )
        ?.addEventListener(
            "click",
            loadBursaries
        );

}


/* =========================================================
   CLEAR
========================================================= */

function setupClearFilters() {

    document
        .getElementById(
            "clearFilters"
        )
        ?.addEventListener(
            "click",
            () => {

                document
                    .getElementById(
                        "directorySearch"
                    )
                    .value = "";


                document
                    .getElementById(
                        "searchInput"
                    )
                    .value = "";


                document
                    .getElementById(
                        "studyLevelFilter"
                    )
                    .value = "";


                document
                    .getElementById(
                        "fieldFilter"
                    )
                    .value = "";


                document
                    .getElementById(
                        "sortFilter"
                    )
                    .value = "name";


                renderBursaries(
                    allBursaries
                );

            }
        );

}


/* =========================================================
   MOBILE
========================================================= */

function setupMobileMenu() {

    const menu =
        document.getElementById(
            "mobileMenu"
        );


    const sidebar =
        document.getElementById(
            "sidebar"
        );


    menu?.addEventListener(
        "click",
        () => {

            sidebar.classList.toggle(
                "open"
            );

        }
    );

}


/* =========================================================
   HELPERS
========================================================= */

function getInitials(value) {

    if (!value) {

        return "BF";

    }


    return value
        .split(" ")
        .slice(0, 2)
        .map(
            word =>
                word.charAt(0)
        )
        .join("")
        .toUpperCase();

}


function truncate(
    value,
    length
) {

    if (!value) {

        return "";

    }


    value =
        String(value);


    if (
        value.length <= length
    ) {

        return value;

    }


    return (
        value.substring(
            0,
            length
        ).trim() +
        "..."
    );

}


function escapeHtml(value) {

    if (
        value === null ||
        value === undefined
    ) {

        return "";

    }


    return String(value)
        .replaceAll(
            "&",
            "&amp;"
        )
        .replaceAll(
            "<",
            "&lt;"
        )
        .replaceAll(
            ">",
            "&gt;"
        )
        .replaceAll(
            '"',
            "&quot;"
        )
        .replaceAll(
            "'",
            "&#039;"
        );

}


function escapeAttribute(value) {

    return escapeHtml(value);

}