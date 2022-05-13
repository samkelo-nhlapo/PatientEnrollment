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

        public JsonResult GetGender()
        {
            using (var db = GetContxt())
            {
                var eventGender = db.Database.SqlQuery<LocationModel>(string.Format("Profile.spGetGender")).ToList();
                return new JsonResult { Data = eventGender, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
            }
        }

        //MaritalStatus Method
        public JsonResult GetMeritalStatus()
        {
            using (var db = GetContxt())
            {
                var eventMerital = db.Database.SqlQuery<LocationModel>(String.Format("Profile.spGetMaritalStatus")).ToList();
                return new JsonResult { Data = eventMerital, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
            }
        }

        //Country Method
        public JsonResult GetCountries()
        {
            using (var db = GetContxt())
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

        public JsonResult GetCities()
        {
            using (var db = GetContxt())
            {
                var eventCities = db.Database.SqlQuery<LocationModel>(String.Format("Location.spGetCities")).ToList();

                return new JsonResult { Data = eventCities, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
            }

        }


        [HttpPost]
        public JsonResult AddPatient(LocationModel locationModel)
        {
            string connection = ConfigurationManager.ConnectionStrings["EnrollmentEntity"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connection))
            {
                SqlCommand cmd = new SqlCommand("Profile.spAddPatientProfile", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@FirstName", locationModel.FirstName));
                cmd.Parameters.Add(new SqlParameter("@LastName", locationModel.LastName));
                cmd.Parameters.Add(new SqlParameter("@ID_Number", locationModel.ID_Number));
                cmd.Parameters.Add(new SqlParameter("@DateOfBirth", locationModel.DateOfBirth));
                cmd.Parameters.Add(new SqlParameter("@GenderIDFK", Int32.Parse(locationModel.GenderIDFK)));

                cmd.Parameters.Add(new SqlParameter("@PhoneNumber", locationModel.PhoneNumber));
                cmd.Parameters.Add(new SqlParameter("@Email", locationModel.Email));
                cmd.Parameters.Add(new SqlParameter("@Line1", locationModel.Line1));
                cmd.Parameters.Add(new SqlParameter("@Line2", locationModel.Line2));
                cmd.Parameters.Add(new SqlParameter("@CityIDFK", Int32.Parse(locationModel.CityIDFK)));

                cmd.Parameters.Add(new SqlParameter("@ProvinceIDFK", Int32.Parse(locationModel.ProvinceIDFK)));
                cmd.Parameters.Add(new SqlParameter("@CountryIDFK", Int32.Parse(locationModel.CountryIDFK)));
                cmd.Parameters.Add(new SqlParameter("@MaritalStatusIDFK", Int32.Parse(locationModel.MaritalStatusIDFK)));
                cmd.Parameters.Add(new SqlParameter("@MedicationList", locationModel.MedicationList));
                cmd.Parameters.Add(new SqlParameter("@EmergencyName", locationModel.EmergencyName));

                cmd.Parameters.Add(new SqlParameter("@EmergencyLastName", locationModel.EmergencyLastName));
                cmd.Parameters.Add(new SqlParameter("@EmergencyPhoneNumber", locationModel.EmergencyPhoneNumber));
                cmd.Parameters.Add(new SqlParameter("@Relationship", locationModel.Relationship));
                cmd.Parameters.Add(new SqlParameter("@EmergancyDateOfBirth", locationModel.EmergancyDateOfBirth));


                cmd.Parameters.Add(new SqlParameter("@Message", SqlDbType.VarChar.ToString())).Direction = ParameterDirection.Output;

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