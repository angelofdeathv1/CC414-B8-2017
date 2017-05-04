using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml;
using System.Xml.Serialization;
using System.IO;

namespace Engine.UTIL
{
    public class Util
    {

        /// <summary>
        /// formato DD-MM-YYYY
        /// </summary>
        /// <param name="sdate"></param>
        /// <returns></returns>
        public static DateTime isDate(string sdate)
        {
            DateTime dt = DateTime.MinValue;

            try
            {
                string[] sdatesplit = sdate.Split('-');
                dt = new DateTime(Util.isInteger(sdatesplit[2]), Util.isInteger(sdatesplit[1]), Util.isInteger(sdatesplit[0]));
            }
            catch (Exception)
            {
                throw new Engine.BL.InvalidParameter("valid format dd-MM-YYYY, " + sdate + " is incorrect");
            }

            return dt;
        }

        /// <summary>
        /// formato YYYY-MM-DD
        /// </summary>
        /// <param name="sdate"></param>
        /// <returns></returns>
        public static DateTime isDate2(string sdate)
        {
            DateTime dt = DateTime.MinValue;

            try
            {
                string[] sdatesplit = sdate.Split('-');
                dt = new DateTime(Util.isInteger(sdatesplit[0]), Util.isInteger(sdatesplit[1]), Util.isInteger(sdatesplit[2]));
            }
            catch (Exception)
            {
                throw new Engine.BL.InvalidParameter("valid format YYYY-MM-DD, " + sdate + " is incorrect");
            }

            return dt;
        }

        /// <summary>
        /// formato YYYYMMDD
        /// </summary>
        /// <param name="sdate"></param>
        /// <returns></returns>
        public static DateTime isDate3(string sdate)
        {
            DateTime dt = DateTime.MinValue;

            try
            {
                string year = sdate.Substring(0, 4);
                string month = sdate.Substring(4, 2);
                string day = sdate.Substring(6);

                dt = new DateTime(Util.isInteger(year), Util.isInteger(month), Util.isInteger(day));
            }
            catch (Exception)
            {
                throw new Engine.BL.InvalidParameter("valid format YYYYMMDD, " + sdate + " is incorrect");
            }

            return dt;
        }

        public static int isInteger(string str)
        {
            int resp = 0;

            try
            {
                resp = Int32.Parse(str);
            }
            catch (Exception)
            {
                throw new Engine.BL.InvalidParameter("Invalid Number " + str);
            }

            return resp;
        }


        public static double isDouble(string str)
        {
            double resp = 0;

            try
            {
                resp = double.Parse(str);
            }
            catch (Exception)
            {
                throw new Engine.BL.InvalidParameter("Invalid Number " + str);
            }

            return resp;
        }


        public static byte[] SerializeToXml<T>(T value)
        {
            if (value == null) return null;

            MemoryStream stream = new MemoryStream();

            using (XmlWriter writer = System.Xml.XmlWriter.Create(stream))
            {
                XmlSerializerNamespaces ns = new XmlSerializerNamespaces();
                ns.Add("", "");
                XmlSerializer serializer = new System.Xml.Serialization.XmlSerializer(value.GetType());
                serializer.Serialize(writer, value, ns);
            }

            return stream.ToArray();

        }




        public static string SerializeToXML<T>(T value)
        {
            string xml = string.Empty;
            if (value == null)
            {
                return null;
            }
            using (MemoryStream stream = new MemoryStream())
            {
                using (XmlWriter writer = System.Xml.XmlWriter.Create(stream))
                {
                    XmlSerializer serializer = new System.Xml.Serialization.XmlSerializer(value.GetType());
                    serializer.Serialize(writer, value);
                }
                xml = System.Text.Encoding.UTF8.GetString(stream.ToArray());
            }
            return xml;
        }

        public static T DeserializeXML<T>(string xml)
        {
            if (string.IsNullOrEmpty(xml))
            {
                return default(T);
            }

            XmlSerializer serializer = new XmlSerializer(typeof(T));

            XmlReaderSettings settings = new XmlReaderSettings();
            // No settings need modifying here

            using (StringReader textReader = new StringReader(xml))
            {
                using (XmlReader xmlReader = XmlReader.Create(textReader, settings))
                {
                    return (T)serializer.Deserialize(xmlReader);
                }
            }
        }//method

