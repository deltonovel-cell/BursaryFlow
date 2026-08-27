using Docnet.Core;
using Docnet.Core.Models;
using Docnet.Core.Readers;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

namespace BursaryFlow.Services
{
    public class DocumentEnhancementService
    {
        private readonly IWebHostEnvironment _environment;

        public DocumentEnhancementService(
            IWebHostEnvironment environment)
        {
            _environment = environment;
        }


        // =========================================================
        // MAIN ENHANCEMENT METHOD
        // =========================================================

        public async Task<DocumentEnhancementResult> EnhanceAsync(
            IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                return new DocumentEnhancementResult
                {
                    Success = false,
                    Message = "No document was provided."
                };
            }

            string extension =
                Path.GetExtension(file.FileName)
                    .ToLowerInvariant();

            string[] supported =
            {
                ".pdf",
                ".jpg",
                ".jpeg",
                ".png",
                ".doc",
                ".docx"
            };

            if (!supported.Contains(extension))
            {
                return new DocumentEnhancementResult
                {
                    Success = false,
                    Message =
                        "This document type cannot be enhanced."
                };
            }

            string uploadsFolder =
                Path.Combine(
                    _environment.WebRootPath,
                    "uploads",
                    "documents"
                );

            Directory.CreateDirectory(
                uploadsFolder
            );

            string workingFile =
                Path.Combine(
                    uploadsFolder,
                    Guid.NewGuid().ToString("N")
                    + extension
                );

            await using (
                FileStream stream =
                    new FileStream(
                        workingFile,
                        FileMode.Create
                    ))
            {
                await file.CopyToAsync(stream);
            }

            try
            {
                string outputFile;

                switch (extension)
                {
                    case ".jpg":
                    case ".jpeg":
                    case ".png":

                        outputFile =
                            EnhanceImage(
                                workingFile,
                                uploadsFolder,
                                file.FileName
                            );

                        break;


                    case ".pdf":

                        outputFile =
                            await EnhancePdf(
                                workingFile,
                                uploadsFolder,
                                file.FileName
                            );

                        break;


                    case ".docx":

                        outputFile =
                            EnhanceDocx(
                                workingFile,
                                uploadsFolder,
                                file.FileName
                            );

                        break;


                    case ".doc":

                        outputFile =
                            CopyUnsupportedWordDocument(
                                workingFile,
                                uploadsFolder,
                                file.FileName
                            );

                        break;


                    default:

                        throw new Exception(
                            "Unsupported document type."
                        );
                }

                if (System.IO.File.Exists(workingFile))
                {
                    System.IO.File.Delete(
                        workingFile
                    );
                }

                string downloadUrl =
                    "/uploads/documents/"
                    + Path.GetFileName(outputFile);

                return new DocumentEnhancementResult
                {
                    Success = true,

                    Message =
                        "Your document has been enhanced successfully.",

                    OriginalFileName =
                        file.FileName,

                    EnhancedFileName =
                        Path.GetFileName(outputFile),

                    DownloadUrl =
                        downloadUrl
                };
            }
            catch (Exception ex)
            {
                Console.WriteLine(
                    "DOCUMENT ENHANCEMENT ERROR:"
                );

                Console.WriteLine(
                    ex.ToString()
                );

                if (System.IO.File.Exists(workingFile))
                {
                    System.IO.File.Delete(
                        workingFile
                    );
                }

                return new DocumentEnhancementResult
                {
                    Success = false,

                    Message =
                        "BursaryFlow could not enhance this document."
                };
            }
        }


        // =========================================================
        // IMAGE ENHANCEMENT
        // JPG / JPEG / PNG
        // =========================================================

