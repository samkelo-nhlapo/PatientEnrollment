using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PatientEnrollmentVS.Models
{
    public class LocationModel
    {
        //Country
        public string CountryId { get; set; }
        public string CountryName { get; set; }

        //Province
        public string ProvinceId { get; set; }
        public string ProvinceName { get; set; }

        //Cities
        public string CityId { get; set; }
        public string CityName { get; set; }

        //MaritalStatus
        public string MaritalStatusId { get; set; }
        public string MaritalStatusDescription { get; set; }

        //Email Type
        public string EmailTypeId { get; set; }
        public string EmailTypeDescription { get; set; }

        //Phone Type
        public string PhoneTypeId { get; set; }
        public string PhoneTypeDescription { get; set; }

        //Patient
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string DateOfBirth { get; set; }
        public string GenderIDFK { get; set; }
        public string PhoneNumber { get; set; }
        public string PhoneType { get; set; }
        public string Email { get; set; }
        public string EmailType { get; set; }
        public string Line1 { get; set; }
        public string Line2 { get; set; }
        public string CityIDFK { get; set; }
        public string ProvinceIDFK { get; set; }
        public string CountryIDFK { get; set; }
        public string MaritalStatusIDFK { get; set; }
        public string MedicationList { get; set; }
        public string EmergencyName { get; set; }
        public string EmergencyLastName { get; set; }
        public string Relationship { get; set; }
        public string RelationshipDateOfBirth { get; set; }
        public string PrimaryCarrierName { get; set; }
        public string FPolicyHolderPhoneNumber { get; set; }
        public string FPolicyHolderName { get; set; }
        public string FPolicyHolderDateOfBirth { get; set; }
        public string FPolicyHolderRelationship { get; set; }
        public string FPolicyHolderGenderIDFK { get; set; }
        public string SecondaryCarrierName { get; set; }
        public string SPolicyHolderPhoneNumber { get; set; }
        public string SPolicyHolderName { get; set; }
        public string SPolicyHolderDateOfBirth { get; set; }
        public string SPolicyHolderRelationship { get; set; }
        public string SPolicyHolderGenderIDFK { get; set; }
        public string Message { get; set; }

    }
}