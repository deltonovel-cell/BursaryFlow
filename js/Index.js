document.addEventListener("DOMContentLoaded", function () {

    /*
     * ==========================================
     * NAVBAR
     * ==========================================
     */

    const navbar = document.getElementById("navbar");
    const mobileMenu = document.getElementById("mobileMenu");
    const navLinks = document.getElementById("navLinks");


    /*
     * NAVBAR SCROLL EFFECT
     */

    function updateNavbar() {

        if (!navbar) {
            return;
        }

        if (window.scrollY > 20) {

            navbar.classList.add("scrolled");

        } else {

            navbar.classList.remove("scrolled");

        }

    }

    window.addEventListener("scroll", updateNavbar);

    updateNavbar();


    /*
     * ==========================================
     * MOBILE MENU
     * ==========================================
     */

    if (mobileMenu && navLinks) {

        mobileMenu.addEventListener("click", function () {

            navLinks.classList.toggle("mobile-open");

            mobileMenu.classList.toggle("active");

        });

    }


    /*
     * CLOSE MOBILE MENU
     * AFTER CLICKING A LINK
     */

    document
        .querySelectorAll(".nav-links a")
        .forEach(function (link) {

            link.addEventListener("click", function () {

                if (navLinks) {

                    navLinks.classList.remove(
                        "mobile-open"
                    );

                }

                if (mobileMenu) {

                    mobileMenu.classList.remove(
                        "active"
                    );

                }

            });

        });


    /*
     * ==========================================
     * SMOOTH INTERNAL LINKS
     * ==========================================
     */

    document
        .querySelectorAll('a[href^="#"]')
        .forEach(function (link) {

            link.addEventListener("click", function (event) {

                const targetId =
                    this.getAttribute("href");

                if (!targetId || targetId === "#") {
                    return;
                }

                const target =
                    document.querySelector(targetId);

                if (!target) {
                    return;
                }

                event.preventDefault();

                target.scrollIntoView({
                    behavior: "smooth",
                    block: "start"
                });

            });

        });


    /*
     * ==========================================
     * SCROLL REVEAL
     * ==========================================
     */

    const revealElements =
        document.querySelectorAll(
            ".feature-card, " +
            ".step, " +
            ".ai-benefit, " +
            ".scanner-card, " +
            ".security-copy, " +
            ".security-visual"
        );


    if (
        "IntersectionObserver" in window &&
        revealElements.length > 0
    ) {

        const observer =
            new IntersectionObserver(
                function (entries) {

                    entries.forEach(function (entry) {

                        if (entry.isIntersecting) {

                            entry.target.classList.add(
                                "revealed"
                            );

                            observer.unobserve(
                                entry.target
                            );

                        }

                    });

                },
                {
                    threshold: 0.12
                }
            );


        revealElements.forEach(function (element) {

            element.classList.add("reveal");

            observer.observe(element);

        });

    }


    /*
     * ==========================================
     * HERO PRODUCT PARALLAX
     * ==========================================
     */

    const heroProduct =
        document.querySelector(".hero-product");


    if (heroProduct) {

        window.addEventListener(
            "mousemove",
            function (event) {

                if (window.innerWidth < 900) {
                    return;
                }

                const x =
                    (event.clientX /
                        window.innerWidth -
                        0.5) * 2;

                const y =
                    (event.clientY /
                        window.innerHeight -
                        0.5) * 2;


                heroProduct.style.transform =
                    "translate(" +
                    x * 5 +
                    "px, " +
                    y * 5 +
                    "px)";

            }
        );


        window.addEventListener(
            "resize",
            function () {

                if (window.innerWidth < 900) {

                    heroProduct.style.transform = "";

                }

            }
        );

    }


    /*
     * ==========================================
     * PROFILE MATCH ANIMATION
     * ==========================================
     */

    const matchRing =
        document.querySelector(".match-ring");


    if (matchRing) {

        let progress = 0;

        const target = 94;


        const interval =
            setInterval(function () {

                progress++;

                matchRing.style.background =
                    "conic-gradient(" +
                    "#285c47 " +
                    progress +
                    "%, #dcebe3 0)";


                if (progress >= target) {

                    clearInterval(interval);

                }

            }, 18);

    }


    /*
     * ==========================================
     * DOCUMENT SCANNER
     * ==========================================
     */

    const scanner =
        document.querySelector(".scanner-card");


    if (scanner) {

        scanner.addEventListener(
            "mouseenter",
            function () {

                scanner.classList.add(
                    "scanner-active"
                );

            }
        );


        scanner.addEventListener(
            "mouseleave",
            function () {

                scanner.classList.remove(
                    "scanner-active"
                );

            }
        );

    }


    /*
     * ==========================================
     * ACTIVE NAVIGATION
     * ==========================================
     */

    const currentPage =
        window.location.pathname.toLowerCase();


    document
        .querySelectorAll(".nav-links a")
        .forEach(function (link) {

            const href =
                link.getAttribute("href");


            if (!href) {
                return;
            }


            if (
                href.startsWith("/") &&
                currentPage.includes(
                    href.toLowerCase()
                )
            ) {

                link.classList.add("active");

            }

        });


    /*
     * ==========================================
     * PREVENT EMPTY LINKS
     * ==========================================
     */

    document
        .querySelectorAll('a[href="#"]')
        .forEach(function (link) {

            link.addEventListener(
                "click",
                function (event) {

                    event.preventDefault();

                }
            );

        });

});