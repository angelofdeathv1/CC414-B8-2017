using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Engine.UTIL
{
    public class Tool
    {
        public static string ToLowerReplaceBlank(string str)
        {
            return str.ToLower().Replace(" ", "_");
        }

        /// formato MM-dd-YYYY
        /// </summary>
        /// <param name="sdate"></param>
        /// <returns></returns>
        public static DateTime isDate(string sdate)
        {
            DateTime dt = DateTime.MinValue;

            try
            {
                string[] sdatesplit = sdate.Split('-');
                dt = new DateTime(Tool.isInteger(sdatesplit[2]), Tool.isInteger(sdatesplit[0]), Tool.isInteger(sdatesplit[1]));
            }
            catch (Exception)
            {
                throw new Engine.BL.InvalidParameter("valid format MM-dd-YYYY, " + sdate + " is incorrect");
            }

            return dt;
        }


        /// formato MM-dd-YYYY hh:mm AM
        /// </summary>
        /// <param name="sdate"></param>
        /// <returns></returns>
        public static DateTime isDateTimeAMPM(string sdatetime)
        {
            DateTime dt = DateTime.MinValue;

            try
            {
                string sdate = sdatetime.Substring(0, 10);
                dt = Tool.isDate(sdate);

                string stime = sdatetime.Substring(11, 5);
                string ampm = sdatetime.Substring(17).ToUpper();

                string[] stimesplit = stime.Split(':');
                int ihr = Tool.isInteger(stimesplit[0]);

                if (ihr <= 0 || ihr > 12) throw new Exception("invalid hours range");

                if (ampm != "AM" && ampm != "PM") throw new Exception("invalid time period must be AM or PM");

                if (ihr + ampm == "12AM") ihr = 0; //si son las 12AM = 00hrs
                else
                    if (ihr + ampm == "12PM") ihr = 12;//si son las 12PM = 12hrs
                    else
                        ihr = (ampm == "PM" ? 12 : 0) + ihr;//si AMPM == PM se suman 12 Hrs

                int imin = Tool.isInteger(stimesplit[1]);

                if (imin < 0 || imin > 59) throw new Exception("invalid minutes range");

                dt = dt.AddHours(ihr).AddMinutes(imin);

            }
            catch (Exception)
            {
                throw new Engine.BL.InvalidParameter("valid format MM-dd-YYYY hh:mm AM, " + sdatetime + " is incorrect");
            }

            return dt;
        }

        /// formato MM-dd-YYYY hh:mm
        /// </summary>
        /// <param name="sdate">12-31-9999 23:59</param>
        /// <returns></returns>
        public static DateTime isDateTime24H(string sdatetime)
        {
            DateTime dt = DateTime.MinValue;

            try
            {
                string sdate = sdatetime.Substring(0, 10);

                dt = Tool.isDate(sdate);

                string stime = sdatetime.Substring(11, 5);

                string[] stimesplit = stime.Split(':');
                int ihr = Tool.isInteger(stimesplit[0]);

                if (ihr < 0 || ihr > 23) throw new Exception("invalid hours range");

                int imin = Tool.isInteger(stimesplit[1]);

                if (imin < 0 || imin > 59) throw new Exception("invalid minutes range");

                dt = dt.AddHours(ihr).AddMinutes(imin);

            }
            catch (Exception)
            {
                throw new Engine.BL.InvalidParameter("valid format MM-dd-YYYY hh24:mm, " + sdatetime + " is incorrect");
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
                throw new Engine.BL.InvalidParameter("Numero invalido " + str + " solo digitos 0-9");
            }

            return resp;
        }

/*
        public void ResizeImage(string FileName, int lnWidth, int lnHeight)
    {

        System.Drawing.Image FullsizeImage = System.Drawing.Image.FromFile(FileName);
        FullsizeImage.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
        FullsizeImage.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);


        int NewWidth = FullsizeImage.Width;
        int NewHeight = FullsizeImage.Height;


        //*** If the image is smaller than a thumbnail just return it
        if (NewWidth < lnWidth && loBMP.Height < lnHeight)
            return loBMP;

        if (loBMP.Width > loBMP.Height)
        {
            lnRatio = (decimal)lnWidth / loBMP.Width;
            lnNewWidth = lnWidth;
            decimal lnTemp = loBMP.Height * lnRatio;
            lnNewHeight = (int)lnTemp;
        }
        else
        {
            lnRatio = (decimal)lnHeight / loBMP.Height;
            lnNewHeight = lnHeight;
            decimal lnTemp = loBMP.Width * lnRatio;
            lnNewWidth = (int)lnTemp;
        }



        if (FullsizeImage.Width > 450)
        {
            NewWidth = 450;
            NewHeight = 300;//regal de 3
        }

        if (FullsizeImage.Height > 450)
        {
            NewHeight = 450;
            NewWidth =600;// regal de 3
        }

        System.Drawing.Image NewImage = FullsizeImage.GetThumbnailImage(NewWidth, NewHeight, null, IntPtr.Zero);
        // Clear handle to original file so that we can overwrite it if necessary
        FullsizeImage.Dispose();

        // Save resized picture
        NewImage.Save(FileName);

        }
        */
        public static byte[] ImageToByte(System.Drawing.Image img)
        {
            System.Drawing.ImageConverter converter = new System.Drawing.ImageConverter();
            return (byte[])converter.ConvertTo(img, typeof(byte[]));
        }

        public static byte[] CreateThumbnail2(string lcFilename, int lnWidth, int lnHeight)
        {
            return ImageToByte(CreateThumbnail( lcFilename,  lnWidth,  lnHeight));
        }

        public static System.Drawing.Bitmap CreateThumbnail(string lcFilename, int lnWidth, int lnHeight)
        {
            System.Drawing.Bitmap bmpOut = null;
            
                using (System.Drawing.Bitmap loBMP = new System.Drawing.Bitmap(lcFilename))
                {
                    System.Drawing.Imaging.ImageFormat loFormat = loBMP.RawFormat;

                    decimal lnRatio;
                    int lnNewWidth = 0;
                    int lnNewHeight = 0;

                    //*** If the image is smaller than a thumbnail just return it
                    /* if (loBMP.Width < lnWidth && loBMP.Height < lnHeight)
                         return loBMP;
                    
                     if (loBMP.Width > loBMP.Height)
                     {
                         lnRatio = (decimal)lnWidth / loBMP.Width;
                         lnNewWidth = lnWidth;
                         decimal lnTemp = loBMP.Height * lnRatio;
                         lnNewHeight = (int)lnTemp;
                     }
                     else
                     {
                         lnRatio = (decimal)lnHeight / loBMP.Height;
                         lnNewHeight = lnHeight;
                         decimal lnTemp = loBMP.Width * lnRatio;
                         lnNewWidth = (int)lnTemp;
                     }
                     */
                    lnNewWidth = lnWidth;
                    lnNewHeight = lnHeight;

                    bmpOut = new System.Drawing.Bitmap(lnNewWidth, lnNewHeight);
                    System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(bmpOut);
                    g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                    g.FillRectangle(System.Drawing.Brushes.White, 0, 0, lnNewWidth, lnNewHeight);
                    g.DrawImage(loBMP, 0, 0, lnNewWidth, lnNewHeight);

                }
            

            return bmpOut;
        }



    }
}
