(function () {
    "use strict";

    document.addEventListener("DOMContentLoaded", function () {

        const paper = document.getElementById("documentPaper");
        const wordCount = document.getElementById("wordCount");
        const titleInput = document.getElementById("documentTitle");
        const editorTitle = document.getElementById("editorTitle");
        const status = document.getElementById("documentStatus");

        const generateButton =
            document.getElementById("generateDocument");

        const saveButton =
            document.getElementById("saveDocument");

        const downloadButton =
            document.getElementById("downloadDocument");

        const improveButton =
            document.getElementById("improveDocument");

        const mobileMenu =
            document.getElementById("mobileMenu");

        const sidebar =
            document.getElementById("sidebar");


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
           MOBILE SIDEBAR
           ===================================================== */

        if (mobileMenu && sidebar) {

            mobileMenu.addEventListener("click", function () {

                sidebar.classList.toggle("open");

            });

        }


        /* =====================================================
           WORD COUNT
           ===================================================== */

        function updateWordCount() {

            if (!paper || !wordCount) {
                return;
            }

            const text = paper.innerText
                .trim()
                .replace(/\s+/g, " ");

            if (!text) {

                wordCount.textContent = "0 words";

                return;
            }

            const words = text
                .split(" ")
                .filter(function (word) {
                    return word.length > 0;
                })
                .length;

            wordCount.textContent =
                words === 1
                    ? "1 word"
                    : words + " words";
        }


        if (paper) {

            paper.addEventListener(
                "input",
                updateWordCount
            );

        }


        /* =====================================================
           DOCUMENT TITLE
           ===================================================== */

        if (titleInput && editorTitle) {

            titleInput.addEventListener(
                "input",
                function () {

                    const title =
                        this.value.trim();

                    editorTitle.textContent =
                        title || "Untitled document";

                }
            );

        }


        /* =====================================================
           DOCUMENT TYPE
           ===================================================== */

        const documentTypes =
            document.querySelectorAll(".document-type");

        documentTypes.forEach(function (button) {

            button.addEventListener(
                "click",
                function () {

                    documentTypes.forEach(
                        function (item) {

                            item.classList.remove(
                                "active"
                            );

                        }
                    );

                    this.classList.add("active");

                    const type =
                        this.dataset.type;

                    const titles = {

                        motivation:
                            "Bursary Motivation Letter",

                        personal:
                            "Personal Statement",

                        email:
                            "Bursary Application Email",

                        response:
                            "Bursary Application Response",

                        custom:
                            "My Bursary Document"

                    };

                    const newTitle =
                        titles[type] ||
                        "My Bursary Document";


                    if (titleInput) {

                        titleInput.value =
                            newTitle;

                    }


                    if (editorTitle) {

                        editorTitle.textContent =
                            newTitle;

                    }


                    const typeLabel =
                        document.querySelector(
                            ".paper-document-type"
                        );

                    if (typeLabel) {

                        const labels = {

                            motivation:
                                "MOTIVATION LETTER",

                            personal:
                                "PERSONAL STATEMENT",

                            email:
                                "APPLICATION EMAIL",

                            response:
                                "APPLICATION RESPONSE",

                            custom:
                                "CUSTOM DOCUMENT"

                        };

                        typeLabel.textContent =
                            labels[type] ||
                            "DOCUMENT";

                    }

                }
            );

        });


        /* =====================================================
           TEXT EDITOR TOOLBAR
           ===================================================== */

        const toolbarButtons =
            document.querySelectorAll(
                "[data-command]"
            );

        toolbarButtons.forEach(function (button) {

            button.addEventListener(
                "click",
                function () {

                    const command =
                        this.dataset.command;

                    if (!paper) {
                        return;
                    }

                    paper.focus();

                    try {

                        document.execCommand(
                            command,
                            false,
                            null
                        );

                    } catch (error) {

                        console.error(
                            "Editor command failed:",
                            error
                        );

                    }

                    updateWordCount();

                }
            );

        });


        /* =====================================================
           UNDO
           ===================================================== */

        const undoButton =
            document.getElementById(
                "undoButton"
            );

        if (undoButton) {

            undoButton.addEventListener(
                "click",
                function () {

                    if (!paper) {
                        return;
                    }

                    paper.focus();

                    document.execCommand(
                        "undo",
                        false,
                        null
                    );

                    updateWordCount();

                }
            );

        }


        /* =====================================================
           REDO
           ===================================================== */

        const redoButton =
            document.getElementById(
                "redoButton"
            );

        if (redoButton) {

            redoButton.addEventListener(
                "click",
                function () {

                    if (!paper) {
                        return;
                    }

                    paper.focus();

                    document.execCommand(
                        "redo",
                        false,
                        null
                    );

                    updateWordCount();

                }
            );

        }


        /* =====================================================
           SAVE DOCUMENT
           ===================================================== */

        if (saveButton) {

            saveButton.addEventListener(
                "click",
                function () {

                    const title =
                        titleInput
                            ? titleInput.value.trim()
                            : "Untitled document";

                    const content =
                        paper
                            ? paper.innerHTML
                            : "";


                    const documentData = {

                        title: title,

                        content: content,

                        savedAt:
                            new Date().toISOString()

                    };


                    /*
                     * Temporary browser storage.
                     *
                     * Later this will be replaced with
                     * your ASP.NET controller/database.
                     */

                    localStorage.setItem(
                        "bursaryflow_document",
                        JSON.stringify(
                            documentData
                        )
                    );


                    if (status) {

                        status.textContent =
                            "Saved just now";

                    }


                    saveButton.classList.add(
                        "saved"
                    );


                    setTimeout(
                        function () {

                            saveButton.classList.remove(
                                "saved"
                            );

                        },
                        1500
                    );

                }
            );

        }


        /* =====================================================
           LOAD SAVED DOCUMENT
           ===================================================== */

        function loadSavedDocument() {

            if (!paper) {
                return;
            }

            const saved =
                localStorage.getItem(
                    "bursaryflow_document"
                );

            if (!saved) {
                return;
            }

            try {

                const documentData =
                    JSON.parse(saved);


                if (
                    documentData.content &&
                    documentData.content.trim() !== ""
                ) {

                    paper.innerHTML =
                        documentData.content;

                }


                if (
                    documentData.title &&
                    titleInput
                ) {

                    titleInput.value =
                        documentData.title;

                }


                if (
                    documentData.title &&
                    editorTitle
                ) {

                    editorTitle.textContent =
                        documentData.title;

                }


                if (status) {

                    status.textContent =
                        "Saved draft";

                }

            } catch (error) {

                console.error(
                    "Could not load saved document:",
                    error
                );

            }

        }


        loadSavedDocument();


        /* =====================================================
           GENERATE WITH DELTON
           ===================================================== */

        if (generateButton) {

            generateButton.addEventListener(
                "click",
                function () {

                    if (
                        generateButton.classList.contains(
                            "generating"
                        )
                    ) {

                        return;

                    }


                    const originalHTML =
                        generateButton.innerHTML;


                    generateButton.classList.add(
                        "generating"
                    );

                    generateButton.disabled =
                        true;


                    generateButton.innerHTML =

                        '<span class="generate-icon">' +
                        '<i data-lucide="loader-circle"></i>' +
                        '</span>' +

                        '<span>' +

                        '<strong>' +
                        'Delton is writing...' +
                        '</strong>' +

                        '<small>' +
                        'Creating your document' +
                        '</small>' +

                        '</span>';


                    refreshIcons();


                    /*
                     * Temporary AI simulation.
                     *
                     * Later this section will call
                     * your ASP.NET controller/API.
                     */

                    setTimeout(
                        function () {

                            generateDocument();

                            generateButton.innerHTML =
                                originalHTML;

                            generateButton.classList.remove(
                                "generating"
                            );

                            generateButton.disabled =
                                false;


                            if (status) {

                                status.textContent =
                                    "Generated by Delton";

                            }


                            refreshIcons();

                        },
                        1800
                    );

                }
            );

        }


        /* =====================================================
           GENERATE DOCUMENT CONTENT
           ===================================================== */

        function generateDocument() {

            if (!paper) {
                return;
            }


            const typeElement =
                document.querySelector(
                    ".document-type.active"
                );

            const type =
                typeElement
                    ? typeElement.dataset.type
                    : "motivation";


            const bursaryNameElement =
                document.getElementById(
                    "bursaryName"
                );

            const instructionsElement =
                document.getElementById(
                    "documentInstructions"
                );


            const bursaryName =
                bursaryNameElement
                    ? bursaryNameElement.value.trim()
                    : "";


            const instructions =
                instructionsElement
                    ? instructionsElement.value.trim()
                    : "";


            const today =
                new Date().toLocaleDateString(
                    "en-ZA",
                    {
                        day: "numeric",
                        month: "long",
                        year: "numeric"
                    }
                );


            let heading =
                "Bursary Motivation Letter";

            let documentType =
                "MOTIVATION LETTER";


            if (type === "personal") {

                heading =
                    "Personal Statement";

                documentType =
                    "PERSONAL STATEMENT";

            }


            if (type === "email") {

                heading =
                    "Bursary Application Email";

                documentType =
                    "APPLICATION EMAIL";

            }


            if (type === "response") {

                heading =
                    "Bursary Application Response";

                documentType =
                    "APPLICATION RESPONSE";

            }


            if (type === "custom") {

                heading =
                    titleInput && titleInput.value.trim()
                        ? titleInput.value.trim()
                        : "My Bursary Document";

                documentType =
                    "CUSTOM DOCUMENT";

            }


            const organisationText =
                bursaryName
                    ? " to " + bursaryName
                    : "";


            let content = "";


            if (type === "motivation") {

                content =

                    "<h1>" +
                    heading +
                    "</h1>" +

                    "<p class=\"paper-date\">" +
                    today +
                    "</p>" +

                    "<p>" +
                    "Dear Bursary Selection Committee," +
                    "</p>" +

                    "<p>" +
                    "My name is Delton Novela, and I am " +
                    "currently pursuing a Bachelor of Science " +
                    "in Computer Science and Informatics at " +
                    "the University of Johannesburg. I am " +
                    "writing to express my sincere interest " +
                    "in receiving financial assistance" +
                    organisationText +
                    " to support my studies and continue " +
                    "working towards my academic and " +
                    "professional goals." +
                    "</p>" +

                    "<p>" +
                    "My passion for technology and computer " +
                    "science has motivated me to build a " +
                    "future in the technology industry. " +
                    "I am committed to developing my skills " +
                    "and using my education to make a " +
                    "meaningful contribution to society." +
                    "</p>" +

                    "<p>" +
                    "Receiving this bursary would reduce " +
                    "the financial pressure associated " +
                    "with my studies and allow me to focus " +
                    "more fully on my academic responsibilities." +
                    "</p>" +

                    (
                        instructions
                            ? "<p>" +
                            instructions +
                            "</p>"
                            : ""
                    ) +

                    "<p>" +
                    "I would be grateful for the opportunity " +
                    "to receive your support and demonstrate " +
                    "my commitment, determination and potential." +
                    "</p>" +

                    "<p>" +
                    "Yours sincerely," +
                    "</p>" +

                    "<p class=\"paper-signature\">" +

                    "<strong>" +
                    "Delton Novela" +
                    "</strong>" +

                    "<br />" +

                    "BSc Computer Science and Informatics" +

                    "<br />" +

                    "University of Johannesburg" +

                    "</p>";

            } else {

                content =

                    "<h1>" +
                    heading +
                    "</h1>" +

                    "<p class=\"paper-date\">" +
                    today +
                    "</p>" +

                    "<p>" +
                    "This document has been prepared with " +
                    "assistance from Delton AI." +
                    "</p>" +

                    "<p>" +
                    "My name is Delton Novela, and I am " +
                    "currently studying Computer Science " +
                    "and Informatics at the University of Johannesburg." +
                    "</p>" +

                    (
                        instructions
                            ? "<p>" +
                            instructions +
                            "</p>"
                            : ""
                    ) +

                    "<p>" +
                    "I am committed to my academic development " +
                    "and to building a meaningful career in technology." +
                    "</p>" +

                    "<p>" +
                    "Yours sincerely," +
                    "</p>" +

                    "<p class=\"paper-signature\">" +

                    "<strong>" +
                    "Delton Novela" +
                    "</strong>" +

                    "<br />" +

                    "BSc Computer Science and Informatics" +

                    "<br />" +

                    "University of Johannesburg" +

                    "</p>";

            }


            paper.innerHTML =

                '<div class="document-paper-header">' +

                '<div class="paper-brand">' +

                '<span class="paper-brand-mark">' +
                '<span></span>' +
                '<span></span>' +
                '<span></span>' +
                '</span>' +

                '<span>' +
                'Bursary<span>Flow</span>' +
                '</span>' +

                '</div>' +

                '<span class="paper-document-type">' +
                documentType +
                '</span>' +

                '</div>' +

                '<div class="paper-content" id="paperContent">' +
                content +
                '</div>';


            updateWordCount();

        }


        /* =====================================================
           IMPROVE DOCUMENT
           ===================================================== */

        if (improveButton) {

            improveButton.addEventListener(
                "click",
                function () {

                    if (!paper) {
                        return;
                    }


                    const paperContent =
                        paper.querySelector(
                            ".paper-content"
                        );


                    if (!paperContent) {
                        return;
                    }


                    const paragraph =
                        document.createElement(
                            "p"
                        );


                    paragraph.innerHTML =

                        "<strong>Delton's suggestion:</strong> " +

                        "Consider adding a specific example " +
                        "of an academic achievement, personal " +
                        "challenge, leadership experience or " +
                        "career goal. Specific details will make " +
                        "your document more personal and memorable.";


                    paperContent.appendChild(
                        paragraph
                    );


                    updateWordCount();


                    if (status) {

                        status.textContent =
                            "Document improved";

                    }

                }
            );

        }


        /* =====================================================
           DOWNLOAD DOCUMENT
           ===================================================== */

        if (downloadButton) {

            downloadButton.addEventListener(
                "click",
                function () {

                    if (!paper) {
                        return;
                    }


                    const title =
                        titleInput &&
                            titleInput.value.trim()
                            ? titleInput.value.trim()
                            : "BursaryFlow Document";


                    const printableContent =
                        paper.innerHTML;


                    const printWindow =
                        window.open(
                            "",
                            "_blank"
                        );


                    if (!printWindow) {

                        alert(
                            "Please allow pop-ups to download your document."
                        );

                        return;

                    }


                    printWindow.document.write(

                        "<!DOCTYPE html>" +

                        "<html>" +

                        "<head>" +

                        "<title>" +
                        title +
                        "</title>" +

                        "<style>" +

                        "body{" +
                        "font-family:Arial,sans-serif;" +
                        "max-width:800px;" +
                        "margin:50px auto;" +
                        "padding:40px;" +
                        "color:#333;" +
                        "line-height:1.7;" +
                        "}" +

                        "h1{" +
                        "font-family:Georgia,serif;" +
                        "margin-bottom:10px;" +
                        "}" +

                        ".paper-date{" +
                        "color:#777;" +
                        "font-size:13px;" +
                        "}" +

                        ".paper-signature{" +
                        "margin-top:30px;" +
                        "}" +

                        ".document-paper-header{" +
                        "display:flex;" +
                        "justify-content:space-between;" +
                        "border-bottom:1px solid #ddd;" +
                        "padding-bottom:20px;" +
                        "margin-bottom:40px;" +
                        "}" +

                        "</style>" +

                        "</head>" +

                        "<body>" +

                        printableContent +

                        "</body>" +

                        "</html>"

                    );


                    printWindow.document.close();


                    setTimeout(
                        function () {

                            printWindow.focus();

                            printWindow.print();

                        },
                        500
                    );


                    if (status) {

                        status.textContent =
                            "Document ready to download";

                    }

                }
            );

        }


        /* =====================================================
           KEYBOARD SHORTCUTS
           ===================================================== */

        if (paper) {

            paper.addEventListener(
                "keydown",
                function (event) {

                    /*
                     * Ctrl + S
                     */

                    if (
                        event.ctrlKey &&
                        event.key.toLowerCase() === "s"
                    ) {

                        event.preventDefault();

                        if (saveButton) {
                            saveButton.click();
                        }

                    }


                    /*
                     * Ctrl + B
                     */

                    if (
                        event.ctrlKey &&
                        event.key.toLowerCase() === "b"
                    ) {

                        event.preventDefault();

                        document.execCommand(
                            "bold",
                            false,
                            null
                        );

                    }


                    /*
                     * Ctrl + I
                     */

                    if (
                        event.ctrlKey &&
                        event.key.toLowerCase() === "i"
                    ) {

                        event.preventDefault();

                        document.execCommand(
                            "italic",
                            false,
                            null
                        );

                    }


                    /*
                     * Ctrl + U
                     */

                    if (
                        event.ctrlKey &&
                        event.key.toLowerCase() === "u"
                    ) {

                        event.preventDefault();

                        document.execCommand(
                            "underline",
                            false,
                            null
                        );

                    }

                }
            );

        }


        /* =====================================================
           INITIAL WORD COUNT
           ===================================================== */

        updateWordCount();


        /* =====================================================
           CLOSE SIDEBAR WHEN CLICKING MAIN CONTENT
           ===================================================== */

        const dashboardMain =
            document.querySelector(
                ".dashboard-main"
            );


        if (dashboardMain && sidebar) {

            dashboardMain.addEventListener(
                "click",
                function () {

                    if (
                        window.innerWidth <= 950 &&
                        sidebar.classList.contains("open")
                    ) {

                        sidebar.classList.remove(
                            "open"
                        );

                    }

                }
            );

        }


    });

})();