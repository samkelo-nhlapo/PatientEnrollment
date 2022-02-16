using PatientEnrollmentVS.Models;
using PatientEnrollmentVS.Repo;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace PatientEnrollmentVS.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            LocationModel model = new LocationModel();
            return View("Index", model);
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        //Country Method
        public JsonResult GetCountries()
        {
            using(var db = GetContxt())
            {
                var eventCountries = db.Database.SqlQuery<LocationModel>(String.Format("Location.spGetCountries")).ToList();
                return new JsonResult { Data = eventCountries, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
            }
        }

        //Province Method
        public JsonResult GetProvinces()
        {
            using (var db = GetContxt())
            {
                var eventProvinces = db.Database.SqlQuery<LocationModel>(String.Format("Location.spGetProvinces")).ToList();
                return new JsonResult { Data = eventProvinces, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
            }
        }

        //city Method
        //public JsonResult GetCities()
        //{
        //    using (var db = GetContxt())
        //    {
        //        var eventCities = db.Database.SqlQuery<LocationModel>(String.Format("Location.spGetCities")).ToList();
        //        return new JsonResult { Data = eventCities, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
        //    }
        //}

        //MaritalStatus Method
        public JsonResult GetMeritalStatus()
        {
            using(var db = GetContxt())
            {
                var eventMerital = db.Database.SqlQuery<LocationModel>(String.Format("Profile.spGetMaritalStatus")).ToList();
                return new JsonResult { Data = eventMerital, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
            }
        }

        public JsonResult GetEmailType()
        {
            using(var db = GetContxt())
            {
                var eventEmailType = db.Database.SqlQuery<LocationModel>(string.Format("Contacts.spGetEmailType")).ToList();
                return new JsonResult { Data = eventEmailType, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
            }
        }

        public JsonResult GetPhoneType()
        {
            using(var db = GetContxt())
            {
                var eventPhoneType = db.Database.SqlQuery<LocationModel>(String.Format("Contacts.spGetPhoneType")).ToList();
                return new JsonResult { Data = eventPhoneType, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
            }
        }

        public JsonResult GetGender()
        {
            using(var db = GetContxt())
            {
                var eventGender = db.Database.SqlQuery<LocationModel>(string.Format("Profile.spGetGender")).ToList();
                return new JsonResult { Data = eventGender, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
            }
        }

        [HttpPost]
        public JsonResult SavePatient(LocationModel locationModel)
        {
            string connection = ConfigurationManager.ConnectionStrings["EnrollmentEntity"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connection))
            {
                SqlCommand cmd = new SqlCommand("Profile.spAddPatientProfile", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@FirstName", locationModel.FirstName));
                cmd.Parameters.Add(new SqlParameter("@LastName", locationModel.LastName));
                cmd.Parameters.Add(new SqlParameter("@IDNumber", locationModel.ID_Number));
                cmd.Parameters.Add(new SqlParameter("@DateOfBirth", locationModel.DateOfBirth));
                cmd.Parameters.Add(new SqlParameter("@PhoneNumber", locationModel.PhoneNumber));
                cmd.Parameters.Add(new SqlParameter("@PhoneTypeIDFK", Int32.Parse(locationModel.PhoneTypeIDFK)));
                cmd.Parameters.Add(new SqlParameter("@Email", locationModel.Email));
                cmd.Parameters.Add(new SqlParameter("@EmailTypeIDFK", Int32.Parse(locationModel.EmailTypeIDFK)));
                cmd.Parameters.Add(new SqlParameter("@Line1", locationModel.Line1));
                cmd.Parameters.Add(new SqlParameter("@Line2", locationModel.Line2));
                cmd.Parameters.Add(new SqlParameter("@CityIDFK", Int32.Parse(locationModel.CityIDFK)));
                cmd.Parameters.Add(new SqlParameter("@ProvinceIDFK", Int32.Parse(locationModel.ProvinceIDFK)));
                cmd.Parameters.Add(new SqlParameter("@CountryIDFK", Int32.Parse(locationModel.CountryIDFK)));
                cmd.Parameters.Add(new SqlParameter("@MaritalStatusIDFK", Int32.Parse(locationModel.MaritalStatusIDFK)));
                cmd.Parameters.Add(new SqlParameter("@MedicationList", locationModel.MedicationList));
                cmd.Parameters.Add(new SqlParameter("@EmergencyName", locationModel.EmergencyName));
                cmd.Parameters.Add(new SqlParameter("@EmergencyLastName", locationModel.EmergencyLastName));
                cmd.Parameters.Add(new SqlParameter("@Relationship", locationModel.Relationship));
                cmd.Parameters.Add(new SqlParameter("@RelationshipDateOfBirth", locationModel.RelationshipDateOfBirth));
                cmd.Parameters.Add(new SqlParameter("@PrimaryCarrierName", locationModel.PrimaryCarrierName));
                cmd.Parameters.Add(new SqlParameter("@FPolicyHolderPhoneNumber", locationModel.FPolicyHolderPhoneNumber));
                cmd.Parameters.Add(new SqlParameter("@FPolicyHolderName", locationModel.FPolicyHolderName));
                cmd.Parameters.Add(new SqlParameter("@FPolicyHolderDateOfBirth", locationModel.FPolicyHolderDateOfBirth));
                cmd.Parameters.Add(new SqlParameter("@FPolicyHolderRelationship", locationModel.FPolicyHolderRelationship));
                cmd.Parameters.Add(new SqlParameter("@FPolicyHolderGenderIDFK", Int32.Parse(locationModel.FPolicyHolderGenderIDFK)));
                cmd.Parameters.Add(new SqlParameter("@SecondaryCarrierName", locationModel.SecondaryCarrierName));
                cmd.Parameters.Add(new SqlParameter("@SPolicyHolderPhoneNumber", locationModel.SPolicyHolderPhoneNumber));
                cmd.Parameters.Add(new SqlParameter("@SPolicyHolderName", locationModel.SPolicyHolderName));
                cmd.Parameters.Add(new SqlParameter("@SPolicyHolderDateOfBirth", locationModel.SPolicyHolderDateOfBirth));
                cmd.Parameters.Add(new SqlParameter("@SPolicyHolderRelationship", locationModel.SPolicyHolderRelationship));
                cmd.Parameters.Add(new SqlParameter("@SPolicyHolderGenderIDFK", Int32.Parse(locationModel.SPolicyHolderGenderIDFK)));


                cmd.Parameters.Add(new SqlParameter("@Message", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    locationModel.Message = Convert.ToString(cmd.Parameters["@Message"].Value);

                    conn.Close();
                }
                catch (Exception e)
                {

                    Console.WriteLine(e.Message);
                }
               
            }
            return new JsonResult { Data = locationModel, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
            
        }


        public static Contxt GetContxt()
        {
            return new Contxt();
        }
    }
}