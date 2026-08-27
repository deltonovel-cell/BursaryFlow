document.addEventListener("DOMContentLoaded", function () {

    const input = document.getElementById("aiInput");
    const sendButton = document.getElementById("sendMessage");
    const messages = document.getElementById("aiMessages");
    const typingIndicator = document.getElementById("typingIndicator");
    const clearChatButton = document.getElementById("clearChat");
    const attachDocumentButton = document.getElementById("attachDocument");
    const voiceInputButton = document.getElementById("voiceInput");

    if (!input || !sendButton || !messages) {
        console.error("Delton AI: Required elements were not found.");
        return;
    }


    // =========================================================
    // LUCIDE ICONS
    // =========================================================

    function refreshIcons() {

        if (typeof lucide !== "undefined") {
            lucide.createIcons();
        }

    }


    // =========================================================
    // ESCAPE HTML
    // =========================================================

    function escapeHtml(text) {

        const div = document.createElement("div");

        div.textContent = text;

        return div.innerHTML;

    }


    // =========================================================
    // FORMAT DELTON RESPONSE
    // =========================================================

    function formatMessage(text) {

        let formatted = escapeHtml(text);

        formatted = formatted.replace(
            /\*\*(.*?)\*\*/g,
            "<strong>$1</strong>"
        );

        formatted = formatted.replace(
            /\*(.*?)\*/g,
            "<em>$1</em>"
        );

        formatted = formatted.replace(
            /\n/g,
            "<br>"
        );

        return formatted;

    }


    // =========================================================
    // CURRENT TIME
    // =========================================================

    function getCurrentTime() {

        return new Date().toLocaleTimeString(
            [],
            {
                hour: "2-digit",
                minute: "2-digit"
            }
        );

    }


    // =========================================================
    // SCROLL CHAT
    // =========================================================

    function scrollToBottom() {

        messages.scrollTo({

            top: messages.scrollHeight,

            behavior: "smooth"

        });

    }


    // =========================================================
    // ADD USER MESSAGE
    // =========================================================

    function addUserMessage(text) {

        const message = document.createElement("div");

        message.className =
            "ai-message ai-message-user";

        message.innerHTML = `

            <div class="message-content">

                <span class="message-name">
                    You
                </span>

                <div class="message-bubble">
                    ${formatMessage(text)}
                </div>

                <span class="message-time">
                    ${getCurrentTime()}
                </span>

            </div>

        `;

        messages.appendChild(message);

        scrollToBottom();

    }


    // =========================================================
    // ADD DELTON MESSAGE
    // =========================================================

    function addDeltonMessage(text) {

        const message = document.createElement("div");

        message.className =
            "ai-message ai-message-bot";

        message.innerHTML = `

            <div class="message-avatar">

                <i data-lucide="sparkles"></i>

            </div>

            <div class="message-content">

                <span class="message-name">
                    Delton
                </span>

                <div class="message-bubble">
                    ${formatMessage(text)}
                </div>

                <span class="message-time">
                    ${getCurrentTime()}
                </span>

            </div>

        `;

        messages.appendChild(message);

        refreshIcons();

        scrollToBottom();

    }


    // =========================================================
    // SHOW TYPING
    // =========================================================

    function showTyping() {

        if (!typingIndicator) {
            return;
        }

        typingIndicator.classList.remove("hidden");

        messages.appendChild(typingIndicator);

        scrollToBottom();

    }


    // =========================================================
    // HIDE TYPING
    // =========================================================

    function hideTyping() {

        if (!typingIndicator) {
            return;
        }

        typingIndicator.classList.add("hidden");

    }


    // =========================================================
    // HIDE SUGGESTIONS
    // =========================================================

    function hideSuggestions() {

        const suggestions =
            document.getElementById("aiSuggestions");

        if (suggestions) {

            suggestions.style.display =
                "none";

        }

    }


    // =========================================================
    // SEND MESSAGE TO CONTROLLER
    // =========================================================

    async function sendMessage() {

        const message =
            input.value.trim();

        if (!message) {
            return;
        }


        // Show user message

        addUserMessage(message);

        input.value = "";

        input.style.height = "auto";

        hideSuggestions();

        sendButton.disabled = true;

        showTyping();


        try {

            const response =
                await fetch(
                    "/AiAssistant/Ask",
                    {
                        method: "POST",

                        headers: {
                            "Content-Type":
                                "application/json"
                        },

                        body: JSON.stringify({
                            message: message
                        })
                    }
                );


            // =================================================
            // READ SERVER RESPONSE
            // =================================================

            let data = null;

            try {

                data = await response.json();

            }
            catch (jsonError) {

                console.error(
                    "Delton AI: Invalid JSON response.",
                    jsonError
                );

            }


            hideTyping();


            // =================================================
            // SUCCESS
            // =================================================

            if (
                response.ok &&
                data &&
                data.success &&
                data.response
            ) {

                addDeltonMessage(
                    data.response
                );

            }


            // =================================================
            // SERVER ERROR
            // =================================================

            else if (data && data.message) {

                addDeltonMessage(
                    data.message
                );

            }


            // =================================================
            // UNKNOWN ERROR
            // =================================================

            else {

                addDeltonMessage(
                    "I'm sorry, Delton couldn't process that request. Please try again."
                );

                console.error(
                    "Delton AI server response:",
                    data
                );

            }

        }

        catch (error) {

            console.error(
                "Delton AI connection error:",
                error
            );

            hideTyping();

            addDeltonMessage(
                "I'm having trouble connecting to BursaryFlow right now. Please check that the application is running and try again."
            );

        }


        sendButton.disabled = false;

        input.focus();

    }


    // =========================================================
    // SEND BUTTON
    // =========================================================

    sendButton.addEventListener(
        "click",
        sendMessage
    );


    // =========================================================
    // ENTER TO SEND
    // =========================================================

    input.addEventListener(
        "keydown",
        function (event) {

            if (
                event.key === "Enter" &&
                !event.shiftKey
            ) {

                event.preventDefault();

                sendMessage();

            }

        }
    );


    // =========================================================
    // AUTO RESIZE TEXTAREA
    // =========================================================

    input.addEventListener(
        "input",
        function () {

            this.style.height =
                "auto";

            this.style.height =
                Math.min(
                    this.scrollHeight,
                    130
                ) + "px";

        }
    );


    // =========================================================
    // SUGGESTION BUTTONS
    // =========================================================

    document
        .querySelectorAll("[data-message]")
        .forEach(
            function (button) {

                button.addEventListener(
                    "click",
                    function () {

                        const message =
                            this.getAttribute(
                                "data-message"
                            );

                        if (!message) {
                            return;
                        }

                        input.value =
                            message;

                        sendMessage();

                    }
                );

            }
        );


    // =========================================================
    // CLEAR CHAT
    // =========================================================

    if (clearChatButton) {

        clearChatButton.addEventListener(
            "click",
            function () {

                const confirmed =
                    confirm(
                        "Clear your Delton conversation?"
                    );

                if (!confirmed) {
                    return;
                }

                messages
                    .querySelectorAll(
                        ".ai-message"
                    )
                    .forEach(
                        function (message) {

                            message.remove();

                        }
                    );

                hideTyping();


                const suggestions =
                    document.getElementById(
                        "aiSuggestions"
                    );

                if (suggestions) {

                    suggestions.style.display =
                        "grid";

                }


                addDeltonMessage(
                    "Conversation cleared. I'm ready whenever you are. What would you like help with?"
                );

            }
        );

    }


    // =========================================================
    // ATTACH DOCUMENT
    // =========================================================

    if (attachDocumentButton) {

        attachDocumentButton.addEventListener(
            "click",
            function () {

                const fileInput =
                    document.createElement(
                        "input"
                    );

                fileInput.type =
                    "file";

                fileInput.accept =
                    ".pdf,.doc,.docx,.jpg,.jpeg,.png";


                fileInput.addEventListener(
                    "change",
                    function () {

                        if (
                            !this.files ||
                            this.files.length === 0
                        ) {
                            return;
                        }


                        const file =
                            this.files[0];


                        addUserMessage(
                            "I attached: " +
                            file.name
                        );


                        showTyping();


                        /*
                         * Document uploading will be
                         * connected to the Documents
                         * controller later.
                         */

                        setTimeout(
                            function () {

                                hideTyping();

                                addDeltonMessage(
                                    "I've received **" +
                                    file.name +
                                    "**.\n\n" +
                                    "Document analysis will be connected to your BursaryFlow document system next."
                                );

                            },
                            1000
                        );

                    }
                );


                fileInput.click();

            }
        );

    }


    // =========================================================
    // VOICE INPUT
    // =========================================================

    if (voiceInputButton) {

        const SpeechRecognition =
            window.SpeechRecognition ||
            window.webkitSpeechRecognition;


        if (!SpeechRecognition) {

            voiceInputButton.addEventListener(
                "click",
                function () {

                    addDeltonMessage(
                        "Voice input isn't supported by this browser. Try Google Chrome or Microsoft Edge."
                    );

                }
            );

        }

        else {

            const recognition =
                new SpeechRecognition();


            recognition.lang =
                "en-ZA";


            recognition.continuous =
                false;


            recognition.interimResults =
                false;


            recognition.addEventListener(
                "start",
                function () {

                    voiceInputButton.classList.add(
                        "recording"
                    );

                }
            );


            recognition.addEventListener(
                "end",
                function () {

                    voiceInputButton.classList.remove(
                        "recording"
                    );

                }
            );


            recognition.addEventListener(
                "result",
                function (event) {

                    const transcript =
                        event.results[0][0]
                            .transcript;

                    input.value =
                        transcript;

                    input.focus();

                }
            );


            recognition.addEventListener(
                "error",
                function (event) {

                    console.error(
                        "Voice recognition error:",
                        event.error
                    );

                    voiceInputButton.classList.remove(
                        "recording"
                    );

                }
            );


            voiceInputButton.addEventListener(
                "click",
                function () {

                    try {

                        recognition.start();

                    }
                    catch (error) {

                        console.error(
                            "Voice recognition could not start:",
                            error
                        );

                    }

                }
            );

        }

    }


    // =========================================================
    // GLOBAL SEARCH SHORTCUT
    // =========================================================

    document.addEventListener(
        "keydown",
        function (event) {

            if (
                event.key === "/" &&
                document.activeElement !== input
            ) {

                const globalSearch =
                    document.getElementById(
                        "globalSearch"
                    );

                if (globalSearch) {

                    event.preventDefault();

                    globalSearch.focus();

                }

            }

        }
    );


    // =========================================================
    // INITIALISE
    // =========================================================

    refreshIcons();

    input.focus();

});