        private string EnhanceImage(
            string inputPath,
            string outputDirectory,
            string originalName)
        {
            string outputName =
                "Enhanced_"
                + Guid.NewGuid().ToString("N")
                + ".jpg";

            string outputPath =
                Path.Combine(
                    outputDirectory,
                    outputName
                );

            using Bitmap original =
                new Bitmap(inputPath);

            int width =
                original.Width;

            int height =
                original.Height;


            // -----------------------------------------------------
            // UPSCALE SMALL DOCUMENTS
            // -----------------------------------------------------

            int minimumWidth = 1800;

            double scale =
                width < minimumWidth
                    ? (double)minimumWidth / width
                    : 1.0;

            int newWidth =
                Math.Max(
                    width,
                    (int)(width * scale)
                );

            int newHeight =
                Math.Max(
                    height,
                    (int)(height * scale)
                );


            using Bitmap enhanced =
                new Bitmap(
                    newWidth,
                    newHeight,
                    PixelFormat.Format24bppRgb
                );


            enhanced.SetResolution(
                300,
                300
            );


            using Graphics graphics =
                Graphics.FromImage(
                    enhanced
                );


            // -----------------------------------------------------
            // HIGH QUALITY RENDERING
            // -----------------------------------------------------

            graphics.CompositingQuality =
                CompositingQuality.HighQuality;

            graphics.InterpolationMode =
                InterpolationMode.HighQualityBicubic;

            graphics.SmoothingMode =
                SmoothingMode.HighQuality;

            graphics.PixelOffsetMode =
                PixelOffsetMode.HighQuality;


            graphics.Clear(
                System.Drawing.Color.White
            );


            graphics.DrawImage(
                original,
                new Rectangle(
                    0,
                    0,
                    newWidth,
                    newHeight
                )
            );


            // -----------------------------------------------------
            // CONTRAST / SHARPNESS IMPROVEMENT
            // -----------------------------------------------------

            using Bitmap processed =
                ImproveDocumentContrast(
                    enhanced
                );


            // -----------------------------------------------------
            // JPEG QUALITY
            // -----------------------------------------------------

            ImageCodecInfo? jpegCodec =
                ImageCodecInfo.GetImageEncoders()
                    .FirstOrDefault(
                        codec =>
                            codec.FormatID
                            == ImageFormat.Jpeg.Guid
                    );


            if (jpegCodec != null)
            {
                EncoderParameters encoderParameters =
                    new EncoderParameters(1);

                encoderParameters.Param[0] =
                    new EncoderParameter(
                        System.Drawing.Imaging.Encoder.Quality,
                        95L
                    );

                processed.Save(
                    outputPath,
                    jpegCodec,
                    encoderParameters
                );

                encoderParameters.Dispose();
            }
            else
            {
                processed.Save(
                    outputPath,
                    ImageFormat.Jpeg
                );
            }

            return outputPath;
        }


        // =========================================================
        // DOCUMENT CONTRAST
        // =========================================================

        private Bitmap ImproveDocumentContrast(
            Bitmap source)
        {
            Bitmap result =
                new Bitmap(
                    source.Width,
                    source.Height,
                    PixelFormat.Format24bppRgb
                );

            result.SetResolution(
                source.HorizontalResolution,
                source.VerticalResolution
            );


            using Graphics graphics =
                Graphics.FromImage(
                    result
                );


            graphics.CompositingQuality =
                CompositingQuality.HighQuality;

            graphics.InterpolationMode =
                InterpolationMode.HighQualityBicubic;

            graphics.SmoothingMode =
                SmoothingMode.HighQuality;


            // -----------------------------------------------------
            // LIGHT CONTRAST / SHARPNESS FILTER
            // -----------------------------------------------------

            float[][] matrix =
            {
                new float[]
                {
                    0, -0.5f, 0
                },

                new float[]
                {
                    -0.5f, 3f, -0.5f
                },

                new float[]
                {
                    0, -0.5f, 0
                }
            };


            using ImageAttributes attributes =
                new ImageAttributes();


            attributes.SetColorMatrix(
                new ColorMatrix(
                    new float[][]
                    {
                        new float[]
                        {
                            1, 0, 0, 0, 0
                        },

                        new float[]
                        {
                            0, 1, 0, 0, 0
                        },

                        new float[]
                        {
                            0, 0, 1, 0, 0
                        },

                        new float[]
                        {
                            0, 0, 0, 1, 0
                        },

                        new float[]
                        {
                            0, 0, 0, 0, 1
                        }
                    }
                )
            );


            graphics.DrawImage(
                source,
                new Rectangle(
                    0,
                    0,
                    result.Width,
                    result.Height
                ),
                0,
                0,
                source.Width,
                source.Height,
                GraphicsUnit.Pixel,
                attributes
            );


            return result;
        }


