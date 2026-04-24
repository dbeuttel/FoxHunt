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
using System.Web.UI.HtmlControls;

namespace FoxHunt
{
    public partial class Form : BasePage
    {
        public class QuizQuestion
        {
            public int Id { get; set; }
            public string QuestionText { get; set; }
            public string QuestionType { get; set; } // "SingleChoice", "MultiChoice", "YesNo", "ShortText", "LongText", "Number", "Checkbox"
            public List<string> Options { get; set; } // Only for dropdown or checkbox
        }

        private dsShare.CandidateRow _row;
        public dsShare.CandidateRow row
        {
            get
            {
                if (_row == null)
                {
                    dsShare.CandidateDataTable _dt = new dsShare.CandidateDataTable();
                    sqlHelper.FillDataTable("select * from Candidate where id = @id", _dt, 1);
                    if (_dt.Rows.Count > 0)
                        _row = _dt[0];
                    else
                        _row = _dt.NewCandidateRow();                                        
                }
                

                return _row;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var questions = new List<QuizQuestion>
                {
                    new QuizQuestion { Id = 1, QuestionText = "What is your favorite color?", QuestionType = "SingleChoice", Options = new List<string>{"Red","Blue","Green"} },
                    new QuizQuestion { Id = 2, QuestionText = "Select all fruits you like", QuestionType = "MultiChoice", Options = new List<string>{"Apple","Banana","Orange"} },
                    new QuizQuestion { Id = 3, QuestionText = "Do you like coding?", QuestionType = "YesNo" },
                    new QuizQuestion { Id = 4, QuestionText = "Describe your experience", QuestionType = "LongText" },
                    new QuizQuestion { Id = 5, QuestionText = "Enter your age", QuestionType = "Number" },
                    new QuizQuestion { Id = 5, QuestionText = "Did you complete the form", QuestionType = "Checkbox" }
                };


                FormBuilder.dsShareForms.FormQuestionDataTable dtQuestions = new FormBuilder.dsShareForms.FormQuestionDataTable();
                sqlHelper.FillDataTable("select * from FormQuestion ORDER by sortOrder", dtQuestions);
                if (dtQuestions.Count < 1)
                {
                    foreach (var issue in questions)
                    {
                        FormBuilder.dsShareForms.FormQuestionRow r = dtQuestions.NewFormQuestionRow();
                        r.QuestionText = issue.QuestionText;
                        r.QuestionType = issue.QuestionType;
                        if(issue.Options != null)
                            r.Options = string.Join(",", issue.Options);
                        dtQuestions.AddFormQuestionRow(r);
                    }
                    sqlHelper.Update(dtQuestions);
                }


                rptQuestions.DataSource = dtQuestions.Rows;
                rptQuestions.DataBind();
            }
        }

        protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var question = (FormBuilder.dsShareForms.FormQuestionRow)e.Item.DataItem;

                // Hide all inputs initially
                ((DropDownList)e.Item.FindControl("ddlSingleChoice")).Visible = false;
                ((ListBox)e.Item.FindControl("lstMultiChoice")).Visible = false;
                //((ListBox)e.Item.FindControl("rblYesNo")).Visible = false;
                ((TextBox)e.Item.FindControl("txtShort")).Visible = false;
                ((TextBox)e.Item.FindControl("txtLong")).Visible = false;
                ((TextBox)e.Item.FindControl("txtNumber")).Visible = false;
                ((CheckBox)e.Item.FindControl("chkCompletion")).Visible = false;

                // Attach QuestionID to controls via Attributes
                ((DropDownList)e.Item.FindControl("ddlSingleChoice")).Attributes["data-questionid"] = question.ID.ToString();
                ((ListBox)e.Item.FindControl("lstMultiChoice")).Attributes["data-questionid"] = question.ID.ToString();
                //((ListBox)e.Item.FindControl("rblYesNo")).Attributes["data-questionid"] = question.ID.ToString();
                ((TextBox)e.Item.FindControl("txtShort")).Attributes["data-questionid"] = question.ID.ToString();
                ((TextBox)e.Item.FindControl("txtLong")).Attributes["data-questionid"] = question.ID.ToString();
                ((TextBox)e.Item.FindControl("txtNumber")).Attributes["data-questionid"] = question.ID.ToString();
                ((CheckBox)e.Item.FindControl("chkCompletion")).Attributes["data-questionid"] = question.ID.ToString();


