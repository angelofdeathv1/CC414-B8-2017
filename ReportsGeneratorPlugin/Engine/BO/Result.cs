using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace Engine.BO
{
    [Serializable]
    public class Result
    {
        public string result { get; set; }
        public object data { get; set; }
        public string error { get; set; }
    }

    [Serializable]
    public class ResultXML
    {
        public string result { get; set; }
        public DataSet data { get; set; }
        public string error { get; set; }
    }
}