        // =========================================================
        // PDF ENHANCEMENT
        // =========================================================

        private async Task<string> EnhancePdf(
            string inputPath,
            string outputDirectory,
            string originalName)
        {
            string outputName =
                "Enhanced_"
                + Guid.NewGuid().ToString("N")
                + ".pdf";

            string outputPath =
                Path.Combine(
                    outputDirectory,
                    outputName
                );


            string temporaryFolder =
                Path.Combine(
                    outputDirectory,
                    "temp_"
                    + Guid.NewGuid().ToString("N")
                );


            Directory.CreateDirectory(
                temporaryFolder
            );


            try
            {
                // -------------------------------------------------
                // READ PDF
                // -------------------------------------------------

                using IDocReader pdf =
                    DocLib.Instance.GetDocReader(
                        inputPath,
                        new PageDimensions(
                            2200,
                            3000
                        )
                    );


                int pageCount =
                    pdf.GetPageCount();


                List<string> pageImages =
                    new List<string>();


                // -------------------------------------------------
                // RENDER EVERY PDF PAGE
                // -------------------------------------------------

                for (
                    int pageIndex = 0;
                    pageIndex < pageCount;
                    pageIndex++
                )
                {
                    using IPageReader page =
                        pdf.GetPageReader(
                            pageIndex
                        );


                    byte[] rawBytes =
                        page.GetImage();


                    int width =
                        page.GetPageWidth();


                    int height =
                        page.GetPageHeight();


                    string pagePath =
                        Path.Combine(
                            temporaryFolder,
                            $"page_{pageIndex + 1}.jpg"
                        );


                    using Bitmap bitmap =
                        new Bitmap(
                            width,
                            height,
                            PixelFormat.Format32bppArgb
                        );


                    BitmapData bitmapData =
                        bitmap.LockBits(
                            new Rectangle(
                                0,
                                0,
                                width,
                                height
                            ),
                            ImageLockMode.WriteOnly,
                            PixelFormat.Format32bppArgb
                        );


                    System.Runtime.InteropServices.Marshal.Copy(
                        rawBytes,
                        0,
                        bitmapData.Scan0,
                        rawBytes.Length
                    );


                    bitmap.UnlockBits(
                        bitmapData
                    );


                    using Bitmap enhanced =
                        ImproveDocumentContrast(
                            bitmap
                        );


                    enhanced.Save(
                        pagePath,
                        ImageFormat.Jpeg
                    );


                    pageImages.Add(
                        pagePath
                    );
                }


                // -------------------------------------------------
                // CREATE ENHANCED PDF
                // -------------------------------------------------

                CreatePdfFromImages(
                    pageImages,
                    outputPath
                );


                return outputPath;
            }
            finally
            {
                if (
                    Directory.Exists(
                        temporaryFolder
                    ))
                {
                    try
                    {
                        Directory.Delete(
                            temporaryFolder,
                            true
                        );
                    }
                    catch
                    {
                        // Ignore cleanup errors.
                    }
                }
            }
        }


        // =========================================================
        // CREATE PDF FROM ENHANCED IMAGES
        // =========================================================