                // Bootstrap Yes/No div
                var yesNoDiv = (HtmlGenericControl)e.Item.FindControl("yesnoButtons");
                string[] options = new string[0];

                if (!question.IsOptionsNull())
                {
                    options = question.Options.Split(',');
                }


                switch (question.QuestionType)
                {
                    case "SingleChoice":
                        var ddl = (DropDownList)e.Item.FindControl("ddlSingleChoice");
                        ddl.DataSource = options;
                        ddl.DataBind();
                        ddl.Visible = true;
                        break;

                    case "MultiChoice":
                        var lst = (ListBox)e.Item.FindControl("lstMultiChoice");
                        lst.DataSource = options;
                        lst.DataBind();
                        lst.Visible = true;
                        break;

                    case "YesNo":
                        var lstYesNo = (ListBox)e.Item.FindControl("lstYesNo");
                        lstYesNo.Attributes["data-questionid"] = question.ID.ToString();
                        lstYesNo.Items.Clear();
                        lstYesNo.Items.Add(new ListItem("Yes", "Yes"));
                        lstYesNo.Items.Add(new ListItem("No", "No"));
                        lstYesNo.Visible = true;
                        break;

                    case "ShortText":
                        e.Item.FindControl("txtShort").Visible = true;
                        break;

                    case "LongText":
                        e.Item.FindControl("txtLong").Visible = true;
                        break;

                    case "Number":
                        e.Item.FindControl("txtNumber").Visible = true;
                        break;

                    case "Checkbox":
                        var chk = (CheckBox)e.Item.FindControl("chkCompletion");
                        chk.Visible = true;
                        break;
                }
            }
        }



        public class QuizAnswer
        {
            public int QuestionId { get; set; }
            public string Answer { get; set; } // Use comma-separated for multi-choice or checkboxes
        }


        protected List<QuizAnswer> SaveQuizResponses()
        {
            var responses = new List<QuizAnswer>();

            foreach (RepeaterItem item in rptQuestions.Items)
            {
                if (item.ItemType != ListItemType.Item && item.ItemType != ListItemType.AlternatingItem)
                    continue;

                int qid = 0;
                string answer = "";

                // SingleChoice
                var ddl = item.FindControl("ddlSingleChoice") as DropDownList;
                if (ddl != null && ddl.Visible)
                {
                    qid = int.Parse(ddl.Attributes["data-questionid"]);
                    answer = ddl.SelectedValue;
                    responses.Add(new QuizAnswer { QuestionId = qid, Answer = answer });
                    continue;
                }

                // MultiChoice
                var lst = item.FindControl("lstMultiChoice") as ListBox;
                if (lst != null && lst.Visible)
                {
                    qid = int.Parse(lst.Attributes["data-questionid"]);
                    var selected = lst.Items.Cast<ListItem>().Where(li => li.Selected).Select(li => li.Value);
                    answer = string.Join(",", selected);
                    responses.Add(new QuizAnswer { QuestionId = qid, Answer = answer });
                    continue;
                }

                // Yes/No
                var lstYesNo = item.FindControl("lstYesNo") as ListBox;
                if (lstYesNo != null && lstYesNo.Visible)
                {
                    qid = int.Parse(lstYesNo.Attributes["data-questionid"]);
                    answer = lstYesNo.SelectedItem != null ? lstYesNo.SelectedItem.Value : "";
                    responses.Add(new QuizAnswer { QuestionId = qid, Answer = answer });
                    continue;
                }



                // ShortText
                var txtShort = item.FindControl("txtShort") as TextBox;
                if (txtShort != null && txtShort.Visible)
                {
                    qid = int.Parse(txtShort.Attributes["data-questionid"]);
                    answer = txtShort.Text;
                    responses.Add(new QuizAnswer { QuestionId = qid, Answer = answer });
                    continue;
                }

                // LongText
                var txtLong = item.FindControl("txtLong") as TextBox;
                if (txtLong != null && txtLong.Visible)
                {
                    qid = int.Parse(txtLong.Attributes["data-questionid"]);
                    answer = txtLong.Text;
                    responses.Add(new QuizAnswer { QuestionId = qid, Answer = answer });
                    continue;
                }

                // Number
                var txtNumber = item.FindControl("txtNumber") as TextBox;
                if (txtNumber != null && txtNumber.Visible)
                {
                    qid = int.Parse(txtNumber.Attributes["data-questionid"]);
                    answer = txtNumber.Text;
                    responses.Add(new QuizAnswer { QuestionId = qid, Answer = answer });
                    continue;
                }

                // Checkbox
                var chk = item.FindControl("chkCompletion") as CheckBox;
                if (chk != null && chk.Visible)
                {
                    qid = int.Parse(chk.Attributes["data-questionid"]);
                    answer = chk.Checked ? "Checked" : "Unchecked";
                    responses.Add(new QuizAnswer { QuestionId = qid, Answer = answer });
                    continue;
                }
            }

            return responses;
        }

        protected void btnSave_Click1(object sender, EventArgs e)
        {
            var userAnswers = SaveQuizResponses();

            FormBuilder.dsShareForms.FormResponseDataTable dtResponses = new FormBuilder.dsShareForms.FormResponseDataTable();
            sqlHelper.FillDataTable("select top 1 * from FormResponse", dtResponses);
            // Example: Save to database (pseudo-code)
            foreach (var ans in userAnswers)
            {
                FormBuilder.dsShareForms.FormResponseRow nRow = dtResponses.NewFormResponseRow();
                nRow.FormQuestionID = ans.QuestionId;
                nRow.answer = ans.Answer;

                dtResponses.AddFormResponseRow(nRow);
            }

            sqlHelper.Update(dtResponses);
            //lblMessage.Text = "Your answers have been saved!";
        }
    }

    public class QuestionResponse
    {
        public int QuestionId { get; set; }
        public string Axis { get; set; } // Economic, Social, Governance, Global
        public int DirectionValue { get; set; } // -1 or +1 from question design
        public int Weight { get; set; } // 4–12
        public int UserDirection { get; set; } // -1 to +1
        public int Confidence { get; set; } // 1–5
        public bool IsCalibration { get; set; }
    }

    public class PartyProfile
    {
        public string PartyName { get; set; }
        public double Economic { get; set; }
        public double Social { get; set; }
        public double Governance { get; set; }
        public double Global { get; set; }

        public double EconomicPriority { get; set; }
        public double SocialPriority { get; set; }
        public double GovernancePriority { get; set; }
        public double GlobalPriority { get; set; }
    }
    public class PoliMigoScoringEngine
    {
        public Dictionary<string, double> CalculateUserAxisScores(List<QuestionResponse> responses)
        {
            var axisTotals = new Dictionary<string, double>();
            var axisWeights = new Dictionary<string, double>();

            foreach (var r in responses.Where(x => !x.IsCalibration))
            {
                double contribution =
                    r.UserDirection *
                    r.DirectionValue *
                    r.Weight *
                    (r.Confidence / 5.0);

                if (!axisTotals.ContainsKey(r.Axis))
                {
                    axisTotals[r.Axis] = 0;
                    axisWeights[r.Axis] = 0;
                }

                axisTotals[r.Axis] += contribution;
                axisWeights[r.Axis] += r.Weight;
            }

            foreach (var axis in axisTotals.Keys.ToList())
            {
                axisTotals[axis] =
                    (axisTotals[axis] / axisWeights[axis]) * 100;
            }

            return axisTotals;
        }

        public double CalculateEuclideanMatch(
            Dictionary<string, double> user,
            PartyProfile party)
        {
            double economic = (user["Economic"] - party.Economic * party.EconomicPriority);
            double social = (user["Social"] - party.Social * party.SocialPriority);
            double governance = (user["Governance"] - party.Governance * party.GovernancePriority);
            double global = (user["Global"] - party.Global * party.GlobalPriority);

            double distance = Math.Sqrt(
                economic * economic +
                social * social +
                governance * governance +
                global * global
            );

            double maxDistance = Math.Sqrt(200 * 200 * 4);

            return 100 - ((distance / maxDistance) * 100);
        }

        public double CalculateVolatility(List<QuestionResponse> responses)
        {
            var contributions = responses
                .Where(x => !x.IsCalibration)
                .Select(r =>
                    r.UserDirection *
                    r.DirectionValue *
                    r.Weight *
                    (r.Confidence / 5.0))
                .ToList();

            double avg = contributions.Average();
            double variance = contributions.Average(v => Math.Pow(v - avg, 2));
            return Math.Sqrt(variance);
        }
    }

}

