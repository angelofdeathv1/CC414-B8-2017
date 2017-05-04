using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Engine.BO
{
    [Serializable]
   public class Status
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }
}