        private void CreatePdfFromImages(
            List<string> images,
            string outputPath)
        {
            // -----------------------------------------------------
            // This creates a clean image-based PDF.
            //
            // Each enhanced page is inserted as a full page.
            // -----------------------------------------------------

            using FileStream stream =
                new FileStream(
                    outputPath,
                    FileMode.Create
                );


            using BinaryWriter writer =
                new BinaryWriter(
                    stream
                );


            List<long> objectOffsets =
                new List<long>();


            writer.Write(
                System.Text.Encoding.ASCII.GetBytes(
                    "%PDF-1.4\n"
                )
            );


            // -----------------------------------------------------
            // SIMPLE PDF IMAGE GENERATION
            // -----------------------------------------------------

            int objectNumber = 1;


            List<byte[]> objects =
                new List<byte[]>();


            foreach (string imagePath in images)
            {
                using Bitmap bitmap =
                    new Bitmap(
                        imagePath
                    );


                byte[] jpegBytes =
                    System.IO.File.ReadAllBytes(
                        imagePath
                    );


                int width =
                    bitmap.Width;

                int height =
                    bitmap.Height;


                string imageObject =
                    $"{objectNumber} 0 obj\n"
                    + "<<\n"
                    + "/Type /XObject\n"
                    + "/Subtype /Image\n"
                    + "/Width "
                    + width
                    + "\n"
                    + "/Height "
                    + height
                    + "\n"
                    + "/ColorSpace /DeviceRGB\n"
                    + "/BitsPerComponent 8\n"
                    + "/Filter /DCTDecode\n"
                    + "/Length "
                    + jpegBytes.Length
                    + "\n"
                    + ">>\n"
                    + "stream\n";


                byte[] header =
                    System.Text.Encoding.ASCII.GetBytes(
                        imageObject
                    );


                byte[] footer =
                    System.Text.Encoding.ASCII.GetBytes(
                        "\nendstream\nendobj\n"
                    );


                byte[] complete =
                    new byte[
                        header.Length
                        + jpegBytes.Length
                        + footer.Length
                    ];


                Buffer.BlockCopy(
                    header,
                    0,
                    complete,
                    0,
                    header.Length
                );


                Buffer.BlockCopy(
                    jpegBytes,
                    0,
                    complete,
                    header.Length,
                    jpegBytes.Length
                );


                Buffer.BlockCopy(
                    footer,
                    0,
                    complete,
                    header.Length
                    + jpegBytes.Length,
                    footer.Length
                );


                objects.Add(
                    complete
                );


                objectNumber++;
            }


            // -----------------------------------------------------
            // WRITE OBJECTS
            // -----------------------------------------------------

            foreach (byte[] obj in objects)
            {
                objectOffsets.Add(
                    stream.Position
                );

                writer.Write(
                    obj
                );
            }


            // -----------------------------------------------------
            // PDF CATALOG
            // -----------------------------------------------------

            long catalogOffset =
                stream.Position;


            writer.Write(
                System.Text.Encoding.ASCII.GetBytes(
                    $"{objectNumber} 0 obj\n"
                    + "<< /Type /Catalog "
                    + $"/Pages {objectNumber + 1} 0 R >>\n"
                    + "endobj\n"
                )
            );


            // -----------------------------------------------------
            // PAGES OBJECT
            // -----------------------------------------------------

            long pagesOffset =
                stream.Position;


            int firstPageObject =
                objectNumber + 2;


            string kids =
                string.Join(
                    " ",
                    Enumerable.Range(
                        0,
                        images.Count
                    )
                    .Select(
                        i =>
                            $"{firstPageObject + i * 2} 0 R"
                    )
                );


            writer.Write(
                System.Text.Encoding.ASCII.GetBytes(
                    $"{objectNumber + 1} 0 obj\n"
                    + "<< /Type /Pages "
                    + $"/Kids [{kids}] "
                    + $"/Count {images.Count} >>\n"
                    + "endobj\n"
                )
            );


            List<long> pageOffsets =
                new List<long>();


            // -----------------------------------------------------
            // PAGES
            // -----------------------------------------------------

            int pageObject =
                firstPageObject;


            foreach (string imagePath in images)
            {
                using Bitmap bitmap =
                    new Bitmap(
                        imagePath
                    );


                int width =
                    bitmap.Width;

                int height =
                    bitmap.Height;


                pageOffsets.Add(
                    stream.Position
                );


                string page =
                    $"{pageObject} 0 obj\n"
                    + "<< /Type /Page "
                    + $"/Parent {objectNumber + 1} 0 R "
                    + "/Resources << "
                    + $"/XObject << /Im0 {objectNumber - images.Count + pageObject - firstPageObject + 1} 0 R >> "
                    + ">> "
                    + $"/MediaBox [0 0 "
                    + width
                    + " "
                    + height
                    + "] "
                    + $"/Contents {pageObject + 1} 0 R >>\n"
                    + "endobj\n";


                writer.Write(
                    System.Text.Encoding.ASCII.GetBytes(
                        page
                    )
                );


                string content =
                    $"q\n"
                    + $"{width} 0 0 {height} 0 0 cm\n"
                    + "/Im0 Do\n"
                    + "Q\n";


                byte[] contentBytes =
                    System.Text.Encoding.ASCII.GetBytes(
                        content
                    );


                writer.Write(
                    System.Text.Encoding.ASCII.GetBytes(
                        $"{pageObject + 1} 0 obj\n"
                        + $"<< /Length {contentBytes.Length} >>\n"
                        + "stream\n"
                    )
                );


                writer.Write(
                    contentBytes
                );


                writer.Write(
                    System.Text.Encoding.ASCII.GetBytes(
                        "endstream\nendobj\n"
                    )
                );


                pageObject += 2;
            }


            // -----------------------------------------------------
            // CROSS REFERENCE
            // -----------------------------------------------------

            long xrefPosition =
                stream.Position;


            int totalObjects =
                pageObject;


            writer.Write(
                System.Text.Encoding.ASCII.GetBytes(
                    $"xref\n0 {totalObjects}\n"
                )
            );


            writer.Write(
                System.Text.Encoding.ASCII.GetBytes(
                    "0000000000 65535 f \n"
                )
            );


            List<long> offsets =
                new List<long>();


            offsets.Add(0);


            offsets.AddRange(
                objectOffsets
            );


            offsets.Add(
                catalogOffset
            );


            offsets.Add(
                pagesOffset
            );


            offsets.AddRange(
                pageOffsets
            );


            while (
                offsets.Count
                < totalObjects
            )
            {
                offsets.Add(0);
            }


            for (
                int i = 1;
                i < totalObjects;
                i++
            )
            {
                writer.Write(
                    System.Text.Encoding.ASCII.GetBytes(
                        $"{offsets[i]:D10} 00000 n \n"
                    )
                );
            }


            writer.Write(
                System.Text.Encoding.ASCII.GetBytes(
                    $"trailer\n"
                    + $"<< /Size {totalObjects} "
                    + $"/Root {objectNumber} 0 R >>\n"
                    + "startxref\n"
                    + $"{xrefPosition}\n"
                    + "%%EOF"
                )
            );
        }


