using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Engine.BO
{
    [Serializable]
    public class User : BaseBo
    {
        public string UserName { get; set; }
        public string Password { get; set; }
       
        public string Name { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }

        public string FullName { get { return Name + " " + LastName; } }

        public string NoEmpleado { get; set; }

        public string NetworkAccount { get; set; }
    }
}
