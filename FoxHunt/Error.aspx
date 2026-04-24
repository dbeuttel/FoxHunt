<%@ Page Language="VB" Inherits="System.Web.UI.Page" %>
<%@ Import Namespace="System.Data" %>  
<%
    Dim toAddress As String = "mmazarick@dconc.gov,dbeuttel@dconc.gov"
    Dim fromAddress As String = "PrecinctOfficialAdmin@dconc.gov"
    Dim redirectUrl As String = "reports.aspx"
%>


<% 
        Dim emailError As Boolean = True
        Dim enableSSLEmail as boolean = false
        Dim currentError As Exception = Session("LastError")
        If currentError Is Nothing Then
            currentError = Application("LastError")
            Application("LastError") = Nothing
        End If
        Session("LastError") = Nothing


        Dim errorReq As HttpRequest = Session("errorRequest")
        If errorReq Is Nothing Then
            errorReq = Application("errorRequest")
            Application("errorRequest") = Nothing
        End If
        If errorReq Is Nothing Then
            errorReq = Request
        End If
        Session("errorRequest") = Nothing

        Dim s As String = ""
        If currentError IsNot Nothing Then
            s = "<html><body style=""white-space: nowrap"">"

            s &= "<strong>An unhandled exception has occurred.</strong><br /><br />"
            s &= "<strong>User: " & HttpContext.Current.User.Identity.Name & "</strong><br /><br />"
            s &= "<strong>Exception information:</strong><br />"
            s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Exception type: " & currentError.GetType.ToString & "<br />"
            s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Exception message: " & currentError.Message.Replace(vbCrLf, "<br />") & "<br />"
            s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Exception StackTrace: " & currentError.StackTrace.Replace(" ", "&nbsp;").Replace(vbCrLf, "<br />") & "<br />"
            s &= "<br />"

            If currentError.InnerException IsNot Nothing Then
                s &= "<strong>Inner Exception information:</strong><br />"
                s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Exception type: " & currentError.InnerException.GetType.ToString & "<br />"
                s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Exception message: " & currentError.InnerException.Message.Replace(vbCrLf, "<br />") & "<br />"
                s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Exception StackTrace: " & currentError.InnerException.StackTrace.Replace(" ", "&nbsp;").Replace(vbCrLf, "<br />") & "<br />"
                s &= "<br />"
            End If
            s &= "<br />"
            s &= "<strong>Request Information:</strong><br />"
            Try
                s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;URL: " & errorReq.Url.AbsoluteUri & "<br />"
                s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Path: " & errorReq.Url.PathAndQuery & "<br />"
            Catch ex As Exception
            End Try
            If errorReq.UrlReferrer IsNot Nothing Then
                s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Referrer URL: " & errorReq.UrlReferrer.AbsoluteUri & "<br />"
                s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Referrer Path: " & errorReq.UrlReferrer.PathAndQuery & "<br />"
            Else
                s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Request URL: " & errorReq.QueryString("aspxerrorpath") & "<br />"
            End If
            s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;User Host Address: " & Request.UserHostAddress & "<br />"
            Try
                s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Form data:</strong> <br />"
                For Each key As String In errorReq.Form
                    s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & key & ": " & errorReq.Form(key) & "<br />"
                Next
            Catch ex As Exception

            End Try
            Try
                s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Cookies: </strong><br />"
                For Each key As String In errorReq.Cookies
                    s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & key & ": " & errorReq.Cookies(key).Value & "<br />"
                Next
            Catch ex As Exception

            End Try
            s &= "<br />"
            s &= "<br />"

            s &= "<strong>Session Information:</strong><br />"
            For Each strName As String In Session.Contents
                s &= "&nbsp;&nbsp;Session Key: " & strName & ":<br />"
                If Session(strName) IsNot Nothing AndAlso Session(strName).GetType IsNot Nothing AndAlso Session(strName).GetType.BaseType IsNot Nothing Then
                    If Session(strName).GetType.BaseType Is GetType(DataRow) Then
                        Dim dtr As DataRow = CType(Session(strName), DataRow)
                        If dtr Is Nothing Then
                            s &= "Nothing"
                            Continue For
                        End If
                        s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type: " & Session(strName).GetType.ToString & "<br />"
                        For Each col As DataColumn In dtr.Table.Columns
                            Try
                                s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & col.ColumnName & ": " & dtr(col.ColumnName).ToString & "<br />"
                            Catch ex As Exception
                                s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & col.ColumnName & " - Exception:" & ex.Message & "<br />"
                            End Try
                        Next
                    ElseIf Session(strName).GetType.BaseType Is GetType(DataTable) Then
                        Dim dt As DataTable = CType(Session(strName), DataTable)
                        If dt Is Nothing Then
                            s &= "Nothing"
                            Continue For
                        End If
                        s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Table Name: " & dt.TableName & "<br />"
                        s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Table Row Count: " & dt.Rows.Count & "<br />"
                    ElseIf Session(strName).GetType.BaseType Is GetType(DataSet) Then
                        Dim ds As DataSet = CType(Session(strName), DataSet)
                        If ds Is Nothing Then
                            s &= "Nothing"
                            Continue For
                        End If
                        For Each dt As DataTable In ds.Tables
                            s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Table Name: " & dt.TableName & "<br />"
                            s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Table Row Count: " & dt.Rows.Count & "<br />"
                            s &= "<br />"
                        Next
                    ElseIf Session(strName).GetType Is GetType(Hashtable) Then
                        Dim ht As Hashtable = CType(Session(strName), Hashtable)
                        If ht Is Nothing Then
                            s &= "Nothing"
                            Continue For
                        End If
                        For Each key As Object In ht.Keys
                            s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Key: " & key.ToString & "<br />"
                            s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Value: " & ht(key).ToString & "<br />"
                        Next
                    Else
                        Try
                            s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Object: " & Session(strName).ToString & "<br />"
                        Catch ex As Exception
                            s &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & strName & " - Exception:" & ex.Message & "<br />"
                        End Try
                    End If
                    s &= "<br />"
                Else
                    s &= "Nothing"
                End If
            Next
            s &= "</body></html>"

            '************The send Email part*************

            Dim myurl As String = ""
            If Not String.IsNullOrEmpty(Request.QueryString("aspxerrorpath")) Then
                myurl = Request.QueryString("aspxerrorpath")
            End If
            If currentError Is Nothing OrElse myurl = "" OrElse myurl.StartsWith("http://0.0.0.0") OrElse myurl.StartsWith("http://localhost") Then
                emailError = False
            End If
            If emailError Then
                Dim emailMsg As New Net.Mail.MailMessage
                With emailMsg
                    If fromAddress.Length > 0 Then _
                     .From = New Net.Mail.MailAddress(fromAddress)
                    .To.Add(toAddress)
                    .Body = s
                    Dim subj As String = currentError.Message
                    If subj.Contains(vbCrLf) Then
                        subj = subj.Substring(0, subj.IndexOf(vbCrLf))
                        subj = subj.Replace(vbCrLf, "")
                    End If
                    .Subject = Request.Url.Host & " Error: " & subj
                    .IsBodyHtml = True
                End With

                Dim client As New Net.Mail.SmtpClient
                client.EnableSsl = enableSSLEmail
                Try
                    client.Send(emailMsg)
                Catch ex As Exception

                End Try
                currentError = Nothing
            End If

        End If
        If redirectUrl Is Nothing OrElse redirectUrl = "" Then
            Response.Write(s)
        Else
            Response.Redirect(redirectUrl)
        End If

%>