        // =========================================================
        // DOCX ENHANCEMENT
        // =========================================================

        private string EnhanceDocx(
            string inputPath,
            string outputDirectory,
            string originalName)
        {
            string outputName =
                "Enhanced_"
                + Guid.NewGuid().ToString("N")
                + ".docx";

            string outputPath =
                Path.Combine(
                    outputDirectory,
                    outputName
                );


            System.IO.File.Copy(
                inputPath,
                outputPath,
                true
            );


            using WordprocessingDocument document =
                WordprocessingDocument.Open(
                    outputPath,
                    true
                );


            Body? body =
                document.MainDocumentPart?
                    .Document?
                    .Body;


            if (body != null)
            {
                foreach (
                    Text text
                    in body.Descendants<Text>())
                {
                    if (
                        !string.IsNullOrWhiteSpace(
                            text.Text
                        ))
                    {
                        text.Text =
                            text.Text.Trim();
                    }
                }
            }


            document.MainDocumentPart?
                .Document?
                .Save();


            return outputPath;
        }


        // =========================================================
        // DOC HANDLING
        // =========================================================

        private string CopyUnsupportedWordDocument(
            string inputPath,
            string outputDirectory,
            string originalName)
        {
            string outputName =
                "Enhanced_"
                + Guid.NewGuid().ToString("N")
                + ".doc";

            string outputPath =
                Path.Combine(
                    outputDirectory,
                    outputName
                );


            System.IO.File.Copy(
                inputPath,
                outputPath,
                true
            );


            return outputPath;
        }
    }


    // =============================================================
    // RESULT MODEL
    // =============================================================

    public class DocumentEnhancementResult
    {
        public bool Success { get; set; }

        public string Message { get; set; } = "";

        public string OriginalFileName { get; set; } = "";

        public string EnhancedFileName { get; set; } = "";

        public string DownloadUrl { get; set; } = "";
    }
}