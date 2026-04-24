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
    public partial class FormBuilderPage : BasePage
    {
        private List<QuizQuestion> Questions
        {
            get
            {
                if (ViewState["Questions"] == null) ViewState["Questions"] = new List<QuizQuestion>();
                return (List<QuizQuestion>)ViewState["Questions"];
            }
            set { ViewState["Questions"] = value; }
        }

        // Model
        [Serializable]
        public class QuizQuestion
        {
            public int Id { get; set; }
            public string QuestionText { get; set; }
            public string QuestionType { get; set; } // SingleChoice, MultiChoice, YesNo, LongText, Number, Checkbox
            //public int SortOrder { get; set; } 
            public List<string> Options { get; set; } = new List<string>();
        }

        public FormBuilder.dsShareForms.FormQuestionDataTable dtQuestions
        {
            get
            {
                //Questions = new List<QuizQuestion>
                //{
                //    new QuizQuestion { Id = 1, QuestionText = "What is your favorite color?", QuestionType = "SingleChoice", Options = new List<string>{"Red","Blue","Green"} },
                //    new QuizQuestion { Id = 2, QuestionText = "Select all fruits you like", QuestionType = "MultiChoice", Options = new List<string>{"Apple","Banana","Orange"} },
                //    new QuizQuestion { Id = 3, QuestionText = "Do you like coding?", QuestionType = "YesNo" },
                //    new QuizQuestion { Id = 4, QuestionText = "Describe your experience", QuestionType = "LongText" },
                //    new QuizQuestion { Id = 5, QuestionText = "Enter your age", QuestionType = "Number" },
                //    new QuizQuestion { Id = 6, QuestionText = "Did you complete the form", QuestionType = "Checkbox" }
                //};

                FormBuilder.dsShareForms.FormQuestionDataTable dtQuestions = new FormBuilder.dsShareForms.FormQuestionDataTable();
                sqlHelper.FillDataTable("select * from FormQuestion ORDER BY SortOrder", dtQuestions);
                if (dtQuestions.Count < 1)
                {
                    foreach (var issue in Questions)
                    {
                        FormBuilder.dsShareForms.FormQuestionRow r = dtQuestions.NewFormQuestionRow();
                        r.QuestionText = issue.QuestionText;
                        r.QuestionType = issue.QuestionType;
                        if (issue.Options != null)
                            r.Options = string.Join(",", issue.Options);
                        dtQuestions.AddFormQuestionRow(r);
                    }
                    sqlHelper.Update(dtQuestions);
                }

                return dtQuestions;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadQuestionsFromDataTable();
                BindQuestions();
            }
        }

        private void LoadQuestionsFromDataTable()
        {
            Questions = new List<QuizQuestion>();

            foreach (FormBuilder.dsShareForms.FormQuestionRow row in dtQuestions)
            {
                Questions.Add(new QuizQuestion
                {
                    Id = row.ID, // make sure your typed dataset has Id column
                    QuestionText = row.QuestionText,
                    QuestionType = row.QuestionType,
                    Options = !row.IsOptionsNull() && !string.IsNullOrWhiteSpace(row.Options)
            ? row.Options.Split(',').ToList()
            : new List<string>()

                });
            }
        }


        private void BindQuestions()
        {
            rptQuestions.DataSource = Questions;
            rptQuestions.DataBind();
        }

        protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var question = (QuizQuestion)e.Item.DataItem;

            // Set question type dropdown
            var ddl = (DropDownList)e.Item.FindControl("ddlQuestionType");
            ddl.SelectedValue = question.QuestionType;

            // Find panel and repeater
            var pnlOptions = (Panel)e.Item.FindControl("pnlOptions");
            var rptOptions = (Repeater)e.Item.FindControl("rptOptions");

            // Show options panel only for choice questions
            if (question.QuestionType == "SingleChoice" || question.QuestionType == "MultiChoice")
            {
                pnlOptions.Visible = true;

                // Make sure Options list is not null
                if (question.Options == null)
                    question.Options = new List<string>();

                rptOptions.DataSource = question.Options;
                rptOptions.DataBind();
            }
            else
            {
                pnlOptions.Visible = false;
            }
        }



        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            int nextId = Questions.Any() ? Questions.Max(q => q.Id) + 1 : 1;

            var newQuestion = new QuizQuestion
            {
                Id = nextId,
                QuestionText = "New Question",
                QuestionType = "SingleChoice",
                Options = new List<string> { "" }
            };

            Questions.Add(newQuestion);

            FormBuilder.dsShareForms.FormQuestionDataTable dt = dtQuestions;
            // Add to dtQuestions as well
            var r = dt.NewFormQuestionRow();
            //r.ID = nextId;
            r.QuestionText = newQuestion.QuestionText;
            r.QuestionType = newQuestion.QuestionType;
            r.Options = string.Join(",", newQuestion.Options);
            dt.AddFormQuestionRow(r);

            sqlHelper.Update(dt); // persist to DB
            BindQuestions();
        }

        protected void ddlQuestionType_SelectedIndexChanged(object sender, EventArgs e)
        {
            var ddl = (DropDownList)sender;
            var item = (RepeaterItem)ddl.NamingContainer;
            var pnlOptions = (Panel)item.FindControl("pnlOptions");

            pnlOptions.Visible = ddl.SelectedValue == "SingleChoice" || ddl.SelectedValue == "MultiChoice";
        }

        protected void btnAddOption_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            var item = (RepeaterItem)btn.NamingContainer;
            var rptOptions = (Repeater)item.FindControl("rptOptions");

            var options = new List<string>();
            foreach (RepeaterItem rItem in rptOptions.Items)
            {
                var txt = (TextBox)rItem.FindControl("txtOption");
                if (!string.IsNullOrWhiteSpace(txt.Text))
                    options.Add(txt.Text);
            }

            // Add blank option
            options.Add("");

            rptOptions.DataSource = options;
            rptOptions.DataBind();
        }

        protected void btnDeleteQuestion_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            var item = (RepeaterItem)btn.NamingContainer;
            int index = item.ItemIndex;

            if (index >= 0 && index < Questions.Count)
            {

                FormBuilder.dsShareForms.FormQuestionDataTable dt = dtQuestions;
                int idToDelete = Questions[index].Id;

                Questions.RemoveAt(index);

                // Remove from dtQuestions
                var row = dt.FindByID(idToDelete);
                if (row != null) dtQuestions.RemoveFormQuestionRow(row);

                sqlHelper.Update(dt);
                BindQuestions();
            }
        }



        protected void btnDeleteOption_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            var item = (RepeaterItem)btn.NamingContainer;
            var parentItem = (RepeaterItem)item.NamingContainer.NamingContainer;

            int optionIndex = item.ItemIndex;
            int questionIndex = parentItem.ItemIndex;

            if (questionIndex >= 0 && questionIndex < Questions.Count)
            {
                FormBuilder.dsShareForms.FormQuestionDataTable dt = dtQuestions;
                var question = Questions[questionIndex];

                if (optionIndex >= 0 && optionIndex < question.Options.Count)
                {
                    question.Options.RemoveAt(optionIndex);

                    // Update dtQuestions
                    var row = dt.FindByID(question.Id);
                    if (row != null)
                        row.Options = string.Join(",", question.Options);

                    sqlHelper.Update(dt);
                    BindQuestions();
                }
            }
        }


        protected void btnSaveOrder_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(hfQuestionOrder.Value))
            {
                FormBuilder.dsShareForms.FormQuestionDataTable dt = dtQuestions;
                var ids = hfQuestionOrder.Value.Split(',')
                                               .Select(int.Parse)
                                               .ToList();

                for (int i = 0; i < ids.Count; i++)
                {
                    var row = dt.FindByID(ids[i]);
                    if (row != null)
                    {
                        row.sortOrder = i;
                    }
                }

                sqlHelper.Update(dt);

                //dtQuestions = dt;

                LoadQuestionsFromDataTable(); // reload from DB ordered
                BindQuestions();
            }
        }






    }
}

