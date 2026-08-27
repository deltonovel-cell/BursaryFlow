namespace BursaryFlow.Services
{
    public enum AssistantIntent
    {
        Greeting,
        ProfileReview,
        BursarySearch,
        Eligibility,
        ApplicationHelp,
        MotivationLetter,
        DocumentHelp,
        ImproveChances,
        Unknown
    }

    public static class IntentDetector
    {
        public static AssistantIntent Detect(string message)
        {
            string text = message.ToLower();

            if (
                text.Contains("based on my profile") ||
                text.Contains("what bursaries do i qualify for") ||
                text.Contains("what do i qualify for")
            )
            {
                return AssistantIntent.ProfileReview;
            }

            if (
                text.Contains("find bursary") ||
                text.Contains("find bursaries")
            )
            {
                return AssistantIntent.BursarySearch;
            }

            if (
                text.Contains("motivation")
            )
            {
                return AssistantIntent.MotivationLetter;
            }

            return AssistantIntent.Unknown;
        }
    }
}