using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace Engine.BO
{
    [Serializable]
    public class BaseBo
    {
        public string Id { get; set; }
        public string Code { get; set; }

        public DateTime created_on { get; set; }
        public string created_by { get; set; }
        public Status status { get; set; }

        public DateTime updated_on { get; set; }
        public string updated_by { get; set; }

        public object GetClone()
        {
            BinaryFormatter bf = new BinaryFormatter();
            MemoryStream ms = new MemoryStream();
            bf.Serialize(ms, this);
            ms.Flush();
            ms.Position = 0;
            return bf.Deserialize(ms);
        }
    }
}