        public static byte[] GetBytes(string str)
        {
            byte[] bytes = new byte[str.Length * sizeof(char)];
            System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
            return bytes;
        }

        public static byte[] GetBytesFromStream(Stream input)
        {
            MemoryStream memoryStream = new MemoryStream();

            input.CopyTo(memoryStream);

            return memoryStream.ToArray();

        }

        public static string GetString(byte[] bytes)
        {
            char[] chars = new char[bytes.Length / sizeof(char)];
            System.Buffer.BlockCopy(bytes, 0, chars, 0, bytes.Length);
            return new string(chars);
        }


        /// <summary>
        /// metodo generico para ordenar una lista de objetos en base al nombre de una propiedad
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="Datos">Lista de Objetos</param>
        /// <param name="PropertyName">Nombre de la Propiedad del Objeto dentro de la lista pasada como parametro</param>
        /// <param name="ascending">true si es ascendente</param>
        /// <returns></returns>
        /// Ult. Mod 20130430 FC se implemento el ordenamiento por propiedades anidadas
        public static List<T> SortList<T>(List<T> Datos, string PropertyName, bool ascending) where T : class
        {
            int nIndex=Convert.ToInt32(PropertyName);
            Comparer<T> comparer = Comparer<T>.Default;
            
            List<T> sDatos = null;
            string[] props = PropertyName.Split(',');
            bool grouping = false;
            if (props.Length > 1) grouping = true;
            string prop1 = "";
            string prop2 = "";

            //si grouping = true significa que debe ordenar primero por la columna por la que se agrupa
            //despues por la otra columna, por default el JqGrid manda concatenado por coma(,) los nombres
            //de las columnas por ejemplo "MasterDO,Serial" en este ejmplo agrupa por "MasterDO" y ordena Por "Serial"
            if (grouping)
            {
                prop1 = props[0].Split(' ')[0].Trim();
                prop2 = props[1].Trim();
            }
            else
                prop1 = PropertyName;

            try
            {
                if (ascending)
                {
                    if (grouping)
                        sDatos = Datos.OrderBy(r => GetNestedPropertyValue(r, prop1)).ThenBy(r => GetNestedPropertyValue(r, prop2)).ToList();
                    else
                        sDatos = Datos.OrderBy(r => GetNestedPropertyValue(r, prop1)).ToList();
                }
                else
                {
                    if (grouping)
                    {
                        sDatos = Datos.OrderByDescending(r => GetNestedPropertyValue(r, prop1)).ThenByDescending(r => GetNestedPropertyValue(r, prop2)).ToList();
                    }
                    else
                    {
                        /* var test = Datos[Convert.ToInt32(PropertyName)];
                         sDatos = Datos.OrderByDescending(r =>test).ToList();*/
                        sDatos = Datos.OrderByDescending(r => GetNestedPropertyValue(r, prop1)).ToList();
                    }

                }
            }
            catch (Exception exe)
            {
                throw new Exception("Sort method has failed, check If Property Name [" + PropertyName + "] exist in " + Datos[0].GetType().FullName + ", --> " + exe.Message);
            }
            return sDatos;
        }//method

        public static object GetNestedPropertyValue(object obj, string property)
        {
            if (string.IsNullOrEmpty(property)) return string.Empty;
            /*var test = (List<Object>)obj;
            var test1 = test[Int32.Parse(property)];*/

            var propertyNames = property.Split('.');

            foreach (var propName in propertyNames)
            {
                if (obj == null) return string.Empty;

                Type type = obj.GetType();

                System.Reflection.PropertyInfo propInfo = type.GetProperty(propName);

                if (propInfo == null) return string.Empty;

                obj = propInfo.GetValue(obj, null);

            }

            return obj;
        }

        public static bool IsStringHtmlValid(string strToCheck)
        {
            System.Text.RegularExpressions.Regex oTextPattern = new System.Text.RegularExpressions.Regex("[^a-zA-Z0-9. ,*#`-]");
            return !oTextPattern.IsMatch(strToCheck);
        }

    }
}
