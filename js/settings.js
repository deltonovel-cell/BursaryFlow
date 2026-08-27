/* =========================================================
   BURSARYFLOW — SETTINGS JAVASCRIPT
   ========================================================= */

document.addEventListener("DOMContentLoaded", function () {

    /* =====================================================
       LUCIDE ICONS
       ===================================================== */

    function refreshIcons() {

        if (typeof lucide !== "undefined") {
            lucide.createIcons();
        }

    }

    refreshIcons();


    /* =====================================================
       SETTINGS SECTION NAVIGATION
       ===================================================== */

    const navItems =
        document.querySelectorAll(".settings-nav-item");

    const panels =
        document.querySelectorAll(".settings-panel");


    function showSection(sectionName) {

        if (!sectionName) {
            return;
        }

        navItems.forEach(function (item) {

            const isActive =
                item.dataset.section === sectionName;

            item.classList.toggle(
                "active",
                isActive
            );

        });


        panels.forEach(function (panel) {

            const isActive =
                panel.dataset.panel === sectionName;

            panel.classList.toggle(
                "active",
                isActive
            );

        });


        /*
         * Keep the selected section in the URL
         * without forcing a page reload.
         */

        try {

            const url =
                new URL(window.location.href);

            url.searchParams.set(
                "section",
                sectionName
            );

            window.history.replaceState(
                {},
                "",
                url
            );

        } catch (error) {

            console.warn(
                "Unable to update settings URL.",
                error
            );

        }


        /*
         * Refresh icons because some sections
         * may have been hidden before.
         */

        refreshIcons();

    }


    navItems.forEach(function (item) {

        item.addEventListener(
            "click",
            function () {

                const section =
                    this.dataset.section;

                showSection(section);

            }
        );

    });


    /*
     * Open the section specified in the URL.
     *
     * Example:
     * /Settings?section=security
     */

    try {

        const params =
            new URLSearchParams(
                window.location.search
            );

        const requestedSection =
            params.get("section");

        if (
            requestedSection &&
            document.querySelector(
                '.settings-panel[data-panel="' +
                requestedSection +
                '"]'
            )
        ) {

            showSection(
                requestedSection
            );

        }

    } catch (error) {

        console.warn(
            "Unable to read settings section.",
            error
        );

    }


    /* =====================================================
       PASSWORD VISIBILITY
       ===================================================== */

    const passwordToggles =
        document.querySelectorAll(
            ".password-toggle"
        );


    passwordToggles.forEach(function (button) {

        button.addEventListener(
            "click",
            function () {

                const targetId =
                    this.dataset.target;

                if (!targetId) {
                    return;
                }

                const input =
                    document.getElementById(
                        targetId
                    );

                if (!input) {
                    return;
                }


                const icon =
                    this.querySelector("svg");


                if (input.type === "password") {

                    input.type = "text";

                    this.setAttribute(
                        "aria-label",
                        "Hide password"
                    );

                    this.setAttribute(
                        "title",
                        "Hide password"
                    );

                    this.innerHTML =
                        '<i data-lucide="eye-off"></i>';

                } else {

                    input.type = "password";

                    this.setAttribute(
                        "aria-label",
                        "Show password"
                    );

                    this.setAttribute(
                        "title",
                        "Show password"
                    );

                    this.innerHTML =
                        '<i data-lucide="eye"></i>';

                }

                refreshIcons();

            }
        );

    });


    /* =====================================================
       PASSWORD VALIDATION
       ===================================================== */

    const newPassword =
        document.getElementById(
            "newPassword"
        );

    const confirmPassword =
        document.getElementById(
            "confirmPassword"
        );


    function updatePasswordRequirements() {

        if (!newPassword) {
            return;
        }

        const value =
            newPassword.value;


        const requirementItems =
            document.querySelectorAll(
                ".password-requirements span"
            );


        if (requirementItems.length < 3) {
            return;
        }


        const lengthValid =
            value.length >= 8;

        const strongValid =
            /[A-Z]/.test(value) &&
            /[a-z]/.test(value) &&
            /[0-9]/.test(value);


        const confirmationValid =
            confirmPassword &&
            value.length > 0 &&
            value === confirmPassword.value;


        updateRequirement(
            requirementItems[0],
            lengthValid
        );

        updateRequirement(
            requirementItems[1],
            strongValid
        );

        updateRequirement(
            requirementItems[2],
            confirmationValid
        );

    }


    function updateRequirement(
        element,
        valid
    ) {

        if (!element) {
            return;
        }


        element.classList.toggle(
            "valid",
            valid
        );


        const icon =
            element.querySelector(
                "svg"
            );


        if (valid) {

            element.style.color =
                "#4f8660";

            if (icon) {
                icon.style.color =
                    "#4f8660";
            }

        } else {

            element.style.color =
                "";

            if (icon) {
                icon.style.color =
                    "";
            }

        }

    }


    if (newPassword) {

        newPassword.addEventListener(
            "input",
            updatePasswordRequirements
        );

    }


    if (confirmPassword) {

        confirmPassword.addEventListener(
            "input",
            updatePasswordRequirements
        );

    }


    /* =====================================================
       DELETE ACCOUNT MODAL
       ===================================================== */

    const deleteModal =
        document.getElementById(
            "deleteModal"
        );

    const openDeleteModal =
        document.getElementById(
            "openDeleteModal"
        );

    const closeDeleteModal =
        document.getElementById(
            "closeDeleteModal"
        );

    const cancelDelete =
        document.getElementById(
            "cancelDelete"
        );

    const deleteModalBackdrop =
        document.getElementById(
            "deleteModalBackdrop"
        );

    const deleteConfirmation =
        document.getElementById(
            "deleteConfirmation"
        );


    function openDeleteAccountModal() {

        if (!deleteModal) {
            return;
        }

        deleteModal.classList.add(
            "open"
        );

        document.body.classList.add(
            "modal-open"
        );


        if (deleteConfirmation) {

            deleteConfirmation.value =
                "";

            setTimeout(
                function () {

                    deleteConfirmation.focus();

                },
                100
            );

        }


        refreshIcons();

    }


    function closeDeleteAccountModal() {

        if (!deleteModal) {
            return;
        }

        deleteModal.classList.remove(
            "open"
        );

        document.body.classList.remove(
            "modal-open"
        );

    }


    if (openDeleteModal) {

        openDeleteModal.addEventListener(
            "click",
            openDeleteAccountModal
        );

    }


    if (closeDeleteModal) {

        closeDeleteModal.addEventListener(
            "click",
            closeDeleteAccountModal
        );

    }


    if (cancelDelete) {

        cancelDelete.addEventListener(
            "click",
            closeDeleteAccountModal
        );

    }


    if (deleteModalBackdrop) {

        deleteModalBackdrop.addEventListener(
            "click",
            closeDeleteAccountModal
        );

    }


    /* =====================================================
       DELETE CONFIRMATION
       ===================================================== */

    const deleteForm =
        deleteModal
            ? deleteModal.querySelector("form")
            : null;


    if (deleteForm) {

        deleteForm.addEventListener(
            "submit",
            function (event) {

                const confirmation =
                    deleteConfirmation
                        ? deleteConfirmation.value
                            .trim()
                            .toUpperCase()
                        : "";


                if (confirmation !== "DELETE") {

                    event.preventDefault();


                    if (deleteConfirmation) {

                        deleteConfirmation.classList.add(
                            "invalid"
                        );

                        deleteConfirmation.focus();

                    }


                    showSettingsMessage(
                        "Please type DELETE exactly to confirm account deletion.",
                        "error"
                    );

                    return;

                }


                const confirmed =
                    window.confirm(
                        "Are you absolutely sure you want to delete your BursaryFlow account? This action cannot be undone."
                    );


                if (!confirmed) {

                    event.preventDefault();

                    return;

                }

            }
        );

    }


    if (deleteConfirmation) {

        deleteConfirmation.addEventListener(
            "input",
            function () {

                this.classList.remove(
                    "invalid"
                );

            }
        );

    }


    /* =====================================================
       GLOBAL SETTINGS MESSAGE
       ===================================================== */

    function showSettingsMessage(
        message,
        type
    ) {

        const existing =
            document.querySelector(
                ".settings-js-alert"
            );


        if (existing) {
            existing.remove();
        }


        const alert =
            document.createElement(
                "div"
            );


        alert.className =
            "settings-alert " +
            (type || "success") +
            " settings-js-alert";


        const icon =
            type === "error"
                ? "circle-alert"
                : "check-circle-2";


        alert.innerHTML =
            '<i data-lucide="' +
            icon +
            '"></i>' +
            '<span>' +
            escapeHtml(message) +
            '</span>';


        const content =
            document.querySelector(
                ".settings-content"
            );


        const hero =
            document.querySelector(
                ".settings-hero"
            );


        if (content && hero) {

            hero.insertAdjacentElement(
                "afterend",
                alert
            );

        }


        refreshIcons();


        setTimeout(
            function () {

                if (alert) {

                    alert.style.opacity =
                        "0";

                    alert.style.transform =
                        "translateY(-5px)";

                    alert.style.transition =
                        "opacity .25s ease, transform .25s ease";

                    setTimeout(
                        function () {

                            if (alert) {
                                alert.remove();
                            }

                        },
                        250
                    );

                }

            },
            4500
        );

    }


    function escapeHtml(value) {

        const div =
            document.createElement(
                "div"
            );

        div.textContent =
            value;

        return div.innerHTML;

    }


    /* =====================================================
       AUTO DISMISS SERVER ALERTS
       ===================================================== */

    const serverAlerts =
        document.querySelectorAll(
            ".settings-alert"
        );


    serverAlerts.forEach(function (alert) {

        setTimeout(
            function () {

                if (!alert) {
                    return;
                }

                alert.style.opacity =
                    "0";

                alert.style.transform =
                    "translateY(-5px)";

                alert.style.transition =
                    "opacity .3s ease, transform .3s ease";


                setTimeout(
                    function () {

                        if (alert) {
                            alert.remove();
                        }

                    },
                    300
                );

            },
            5000
        );

    });


    /* =====================================================
       MOBILE SIDEBAR
       ===================================================== */

    const mobileMenu =
        document.getElementById(
            "mobileMenu"
        );

    const sidebar =
        document.getElementById(
            "sidebar"
        );


    if (mobileMenu && sidebar) {

        mobileMenu.addEventListener(
            "click",
            function () {

                sidebar.classList.toggle(
                    "mobile-open"
                );

            }
        );


        document.addEventListener(
            "click",
            function (event) {

                const clickedInsideSidebar =
                    sidebar.contains(
                        event.target
                    );

                const clickedMenu =
                    mobileMenu.contains(
                        event.target
                    );


                if (
                    !clickedInsideSidebar &&
                    !clickedMenu &&
                    sidebar.classList.contains(
                        "mobile-open"
                    )
                ) {

                    sidebar.classList.remove(
                        "mobile-open"
                    );

                }

            }
        );

    }


    /* =====================================================
       GLOBAL SEARCH SHORTCUT
       ===================================================== */

    const globalSearch =
        document.getElementById(
            "globalSearch"
        );


    document.addEventListener(
        "keydown",
        function (event) {

            /*
             * "/" focuses search unless the user
             * is already typing in an input.
             */

            if (
                event.key === "/" &&
                document.activeElement.tagName !== "INPUT" &&
                document.activeElement.tagName !== "TEXTAREA" &&
                document.activeElement.tagName !== "SELECT"
            ) {

                event.preventDefault();

                if (globalSearch) {

                    globalSearch.focus();

                }

            }


            /*
             * Escape closes modal/sidebar.
             */

            if (
                event.key === "Escape" ||
                event.key === "Esc"
            ) {

                if (
                    deleteModal &&
                    deleteModal.classList.contains(
                        "open"
                    )
                ) {

                    closeDeleteAccountModal();

                }


                if (
                    sidebar &&
                    sidebar.classList.contains(
                        "mobile-open"
                    )
                ) {

                    sidebar.classList.remove(
                        "mobile-open"
                    );

                }

            }

        }
    );


    /* =====================================================
       HEADER USER BUTTON
       ===================================================== */

    const headerUser =
        document.querySelector(
            ".header-user"
        );


    if (headerUser) {

        headerUser.addEventListener(
            "click",
            function () {

                /*
                 * The dashboard may later have a user
                 * dropdown. For now, take the user to
                 * their profile.
                 */

                window.location.href =
                    "/Profile";

            }
        );

    }


    /* =====================================================
       PROFILE MENU
       ===================================================== */

    const profileMenu =
        document.querySelector(
            ".profile-menu"
        );


    if (profileMenu) {

        profileMenu.addEventListener(
            "click",
            function () {

                window.location.href =
                    "/Profile";

            }
        );

    }


    /* =====================================================
       SETTINGS FORM VISUAL FEEDBACK
       ===================================================== */

    const settingsForms =
        document.querySelectorAll(
            ".settings-form, .settings-preference-form"
        );


    settingsForms.forEach(function (form) {

        form.addEventListener(
            "submit",
            function () {

                const submitButton =
                    this.querySelector(
                        'button[type="submit"]'
                    );


                if (!submitButton) {
                    return;
                }


                /*
                 * Do not permanently disable the button.
                 * The server may reload the page after saving.
                 */

                const originalHTML =
                    submitButton.innerHTML;


                submitButton.dataset.originalHtml =
                    originalHTML;


                submitButton.innerHTML =
                    '<i data-lucide="loader-circle" class="settings-submit-loader"></i>' +
                    '<span>Saving...</span>';


                submitButton.classList.add(
                    "saving"
                );


                refreshIcons();

            }
        );

    });


    /* =====================================================
       TOGGLE VISUAL FEEDBACK
       ===================================================== */

    const toggles =
        document.querySelectorAll(
            ".toggle input"
        );


    toggles.forEach(function (toggle) {

        toggle.addEventListener(
            "change",
            function () {

                const parent =
                    this.closest(
                        ".preference-item"
                    );


                if (!parent) {
                    return;
                }


                parent.classList.toggle(
                    "preference-enabled",
                    this.checked
                );

            }
        );


        /*
         * Set initial state.
         */

        const parent =
            toggle.closest(
                ".preference-item"
            );


        if (parent) {

            parent.classList.toggle(
                "preference-enabled",
                toggle.checked
            );

        }

    });


    /* =====================================================
       PASSWORD MATCH FEEDBACK
       ===================================================== */

    if (
        newPassword &&
        confirmPassword
    ) {

        confirmPassword.addEventListener(
            "input",
            function () {

                if (!this.value) {

                    this.style.borderColor =
                        "";

                    return;

                }


                if (
                    this.value ===
                    newPassword.value
                ) {

                    this.style.borderColor =
                        "#78a184";

                } else {

                    this.style.borderColor =
                        "#d88984";

                }

            }
        );

    }


    /* =====================================================
       PREVENT ENTER FROM ACCIDENTALLY
       SUBMITTING DELETE MODAL
       ===================================================== */

    if (deleteConfirmation) {

        deleteConfirmation.addEventListener(
            "keydown",
            function (event) {

                if (event.key === "Enter") {

                    event.preventDefault();

                }

            }
        );

    }


    /* =====================================================
       INITIALISE
       ===================================================== */

    updatePasswordRequirements();

    refreshIcons();

});