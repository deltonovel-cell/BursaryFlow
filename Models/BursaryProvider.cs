using System;
using System.Collections.Generic;

namespace HouseServices.Models
{
    public class BursaryProvider
    {
        public int ProviderID { get; set; }

        public string ProviderName { get; set; } = string.Empty;

        public string? ProviderType { get; set; }

        public string? Description { get; set; }

        public string? WebsiteURL { get; set; }

        public string? ApplicationPortalURL { get; set; }

        public string? ContactEmail { get; set; }

        public string? ContactPhone { get; set; }

        public bool IsOfficial { get; set; }

        public bool IsActive { get; set; }

        public DateTime? LastVerified { get; set; }

        public DateTime CreatedDate { get; set; }

        public ICollection<Bursary> Bursaries { get; set; }
            = new List<Bursary>();
    }
}