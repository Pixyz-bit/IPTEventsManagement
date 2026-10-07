using System.Web.UI.WebControls;

namespace _241611JalopEventsManagement.Backend.Helpers
{
    public static class EventCollegeOptions
    {
        public static void Bind(DropDownList dropdown)
        {
            string placeholder = dropdown.Items.Count > 0 ? dropdown.Items[0].Text : "All Academic Colleges";
            dropdown.Items.Clear();
            dropdown.Items.Add(new ListItem(placeholder, ""));
            dropdown.Items.Add(new ListItem("College of Computer Studies (CCS)", "College of Computer Studies"));
            dropdown.Items.Add(new ListItem("College of Engineering (COE)", "College of Engineering"));
            dropdown.Items.Add(new ListItem("College of Business Administration and Accountancy (CBAA)", "College of Business Administration and Accountancy"));
            dropdown.Items.Add(new ListItem("College of Education (CED)", "College of Education"));
        }
    }
}
