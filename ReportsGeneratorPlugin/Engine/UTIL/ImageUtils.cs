using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Engine.UTIL
{
    public class ImageUtils
    {



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
            return ImageToByte(CreateThumbnail(lcFilename, lnWidth, lnHeight));
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
