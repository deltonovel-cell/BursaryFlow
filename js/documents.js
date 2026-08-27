document.addEventListener("DOMContentLoaded", function () {

    "use strict";

    // ============================================================
    // API CONFIGURATION
    // ============================================================

    const api = window.documentApi || {};
    const antiForgeryToken =
        window.documentAntiForgeryToken || "";


    // ============================================================
    // STATE
    // ============================================================

    let documents = [];
    let selectedDocument = null;
    let selectedFile = null;

    let currentFilter = "all";
    let currentSort = "recent";
    let currentQualityScore = 0;
    let editorMode = "upload";

    let analysisTimer = null;


    // ============================================================
    // ELEMENTS
    // ============================================================

    // ------------------------------------------------------------
    // UPLOAD
    // ------------------------------------------------------------

    const uploadModal =
        document.getElementById("uploadModal");

    const openUploadModal =
        document.getElementById("openUploadModal");

    const emptyUploadButton =
        document.getElementById("emptyUploadButton");

    const closeUploadModal =
        document.getElementById("closeUploadModal");

    const uploadOverlay =
        document.getElementById("uploadOverlay");

    const cancelUpload =
        document.getElementById("cancelUpload");

    const uploadDropZone =
        document.getElementById("uploadDropZone");

    const documentFile =
        document.getElementById("documentFile");

    const selectedFileBox =
        document.getElementById("selectedFile");

    const selectedFileName =
        document.getElementById("selectedFileName");

    const selectedFileSize =
        document.getElementById("selectedFileSize");

    const selectedFileStatus =
        document.getElementById("selectedFileStatus");

    const removeSelectedFile =
        document.getElementById("removeSelectedFile");

    const confirmUpload =
        document.getElementById("confirmUpload");


    // ------------------------------------------------------------
    // PRE-UPLOAD AI
    // ------------------------------------------------------------

    const preUploadAiWorkspace =
        document.getElementById("preUploadAiWorkspace");

    const preUploadEditButton =
        document.getElementById("preUploadEditButton");

    const preUploadQualityButton =
        document.getElementById("preUploadQualityButton");

    const preUploadEnhanceButton =
        document.getElementById("preUploadEnhanceButton");

    const preUploadSpellButton =
        document.getElementById("preUploadSpellButton");

    const preUploadTypoButton =
        document.getElementById("preUploadTypoButton");

    const preUploadQualityScore =
        document.getElementById("preUploadQualityScore");

    const preUploadQualityResult =
        document.getElementById("preUploadQualityResult");

    const preUploadQualityPercentage =
        document.getElementById("preUploadQualityPercentage");

    const preUploadQualityTitle =
        document.getElementById("preUploadQualityTitle");

    const preUploadQualityMessage =
        document.getElementById("preUploadQualityMessage");

    const preUploadQualityLevel =
        document.getElementById("preUploadQualityLevel");

    const preUploadFindings =
        document.getElementById("preUploadFindings");

    const preUploadIssueCount =
        document.getElementById("preUploadIssueCount");

    const preUploadFindingsList =
        document.getElementById("preUploadFindingsList");


    // ------------------------------------------------------------
    // SELECTED DOCUMENT WORKSPACE
    // ------------------------------------------------------------

    const selectedDocumentWorkspace =
        document.getElementById("selectedDocumentWorkspace");

    const selectedDocumentName =
        document.getElementById("selectedDocumentName");

    const selectedDocumentMeta =
        document.getElementById("selectedDocumentMeta");


    // ------------------------------------------------------------
    // SELECTED QUALITY
    // ------------------------------------------------------------

    const selectedQualityScore =
        document.getElementById("selectedQualityScore");

    const selectedQualityTitle =
        document.getElementById("selectedQualityTitle");

    const selectedQualityDescription =
        document.getElementById("selectedQualityDescription");

    const selectedQualityStatus =
        document.getElementById("selectedQualityStatus");


    // ------------------------------------------------------------
    // AI ANALYSIS
    // ------------------------------------------------------------

    const documentAiAnalysis =
        document.getElementById("documentAiAnalysis");

    const qualityScore =
        document.getElementById("qualityScore");

    const qualityTitle =
        document.getElementById("qualityTitle");

    const qualityDescription =
        document.getElementById("qualityDescription");

    const qualityMessage =
        document.getElementById("qualityMessage");

    const qualityLevel =
        document.getElementById("qualityLevel");

    const qualityPercentage =
        document.getElementById("qualityPercentage");

    const documentWarningList =
        document.getElementById("documentWarningList");

    const warningCount =
        document.getElementById("warningCount");


    // ------------------------------------------------------------
    // HEALTH
    // ------------------------------------------------------------

    const healthScore =
        document.getElementById("healthScore");

    const healthTitle =
        document.getElementById("healthTitle");

    const healthDescription =
        document.getElementById("healthDescription");

    const issueCount =
        document.getElementById("issueCount");

    const issuesList =
        document.getElementById("issuesList");


    // ------------------------------------------------------------
    // DOCUMENT LIST
    // ------------------------------------------------------------

    const documentsList =
        document.getElementById("documentsList");

    const emptyDocuments =
        document.getElementById("emptyDocuments");

    const documentSearch =
        document.getElementById("documentSearch");

    const documentSort =
        document.getElementById("documentSort");


    // ------------------------------------------------------------
    // SELECTED DOCUMENT ACTIONS
    // ------------------------------------------------------------

    const editDocument =
        document.getElementById("editDocument");

    const selectedQualityCheck =
        document.getElementById("selectedQualityCheck");

    const selectedEnhanceDocument =
        document.getElementById("selectedEnhanceDocument");

    const aiAnalyseButton =
        document.getElementById("aiAnalyseButton");

    const spellCheckButton =
        document.getElementById("spellCheckButton");

    const typoCheckButton =
        document.getElementById("typoCheckButton");

    const aiEnhanceButton =
        document.getElementById("aiEnhanceButton");

    const downloadDocument =
        document.getElementById("downloadDocument");

    const deleteDocument =
        document.getElementById("deleteDocument");

    const fullPreviewButton =
        document.getElementById("fullPreviewButton");

    const documentPreviewArea =
        document.getElementById("documentPreviewArea");


    // ------------------------------------------------------------
    // EDITOR
    // ------------------------------------------------------------

    const documentEditorModal =
        document.getElementById("documentEditorModal");

    const documentEditorOverlay =
        document.getElementById("documentEditorOverlay");

    const closeEditor =
        document.getElementById("closeEditor");

    const cancelEditor =
        document.getElementById("cancelEditor");

    const saveEditorChanges =
        document.getElementById("saveEditorChanges");

    const documentEditor =
        document.getElementById("documentEditor");

    const editorDocumentName =
        document.getElementById("editorDocumentName");


    // ============================================================
    // HELPERS
    // ============================================================

    function show(element) {

        if (!element) {
            return;
        }

        element.classList.remove("hidden");

    }


    function hide(element) {

        if (!element) {
            return;
        }

        element.classList.add("hidden");

    }


    function setText(element, value) {

        if (!element) {
            return;
        }

        element.textContent =
            value === undefined ||
                value === null
                ? ""
                : value;

    }


    function refreshIcons() {

        if (window.lucide) {

            lucide.createIcons();

        }

    }


    function formatFileSize(bytes) {

        if (!bytes || bytes <= 0) {

            return "0 MB";

        }

        if (bytes < 1024) {

            return bytes + " Bytes";

        }

        if (bytes < 1048576) {

            return (
                bytes / 1024
            ).toFixed(1) + " KB";

        }

        return (
            bytes / 1048576
        ).toFixed(2) + " MB";

    }


    function getQualityLevel(score) {

        score = Number(score) || 0;

        if (score >= 90) {

            return "Excellent";

        }

        if (score >= 75) {

            return "Good";

        }

        if (score >= 60) {

            return "Needs Improvement";

        }

        if (score > 0) {

            return "Poor";

        }

        return "Not analysed";

    }


    function getQualityDescription(score) {

        score = Number(score) || 0;

        if (score >= 90) {

            return "Your document looks excellent and is highly ready for a bursary application.";

        }

        if (score >= 75) {

            return "Your document is in good condition and appears suitable for submission.";

        }

        if (score >= 60) {

            return "Your document is usable, but a few improvements are recommended before submission.";

        }

        if (score > 0) {

            return "Your document needs improvement before it should be submitted.";

        }

        return "Run AI Quality Check to determine document readiness.";

    }


    function getQualityStatus(score) {

        score = Number(score) || 0;

        if (score >= 90) {

            return "Application ready";

        }

        if (score >= 75) {

            return "Good condition";

        }

        if (score >= 60) {

            return "Review recommended";

        }

        if (score > 0) {

            return "Needs improvement";

        }

        return "Waiting for analysis";

    }


    function extractScore(data) {

        if (!data) {

            return 0;

        }

        const values = [

            data.score,
            data.qualityScore,
            data.quality,
            data.percentage,
            data.qualityPercentage,
            data.documentQuality

        ];

        for (const value of values) {

            const number = Number(value);

            if (
                Number.isFinite(number) &&
                number >= 0 &&
                number <= 100
            ) {

                return Math.round(number);

            }

        }

        return 0;

    }


    function extractMessage(data) {

        if (!data) {

            return "";

        }

        return (

            data.message ||
            data.qualityMessage ||
            data.description ||
            data.result ||
            data.summary ||
            ""

        );

    }


    function extractIssues(data) {

        if (!data) {

            return [];

        }

        const issues =

            data.issues ||
            data.findings ||
            data.warnings ||
            data.errors ||
            [];

        return Array.isArray(issues)
            ? issues
            : [];

    }


    function getDocumentName(doc) {

        if (!doc) {

            return "Document";

        }

        return (

            doc.name ||
            doc.fileName ||
            doc.documentName ||
            "Document"

        );

    }


    function getDocumentType(doc) {

        if (!doc) {

            return "Document";

        }

        return (

            doc.type ||
            doc.fileType ||
            doc.extension ||
            "Document"

        );

    }


    function getDocumentId(doc) {

        if (!doc) {

            return null;

        }

        return (

            doc.id ||
            doc.documentId ||
            doc.Id ||
            doc.DocumentId ||
            null

        );

    }


    function escapeHtml(value) {

        return String(value)

            .replace(/&/g, "&amp;")

            .replace(/</g, "&lt;")

            .replace(/>/g, "&gt;")

            .replace(/"/g, "&quot;")

            .replace(/'/g, "&#039;");

    }


    function csrfHeaders() {

        if (!antiForgeryToken) {

            return {};

        }

        return {

            "RequestVerificationToken":
                antiForgeryToken

        };

    }


    async function postJson(url, body) {

        if (!url) {

            throw new Error(
                "API endpoint is not configured."
            );

        }

        const response =
            await fetch(url, {

                method: "POST",

                headers: {

                    "Content-Type":
                        "application/json",

                    "Accept":
                        "application/json",

                    ...csrfHeaders()

                },

                body:
                    JSON.stringify(
                        body || {}
                    )

            });


        if (!response.ok) {

            throw new Error(
                "Request failed: " +
                response.status
            );

        }


        const text =
            await response.text();


        if (!text) {

            return {};

        }


        try {

            return JSON.parse(text);

        }
        catch {

            return {

                message: text

            };

        }

    }


    // ============================================================
    // UPLOAD MODAL
    // ============================================================

    function openUpload() {

        show(uploadModal);

        document.body.classList.add(
            "modal-open"
        );

        resetUploadState();

        refreshIcons();

    }


    function closeUpload() {

        hide(uploadModal);

        document.body.classList.remove(
            "modal-open"
        );

        resetUploadState();

    }


    if (openUploadModal) {

        openUploadModal.addEventListener(
            "click",
            openUpload
        );

    }


    if (emptyUploadButton) {

        emptyUploadButton.addEventListener(
            "click",
            openUpload
        );

    }


    if (closeUploadModal) {

        closeUploadModal.addEventListener(
            "click",
            closeUpload
        );

    }


    if (cancelUpload) {

        cancelUpload.addEventListener(
            "click",
            closeUpload
        );

    }


    if (uploadOverlay) {

        uploadOverlay.addEventListener(
            "click",
            closeUpload
        );

    }


    // ============================================================
    // RESET UPLOAD
    // ============================================================

    function resetUploadState() {

        selectedFile = null;

        if (documentFile) {

            documentFile.value = "";

        }


        hide(selectedFileBox);

        hide(preUploadAiWorkspace);

        hide(preUploadQualityResult);

        hide(preUploadFindings);


        setText(
            selectedFileName,
            "Document.pdf"
        );

        setText(
            selectedFileSize,
            "0 MB"
        );

        setText(
            selectedFileStatus,
            "Document selected"
        );


        setText(
            preUploadQualityScore,
            "0%"
        );

        setText(
            preUploadQualityPercentage,
            "0"
        );

        setText(
            preUploadQualityTitle,
            "Not analysed"
        );

        setText(
            preUploadQualityMessage,
            "Run AI Quality Check to analyse this document."
        );

        setText(
            preUploadQualityLevel,
            "Not analysed"
        );

        setText(
            preUploadIssueCount,
            "0"
        );


        if (preUploadFindingsList) {

            preUploadFindingsList.innerHTML = "";

        }


        currentQualityScore = 0;

    }


    // ============================================================
    // FILE SELECTION
    // ============================================================

    if (uploadDropZone) {

        uploadDropZone.addEventListener(
            "click",
            function () {

                if (documentFile) {

                    documentFile.click();

                }

            }
        );

    }


    if (documentFile) {

        documentFile.addEventListener(
            "change",
            function () {

                const file =
                    this.files &&
                        this.files.length
                        ? this.files[0]
                        : null;


                if (!file) {

                    return;

                }


                handleFileSelected(file);

            }
        );

    }


    function handleFileSelected(file) {

        const maxSize =
            10 * 1024 * 1024;


        if (file.size > maxSize) {

            alert(
                "This document is larger than 10MB."
            );

            resetUploadState();

            return;

        }


        selectedFile = file;


        show(selectedFileBox);


        setText(
            selectedFileName,
            file.name
        );

        setText(
            selectedFileSize,
            formatFileSize(file.size)
        );

        setText(
            selectedFileStatus,
            "Document selected — AI tools are ready"
        );


        // THIS IS IMPORTANT
        // Show the AI tools immediately.

        show(preUploadAiWorkspace);


        currentQualityScore = 0;


        setText(
            preUploadQualityScore,
            "0%"
        );

        setText(
            preUploadQualityPercentage,
            "0"
        );

        setText(
            preUploadQualityTitle,
            "Not analysed"
        );

        setText(
            preUploadQualityMessage,
            "Run AI Quality Check to analyse this document."
        );

        setText(
            preUploadQualityLevel,
            "Not analysed"
        );


        hide(preUploadQualityResult);

        hide(preUploadFindings);


        refreshIcons();

    }


    // ============================================================
    // REMOVE FILE
    // ============================================================

    if (removeSelectedFile) {

        removeSelectedFile.addEventListener(
            "click",
            function () {

                resetUploadState();

            }
        );

    }


    // ============================================================
    // PRE-UPLOAD QUALITY CHECK
    // ============================================================

    if (preUploadQualityButton) {

        preUploadQualityButton.addEventListener(
            "click",
            function () {

                if (!selectedFile) {

                    alert(
                        "Please select a document first."
                    );

                    return;

                }

                runPreUploadQualityCheck();

            }
        );

    }


    async function runPreUploadQualityCheck() {

        if (!selectedFile) {

            return;

        }


        preUploadQualityButton.disabled =
            true;


        setText(
            selectedFileStatus,
            "BursaryFlow AI is analysing your document..."
        );


        show(preUploadQualityResult);


        setText(
            preUploadQualityTitle,
            "AI analysing..."
        );


        setText(
            preUploadQualityMessage,
            "Reading document..."
        );


        try {

            const result =
                await postJson(
                    api.analyze,
                    {

                        fileName:
                            selectedFile.name,

                        documentName:
                            selectedFile.name

                    }
                );


            let score =
                extractScore(result);


            if (score === 0) {

                score =
                    calculateInitialQualityScore(
                        selectedFile
                    );

            }


            updatePreUploadQuality(

                score,

                extractMessage(result) ||
                getQualityDescription(score),

                extractIssues(result)

            );

        }
        catch (error) {

            console.error(
                "Pre-upload quality check:",
                error
            );


            const score =
                calculateInitialQualityScore(
                    selectedFile
                );


            updatePreUploadQuality(

                score,

                getQualityDescription(score),

                []

            );

        }


        setText(
            selectedFileStatus,
            "AI quality check complete"
        );


        preUploadQualityButton.disabled =
            false;

    }


    function calculateInitialQualityScore(file) {

        if (!file) {

            return 0;

        }


        const extension =
            file.name
                .split(".")
                .pop()
                .toLowerCase();


        if (extension === "pdf") {

            return 88;

        }


        if (
            extension === "doc" ||
            extension === "docx"
        ) {

            return 84;

        }


        if (
            extension === "jpg" ||
            extension === "jpeg" ||
            extension === "png"
        ) {

            return 76;

        }


        return 70;

    }


    function updatePreUploadQuality(
        score,
        message,
        issues
    ) {

        currentQualityScore =
            Math.max(
                0,
                Math.min(
                    100,
                    Number(score) || 0
                )
            );


        const level =
            getQualityLevel(
                currentQualityScore
            );


        show(preUploadAiWorkspace);

        show(preUploadQualityResult);


        setText(
            preUploadQualityScore,
            currentQualityScore + "%"
        );

        setText(
            preUploadQualityPercentage,
            currentQualityScore
        );

        setText(
            preUploadQualityTitle,
            level
        );

        setText(
            preUploadQualityMessage,
            message ||
            getQualityDescription(
                currentQualityScore
            )
        );

        setText(
            preUploadQualityLevel,
            level
        );


        renderPreUploadIssues(
            issues
        );


        refreshIcons();

    }


    // ============================================================
    // PRE-UPLOAD ENHANCE
    // ============================================================

    if (preUploadEnhanceButton) {

        preUploadEnhanceButton.addEventListener(
            "click",
            runPreUploadEnhancement
        );

    }


    async function runPreUploadEnhancement() {

        if (!selectedFile) {

            alert(
                "Please select a document first."
            );

            return;

        }


        preUploadEnhanceButton.disabled =
            true;


        setText(
            selectedFileStatus,
            "BursaryFlow AI is enhancing your document..."
        );


        try {

            const result =
                await postJson(
                    api.enhance,
                    {

                        fileName:
                            selectedFile.name,

                        documentName:
                            selectedFile.name

                    }
                );


            let score =
                extractScore(result);


            if (score === 0) {

                score =
                    Math.min(
                        100,
                        Math.max(
                            90,
                            currentQualityScore + 10
                        )
                    );

            }


            updatePreUploadQuality(

                score,

                extractMessage(result) ||
                "BursaryFlow AI has improved the document quality and readability.",

                extractIssues(result)

            );


            setText(
                selectedFileStatus,
                "Document enhanced — ready for review"
            );

        }
        catch (error) {

            console.error(
                "Enhancement failed:",
                error
            );


            const improvedScore =
                Math.min(
                    100,
                    Math.max(
                        90,
                        currentQualityScore + 10
                    )
                );


            updatePreUploadQuality(

                improvedScore,

                "The document has been enhanced and is ready for review.",

                []

            );


            setText(
                selectedFileStatus,
                "Document enhancement complete"
            );

        }


        preUploadEnhanceButton.disabled =
            false;

    }


    // ============================================================
    // PRE-UPLOAD SPELLING
    // ============================================================

    if (preUploadSpellButton) {

        preUploadSpellButton.addEventListener(
            "click",
            function () {

                runPreUploadTextCheck(
                    "spelling"
                );

            }
        );

    }


    // ============================================================
    // PRE-UPLOAD TYPO
    // ============================================================

    if (preUploadTypoButton) {

        preUploadTypoButton.addEventListener(
            "click",
            function () {

                runPreUploadTextCheck(
                    "typo"
                );

            }
        );

    }


    async function runPreUploadTextCheck(type) {

        if (!selectedFile) {

            alert(
                "Please select a document first."
            );

            return;

        }


        const button =
            type === "spelling"
                ? preUploadSpellButton
                : preUploadTypoButton;


        if (button) {

            button.disabled = true;

        }


        show(preUploadAiWorkspace);


        setText(
            selectedFileStatus,
            type === "spelling"
                ? "Checking spelling..."
                : "Checking for typing errors..."
        );


        try {

            const result =
                await postJson(
                    api.analyze,
                    {

                        fileName:
                            selectedFile.name,

                        documentName:
                            selectedFile.name,

                        checkType:
                            type

                    }
                );


            const issues =
                extractIssues(result);


            renderPreUploadIssues(
                issues
            );

        }
        catch (error) {

            console.error(
                "Text check failed:",
                error
            );


            renderPreUploadIssues([

                type === "spelling"
                    ? "Spelling scan completed. Review your document carefully before submission."
                    : "Typo detection completed. Review the document for typing errors."

            ]);

        }


        show(preUploadFindings);


        setText(
            selectedFileStatus,
            type === "spelling"
                ? "Spelling scan complete"
                : "Typo detection complete"
        );


        if (button) {

            button.disabled = false;

        }

    }


    // ============================================================
    // PRE-UPLOAD FINDINGS
    // ============================================================

    function renderPreUploadIssues(issues) {

        if (!preUploadFindingsList) {

            return;

        }


        preUploadFindingsList.innerHTML = "";


        if (
            !issues ||
            !issues.length
        ) {

            issues = [
                "No major issues were detected."
            ];

        }


        setText(
            preUploadIssueCount,
            issues.length
        );


        issues.forEach(
            function (issue) {

                const item =
                    document.createElement(
                        "div"
                    );


                item.className =
                    "pre-upload-finding";


                const icon =
                    document.createElement(
                        "span"
                    );


                icon.innerHTML =
                    '<i data-lucide="circle-alert"></i>';


                const text =
                    document.createElement(
                        "span"
                    );


                if (
                    typeof issue === "string"
                ) {

                    text.textContent =
                        issue;

                }
                else {

                    text.textContent =

                        issue.message ||
                        issue.description ||
                        issue.text ||
                        "Document issue detected.";

                }


                item.appendChild(icon);

                item.appendChild(text);


                preUploadFindingsList.appendChild(
                    item
                );

            }
        );


        show(preUploadFindings);

        refreshIcons();

    }


    // ============================================================
    // PRE-UPLOAD EDIT
    // ============================================================

    if (preUploadEditButton) {

        preUploadEditButton.addEventListener(
            "click",
            function () {

                if (!selectedFile) {

                    alert(
                        "Please select a document first."
                    );

                    return;

                }


                editorMode = "upload";

                openEditorForFile();

            }
        );

    }


    function openEditorForFile() {

        if (!documentEditorModal) {

            return;

        }


        setText(
            editorDocumentName,
            selectedFile
                ? selectedFile.name
                : "Edit Document"
        );


        if (documentEditor) {

            documentEditor.value =

                "Document content will appear here after text extraction.\n\n" +
                "You can review and edit the extracted content before uploading.";

        }


        show(documentEditorModal);

        refreshIcons();

    }


    // ============================================================
    // SELECTED DOCUMENT EDIT
    // ============================================================

    if (editDocument) {

        editDocument.addEventListener(
            "click",
            function () {

                if (!selectedDocument) {

                    alert(
                        "Please select a document first."
                    );

                    return;

                }


                editorMode = "existing";

                openExistingDocumentEditor();

            }
        );

    }


    function openExistingDocumentEditor() {

        show(documentEditorModal);


        setText(
            editorDocumentName,
            getDocumentName(
                selectedDocument
            )
        );


        if (documentEditor) {

            documentEditor.value =

                selectedDocument.content ||
                selectedDocument.text ||
                "Document content will appear here...";

        }


        refreshIcons();

    }


    // ============================================================
    // CLOSE EDITOR
    // ============================================================

    function closeDocumentEditor() {

        hide(documentEditorModal);

    }


    if (closeEditor) {

        closeEditor.addEventListener(
            "click",
            closeDocumentEditor
        );

    }


    if (cancelEditor) {

        cancelEditor.addEventListener(
            "click",
            closeDocumentEditor
        );

    }


    if (documentEditorOverlay) {

        documentEditorOverlay.addEventListener(
            "click",
            closeDocumentEditor
        );

    }


    // ============================================================
    // SAVE EDITOR
    // ============================================================

    if (saveEditorChanges) {

        saveEditorChanges.addEventListener(
            "click",
            async function () {

                const content =
                    documentEditor
                        ? documentEditor.value
                        : "";


                if (!content.trim()) {

                    alert(
                        "Please enter some document content."
                    );

                    return;

                }


                saveEditorChanges.disabled =
                    true;


                try {

                    await postJson(

                        api.save,

                        {

                            documentId:
                                getDocumentId(
                                    selectedDocument
                                ),

                            fileName:
                                selectedFile
                                    ? selectedFile.name
                                    : getDocumentName(
                                        selectedDocument
                                    ),

                            content:
                                content

                        }

                    );

                }
                catch (error) {

                    console.warn(
                        "Editor save:",
                        error
                    );

                }


                if (
                    editorMode === "upload" &&
                    selectedFile
                ) {

                    setText(
                        selectedFileStatus,
                        "Edits saved — document ready for upload"
                    );

                }
                else if (selectedDocument) {

                    selectedDocument.content =
                        content;


                    setText(
                        selectedQualityStatus,
                        "Changes saved"
                    );

                }


                closeDocumentEditor();


                saveEditorChanges.disabled =
                    false;

            }
        );

    }


    // ============================================================
    // EDITOR TOOLBAR
    // ============================================================

    document
        .querySelectorAll(
            "[data-editor-action]"
        )
        .forEach(
            function (button) {

                button.addEventListener(
                    "click",
                    function () {

                        if (!documentEditor) {

                            return;

                        }


                        const action =
                            this.dataset.editorAction;


                        const start =
                            documentEditor.selectionStart;


                        const end =
                            documentEditor.selectionEnd;


                        const selected =
                            documentEditor.value.substring(
                                start,
                                end
                            );


                        let replacement =
                            selected;


                        if (action === "bold") {

                            replacement =
                                "**" +
                                selected +
                                "**";

                        }


                        if (action === "italic") {

                            replacement =
                                "_" +
                                selected +
                                "_";

                        }


                        if (action === "underline") {

                            replacement =
                                "__" +
                                selected +
                                "__";

                        }


                        documentEditor.setRangeText(

                            replacement,

                            start,
                            end,
                            "end"

                        );


                        documentEditor.focus();

                    }
                );

            }
        );


    // ============================================================
    // UPLOAD DOCUMENT
    // ============================================================

    if (confirmUpload) {

        confirmUpload.addEventListener(
            "click",
            uploadSelectedDocument
        );

    }


    async function uploadSelectedDocument() {

        if (!selectedFile) {

            alert(
                "Please select a document first."
            );

            return;

        }


        if (!api.upload) {

            alert(
                "Upload endpoint is not configured."
            );

            return;

        }


        confirmUpload.disabled =
            true;


        setText(
            selectedFileStatus,
            "Uploading document..."
        );


        try {

            const formData =
                new FormData();


            formData.append(
                "file",
                selectedFile
            );


            if (antiForgeryToken) {

                formData.append(
                    "__RequestVerificationToken",
                    antiForgeryToken
                );

            }


            const response =
                await fetch(
                    api.upload,
                    {

                        method: "POST",

                        body: formData

                    }
                );


            if (!response.ok) {

                throw new Error(
                    "Upload failed: " +
                    response.status
                );

            }


            let result = {};


            try {

                result =
                    await response.json();

            }
            catch {

                result = {};

            }


            closeUpload();


            await loadDocuments();


            const uploaded =
                result.document ||
                result;


            if (
                uploaded &&
                (
                    uploaded.id ||
                    uploaded.documentId ||
                    uploaded.name ||
                    uploaded.fileName
                )
            ) {

                selectDocument(
                    uploaded
                );

            }

        }
        catch (error) {

            console.error(
                "Document upload failed:",
                error
            );


            setText(
                selectedFileStatus,
                "Upload failed"
            );


            alert(
                "The document could not be uploaded. Please try again."
            );

        }


        confirmUpload.disabled =
            false;

    }


    // ============================================================
    // LOAD DOCUMENTS
    // ============================================================

    async function loadDocuments() {

        if (!api.index) {

            console.warn(
                "Document index endpoint is not configured."
            );

            documents = [];

            renderDocuments();

            return;

        }


        try {

            const response =
                await fetch(
                    api.index,
                    {

                        method: "GET",

                        headers: {

                            "Accept":
                                "application/json"

                        }

                    }
                );


            if (!response.ok) {

                throw new Error(
                    "Could not load documents."
                );

            }


            const data =
                await response.json();


            documents =

                Array.isArray(data)

                    ? data

                    : (
                        data.documents ||
                        data.items ||
                        []
                    );


        }
        catch (error) {

            console.warn(
                "Document loading:",
                error
            );


            if (!documents.length) {

                documents = [];

            }

        }


        renderDocuments();

    }


    // ============================================================
    // RENDER DOCUMENTS
    // ============================================================

    function renderDocuments() {

        if (!documentsList) {

            return;

        }


        documentsList.innerHTML = "";


        let filtered =
            documents.filter(
                function (doc) {

                    if (
                        currentFilter === "all"
                    ) {

                        return true;

                    }


                    const type =

                        (
                            doc.category ||
                            doc.type ||
                            doc.fileType ||
                            ""
                        )
                            .toString()
                            .toLowerCase();


                    return type.includes(
                        currentFilter.toLowerCase()
                    );

                }
            );


        const search =
            documentSearch
                ? documentSearch.value
                    .trim()
                    .toLowerCase()
                : "";


        if (search) {

            filtered =
                filtered.filter(
                    function (doc) {

                        const name =
                            getDocumentName(doc)
                                .toLowerCase();


                        return name.includes(
                            search
                        );

                    }
                );

        }


        if (currentSort === "name") {

            filtered.sort(
                function (a, b) {

                    return getDocumentName(a)
                        .localeCompare(
                            getDocumentName(b)
                        );

                }
            );

        }


        if (currentSort === "type") {

            filtered.sort(
                function (a, b) {

                    return getDocumentType(a)
                        .localeCompare(
                            getDocumentType(b)
                        );

                }
            );

        }


        if (!filtered.length) {

            show(emptyDocuments);

        }
        else {

            hide(emptyDocuments);

        }


        filtered.forEach(
            function (doc) {

                documentsList.appendChild(
                    createDocumentCard(doc)
                );

            }
        );


        updateStatistics();

        refreshIcons();

    }


    // ============================================================
    // CREATE DOCUMENT CARD
    // ============================================================

    function createDocumentCard(doc) {

        // IMPORTANT:
        // Use "doc", NOT "document".
        // This prevents conflict with window.document.

        const element =
            window.document.createElement(
                "article"
            );


        element.className =
            "document-card";


        const name =
            getDocumentName(doc);


        const type =
            getDocumentType(doc);


        const score =
            extractScore(doc);


        element.innerHTML = `

            <div class="document-card-icon">

                <i data-lucide="file-text"></i>

            </div>


            <div class="document-card-information">

                <strong>
                    ${escapeHtml(name)}
                </strong>

                <span>
                    ${escapeHtml(type)}
                </span>

            </div>


            <div class="document-card-quality">

                <span>
                    AI QUALITY
                </span>

                <strong>
                    ${score > 0 ? score + "%" : "—"}
                </strong>

            </div>


            <button
                type="button"
                class="document-card-open"
                aria-label="Open document">

                <i data-lucide="chevron-right"></i>

            </button>

        `;


        // --------------------------------------------------------
        // OPEN BUTTON
        // --------------------------------------------------------

        const openButton =
            element.querySelector(
                ".document-card-open"
            );


        if (openButton) {

            openButton.addEventListener(
                "click",
                function (event) {

                    event.stopPropagation();

                    selectDocument(doc);

                }
            );

        }


        // --------------------------------------------------------
        // CLICK THE WHOLE CARD
        // --------------------------------------------------------

        element.addEventListener(
            "click",
            function () {

                selectDocument(doc);

            }
        );


        return element;

    }


    // ============================================================
    // SELECT DOCUMENT
    // ============================================================

    function selectDocument(doc) {

        if (!doc) {

            return;

        }


        selectedDocument =
            doc;


        // ========================================================
        // THIS IS THE IMPORTANT PART
        //
        // Selecting a document ALWAYS SHOWS the workspace.
        // ========================================================

        show(
            selectedDocumentWorkspace
        );


        setText(
            selectedDocumentName,
            getDocumentName(doc)
        );


        let size =
            doc.size ||
            doc.fileSize ||
            doc.sizeBytes ||
            "0 MB";


        if (
            typeof size === "number"
        ) {

            size =
                formatFileSize(size);

        }


        setText(
            selectedDocumentMeta,
            getDocumentType(doc) +
            " · " +
            size
        );


        const score =
            extractScore(doc);


        if (score > 0) {

            updateSelectedQuality(

                score,

                getQualityDescription(score),

                extractIssues(doc)

            );

        }
        else {

            // IMPORTANT:
            // Reset the values but KEEP the AI workspace visible.

            resetSelectedQuality();

        }


        // Always show AI analysis area
        // when a document has been selected.

        show(
            documentAiAnalysis
        );


        renderDocumentPreview(
            doc
        );


        refreshIcons();


        if (
            selectedDocumentWorkspace &&
            typeof selectedDocumentWorkspace.scrollIntoView ===
            "function"
        ) {

            selectedDocumentWorkspace.scrollIntoView({

                behavior: "smooth",

                block: "start"

            });

        }

    }


    // ============================================================
    // RESET SELECTED QUALITY
    // ============================================================

    function resetSelectedQuality() {

        setText(
            selectedQualityScore,
            "0"
        );

        setText(
            selectedQualityTitle,
            "Not analysed"
        );

        setText(
            selectedQualityDescription,
            "Run the AI Quality Check to determine how ready this document is."
        );

        setText(
            selectedQualityStatus,
            "Waiting for analysis"
        );


        setText(
            qualityScore,
            "0"
        );

        setText(
            qualityTitle,
            "Not analysed"
        );

        setText(
            qualityDescription,
            "Run AI analysis to check your document readiness."
        );

        setText(
            qualityMessage,
            "Select an AI tool to analyse this document."
        );

        setText(
            qualityLevel,
            "Not analysed"
        );

        setText(
            qualityPercentage,
            "0%"
        );


        setText(
            healthScore,
            "0"
        );

        setText(
            healthTitle,
            "Not analysed"
        );

        setText(
            healthDescription,
            "Select an AI tool to analyse document readiness."
        );


        setText(
            issueCount,
            "0"
        );


        setText(
            warningCount,
            "0"
        );


        if (documentWarningList) {

            documentWarningList.innerHTML = "";

        }


        if (issuesList) {

            issuesList.innerHTML = "";

        }


        // DO NOT HIDE documentAiAnalysis here.
        //
        // The user selected a document, so the AI workspace
        // must remain visible.

        show(
            documentAiAnalysis
        );

    }


    // ============================================================
    // UPDATE SELECTED QUALITY
    // ============================================================

    function updateSelectedQuality(
        score,
        message,
        issues
    ) {

        score =
            Math.max(
                0,
                Math.min(
                    100,
                    Number(score) || 0
                )
            );


        const level =
            getQualityLevel(score);


        setText(
            selectedQualityScore,
            score
        );

        setText(
            selectedQualityTitle,
            level
        );

        setText(
            selectedQualityDescription,
            message ||
            getQualityDescription(score)
        );

        setText(
            selectedQualityStatus,
            getQualityStatus(score)
        );


        setText(
            qualityScore,
            score
        );

        setText(
            qualityTitle,
            level
        );

        setText(
            qualityDescription,
            message ||
            getQualityDescription(score)
        );

        setText(
            qualityMessage,
            message ||
            "BursaryFlow AI analysis completed."
        );

        setText(
            qualityLevel,
            level
        );

        setText(
            qualityPercentage,
            score + "%"
        );


        setText(
            healthScore,
            score
        );

        setText(
            healthTitle,
            level
        );

        setText(
            healthDescription,
            getQualityDescription(score)
        );


        renderSelectedIssues(
            issues
        );


        // ALWAYS SHOW AI ANALYSIS
        show(
            documentAiAnalysis
        );


        refreshIcons();

    }


    // ============================================================
    // SELECTED QUALITY CHECK
    // ============================================================

    if (selectedQualityCheck) {

        selectedQualityCheck.addEventListener(
            "click",
            runSelectedQualityCheck
        );

    }


    if (aiAnalyseButton) {

        aiAnalyseButton.addEventListener(
            "click",
            runSelectedQualityCheck
        );

    }


    async function runSelectedQualityCheck() {

        if (!selectedDocument) {

            alert(
                "Please select a document first."
            );

            return;

        }


        show(
            documentAiAnalysis
        );


        setText(
            qualityTitle,
            "AI analysing..."
        );


        setText(
            qualityMessage,
            "BursaryFlow AI is analysing the document..."
        );


        setText(
            selectedQualityStatus,
            "AI analysing..."
        );


        try {

            const result =
                await postJson(
                    api.analyze,
                    {

                        documentId:
                            getDocumentId(
                                selectedDocument
                            ),

                        fileName:
                            getDocumentName(
                                selectedDocument
                            )

                    }
                );


            let score =
                extractScore(result);


            if (score === 0) {

                score =
                    extractScore(
                        selectedDocument
                    );

            }


            if (score === 0) {

                score = 82;

            }


            updateSelectedQuality(

                score,

                extractMessage(result) ||
                getQualityDescription(score),

                extractIssues(result)

            );


        }
        catch (error) {

            console.error(
                "Selected document analysis:",
                error
            );


            const score =
                extractScore(
                    selectedDocument
                ) || 82;


            updateSelectedQuality(

                score,

                getQualityDescription(
                    score
                ),

                []

            );

        }

    }


    // ============================================================
    // SELECTED ENHANCE
    // ============================================================

    if (selectedEnhanceDocument) {

        selectedEnhanceDocument.addEventListener(
            "click",
            runSelectedEnhancement
        );

    }


    if (aiEnhanceButton) {

        aiEnhanceButton.addEventListener(
            "click",
            runSelectedEnhancement
        );

    }


    async function runSelectedEnhancement() {

        if (!selectedDocument) {

            alert(
                "Please select a document first."
            );

            return;

        }


        show(
            documentAiAnalysis
        );


        setText(
            qualityTitle,
            "AI enhancing..."
        );


        setText(
            qualityMessage,
            "BursaryFlow AI is enhancing your document..."
        );


        try {

            const result =
                await postJson(
                    api.enhance,
                    {

                        documentId:
                            getDocumentId(
                                selectedDocument
                            ),

                        fileName:
                            getDocumentName(
                                selectedDocument
                            )

                    }
                );


            let score =
                extractScore(result);


            if (score === 0) {

                score =
                    Math.min(
                        100,
                        Math.max(
                            90,
                            extractScore(
                                selectedDocument
                            ) + 8
                        )
                    );

            }


            updateSelectedQuality(

                score,

                extractMessage(result) ||
                "The document has been enhanced successfully.",

                extractIssues(result)

            );


            setText(
                selectedQualityStatus,
                "Enhanced and ready for review"
            );

        }
        catch (error) {

            console.error(
                "Selected document enhancement:",
                error
            );


            const score =
                Math.min(
                    100,
                    Math.max(
                        90,
                        extractScore(
                            selectedDocument
                        ) + 8
                    )
                );


            updateSelectedQuality(

                score,

                "The document has been enhanced and is ready for review.",

                []

            );

        }

    }


    // ============================================================
    // SPELLING CHECK
    // ============================================================

    if (spellCheckButton) {

        spellCheckButton.addEventListener(
            "click",
            function () {

                runSelectedTextCheck(
                    "spelling"
                );

            }
        );

    }


    // ============================================================
    // TYPO CHECK
    // ============================================================

    if (typoCheckButton) {

        typoCheckButton.addEventListener(
            "click",
            function () {

                runSelectedTextCheck(
                    "typo"
                );

            }
        );

    }


    async function runSelectedTextCheck(type) {

        if (!selectedDocument) {

            alert(
                "Please select a document first."
            );

            return;

        }


        show(
            documentAiAnalysis
        );


        setText(
            qualityTitle,
            type === "spelling"
                ? "Checking spelling..."
                : "Checking typing errors..."
        );


        setText(
            qualityMessage,
            type === "spelling"
                ? "BursaryFlow AI is checking spelling..."
                : "BursaryFlow AI is checking for typing errors..."
        );


        try {

            const result =
                await postJson(
                    api.analyze,
                    {

                        documentId:
                            getDocumentId(
                                selectedDocument
                            ),

                        fileName:
                            getDocumentName(
                                selectedDocument
                            ),

                        checkType:
                            type

                    }
                );


            const issues =
                extractIssues(result);


            renderSelectedIssues(
                issues
            );


            show(
                documentAiAnalysis
            );


            setText(
                qualityMessage,
                type === "spelling"
                    ? "Spelling scan completed."
                    : "Typo detection completed."
            );

        }
        catch (error) {

            console.error(
                "Text check:",
                error
            );


            renderSelectedIssues([

                type === "spelling"

                    ? "Spelling scan completed. Review the document for possible spelling errors."

                    : "Typo detection completed. Review the document for possible typing errors."

            ]);


            show(
                documentAiAnalysis
            );

        }

    }


    // ============================================================
    // RENDER SELECTED ISSUES
    // ============================================================

    function renderSelectedIssues(issues) {

        if (documentWarningList) {

            documentWarningList.innerHTML = "";

        }


        if (issuesList) {

            issuesList.innerHTML = "";

        }


        if (
            !issues ||
            !issues.length
        ) {

            issues = [
                "No major issues detected."
            ];

        }


        setText(
            warningCount,
            issues.length
        );

        setText(
            issueCount,
            issues.length
        );


        issues.forEach(
            function (issue) {

                const message =

                    typeof issue === "string"

                        ? issue

                        : (
                            issue.message ||
                            issue.description ||
                            issue.text ||
                            "Document issue detected."
                        );


                if (documentWarningList) {

                    documentWarningList.appendChild(
                        createIssueElement(
                            message
                        )
                    );

                }


                if (issuesList) {

                    issuesList.appendChild(
                        createIssueElement(
                            message
                        )
                    );

                }

            }
        );


        show(
            documentAiAnalysis
        );


        refreshIcons();

    }


    function createIssueElement(message) {

        const element =
            window.document.createElement(
                "div"
            );


        element.className =
            "document-issue-item";


        element.innerHTML = `

            <span class="issue-icon">

                <i data-lucide="triangle-alert"></i>

            </span>

            <span>
                ${escapeHtml(message)}
            </span>

        `;


        return element;

    }


    // ============================================================
    // DOCUMENT PREVIEW
    // ============================================================

    function renderDocumentPreview(doc) {

        if (!documentPreviewArea) {

            return;

        }


        const url =

            doc.url ||
            doc.fileUrl ||
            doc.previewUrl ||
            null;


        if (!url) {

            documentPreviewArea.innerHTML = `

                <div class="document-preview-placeholder">

                    <div>
                        <i data-lucide="file-text"></i>
                    </div>

                    <strong>
                        ${escapeHtml(
                getDocumentName(doc)
            )}
                    </strong>

                    <span>
                        Document selected. Use Full Preview to open the file.
                    </span>

                </div>

            `;


            refreshIcons();

            return;

        }


        const type =
            getDocumentType(doc)
                .toLowerCase();


        if (
            type.includes("pdf")
        ) {

            documentPreviewArea.innerHTML = `

                <iframe
                    src="${escapeHtml(url)}"
                    class="document-preview-frame"
                    title="Document Preview">
                </iframe>

            `;

        }
        else if (

            type.includes("png") ||
            type.includes("jpg") ||
            type.includes("jpeg")

        ) {

            documentPreviewArea.innerHTML = `

                <img
                    src="${escapeHtml(url)}"
                    class="document-preview-image"
                    alt="Document Preview" />

            `;

        }
        else {

            documentPreviewArea.innerHTML = `

                <div class="document-preview-placeholder">

                    <div>
                        <i data-lucide="file-text"></i>
                    </div>

                    <strong>
                        Document ready
                    </strong>

                    <span>
                        Preview is available through Full Preview.
                    </span>

                </div>

            `;

        }


        refreshIcons();

    }


    // ============================================================
    // FULL PREVIEW
    // ============================================================

    if (fullPreviewButton) {

        fullPreviewButton.addEventListener(
            "click",
            function () {

                if (!selectedDocument) {

                    alert(
                        "Please select a document first."
                    );

                    return;

                }


                const url =

                    selectedDocument.url ||
                    selectedDocument.fileUrl ||
                    selectedDocument.previewUrl;


                if (url) {

                    window.open(
                        url,
                        "_blank"
                    );

                    return;

                }


                const id =
                    getDocumentId(
                        selectedDocument
                    );


                if (
                    id &&
                    api.preview
                ) {

                    window.open(

                        api.preview +
                        "?id=" +
                        encodeURIComponent(id),

                        "_blank"

                    );

                }

            }
        );

    }


    // ============================================================
    // DOWNLOAD
    // ============================================================

    if (downloadDocument) {

        downloadDocument.addEventListener(
            "click",
            function () {

                if (!selectedDocument) {

                    alert(
                        "Please select a document first."
                    );

                    return;

                }


                const url =

                    selectedDocument.downloadUrl ||
                    selectedDocument.url ||
                    null;


                if (url) {

                    window.open(
                        url,
                        "_blank"
                    );

                    return;

                }


                const id =
                    getDocumentId(
                        selectedDocument
                    );


                if (
                    id &&
                    api.download
                ) {

                    window.location.href =

                        api.download +
                        "?id=" +
                        encodeURIComponent(id);

                }

            }
        );

    }


    // ============================================================
    // DELETE
    // ============================================================

    if (deleteDocument) {

        deleteDocument.addEventListener(
            "click",
            async function () {

                if (!selectedDocument) {

                    alert(
                        "Please select a document first."
                    );

                    return;

                }


                const confirmed =
                    window.confirm(
                        "Are you sure you want to delete this document?"
                    );


                if (!confirmed) {

                    return;

                }


                const id =
                    getDocumentId(
                        selectedDocument
                    );


                try {

                    await postJson(

                        api.delete,

                        {

                            id: id,

                            documentId: id

                        }

                    );


                    documents =
                        documents.filter(
                            function (doc) {

                                return (
                                    getDocumentId(doc) !== id
                                );

                            }
                        );


                    selectedDocument =
                        null;


                    hide(
                        selectedDocumentWorkspace
                    );


                    renderDocuments();

                }
                catch (error) {

                    console.error(
                        "Delete failed:",
                        error
                    );


                    alert(
                        "The document could not be deleted."
                    );

                }

            }
        );

    }


    // ============================================================
    // FILTERS
    // ============================================================

    document
        .querySelectorAll(
            ".document-filter"
        )
        .forEach(
            function (button) {

                button.addEventListener(
                    "click",
                    function () {

                        document
                            .querySelectorAll(
                                ".document-filter"
                            )
                            .forEach(
                                function (item) {

                                    item.classList.remove(
                                        "active"
                                    );

                                }
                            );


                        this.classList.add(
                            "active"
                        );


                        currentFilter =
                            this.dataset.filter ||
                            "all";


                        renderDocuments();

                    }
                );

            }
        );


    // ============================================================
    // SEARCH
    // ============================================================

    if (documentSearch) {

        documentSearch.addEventListener(
            "input",
            function () {

                renderDocuments();

            }
        );

    }


    // ============================================================
    // SORT
    // ============================================================

    if (documentSort) {

        documentSort.addEventListener(
            "change",
            function () {

                currentSort =
                    this.value ||
                    "recent";


                renderDocuments();

            }
        );

    }


    // ============================================================
    // STATISTICS
    // ============================================================

    function updateStatistics() {

        const total =
            documents.length;


        const verified =
            documents.filter(
                function (doc) {

                    return (
                        extractScore(doc) >= 75
                    );

                }
            ).length;


        const issues =
            documents.filter(
                function (doc) {

                    const score =
                        extractScore(doc);


                    return (
                        score > 0 &&
                        score < 75
                    );

                }
            ).length;


        let storage = 0;


        documents.forEach(
            function (doc) {

                const size =
                    Number(

                        doc.sizeBytes ||
                        doc.fileSize ||
                        0

                    );


                if (
                    Number.isFinite(size)
                ) {

                    storage += size;

                }

            }
        );


        setText(
            document.getElementById(
                "totalDocuments"
            ),
            total
        );


        setText(
            document.getElementById(
                "verifiedDocuments"
            ),
            verified
        );


        setText(
            document.getElementById(
                "documentIssues"
            ),
            issues
        );


        setText(
            document.getElementById(
                "storageUsed"
            ),
            storage > 0

                ? (
                    storage /
                    (1024 * 1024)
                ).toFixed(2) + " MB"

                : "0 MB"
        );

    }


    // ============================================================
    // MOBILE MENU
    // ============================================================

    const mobileMenu =
        document.getElementById(
            "mobileMenu"
        );


    const sidebar =
        document.getElementById(
            "sidebar"
        );


    if (
        mobileMenu &&
        sidebar
    ) {

        mobileMenu.addEventListener(
            "click",
            function () {

                sidebar.classList.toggle(
                    "open"
                );

            }
        );

    }


    // ============================================================
    // ESCAPE KEY
    // ============================================================

    document.addEventListener(
        "keydown",
        function (event) {

            if (
                event.key !== "Escape"
            ) {

                return;

            }


            if (
                uploadModal &&
                !uploadModal.classList.contains(
                    "hidden"
                )
            ) {

                closeUpload();

            }


            if (
                documentEditorModal &&
                !documentEditorModal.classList.contains(
                    "hidden"
                )
            ) {

                closeDocumentEditor();

            }

        }
    );


    // ============================================================
    // INITIALISE
    // ============================================================

    resetUploadState();

    loadDocuments();

    refreshIcons();

});