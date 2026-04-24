using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;    
using System.Data;
using Binding;
using System.Net.Mail;
using static FoxHunt.ApexChart;
using System.Web.Script.Serialization;

using iTextSharp.text.pdf;
using iTextSharp.text.pdf.parser;
using System.Text.RegularExpressions;
using System.IO;
using System.Text;
using HtmlAgilityPack;
using System.Net;
using System.Net.Http;
using Newtonsoft.Json;
using System.Threading.Tasks;

namespace FoxHunt
{
    public partial class UploadBallots : BasePage
    {
        public class BallotStyle
        {
            public string StyleCode { get; set; }
            public List<string> Candidates { get; set; } = new List<string>();
        }

        public static List<string> GetDistinctCandidateNames(IEnumerable<BallotStyle> ballots)
        {
            return ballots
                .SelectMany(b => b.Candidates)
                .Select(NormalizeName)
                .Where(n => !string.IsNullOrWhiteSpace(n))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .OrderBy(n => n)
                .ToList();
        }

        public class CandidatePartyInfo
        {
            public string Name { get; set; }
            public string Party { get; set; }
            public string SourceUrl { get; set; }
        }

        public static List<string> GetTopCandidates(List<string> distinctCandidates, int count = 5)
        {
            return distinctCandidates.Take(count).ToList();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        public static CandidatePartyInfo LookupPartyAffiliation(string candidateName)
        {
            var searchName = Uri.EscapeDataString(candidateName);
            var searchUrl = $"https://ballotpedia.org/wiki/index.php?search={searchName}";

            var web = new HtmlWeb();
            var doc = web.Load(searchUrl);

            // Step 1: check if we landed on a search page
            var searchResults = doc.DocumentNode.SelectNodes("//div[contains(@class,'searchresults')]//a");

            string finalUrl;
            HtmlDocument finalDoc;

            if (searchResults != null && searchResults.Count > 0)
            {
                // Take first search result
                finalUrl = "https://ballotpedia.org" + searchResults[0].GetAttributeValue("href", "");
                finalDoc = web.Load(finalUrl);
            }
            else
            {
                // Already on candidate page
                finalUrl = searchUrl;
                finalDoc = doc;
            }

            // Step 2: find party
            var partyNode = finalDoc.DocumentNode
                .SelectSingleNode("//th[text()='Party']/following-sibling::td");

            string party = partyNode != null
                ? partyNode.InnerText.Trim()
                : "Unknown";

            return new CandidatePartyInfo
            {
                Name = candidateName,
                Party = party,
                SourceUrl = finalUrl
            };
        }

        private static string NormalizeName(string name)
        {
            return Regex.Replace(name.Trim(), @"\s+", " ");
        }

        public static List<BallotStyle> ExtractBallotsWithCandidates(Stream pdfStream, int startPage = 10)
        {
            var ballots = new Dictionary<string, BallotStyle>();

            using (var reader = new PdfReader(pdfStream))
            {
                for (int page = startPage; page <= reader.NumberOfPages; page++)
                {
                    var text = PdfTextExtractor.GetTextFromPage(
                        reader,
                        page,
                        new SimpleTextExtractionStrategy());

                    // 🔍 DEBUG: dump raw extracted text
                    var debugPath = HttpContext.Current.Server.MapPath(
                        $"~/App_Data/debug_page_{page}.txt");

                    var lines = text
                        .Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries)
                        .Select(l => l.Trim())
                        .ToList();

                    string currentBallot = null;

                    foreach (var line in lines)
                    {
                        // Ballot style codes: D0001, R0022, N0032
                        if (Regex.IsMatch(line, @"^[DRNU]\d{4}$"))
                        {
                            currentBallot = line;

                            if (!ballots.ContainsKey(currentBallot))
                            {
                                ballots[currentBallot] = new BallotStyle
                                {
                                    StyleCode = currentBallot
                                };
                            }

                            continue;
                        }

                        if (currentBallot == null)
                            continue;

                        if (LooksLikeCandidateName(line))
                        {
                            ballots[currentBallot].Candidates.Add(line);
                        }
                    }
                }
            }

            return ballots.Values.ToList();
        }


        private static bool LooksLikeCandidateName(string line)
        {
            if (line.Length < 5)
                return false;

            // Skip obvious headers
            if (line.ToUpper() == line && line.Contains(" "))
                return false;

            // Skip party labels
            if (Regex.IsMatch(line, @"\b(DEM|REP|UNA|LIB|GRE)\b"))
                return false;

            // Looks like "First Last" or "First M. Last"
            return Regex.IsMatch(line, @"^[A-Z][a-z]+(\s[A-Z]\.)?\s[A-Z][a-z]+");
        }

        protected void UploadButton_Click(object sender, EventArgs e)
        {
            if (!FileUpload1.HasFile)
                return;

            var ballots = ExtractBallotsWithCandidates(FileUpload1.FileContent);
            //var error = "";

            //All distinct "names"
            var distinctCandidates = GetDistinctCandidateNames(ballots);
            var sbC = new StringBuilder();

            sbC.Append("<h2>All Candidates (Distinct)</h2>");

            foreach (var name in distinctCandidates)
            {
                sbC.Append($"• {name}<br/>");
            }

            Output.Text = sbC.ToString();


            //Data.importToDataTable(ulFiles.fileList, error);

            //All by Ballot
            var sb = new StringBuilder();

            foreach (var ballot in ballots)
            {
                sb.Append($"<h3>Ballot {ballot.StyleCode}</h3>");

                foreach (var c in ballot.Candidates)
                {
                    sb.Append($"&nbsp;&nbsp;• {c}<br/>");
                }
            }

            Output.Text += sb.ToString();

            //returnJsAlert("File must be one of the following: .csv, .xls, .xlsx.")
            // Response.Redirect("/ProcessCandidates.aspx");
        }

    }

    
}
