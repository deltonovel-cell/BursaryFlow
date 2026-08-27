using BursaryFlow.Models;
using BursaryFlow.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using System.Text;

namespace BursaryFlow.Controllers
{
    public class AiAssistantController : Controller
    {
        private readonly StudentProfileService _studentService;
        private readonly BursaryKnowledgeService _bursaryService;
        private readonly BursaryMatchingService _matchingService;

        public AiAssistantController(
            StudentProfileService studentService,
            BursaryKnowledgeService bursaryService,
            BursaryMatchingService matchingService)
        {
            _studentService = studentService;
            _bursaryService = bursaryService;
            _matchingService = matchingService;
        }

        // =========================================================
        // AI ASSISTANT PAGE
        // =========================================================

        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }

        // =========================================================
        // RECEIVE AI MESSAGE
        // =========================================================

        [HttpPost]
        public IActionResult Ask([FromBody] AiAssistantRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Message))
            {
                return BadRequest(new
                {
                    success = false,
                    message = "Please enter a message."
                });
            }

            try
            {
                string response = GenerateResponse(request.Message);

                return Json(new
                {
                    success = true,
                    response = response
                });
            }
            catch (Exception ex)
            {
                Console.WriteLine("DELTON AI ERROR: " + ex.Message);

                return StatusCode(500, new
                {
                    success = false,
                    message = "Delton could not process your request."
                });
            }
        }

        // =========================================================
        // DELTON RESPONSE ENGINE
        // =========================================================

        private string GenerateResponse(string message)
        {
            string text = message.Trim().ToLower();

            var profile = _studentService.GetCurrentStudent();

            // =====================================================
            // GREETINGS
            // =====================================================

            if (text == "hi" ||
                text == "hello" ||
                text == "hey" ||
                text == "hiya" ||
                text == "heyy" ||
                text == "morning" ||
                text == "afternoon" ||
                text == "evening" ||
                text.Contains("good morning") ||
                text.Contains("good afternoon") ||
                text.Contains("good evening"))
            {
                return
                    $"Hey {profile.FirstName}! 👋\n\n" +
                    "I'm Delton, your BursaryFlow AI assistant.\n\n" +
                    "I can help you find bursaries, check your profile, understand eligibility, prepare applications, organise documents and improve your chances of receiving funding.\n\n" +
                    "What would you like help with?";
            }

            // =====================================================
            // CASUAL CONVERSATION
            // =====================================================

            if (text.Contains("how are you") ||
                text.Contains("how are things") ||
                text.Contains("you good") ||
                text.Contains("are you good") ||
                text.Contains("how's it going") ||
                text.Contains("hows it going") ||
                text.Contains("how do you feel"))
            {
                return
                    "I'm doing great! 😄\n\n" +
                    "I'm ready to help you with your bursary journey.\n\n" +
                    "You can ask me about your profile, bursaries, applications, documents, eligibility or motivation letters.";
            }

            // =====================================================
            // THANK YOU
            // =====================================================

            if (text.Contains("thank you") ||
                text.Contains("thanks") ||
                text.Contains("thank u") ||
                text.Contains("thx") ||
                text.Contains("appreciate it"))
            {
                return
                    $"You're welcome, {profile.FirstName}! 😊\n\n" +
                    "I'm here whenever you need help with BursaryFlow.";
            }

            // =====================================================
            // WHO IS DELTON
            // =====================================================

            if (text.Contains("who are you") ||
                text.Contains("what are you") ||
                text.Contains("your name") ||
                text.Contains("who is delton") ||
                text.Contains("what is delton"))
            {
                return
                    "I'm Delton 🤖, the AI assistant inside BursaryFlow.\n\n" +
                    "My job is to help students find suitable bursaries, understand requirements, prepare applications, organise documents and improve their chances of receiving funding.";
            }

            // =====================================================
            // MY NAME
            // =====================================================

            if (text.Contains("what is my name") ||
                text.Contains("who am i") ||
                text.Contains("do you know my name") ||
                text.Contains("my name"))
            {
                return
                    $"Your name is {profile.FirstName}.\n\n" +
                    "That's the name currently stored in your BursaryFlow student profile.";
            }

            // =====================================================
            // AVERAGE / MARKS
            // =====================================================

            if (text.Contains("my average") ||
                text.Contains("my mark") ||
                text.Contains("my marks") ||
                text.Contains("academic average") ||
                text.Contains("average mark") ||
                text.Contains("average percentage") ||
                text.Contains("my percentage") ||
                text.Contains("how did i do") ||
                text.Contains("what did i get") ||
                text.Contains("my academic performance"))
            {
                if (profile.AverageMark.HasValue)
                {
                    return
                        $"Your current academic average is **{profile.AverageMark.Value:0.##}%**.\n\n" +
                        "That's a strong part of your bursary profile. Many bursaries use academic performance as part of their eligibility criteria.\n\n" +
                        "I can also use your average when matching you with bursary opportunities.";
                }

                return
                    "Your academic average isn't currently available in your BursaryFlow profile.\n\n" +
                    "Update your profile so I can use your academic performance when matching bursaries.";
            }

            // =====================================================
            // COURSE / FIELD OF STUDY
            // =====================================================

            if (text.Contains("what do i study") ||
                text.Contains("what am i studying") ||
                text.Contains("what is my course") ||
                text.Contains("what's my course") ||
                text.Contains("my course") ||
                text.Contains("my field") ||
                text.Contains("field of study") ||
                text.Contains("what am i doing at university") ||
                text.Contains("what am i studying at university"))
            {
                if (!string.IsNullOrWhiteSpace(profile.Course))
                {
                    return
                        $"You're studying **{profile.Course}**.\n\n" +
                        $"You're currently in Year {profile.YearOfStudy} at **{profile.Institution}**.";
                }

                return
                    "Your course hasn't been added to your profile yet.";
            }

            // =====================================================
            // INSTITUTION / UNIVERSITY
            // =====================================================

            if (text.Contains("where do i study") ||
                text.Contains("which university") ||
                text.Contains("what university") ||
                text.Contains("my university") ||
                text.Contains("my institution") ||
                text.Contains("where am i studying") ||
                text.Contains("where do i go to university") ||
                text.Contains("which institution"))
            {
                if (!string.IsNullOrWhiteSpace(profile.Institution))
                {
                    return
                        $"You're currently studying at **{profile.Institution}**.\n\n" +
                        $"You're studying **{profile.Course}** and you're in Year {profile.YearOfStudy}.";
                }

                return
                    "Your institution hasn't been added to your profile yet.";
            }

            // =====================================================
            // YEAR OF STUDY
            // =====================================================

            if (text.Contains("what year") ||
                text.Contains("which year") ||
                text.Contains("year of study") ||
                text.Contains("my year") ||
                text.Contains("what level") ||
                text.Contains("which year am i") ||
                text.Contains("what year am i"))
            {
                return
                    $"You're currently in **Year {profile.YearOfStudy}** of your studies.\n\n" +
                    $"You're studying {profile.Course} at {profile.Institution}.";
            }

            // =====================================================
            // PROFILE
            // =====================================================

            if (text.Contains("my profile") ||
                text.Contains("show my profile") ||
                text.Contains("profile details") ||
                text.Contains("what's on my profile") ||
                text.Contains("what is on my profile") ||
                text.Contains("tell me about my profile") ||
                text.Contains("what do you know about me") ||
                text.Contains("what do you know about my profile"))
            {
                StringBuilder result = new StringBuilder();

                result.AppendLine(
                    $"Here's what I currently know about your BursaryFlow profile, {profile.FirstName}:"
                );

                result.AppendLine();

                result.AppendLine(
                    $"**Institution:** {profile.Institution ?? "Not provided"}"
                );

                result.AppendLine(
                    $"**Course:** {profile.Course ?? "Not provided"}"
                );

                result.AppendLine(
                    $"**Faculty:** {profile.Faculty ?? "Not provided"}"
                );

                result.AppendLine(
                    $"**Study level:** {profile.StudyLevel ?? "Not provided"}"
                );

                result.AppendLine(
                    $"**Year of study:** {profile.YearOfStudy}"
                );

                if (profile.AverageMark.HasValue)
                {
                    result.AppendLine(
                        $"**Average:** {profile.AverageMark.Value:0.##}%"
                    );
                }
                else
                {
                    result.AppendLine(
                        "**Average:** Not provided"
                    );
                }

                result.AppendLine(
                    $"**Province:** {profile.Province ?? "Not provided"}"
                );

                result.AppendLine();

                result.AppendLine(
                    "I use this information to help identify bursaries that may be suitable for you."
                );

                return result.ToString();
            }

            // =====================================================
            // BURSARY SEARCH / MATCHING
            // =====================================================

            if (text.Contains("bursary") ||
                text.Contains("bursaries") ||
                text.Contains("funding") ||
                text.Contains("financial aid") ||
                text.Contains("financial support") ||
                text.Contains("scholarship") ||
                text.Contains("scholarships") ||
                text.Contains("fund my studies") ||
                text.Contains("pay for my studies") ||
                text.Contains("money for university") ||
                text.Contains("funding opportunities") ||
                text.Contains("funding opportunity"))
            {
                // Questions specifically about requirements are handled later.
                // This prevents every mention of "bursary" from immediately
                // becoming a matching request.

                if (text.Contains("what is a bursary") ||
                    text.Contains("what are bursaries") ||
                    text.Contains("what does bursary mean"))
                {
                    return
                        "A bursary is financial assistance provided to help a student pay for their education.\n\n" +
                        "Bursaries can help cover things such as tuition, accommodation, books, transport or other study-related expenses.\n\n" +
                        "Unlike a normal student loan, a bursary generally does not need to be repaid, although some bursaries may have conditions attached.";
                }

                var allBursaries = _bursaryService.GetAll();

                var matches = _matchingService.MatchStudent(
                    profile,
                    allBursaries);

                if (!matches.Any())
                {
                    return
                        "I couldn't find a suitable bursary in the current BursaryFlow database based on your profile.\n\n" +
                        $"Your current profile shows an average of " +
                        $"{(profile.AverageMark.HasValue ? profile.AverageMark.Value.ToString("0.##") + "%" : "not available")} " +
                        $"and you're studying {profile.Course ?? "a course that hasn't been specified"}.\n\n" +
                        "Try completing more of your profile or check again when new bursaries are added.";
                }

                StringBuilder result = new StringBuilder();

                result.AppendLine(
                    $"I found **{matches.Count} bursary option{(matches.Count == 1 ? "" : "s")}** that may match your profile:"
                );

                result.AppendLine();

                foreach (var bursary in matches)
                {
                    result.AppendLine(
                        $"**{bursary.BursaryName}**"
                    );

                    if (!string.IsNullOrWhiteSpace(bursary.Description))
                    {
                        result.AppendLine(
                            bursary.Description
                        );
                    }

                    if (!string.IsNullOrWhiteSpace(bursary.StudyFields))
                    {
                        result.AppendLine(
                            $"Study field: {bursary.StudyFields}"
                        );
                    }

                    if (bursary.MinimumAverage.HasValue)
                    {
                        result.AppendLine(
                            $"Minimum average: {bursary.MinimumAverage.Value:0.##}%"
                        );
                    }

                    result.AppendLine();
                }

                result.AppendLine(
                    "Would you like me to explain why these bursaries match your profile?"
                );

                return result.ToString();
            }

            // =====================================================
            // WHY DO I QUALIFY?
            // =====================================================

            if (text.Contains("why do i qualify") ||
                text.Contains("why am i eligible") ||
                text.Contains("why does it match") ||
                text.Contains("why do these match") ||
                text.Contains("why was i matched") ||
                text.Contains("why did you match me"))
            {
                var allBursaries = _bursaryService.GetAll();

                var matches = _matchingService.MatchStudent(
                    profile,
                    allBursaries);

                if (!matches.Any())
                {
                    return
                        "I don't currently have any matching bursaries to explain.\n\n" +
                        "Try asking me to find bursaries for you first.";
                }

                StringBuilder result = new StringBuilder();

                result.AppendLine(
                    "Here's why the current bursary matches may suit you:"
                );

                result.AppendLine();

                if (profile.AverageMark.HasValue)
                {
                    result.AppendLine(
                        $"• Your academic average is **{profile.AverageMark.Value:0.##}%**."
                    );
                }

                result.AppendLine(
                    $"• Your course is **{profile.Course ?? "not specified"}**."
                );

                result.AppendLine(
                    $"• You're in **Year {profile.YearOfStudy}**."
                );

                if (!string.IsNullOrWhiteSpace(profile.Institution))
                {
                    result.AppendLine(
                        $"• Your institution is **{profile.Institution}**."
                    );
                }

                result.AppendLine();

                foreach (var bursary in matches)
                {
                    result.AppendLine(
                        $"**{bursary.BursaryName}**"
                    );

                    if (bursary.MinimumAverage.HasValue &&
                        profile.AverageMark.HasValue)
                    {
                        if (profile.AverageMark.Value >= bursary.MinimumAverage.Value)
                        {
                            result.AppendLine(
                                $"Your average meets the minimum requirement of {bursary.MinimumAverage.Value:0.##}%."
                            );
                        }
                        else
                        {
                            result.AppendLine(
                                $"The bursary has a minimum average of {bursary.MinimumAverage.Value:0.##}%."
                            );
                        }
                    }

                    result.AppendLine();
                }

                return result.ToString();
            }

            // =====================================================
            // DOCUMENTS
            // =====================================================

            if (text.Contains("document") ||
                text.Contains("documents") ||
                text.Contains("upload") ||
                text.Contains("paperwork") ||
                text.Contains("proof") ||
                text.Contains("what must i submit") ||
                text.Contains("what should i submit") ||
                text.Contains("what do i need to submit") ||
                text.Contains("what should i prepare"))
            {
                return
                    "For many bursary applications, you may need:\n\n" +
                    "• Certified copy of your ID\n" +
                    "• Proof of registration\n" +
                    "• Latest academic transcript\n" +
                    "• Proof of household income\n" +
                    "• Proof of residence\n" +
                    "• Parent or guardian income documents where required\n" +
                    "• A bursary motivation letter\n\n" +
                    "The exact requirements depend on the bursary provider, so always check the specific bursary's requirements before submitting.";
            }

            // =====================================================
            // MOTIVATION LETTER
            // =====================================================

            if (text.Contains("motivation") ||
                text.Contains("motivation letter") ||
                text.Contains("write my motivation") ||
                text.Contains("help me write") ||
                text.Contains("personal statement") ||
                text.Contains("write a letter"))
            {
                return
                    $"Absolutely, {profile.FirstName}. I can help you create a strong bursary motivation letter.\n\n" +
                    "A good motivation letter should explain:\n\n" +
                    $"• Who you are\n" +
                    $"• What you study ({profile.Course ?? "your course"})\n" +
                    $"• Your academic performance ({(profile.AverageMark.HasValue ? profile.AverageMark.Value.ToString("0.##") + "%" : "your average")})\n" +
                    "• Your career goals\n" +
                    "• Why you need financial support\n" +
                    "• Why you chose the particular bursary\n" +
                    "• Why the organisation should invest in you\n\n" +
                    "Tell me the bursary you're applying for and your career goals, and I can help you build the letter.";
            }

            // =====================================================
            // APPLICATION HELP
            // =====================================================

            if (text.Contains("application") ||
                text.Contains("apply") ||
                text.Contains("applying") ||
                text.Contains("how do i apply") ||
                text.Contains("help me apply") ||
                text.Contains("application process") ||
                text.Contains("submit my application"))
            {
                return
                    "I can help you work through a bursary application step by step.\n\n" +
                    "A typical process is:\n\n" +
                    "1. Find a bursary that matches your profile.\n" +
                    "2. Check the eligibility requirements.\n" +
                    "3. Check the closing date.\n" +
                    "4. Prepare the required documents.\n" +
                    "5. Complete the application form.\n" +
                    "6. Write your motivation if required.\n" +
                    "7. Review your information carefully.\n" +
                    "8. Submit before the deadline.\n\n" +
                    "If you tell me which bursary you're applying for, I can help you understand what you need to do.";
            }

            // =====================================================
            // ELIGIBILITY
            // =====================================================

            if (text.Contains("eligible") ||
                text.Contains("eligibility") ||
                text.Contains("requirements") ||
                text.Contains("requirement") ||
                text.Contains("do i qualify") ||
                text.Contains("can i get") ||
                text.Contains("can i receive") ||
                text.Contains("am i able to get") ||
                text.Contains("am i eligible"))
            {
                return
                    "Bursary eligibility commonly depends on several factors:\n\n" +
                    "• Academic performance\n" +
                    "• Course or field of study\n" +
                    "• Year of study\n" +
                    "• Household income\n" +
                    "• Institution\n" +
                    "• Citizenship\n" +
                    "• Age requirements\n" +
                    "• Disability status where applicable\n" +
                    "• Other bursary-specific conditions\n\n" +
                    $"Your current profile shows a **{(profile.AverageMark.HasValue ? profile.AverageMark.Value.ToString("0.##") + "%" : "not available")}** average and you're studying **{profile.Course ?? "a course not specified"}**.\n\n" +
                    "I can compare your profile with the bursaries currently available in BursaryFlow.";
            }

            // =====================================================
            // DEADLINES
            // =====================================================

            if (text.Contains("deadline") ||
                text.Contains("deadlines") ||
                text.Contains("closing date") ||
                text.Contains("closing dates") ||
                text.Contains("when does it close") ||
                text.Contains("when is it due") ||
                text.Contains("last day") ||
                text.Contains("when should i apply"))
            {
                return
                    "Bursary closing dates depend on the specific provider and bursary.\n\n" +
                    "You should check the individual bursary details for the exact closing date before applying.\n\n" +
                    "My recommendation is to prepare your documents early instead of waiting until the deadline.";
            }

            // =====================================================
            // IMPROVE CHANCES
            // =====================================================

            if (text.Contains("improve my chances") ||
                text.Contains("better chance") ||
                text.Contains("increase my chances") ||
                text.Contains("how can i improve") ||
                text.Contains("make my chances better") ||
                text.Contains("improve my profile") ||
                text.Contains("be more competitive"))
            {
                string average = profile.AverageMark.HasValue
                    ? profile.AverageMark.Value.ToString("0.##") + "%"
                    : "not available";

                return
                    $"Based on your current profile, your academic average is **{average}**.\n\n" +
                    "To improve your bursary chances:\n\n" +
                    "• Keep your academic results as strong as possible.\n" +
                    "• Apply to multiple suitable bursaries.\n" +
                    "• Apply before the closing date.\n" +
                    "• Keep all required documents ready.\n" +
                    "• Make sure your documents are clear and readable.\n" +
                    "• Write a specific motivation letter instead of a generic one.\n" +
                    "• Keep your BursaryFlow profile complete and up to date.\n\n" +
                    "Most importantly, focus on bursaries where your profile actually matches the requirements.";
            }

            // =====================================================
            // CAREER / COURSE QUESTIONS
            // =====================================================

            if (text.Contains("career") ||
                text.Contains("future") ||
                text.Contains("job") ||
                text.Contains("jobs after"))
            {
                return
                    $"Since you're studying **{profile.Course}**, there are several career paths you could explore depending on your interests.\n\n" +
                    "For Computer Science, examples include software development, data science, cybersecurity, cloud computing, systems analysis and artificial intelligence.\n\n" +
                    "If you're asking because you want to strengthen your bursary motivation, I can also help you connect your career goals to your application.";
            }

            // =====================================================
            // FUNDING EXPLANATION
            // =====================================================

            if (text.Contains("how can i get funding") ||
                text.Contains("how do i get funding") ||
                text.Contains("where can i get funding") ||
                text.Contains("i need funding") ||
                text.Contains("i need financial help") ||
                text.Contains("i need financial support") ||
                text.Contains("help me get funding"))
            {
                return
                    "I can help you look for funding opportunities through BursaryFlow.\n\n" +
                    $"Your profile currently shows that you're studying **{profile.Course}** at **{profile.Institution}**, with an average of **{(profile.AverageMark.HasValue ? profile.AverageMark.Value.ToString("0.##") + "%" : "not available")}**.\n\n" +
                    "The best next step is to search for bursaries that match your academic profile and field of study.\n\n" +
                    "You can ask me: **\"Find bursaries for me.\"**";
            }

            // =====================================================
            // PROFILE COMPLETENESS
            // =====================================================

            if (text.Contains("complete profile") ||
                text.Contains("profile complete") ||
                text.Contains("missing from my profile") ||
                text.Contains("what is missing") ||
                text.Contains("what am i missing"))
            {
                return
                    "Your profile already contains several important details, including:\n\n" +
                    $"• Name: {profile.FirstName}\n" +
                    $"• Institution: {profile.Institution}\n" +
                    $"• Course: {profile.Course}\n" +
                    $"• Faculty: {profile.Faculty}\n" +
                    $"• Study level: {profile.StudyLevel}\n" +
                    $"• Year of study: {profile.YearOfStudy}\n" +
                    $"• Average: {(profile.AverageMark.HasValue ? profile.AverageMark.Value.ToString("0.##") + "%" : "Not provided")}\n" +
                    $"• Province: {profile.Province}\n\n" +
                    "Adding more financial and personal information where required can help improve bursary matching.";
            }

            // =====================================================
            // WHAT CAN DELTON DO?
            // =====================================================

            if (text.Contains("what can you do") ||
                text.Contains("what can you help") ||
                text.Contains("what do you help with") ||
                text.Contains("help me with") ||
                text.Contains("what are your capabilities"))
            {
                return
                    "I can help you with several parts of your bursary journey:\n\n" +
                    "• Find bursaries that match your profile\n" +
                    "• Explain why a bursary matches you\n" +
                    "• Tell you about your student profile\n" +
                    "• Check your academic average\n" +
                    "• Explain bursary eligibility\n" +
                    "• Tell you what documents you may need\n" +
                    "• Help prepare applications\n" +
                    "• Help write motivation letters\n" +
                    "• Give advice on improving your bursary chances\n\n" +
                    "Just ask me naturally — you don't need to use a specific command.";
            }

            // =====================================================
            // GENERAL BURSARY QUESTION
            // =====================================================

            if (text.Contains("student funding") ||
                text.Contains("education funding") ||
                text.Contains("study funding") ||
                text.Contains("university funding") ||
                text.Contains("financial assistance"))
            {
                return
                    "There are several forms of student funding, including bursaries, scholarships and other financial-aid programmes.\n\n" +
                    "Bursaries are often based on factors such as academic performance, field of study, financial need and other eligibility requirements.\n\n" +
                    "I can check the bursaries currently available in BursaryFlow against your profile.";
            }

            // =====================================================
            // FALLBACK
            // =====================================================

            return
                $"I understand you're asking about \"{message}\".\n\n" +
                "I may not have a specific answer for that question yet, but I can help you with:\n\n" +
                "• Finding bursaries\n" +
                "• Checking your profile\n" +
                "• Your academic average\n" +
                "• Eligibility and requirements\n" +
                "• Required documents\n" +
                "• Bursary applications\n" +
                "• Motivation letters\n" +
                "• Application deadlines\n" +
                "• Improving your bursary chances\n\n" +
                "Try asking something like:\n" +
                "**\"Find bursaries for me.\"**\n" +
                "**\"What is my average?\"**\n" +
                "**\"Tell me about my profile.\"**";
        }
    }
}