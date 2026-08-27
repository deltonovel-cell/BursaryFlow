/* ================================
   BURSARY DETAILS
================================ */

document.addEventListener("DOMContentLoaded", () => {

    loadBursary();

    setupMobileMenu();

});


/* ================================
   LOAD BURSARY
================================ */

async function loadBursary() {

    showLoading();

    try {

        const response =
            await fetch(`/api/Bursary/${bursaryId}`);

        if (!response.ok) {
            throw new Error(
                `API returned ${response.status}`
            );
        }

        const result =
            await response.json();

        console.log(
            "Bursary details:",
            result
        );

        const bursary =
            result.data ?? result;

        if (!bursary) {
            throw new Error(
                "Bursary was not found."
            );
        }

        renderBursary(bursary);

    }
    catch (error) {

        console.error(
            "Failed to load bursary:",
            error
        );

        showError();

    }

}


/* ================================
   RENDER
================================ */

function renderBursary(bursary) {

    const name =
        bursary.bursaryName ??
        bursary.BursaryName ??
        "Bursary Opportunity";

    const provider =
        getProviderName(bursary);

    const description =
        bursary.description ??
        bursary.Description ??
        "No description available.";

    const studyLevel =
        bursary.studyLevel ??
        bursary.StudyLevel ??
        "Various";

    const studyFields =
        bursary.studyFields ??
        bursary.StudyFields ??
        "Various";

    const minimumAverage =
        bursary.minimumAverage ??
        bursary.MinimumAverage;

    const householdIncome =
        bursary.maximumHouseholdIncome ??
        bursary.MaximumHouseholdIncome;

    const minimumYear =
        bursary.minimumYearOfStudy ??
        bursary.MinimumYearOfStudy;

    const maximumYear =
        bursary.maximumYearOfStudy ??
        bursary.MaximumYearOfStudy;

    const citizenship =
        bursary.citizenshipRequirement ??
        bursary.CitizenshipRequirement ??
        "Not specified";

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


    /* NAME */

    setText(
        "bursaryName",
        name
    );


    /* PROVIDER */

    setText(
        "providerName",
        provider
    );

    setText(
        "providerCardName",
        provider
    );


    /* DESCRIPTION */

    setText(
        "bursaryDescription",
        description
    );


    /* INITIALS */

    setText(
        "providerInitials",
        getInitials(provider)
    );


    /* VERIFIED */

    if (verified) {

        document
            .getElementById(
                "verifiedBadge"
            )
            .classList.remove(
                "hidden"
            );

    }


    /* ELIGIBILITY */

    setText(
        "studyLevel",
        studyLevel
    );

    setText(
        "studyFields",
        studyFields
    );


    setText(
        "minimumAverage",
        minimumAverage !== null &&
            minimumAverage !== undefined
            ? `${minimumAverage}%`
            : "Not specified"
    );


    setText(
        "householdIncome",
        householdIncome !== null &&
            householdIncome !== undefined
            ? formatCurrency(
                householdIncome
            )
            : "Not specified"
    );


    setText(
        "yearOfStudy",
        formatYearRange(
            minimumYear,
            maximumYear
        )
    );


    setText(
        "citizenship",
        citizenship
    );


    /* PROVIDER */

    const providerObject =
        bursary.provider ??
        bursary.Provider;

    if (
        providerObject &&
        typeof providerObject === "object"
    ) {

        setText(
            "providerCardName",
            providerObject.providerName ??
            providerObject.ProviderName ??
            provider
        );

        setText(
            "providerType",
            providerObject.providerType ??
            providerObject.ProviderType ??
            "Provider"
        );


        if (
            providerObject.isOfficial ??
            providerObject.IsOfficial
        ) {

            document
                .getElementById(
                    "officialProvider"
                )
                .classList.remove(
                    "hidden"
                );

        }


        const email =
            providerObject.contactEmail ??
            providerObject.ContactEmail;

        const phone =
            providerObject.contactPhone ??
            providerObject.ContactPhone;

        let contact = "";

        if (email) {
            contact += email;
        }

        if (phone) {

            if (contact) {
                contact += "<br>";
            }

            contact += phone;

        }

        document
            .getElementById(
                "providerContact"
            )
            .innerHTML = contact;

    }
    else {

        setText(
            "providerType",
            "Bursary provider"
        );

    }


    /* FUNDING */

    renderFunding(
        bursary
    );


    /* APPLICATION */

    const applyButton =
        document.getElementById(
            "applyButton"
        );

    if (applicationUrl) {

        applyButton.href =
            applicationUrl;

    }
    else {

        applyButton.href =
            `/Application/Create?bursaryId=${bursaryId}`;

        applyButton.removeAttribute(
            "target"
        );

        applyButton.removeAttribute(
            "rel"
        );

    }


    /* WEBSITE */

    if (website) {

        const websiteButton =
            document.getElementById(
                "websiteButton"
            );

        websiteButton.href =
            website;

        websiteButton.classList.remove(
            "hidden"
        );

    }


    /* SHOW PAGE */

    document
        .getElementById(
            "detailsLoading"
        )
        .classList.add(
            "hidden"
        );

    document
        .getElementById(
            "bursaryDetails"
        )
        .classList.remove(
            "hidden"
        );

}


