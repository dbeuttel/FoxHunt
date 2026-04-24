using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.SessionState;
using System.DirectoryServices.AccountManagement;
using BaseClasses;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.IO;
using System.Web.UI.WebControls.WebParts;
using static FoxHunt.dsShare;
using System.Data.SQLite;
using System.Runtime.InteropServices.ComTypes;
using System.Net.Mail;
using System.Text;
using static System.Collections.Specialized.BitVector32;
using System.Net.NetworkInformation;
using DTIGrid;
using System.IO.Compression;
using CsvHelper;
using System.Globalization;

namespace FoxHunt
{
    public static class FuzzyMatch
    {
        public static readonly Dictionary<string, string> Synonyms = Dizionario.MasterDictionary;

        public static string FindBestMatch(
        string sourceColumn,
        IEnumerable<string> targetColumns,
        double threshold = 0.65)
        {
            if (string.IsNullOrWhiteSpace(sourceColumn) || targetColumns == null)
                return null;

            var normalizedSource = NormalizeAndTokenize(sourceColumn);

            string bestMatch = null;
            double bestScore = 0;

            foreach (var target in targetColumns)
            {
                var normalizedTarget = NormalizeAndTokenize(target);

                double score = CalculateScore(normalizedSource, normalizedTarget);

                if (score > bestScore)
                {
                    bestScore = score;
                    bestMatch = target;
                }
            }

            return bestScore >= threshold ? bestMatch : null;
        }

        // ==============================
        // 3️⃣  Normalize + Tokenize
        // ==============================
        private static List<string> NormalizeAndTokenize(string input)
        {
            var tokens = input
                .Replace("-", "_")
                .Replace(" ", "_")
                .Split(new[] { '_' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(t => NormalizeToken(t))
                .ToList();

            return tokens;
        }

        private static string NormalizeToken(string token)
        {
            token = token.ToLower()
                         .Replace(".", "")
                         .Trim();

            if (Synonyms.ContainsKey(token))
                return Synonyms[token];

            return token;
        }

        // ==============================
        // 4️⃣  Weighted Score
        // ==============================
        private static double CalculateScore(
    List<string> sourceTokens,
    List<string> targetTokens)
        {
            if (sourceTokens.Count == 0 || targetTokens.Count == 0)
                return 0;

            double score = 0;
            double maxScore = 0;

            foreach (var s in sourceTokens)
            {
                double weight = WeakTokens.Contains(s) ? 0.3 : 1.0;
                maxScore += weight;

                if (targetTokens.Contains(s))
                    score += weight;
            }

            double tokenScore = score / maxScore;

            // Bonus if one token set is mostly contained in the other
            if (sourceTokens.All(t => targetTokens.Contains(t)) ||
                targetTokens.All(t => sourceTokens.Contains(t)))
            {
                tokenScore += 0.15;
            }

            // Clamp to 1
            tokenScore = Math.Min(tokenScore, 1.0);

            return tokenScore;
        }


        // ==============================
        // 5️⃣  Levenshtein Similarity
        // ==============================
        private static double CharacterSimilarity(string a, string b)
        {
            int distance = LevenshteinDistance(a, b);
            int maxLen = Math.Max(a.Length, b.Length);

            return maxLen == 0 ? 1 : 1.0 - ((double)distance / maxLen);
        }

        private static int LevenshteinDistance(string s, string t)
        {
            if (string.IsNullOrEmpty(s)) return t?.Length ?? 0;
            if (string.IsNullOrEmpty(t)) return s.Length;

            int[,] d = new int[s.Length + 1, t.Length + 1];

            for (int i = 0; i <= s.Length; i++) d[i, 0] = i;
            for (int j = 0; j <= t.Length; j++) d[0, j] = j;

            for (int i = 1; i <= s.Length; i++)
            {
                for (int j = 1; j <= t.Length; j++)
                {
                    int cost = s[i - 1] == t[j - 1] ? 0 : 1;

                    d[i, j] = Math.Min(
                        Math.Min(d[i - 1, j] + 1,
                                 d[i, j - 1] + 1),
                        d[i - 1, j - 1] + cost);
                }
            }

            return d[s.Length, t.Length];
        }

        //Common words used in column naming that do not boost a match
        private static readonly HashSet<string> WeakTokens = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            // Common generic identifiers
            "id", "code", "number", "num", "value", "type", "flag", "status", "key", "ref", "refid",

            // Dates / timestamps
            "date", "dt", "time", "created", "updated", "modified", "deleted", "entered", "changed",

            // Descriptions / labels
            "desc", "description", "notes", "remark", "label", "title", "comment",

            // Counters / quantities
            "qty", "count", "amount", "total", "sum", "average", "avg", "min", "max",

            // Misc generic tokens
            "code", "level", "group", "category", "type", "indicator", "statusflag", "active", "inactive",

            // Boolean / flags
            "flag", "isactive", "enabled", "disabled", "yesno", "yn", "approved", "verified",

            // Index / sequence
            "seq", "sequence", "order", "sort", "position", "rank", "index",

            // Misc short words
            "num", "val", "key", "id2", "code2", "attr", "attribute", "option", "param", "parameter"
        };

    }

}
