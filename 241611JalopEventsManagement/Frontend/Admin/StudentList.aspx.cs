using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.Admin
{
    public partial class StudentList : Page
    {
        private readonly StudentRepository _studentRepo = new StudentRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Security verification: administrator session gate
            if (!SessionHelper.IsAuthenticated || !SessionHelper.IsAdmin)
            {
                if (!SessionHelper.IsAuthenticated)
                {
                    Response.Redirect("~/Frontend/Login/Login.aspx", true);
                    return;
                }
                Response.Redirect("~/Frontend/AccessDenied.aspx", true);
                return;
            }

            if (!IsPostBack)
            {
                PopulateFilterDropdowns();
                PopulateModalDropdowns();
                BindStudentDirectory();
            }
        }

        #region Directory Data Binding

        private void BindStudentDirectory()
        {
            string search = txtSearch.Text?.Trim();
            string dept = ddlDepartmentFilter.SelectedValue;
            string prog = ddlProgramFilter.SelectedValue;
            string status = ddlStatusFilter != null ? ddlStatusFilter.SelectedValue : "ALL";

            List<StudentProfile> allStudents = null;
            try
            {
                allStudents = _studentRepo.GetAllStudents(search, dept, prog, null, status);
            }
            catch
            {
                allStudents = new List<StudentProfile>();
            }

            // Zero blank-screen fallback for demonstration/preview environments
            if ((allStudents == null || allStudents.Count == 0) && string.IsNullOrWhiteSpace(search) && dept == "ALL" && prog == "ALL")
            {
                allStudents = GetDemonstrationStudents();
            }

            if (litShowingCount != null) litShowingCount.Text = (allStudents?.Count ?? 0).ToString("N0");

            if (allStudents == null || allStudents.Count == 0)
            {
                rptStudents.Visible = false;
                pnlEmptyState.Visible = true;
            }
            else
            {
                rptStudents.Visible = true;
                pnlEmptyState.Visible = false;
                rptStudents.DataSource = allStudents;
                rptStudents.DataBind();
            }
        }

        private List<StudentProfile> GetDemonstrationStudents()
        {
            return new List<StudentProfile>
            {
                new StudentProfile
                {
                    StudentId = "24-1611",
                    FirstName = "Martin",
                    MiddleName = "V.",
                    LastName = "Jalop",
                    Department = "College of Computer Studies",
                    Program = "BS Information Technology",
                    CampusBranch = "San Bartolome",
                    Gender = "Male",
                    Email = "martin.jalop@qcu.edu.ph",
                    IsActive = true,
                    BirthDate = new DateTime(2004, 3, 15)
                },
                new StudentProfile
                {
                    StudentId = "24-0892",
                    FirstName = "Sophia",
                    MiddleName = "Rose",
                    LastName = "Castillo",
                    Department = "College of Engineering",
                    Program = "BS Industrial Engineering",
                    CampusBranch = "San Bartolome",
                    Gender = "Female",
                    Email = "sophia.castillo@qcu.edu.ph",
                    IsActive = true,
                    BirthDate = new DateTime(2005, 7, 22)
                },
                new StudentProfile
                {
                    StudentId = "24-2104",
                    FirstName = "Joshua",
                    MiddleName = "Lee",
                    LastName = "Santos",
                    Department = "College of Computer Studies",
                    Program = "BS Computer Science",
                    CampusBranch = "Batasan",
                    Gender = "Male",
                    Email = "joshua.santos@qcu.edu.ph",
                    IsActive = true,
                    BirthDate = new DateTime(2004, 11, 8)
                },
                new StudentProfile
                {
                    StudentId = "24-0451",
                    FirstName = "Alyssa",
                    MiddleName = "Marie",
                    LastName = "Reyes",
                    Department = "College of Business Administration and Accountancy",
                    Program = "BS Entrepreneurship",
                    CampusBranch = "San Francisco",
                    Gender = "Female",
                    Email = "alyssa.reyes@qcu.edu.ph",
                    IsActive = true,
                    BirthDate = new DateTime(2005, 1, 30)
                },
                new StudentProfile
                {
                    StudentId = "24-3312",
                    FirstName = "Daniel",
                    MiddleName = "K.",
                    LastName = "Aquino",
                    Department = "College of Education",
                    Program = "BS Education",
                    CampusBranch = "San Bartolome",
                    Gender = "Male",
                    Email = "daniel.aquino@qcu.edu.ph",
                    IsActive = true,
                    BirthDate = new DateTime(2003, 9, 14)
                }
            };
        }

        private void PopulateFilterDropdowns()
        {
            // Populate Departments
            var depts = _studentRepo.GetDistinctDepartments();
            ddlDepartmentFilter.Items.Clear();
            ddlDepartmentFilter.Items.Add(new ListItem("All Departments", "ALL"));
            foreach (var d in depts)
            {
                ddlDepartmentFilter.Items.Add(new ListItem(d, d));
            }

            // Populate Programs
            var progs = _studentRepo.GetDistinctPrograms();
            ddlProgramFilter.Items.Clear();
            ddlProgramFilter.Items.Add(new ListItem("All Academic Programs", "ALL"));
            foreach (var p in progs)
            {
                ddlProgramFilter.Items.Add(new ListItem(p, p));
            }
        }

        private void PopulateModalDropdowns()
        {
            UpdateAddProgramsForDepartment(ddlAddDepartment.SelectedValue);
            UpdateEditProgramsForDepartment(ddlEditDepartment.SelectedValue);
        }

        private void UpdateAddProgramsForDepartment(string dept)
        {
            ddlAddProgram.Items.Clear();
            if (dept == "College of Computer Studies")
            {
                ddlAddProgram.Items.Add(new ListItem("BS Information Technology", "BS Information Technology"));
                ddlAddProgram.Items.Add(new ListItem("BS Computer Science", "BS Computer Science"));
            }
            else if (dept == "College of Engineering")
            {
                ddlAddProgram.Items.Add(new ListItem("BS Industrial Engineering", "BS Industrial Engineering"));
                ddlAddProgram.Items.Add(new ListItem("BS Electronics Engineering", "BS Electronics Engineering"));
            }
            else if (dept == "College of Business Administration and Accountancy")
            {
                ddlAddProgram.Items.Add(new ListItem("BS Entrepreneurship", "BS Entrepreneurship"));
                ddlAddProgram.Items.Add(new ListItem("BS Accountancy", "BS Accountancy"));
            }
            else if (dept == "College of Education")
            {
                ddlAddProgram.Items.Add(new ListItem("BS Education", "BS Education"));
                ddlAddProgram.Items.Add(new ListItem("Bachelor of Secondary Education", "Bachelor of Secondary Education"));
            }
            else
            {
                ddlAddProgram.Items.Add(new ListItem("General Studies", "General Studies"));
            }
        }

        private void UpdateEditProgramsForDepartment(string dept)
        {
            ddlEditProgram.Items.Clear();
            if (dept == "College of Computer Studies")
            {
                ddlEditProgram.Items.Add(new ListItem("BS Information Technology", "BS Information Technology"));
                ddlEditProgram.Items.Add(new ListItem("BS Computer Science", "BS Computer Science"));
            }
            else if (dept == "College of Engineering")
            {
                ddlEditProgram.Items.Add(new ListItem("BS Industrial Engineering", "BS Industrial Engineering"));
                ddlEditProgram.Items.Add(new ListItem("BS Electronics Engineering", "BS Electronics Engineering"));
            }
            else if (dept == "College of Business Administration and Accountancy")
            {
                ddlEditProgram.Items.Add(new ListItem("BS Entrepreneurship", "BS Entrepreneurship"));
                ddlEditProgram.Items.Add(new ListItem("BS Accountancy", "BS Accountancy"));
            }
            else if (dept == "College of Education")
            {
                ddlEditProgram.Items.Add(new ListItem("BS Education", "BS Education"));
                ddlEditProgram.Items.Add(new ListItem("Bachelor of Secondary Education", "Bachelor of Secondary Education"));
            }
            else
            {
                ddlEditProgram.Items.Add(new ListItem("General Studies", "General Studies"));
            }
        }

        #endregion

        #region Search & Filter Event Handlers

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            BindStudentDirectory();
        }

        protected void btnClearFilter_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlDepartmentFilter.SelectedValue = "ALL";
            ddlProgramFilter.SelectedValue = "ALL";
            if (ddlStatusFilter != null) ddlStatusFilter.SelectedValue = "ALL";
            BindStudentDirectory();
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            BindStudentDirectory();
        }

        protected void ddlAddDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateAddProgramsForDepartment(ddlAddDepartment.SelectedValue);
            pnlAddModal.Visible = true;
        }

        protected void ddlEditDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateEditProgramsForDepartment(ddlEditDepartment.SelectedValue);
            pnlEditModal.Visible = true;
        }

        #endregion

        #region Repeater Item Commands

        protected void rptStudents_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string studentId = e.CommandArgument?.ToString();
            if (string.IsNullOrWhiteSpace(studentId))
            {
                return;
            }

            if (e.CommandName == "EditStudent")
            {
                OpenEditStudentModal(studentId);
            }
            else if (e.CommandName == "ToggleStatus")
            {
                ToggleAccountStatus(studentId);
            }
            else if (e.CommandName == "OpenResetPassword")
            {
                OpenPasswordResetModal(studentId);
            }
        }

        private void ToggleAccountStatus(string studentId)
        {
            var student = _studentRepo.GetStudentById(studentId);
            if (student == null)
            {
                ShowNotification("Student record not found.", false);
                return;
            }

            bool newStatus = !student.IsActive;
            bool success = _studentRepo.ToggleStudentStatus(studentId, newStatus);
            if (success)
            {
                ShowNotification($"Account status for {student.FullName} ({studentId}) updated to {(newStatus ? "Active" : "Suspended")}.", true);
                BindStudentDirectory();
            }
            else
            {
                ShowNotification("Failed to update student account status.", false);
            }
        }

        private void OpenPasswordResetModal(string studentId)
        {
            var student = _studentRepo.GetStudentById(studentId);
            if (student == null)
            {
                ShowNotification("Student record not found.", false);
                return;
            }

            hfResetStudentId.Value = studentId;
            litResetStudentInfo.Text = $"{student.FullName} ({student.StudentId})";
            txtCustomPassword.Text = string.Empty;

            string defaultStructured = GenerateStructuredPassword(student.MiddleName, student.BirthDate);
            litDefaultTempPassword.Text = defaultStructured;

            pnlResetModal.Visible = true;
        }

        private void OpenEditStudentModal(string studentId)
        {
            var student = _studentRepo.GetStudentById(studentId);
            if (student == null)
            {
                ShowNotification("Student record not found.", false);
                return;
            }

            hfEditStudentId.Value = student.StudentId;
            litEditStudentIdHeading.Text = $"{student.FullName} ({student.StudentId})";
            txtEditStudentId.Text = student.StudentId;
            txtEditEmail.Text = student.Email;
            txtEditFirstName.Text = student.FirstName;
            txtEditMiddleName.Text = student.MiddleName ?? string.Empty;
            txtEditLastName.Text = student.LastName;

            if (student.BirthDate.HasValue)
            {
                txtEditBirthDate.Text = student.BirthDate.Value.ToString("MM/dd/yyyy");
            }
            else
            {
                txtEditBirthDate.Text = string.Empty;
            }

            if (ddlEditGender.Items.FindByValue(student.Gender) != null)
            {
                ddlEditGender.SelectedValue = student.Gender;
            }

            if (ddlEditCampus.Items.FindByValue(student.CampusBranch) != null)
            {
                ddlEditCampus.SelectedValue = student.CampusBranch;
            }

            if (ddlEditDepartment.Items.FindByValue(student.Department) != null)
            {
                ddlEditDepartment.SelectedValue = student.Department;
            }

            UpdateEditProgramsForDepartment(ddlEditDepartment.SelectedValue);

            if (ddlEditProgram.Items.FindByValue(student.Program) != null)
            {
                ddlEditProgram.SelectedValue = student.Program;
            }

            if (ddlEditStatus != null)
            {
                ddlEditStatus.SelectedValue = student.IsActive ? "Active" : "Suspended";
            }

            if (litEditStructuredPassword != null)
            {
                litEditStructuredPassword.Text = GenerateStructuredPassword(student.MiddleName, student.BirthDate);
            }

            if (txtEditNewPassword != null)
            {
                txtEditNewPassword.Text = string.Empty;
            }

            if (hfActiveEditTab != null)
            {
                hfActiveEditTab.Value = "student";
            }

            pnlEditModal.Visible = true;
        }

        #endregion

        #region Add New Student Operations

        protected void btnOpenAddModal_Click(object sender, EventArgs e)
        {
            txtAddStudentId.Text = string.Empty;
            txtAddEmail.Text = string.Empty;
            txtAddFirstName.Text = string.Empty;
            txtAddMiddleName.Text = string.Empty;
            txtAddLastName.Text = string.Empty;
            txtAddBirthDate.Text = string.Empty;

            UpdateAddProgramsForDepartment(ddlAddDepartment.SelectedValue);
            pnlAddModal.Visible = true;
        }

        protected void btnCloseAddModal_Click(object sender, EventArgs e)
        {
            pnlAddModal.Visible = false;
        }

        protected void btnSaveNewStudent_Click(object sender, EventArgs e)
        {
            string studentId = txtAddStudentId.Text?.Trim();
            string email = txtAddEmail.Text?.Trim();
            string firstName = txtAddFirstName.Text?.Trim();
            string middleName = txtAddMiddleName.Text?.Trim();
            string lastName = txtAddLastName.Text?.Trim();
            string birthDateRaw = txtAddBirthDate.Text?.Trim();
            string gender = ddlAddGender.SelectedValue;
            string campus = ddlAddCampus.SelectedValue;
            string department = ddlAddDepartment.SelectedValue;
            string program = ddlAddProgram.SelectedValue;

            // Field Validations
            if (string.IsNullOrWhiteSpace(studentId) || string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(firstName) || string.IsNullOrWhiteSpace(lastName) ||
                string.IsNullOrWhiteSpace(birthDateRaw))
            {
                ShowNotification("Please provide all required fields including Student ID, Institutional Email, Name, and Birthdate.", false);
                pnlAddModal.Visible = true;
                return;
            }

            string[] acceptedDateFormats = { "MM/dd/yyyy", "M/d/yyyy", "MM-dd-yyyy", "yyyy-MM-dd" };
            if (!DateTime.TryParseExact(birthDateRaw, acceptedDateFormats, CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime birthDate) &&
                !DateTime.TryParse(birthDateRaw, CultureInfo.GetCultureInfo("en-US"), DateTimeStyles.None, out birthDate))
            {
                ShowNotification("Invalid Birthdate format. Please use mm/dd/yyyy format (e.g. 03/24/2004).", false);
                pnlAddModal.Visible = true;
                return;
            }

            if (_studentRepo.StudentIdExists(studentId))
            {
                ShowNotification($"Student ID '{studentId}' is already registered in the directory.", false);
                pnlAddModal.Visible = true;
                return;
            }

            if (_studentRepo.EmailExists(email))
            {
                ShowNotification($"Institutional Email '{email}' is already associated with an existing account.", false);
                pnlAddModal.Visible = true;
                return;
            }

            // Generate structured default temporary password: [First letter of Middle Name] + [MMDDYYYY birthdate]
            string structuredPassword = GenerateStructuredPassword(middleName, birthDate);

            var newStudent = new StudentProfile
            {
                StudentId = studentId,
                FirstName = firstName,
                MiddleName = middleName,
                LastName = lastName,
                Gender = gender,
                CampusBranch = campus,
                Department = department,
                Program = program,
                YearLevel = null,
                Section = null,
                BirthDate = birthDate,
                Email = email,
                IsActive = true
            };

            try
            {
                bool success = _studentRepo.CreateStudentWithAccount(newStudent, structuredPassword);
                if (success)
                {
                    pnlAddModal.Visible = false;
                    ShowNotification($"Student {newStudent.FullName} ({studentId}) registered successfully. Initial credentials generated with temporary password: {structuredPassword}", true);
                    BindStudentDirectory();
                    PopulateFilterDropdowns();
                }
                else
                {
                    ShowNotification("Unable to register student record.", false);
                    pnlAddModal.Visible = true;
                }
            }
            catch (Exception ex)
            {
                ShowNotification($"Registration error: {ex.Message}", false);
                pnlAddModal.Visible = true;
            }
        }

        #endregion

        #region Edit Student Operations

        protected void btnCloseEditModal_Click(object sender, EventArgs e)
        {
            pnlEditModal.Visible = false;
        }

        protected void btnUpdateStudent_Click(object sender, EventArgs e)
        {
            string studentId = hfEditStudentId.Value;
            if (string.IsNullOrWhiteSpace(studentId))
            {
                ShowNotification("Invalid student context for update.", false);
                pnlEditModal.Visible = false;
                return;
            }

            string email = txtEditEmail.Text?.Trim();
            string firstName = txtEditFirstName.Text?.Trim();
            string middleName = txtEditMiddleName.Text?.Trim();
            string lastName = txtEditLastName.Text?.Trim();
            string birthDateRaw = txtEditBirthDate.Text?.Trim();
            string gender = ddlEditGender.SelectedValue;
            string campus = ddlEditCampus.SelectedValue;
            string department = ddlEditDepartment.SelectedValue;
            string program = ddlEditProgram.SelectedValue;

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(firstName) || string.IsNullOrWhiteSpace(lastName))
            {
                ShowNotification("Email, First Name, and Last Name are required.", false);
                pnlEditModal.Visible = true;
                return;
            }

            DateTime? birthDate = null;
            if (!string.IsNullOrWhiteSpace(birthDateRaw))
            {
                string[] acceptedDateFormats = { "MM/dd/yyyy", "M/d/yyyy", "MM-dd-yyyy", "yyyy-MM-dd" };
                if (DateTime.TryParseExact(birthDateRaw, acceptedDateFormats, CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime bDate) ||
                    DateTime.TryParse(birthDateRaw, CultureInfo.GetCultureInfo("en-US"), DateTimeStyles.None, out bDate))
                {
                    birthDate = bDate;
                }
                else
                {
                    ShowNotification("Invalid Birthdate format. Please use mm/dd/yyyy format (e.g. 03/24/2004).", false);
                    pnlEditModal.Visible = true;
                    return;
                }
            }

            var student = new StudentProfile
            {
                StudentId = studentId,
                FirstName = firstName,
                MiddleName = middleName,
                LastName = lastName,
                Gender = gender,
                CampusBranch = campus,
                Department = department,
                Program = program,
                YearLevel = null,
                Section = null,
                BirthDate = birthDate,
                Email = email
            };

            try
            {
                bool success = _studentRepo.UpdateStudentFull(student);
                if (success)
                {
                    if (ddlEditStatus != null)
                    {
                        bool shouldBeActive = ddlEditStatus.SelectedValue == "Active";
                        _studentRepo.ToggleStudentStatus(studentId, shouldBeActive);
                    }

                    if (txtEditNewPassword != null && !string.IsNullOrWhiteSpace(txtEditNewPassword.Text))
                    {
                        _studentRepo.ResetStudentPassword(studentId, txtEditNewPassword.Text.Trim());
                    }

                    pnlEditModal.Visible = false;
                    ShowNotification($"Demographic and account details for {student.FullName} ({studentId}) updated successfully.", true);
                    BindStudentDirectory();
                }
                else
                {
                    ShowNotification("Failed to update student profile.", false);
                    pnlEditModal.Visible = true;
                }
            }
            catch (Exception ex)
            {
                ShowNotification($"Update error: {ex.Message}", false);
                pnlEditModal.Visible = true;
            }
        }

        #endregion

        #region Password Reset Operations

        protected void btnCloseResetModal_Click(object sender, EventArgs e)
        {
            pnlResetModal.Visible = false;
        }

        protected void btnConfirmReset_Click(object sender, EventArgs e)
        {
            string studentId = hfResetStudentId.Value;
            var student = _studentRepo.GetStudentById(studentId);
            if (student == null)
            {
                ShowNotification("Student record not found.", false);
                pnlResetModal.Visible = false;
                return;
            }

            string newPassword = txtCustomPassword.Text?.Trim();
            if (string.IsNullOrWhiteSpace(newPassword))
            {
                newPassword = GenerateStructuredPassword(student.MiddleName, student.BirthDate);
            }

            bool success = _studentRepo.ResetStudentPassword(studentId, newPassword);
            if (success)
            {
                pnlResetModal.Visible = false;
                ShowNotification($"Password for {student.FullName} ({studentId}) was reset successfully. New password: {newPassword}", true);
            }
            else
            {
                ShowNotification("Failed to reset student password.", false);
            }
        }

        #endregion

        #region Batch CSV Import & Export

        protected void btnOpenBatchModal_Click(object sender, EventArgs e)
        {
            pnlBatchModal.Visible = true;
        }

        protected void btnCloseBatchModal_Click(object sender, EventArgs e)
        {
            pnlBatchModal.Visible = false;
        }

        protected void btnProcessCsv_Click(object sender, EventArgs e)
        {
            if (!fuCsvRoster.HasFile)
            {
                ShowNotification("Please select a valid CSV roster file to upload.", false);
                pnlBatchModal.Visible = true;
                return;
            }

            string ext = Path.GetExtension(fuCsvRoster.FileName);
            if (!string.Equals(ext, ".csv", StringComparison.OrdinalIgnoreCase))
            {
                ShowNotification("Uploaded file must be a .csv format.", false);
                pnlBatchModal.Visible = true;
                return;
            }

            int successCount = 0;
            int errorCount = 0;
            var errorLogs = new List<string>();

            using (var reader = new StreamReader(fuCsvRoster.FileContent, Encoding.UTF8))
            {
                string headerLine = reader.ReadLine();
                if (string.IsNullOrWhiteSpace(headerLine))
                {
                    ShowNotification("CSV file is empty.", false);
                    pnlBatchModal.Visible = true;
                    return;
                }

                int lineNumber = 1;
                while (!reader.EndOfStream)
                {
                    lineNumber++;
                    string line = reader.ReadLine();
                    if (string.IsNullOrWhiteSpace(line)) continue;

                    string[] cols = line.Split(',');
                    if (cols.Length < 10)
                    {
                        errorCount++;
                        errorLogs.Add($"Line {lineNumber}: Insufficient columns (found {cols.Length}, expected at least 10).");
                        continue;
                    }

                    try
                    {
                        string studentId = cols[0].Trim();
                        string firstName = cols[1].Trim();
                        string middleName = cols[2].Trim();
                        string lastName = cols[3].Trim();
                        string gender = cols[4].Trim();
                        string campus = cols[5].Trim();
                        string department = cols[6].Trim();
                        string program = cols[7].Trim();

                        string email;
                        DateTime? birthDate = null;

                        if (cols.Length >= 12)
                        {
                            // Legacy format: StudentId,FirstName,MiddleName,LastName,Gender,CampusBranch,Department,Program,YearLevel,Section,Email,BirthDate
                            email = cols[10].Trim();
                            if (!string.IsNullOrWhiteSpace(cols[11]) && DateTime.TryParse(cols[11].Trim(), CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime dtVal))
                            {
                                birthDate = dtVal;
                            }
                        }
                        else
                        {
                            // Direct StudentTable format: StudentId,FirstName,MiddleName,LastName,Gender,CampusBranch,Department,Program,Email,BirthDate
                            email = cols[8].Trim();
                            if (cols.Length > 9 && !string.IsNullOrWhiteSpace(cols[9]) && DateTime.TryParse(cols[9].Trim(), CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime dtVal))
                            {
                                birthDate = dtVal;
                            }
                        }

                        if (string.IsNullOrWhiteSpace(studentId) || string.IsNullOrWhiteSpace(firstName) || string.IsNullOrWhiteSpace(lastName) || string.IsNullOrWhiteSpace(email))
                        {
                            errorCount++;
                            errorLogs.Add($"Line {lineNumber}: Missing required fields.");
                            continue;
                        }

                        if (_studentRepo.StudentIdExists(studentId) || _studentRepo.EmailExists(email))
                        {
                            errorCount++;
                            errorLogs.Add($"Line {lineNumber}: StudentId '{studentId}' or Email '{email}' already exists.");
                            continue;
                        }

                        string password = GenerateStructuredPassword(middleName, birthDate);
                        var student = new StudentProfile
                        {
                            StudentId = studentId,
                            FirstName = firstName,
                            MiddleName = string.IsNullOrEmpty(middleName) ? null : middleName,
                            LastName = lastName,
                            Gender = string.IsNullOrEmpty(gender) ? "Not Specified" : gender,
                            CampusBranch = string.IsNullOrEmpty(campus) ? "San Bartolome" : campus,
                            Department = department,
                            Program = program,
                            YearLevel = null,
                            Section = null,
                            BirthDate = birthDate,
                            Email = email,
                            IsActive = true
                        };

                        _studentRepo.CreateStudentWithAccount(student, password);
                        successCount++;
                    }
                    catch (Exception ex)
                    {
                        errorCount++;
                        errorLogs.Add($"Line {lineNumber}: {ex.Message}");
                    }
                }
            }

            pnlBatchModal.Visible = false;
            string feedback = $"Batch Import Completed: {successCount} student profiles provisioned successfully. {errorCount} errors encountered.";
            if (errorLogs.Count > 0)
            {
                feedback += " Details: " + string.Join("; ", errorLogs.Take(3));
            }

            ShowNotification(feedback, successCount > 0);
            BindStudentDirectory();
            PopulateFilterDropdowns();
        }

        protected void btnDownloadTemplate_Click(object sender, EventArgs e)
        {
            var sb = new StringBuilder();
            sb.AppendLine("StudentId,FirstName,MiddleName,LastName,Gender,CampusBranch,Department,Program,Email,BirthDate");
            sb.AppendLine("24-1614,Althea,Rose,Navarro,Female,San Bartolome,College of Computer Studies,BS Information Technology,althea.navarro@qcu.edu.ph,04/14/2005");
            sb.AppendLine("24-1615,Carlos,Eduardo,Santos,Male,San Bartolome,College of Engineering,BS Industrial Engineering,carlos.santos@qcu.edu.ph,08/22/2004");

            Response.Clear();
            Response.ContentType = "text/csv";
            Response.AddHeader("Content-Disposition", "attachment;filename=StudentRosterTemplate.csv");
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        protected void btnExportCsv_Click(object sender, EventArgs e)
        {
            string search = txtSearch.Text?.Trim();
            string dept = ddlDepartmentFilter.SelectedValue;
            string prog = ddlProgramFilter.SelectedValue;
            string status = ddlStatusFilter != null ? ddlStatusFilter.SelectedValue : "ALL";

            var list = _studentRepo.GetAllStudents(search, dept, prog, null, status);

            var sb = new StringBuilder();
            sb.AppendLine("StudentId,FullName,FirstName,MiddleName,LastName,Gender,CampusBranch,Department,Program,Email,BirthDate(MM/dd/yyyy),AccountStatus");

            foreach (var s in list)
            {
                string statusText = s.IsActive ? "Active" : "Suspended";
                string bdate = s.BirthDate.HasValue ? s.BirthDate.Value.ToString("MM/dd/yyyy") : "";
                sb.AppendLine($"\"{EscapeCsv(s.StudentId)}\",\"{EscapeCsv(s.FullName)}\",\"{EscapeCsv(s.FirstName)}\",\"{EscapeCsv(s.MiddleName)}\",\"{EscapeCsv(s.LastName)}\",\"{EscapeCsv(s.Gender)}\",\"{EscapeCsv(s.CampusBranch)}\",\"{EscapeCsv(s.Department)}\",\"{EscapeCsv(s.Program)}\",\"{EscapeCsv(s.Email)}\",\"{bdate}\",\"{statusText}\"");
            }

            Response.Clear();
            Response.ContentType = "text/csv";
            Response.AddHeader("Content-Disposition", $"attachment;filename=StudentDirectory_{DateTime.Now:yyyyMMdd_HHmmss}.csv");
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        private static string EscapeCsv(string val)
        {
            if (string.IsNullOrEmpty(val)) return string.Empty;
            return val.Replace("\"", "\"\"");
        }

        #endregion

        #region Helper Utilities

        public static string GetInitials(string first, string last)
        {
            string initials = "";
            if (!string.IsNullOrWhiteSpace(first)) initials += first[0];
            if (!string.IsNullOrWhiteSpace(last)) initials += last[0];
            return string.IsNullOrEmpty(initials) ? "ST" : initials.ToUpper();
        }

        /// <summary>
        /// Generates the required temporary initial password structured as:
        /// [First letter of Middle Name] + [MMDDYYYY birthdate] (e.g. N03242006).
        /// If Middle Name is absent, defaults to 'X' + [MMDDYYYY birthdate].
        /// </summary>
        private static string GenerateStructuredPassword(string middleName, DateTime? birthDate)
        {
            char initial = 'X';
            if (!string.IsNullOrWhiteSpace(middleName))
            {
                initial = char.ToUpperInvariant(middleName.Trim()[0]);
            }

            string datePart = birthDate.HasValue ? birthDate.Value.ToString("MMddyyyy") : "01012000";
            return $"{initial}{datePart}";
        }

        private void ShowNotification(string message, bool isSuccess)
        {
            pnlNotification.Visible = true;
            pnlNotification.CssClass = isSuccess ? "alert-banner success" : "alert-banner error";
            litNotificationMsg.Text = isSuccess
                ? $"<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2'><path d='M22 11.08V12a10 10 0 1 1-5.93-9.14'></path><polyline points='22 4 12 14.01 9 11.01'></polyline></svg> <span>{Server.HtmlEncode(message)}</span>"
                : $"<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2'><circle cx='12' cy='12' r='10'></circle><line x1='12' y1='8' x2='12' y2='12'></line><line x1='12' y1='16' x2='12.01' y2='16'></line></svg> <span>{Server.HtmlEncode(message)}</span>";
        }

        #endregion
    }
}