/* ================================
   FUNDING
================================ */

function renderFunding(bursary) {

    const fundingList =
        document.getElementById(
            "fundingList"
        );

    const funding = [];


    if (
        bursary.tuitionIncluded ??
        bursary.TuitionIncluded
    ) {

        funding.push(
            "Tuition fees"
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
        bursary.accommodationAllowanceIncluded ??
        bursary.AccommodationAllowanceIncluded
    ) {

        funding.push(
            "Accommodation allowance"
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


    if (
        bursary.transportAllowanceIncluded ??
        bursary.TransportAllowanceIncluded
    ) {

        funding.push(
            "Transport allowance"
        );

    }


    if (!funding.length) {

        funding.push(
            "Financial support"
        );

    }


    fundingList.innerHTML =
        funding
            .map(item => `

                <div class="funding-item">

                    <span>✓</span>

                    ${escapeHtml(item)}

                </div>

            `)
            .join("");

}


/* ================================
   PROVIDER
================================ */

function getProviderName(bursary) {

    const provider =
        bursary.provider ??
        bursary.Provider;

    if (
        typeof provider === "string"
    ) {

        return provider;

    }

    if (
        provider &&
        typeof provider === "object"
    ) {

        return (
            provider.providerName ??
            provider.ProviderName ??
            "Bursary Provider"
        );

    }

    return "Bursary Provider";

}


/* ================================
   YEAR RANGE
================================ */

function formatYearRange(
    minimum,
    maximum
) {

    if (
        minimum === null ||
        minimum === undefined
    ) {

        if (
            maximum === null ||
            maximum === undefined
        ) {

            return "All years";

        }

        return `Up to year ${maximum}`;

    }


    if (
        maximum === null ||
        maximum === undefined
    ) {

        return `Year ${minimum} and above`;

    }


    if (minimum === maximum) {

        return `Year ${minimum}`;

    }


    return `Years ${minimum} - ${maximum}`;

}


/* ================================
   CURRENCY
================================ */

function formatCurrency(value) {

    return new Intl.NumberFormat(
        "en-ZA",
        {
            style: "currency",
            currency: "ZAR",
            maximumFractionDigits: 0
        }
    ).format(value);

}


/* ================================
   LOADING
================================ */

function showLoading() {

    document
        .getElementById(
            "detailsLoading"
        )
        .classList.remove(
            "hidden"
        );

    document
        .getElementById(
            "bursaryDetails"
        )
        .classList.add(
            "hidden"
        );

    document
        .getElementById(
            "detailsError"
        )
        .classList.add(
            "hidden"
        );

}


/* ================================
   ERROR
================================ */

function showError() {

    document
        .getElementById(
            "detailsLoading"
        )
        .classList.add(
            "hidden"
        );

    document
        .getElementById(
            "bursaryDetails"
        )
        .classList.add(
            "hidden"
        );

    document
        .getElementById(
            "detailsError"
        )
        .classList.remove(
            "hidden"
        );

}


/* ================================
   MOBILE
================================ */

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


/* ================================
   HELPERS
================================ */

function setText(
    id,
    value
) {

    const element =
        document.getElementById(id);

    if (element) {

        element.textContent =
            value ?? "";

    }

}


function getInitials(value) {

    if (!value) {
        return "BF";
    }

    return String(value)
        .split(" ")
        .slice(0, 2)
        .map(
            word =>
                word.charAt(0)
        )
        .join("")
        .toUpperCase();

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