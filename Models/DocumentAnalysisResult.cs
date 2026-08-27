using System.Collections.Generic;

namespace BursaryFlow.Models
{
    public class DocumentAnalysisResult
    {
        public bool Success { get; set; }

        public string FileName { get; set; } = "";

        public string FileType { get; set; } = "";

        public long FileSize { get; set; }

        public int QualityScore { get; set; }

        public string QualityLevel { get; set; } = "";

        public bool NeedsEnhancement { get; set; }

        public bool ContainsText { get; set; }

        public bool IsScannedDocument { get; set; }

        public string Message { get; set; } = "";

        public List<DocumentIssue> Issues { get; set; }
            = new List<DocumentIssue>();
    }


    public class DocumentIssue
    {
        public string Type { get; set; } = "";

        public string Severity { get; set; } = "";

        public string Field { get; set; } = "";

        public string Message { get; set; } = "";

        public string DetectedText { get; set; } = "";

        public string SuggestedText { get; set; } = "";
    }
}