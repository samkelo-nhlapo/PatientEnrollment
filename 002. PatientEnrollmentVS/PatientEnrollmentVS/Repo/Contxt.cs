using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;

namespace PatientEnrollmentVS.Repo
{
    public class Contxt : DbContext
    {
        public Contxt() : base("name = EnrollmentEntity")
        {
        }
    }
}