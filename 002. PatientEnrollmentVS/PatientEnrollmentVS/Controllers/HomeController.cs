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
                
                //Sending parameters values to the stored procedure 
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


                cmd.Parameters.Add(new SqlParameter("@Message", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;

                conn.Open();
                cmd.ExecuteNonQuery();
                
                if(Convert.ToString(cmd.Parameters["@Message"].Value) == "")
                {
                    conn.Close();
                }
                else
                {
                    locationModel.Message = Convert.ToString(cmd.Parameters["@Message"].Value);
                }

            }
            return new JsonResult { Data = locationModel, JsonRequestBehavior = JsonRequestBehavior.AllowGet };

        }

        [HttpGet]
        public JsonResult GetPatient(string IDnumber = "")
        {
            GetPatientModel locationModel = new GetPatientModel();

            string conn = ConfigurationManager.ConnectionStrings["EnrollmentEntity"].ConnectionString;

            using(SqlConnection connection = new SqlConnection(conn))
            {
                SqlCommand cmd = new SqlCommand("Profile.spGetPatient", connection);
                cmd.CommandType = CommandType.StoredProcedure;
                
                //input 
                cmd.Parameters.Add(new SqlParameter("@IDNumber", IDnumber));
                
                //output
                cmd.Parameters.Add(new SqlParameter("@FirstName", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@LastName", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@ID_Number", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@DateOfBirth", SqlDbType.DateTime)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@GenderIDFK", SqlDbType.Int)).Direction = ParameterDirection.Output;

                cmd.Parameters.Add(new SqlParameter("@PhoneNumber", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@Line1", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@Line2", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@CityIDFK", SqlDbType.Int)).Direction = ParameterDirection.Output;

                cmd.Parameters.Add(new SqlParameter("@ProvinceIDFK", SqlDbType.Int)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@CountryIDFK", SqlDbType.Int)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@MaritalStatusIDFK", SqlDbType.Int)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@MedicationList", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@EmergencyName", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;

                cmd.Parameters.Add(new SqlParameter("@EmergencyLastName", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@EmergencyPhoneNumber", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@Relationship", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;
                cmd.Parameters.Add(new SqlParameter("@EmergancyDateOfBirth", SqlDbType.VarChar, 250)).Direction = ParameterDirection.Output;

                cmd.Parameters.Add(new SqlParameter("@Message", SqlDbType.VarChar.ToString())).Direction = ParameterDirection.Output;

                try
                {
                    connection.Open();
                    cmd.ExecuteNonQuery();

                    if(Convert.ToString(cmd.Parameters["@Message"].Value) == "")
                    {
                        //Store output parameter value in variables
                        locationModel.IDNumber = Convert.ToString(cmd.Parameters["@IDNumber"].Value);
                        locationModel.FirstName = Convert.ToString(cmd.Parameters["@FirstName"].Value);
                        locationModel.LastName = Convert.ToString(cmd.Parameters["@LastName"].Value);
                        locationModel.ID_Number = Convert.ToString(cmd.Parameters["@ID_Number"].Value);
                        locationModel.DateOfBirth = Convert.ToDateTime(cmd.Parameters["@DateOfBirth"].Value);

                        locationModel.GenderIDFK = Convert.ToInt32(cmd.Parameters["@GenderIDFK"].Value);
                        locationModel.PhoneNumber = Convert.ToString(cmd.Parameters["@PhoneNumber"].Value);
                        locationModel.Email = Convert.ToString(cmd.Parameters["@Email"].Value);
                        locationModel.Line1 = Convert.ToString(cmd.Parameters["@Line1"].Value);

                        locationModel.Line2 = Convert.ToString(cmd.Parameters["@Line2"].Value);
                        locationModel.CityIDFK = Convert.ToInt32(cmd.Parameters["@CityIDFK"].Value);
                        locationModel.ProvinceIDFK = Convert.ToInt32(cmd.Parameters["@ProvinceIDFK"].Value);
                        locationModel.CountryIDFK = Convert.ToInt32(cmd.Parameters["@CountryIDFK"].Value);

                        locationModel.MaritalStatusIDFK = Convert.ToInt32(cmd.Parameters["@MaritalStatusIDFK"].Value);
                        locationModel.MedicationList = Convert.ToString(cmd.Parameters["@MedicationList"].Value);
                        locationModel.EmergencyName = Convert.ToString(cmd.Parameters["@EmergencyName"].Value);
                        locationModel.EmergencyLastName = Convert.ToString(cmd.Parameters["@EmergencyLastName"].Value);

                        locationModel.EmergencyPhoneNumber = Convert.ToString(cmd.Parameters["@EmergencyPhoneNumber"].Value);
                        locationModel.Relationship = Convert.ToString(cmd.Parameters["@Relationship"].Value);
                        locationModel.EmergancyDateOfBirth = Convert.ToDateTime(cmd.Parameters["@EmergancyDateOfBirth"].Value);

                        locationModel.Message = "";

                    }
                    else
                    {
                        locationModel.IDNumber = IDnumber;
                        locationModel.FirstName = "";
                        locationModel.LastName = "";
                        locationModel.ID_Number = "";
                        locationModel.DateOfBirth = DateTime.Now;
                        locationModel.GenderIDFK = 0;
                        locationModel.PhoneNumber = "";
                        locationModel.Email = "";
                        locationModel.Line1 = "";
                        locationModel.Line2 = "";
                        locationModel.CityIDFK = 0;
                        locationModel.ProvinceIDFK = 0;
                        locationModel.CountryIDFK = 0;
                        locationModel.MaritalStatusIDFK = 0;
                        locationModel.MedicationList = "";
                        locationModel.EmergencyName = "";
                        locationModel.EmergencyLastName = "";
                        locationModel.EmergencyPhoneNumber = "";
                        locationModel.Relationship = "";
                        locationModel.EmergancyDateOfBirth = DateTime.Now;
                    }

                }
                catch (Exception e)
                {

                    Console.WriteLine(e.Message);
                }
                finally
                {
                    connection.Close();
                }

                return new JsonResult { Data = locationModel, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
            }
        }

        public static Contxt GetContxt()
        {
            return new Contxt();
        }
    }
}