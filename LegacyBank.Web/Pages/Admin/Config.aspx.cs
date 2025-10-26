using System;
using System.Configuration;
using System.IO;
using System.Web.UI;
using System.Xml;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Pages.Admin
{
    public partial class Config : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSettings();
            }
        }

        private void LoadSettings()
        {
            lblSettings.Text = "<ul>";
            foreach (string key in ConfigurationManager.AppSettings.AllKeys)
            {
                lblSettings.Text += $"<li><strong>{key}:</strong> {ConfigurationManager.AppSettings[key]}</li>";
            }
            lblSettings.Text += "</ul>";
            
            txtApiKey.Text = ConfigurationManager.AppSettings["creditScoreApiKey"];
            
            // Show connection string (legacy smell - security issue)
            lblConnectionString.Text = $"<strong>Connection String:</strong> {ConfigurationManager.ConnectionStrings["LegacyBankDb"].ConnectionString}";
        }

        protected void btnUpdateKey_Click(object sender, EventArgs e)
        {
            try
            {
                Log.Info("Updating API key configuration");
                
                // Legacy smell: write to XML file under App_Data
                string configPath = Server.MapPath("~/App_Data/appSettings.xml");
                
                var doc = new XmlDocument();
                if (File.Exists(configPath))
                {
                    doc.Load(configPath);
                }
                else
                {
                    doc.LoadXml("<appSettings></appSettings>");
                }
                
                var root = doc.DocumentElement;
                var keyNode = root.SelectSingleNode("//add[@key='creditScoreApiKey']");
                
                if (keyNode == null)
                {
                    keyNode = doc.CreateElement("add");
                    var keyAttr = doc.CreateAttribute("key");
                    keyAttr.Value = "creditScoreApiKey";
                    keyNode.Attributes.Append(keyAttr);
                    root.AppendChild(keyNode);
                }
                
                var valueAttr = keyNode.Attributes["value"];
                if (valueAttr == null)
                {
                    valueAttr = doc.CreateAttribute("value");
                    keyNode.Attributes.Append(valueAttr);
                }
                valueAttr.Value = txtApiKey.Text;
                
                doc.Save(configPath);
                
                lblResult.Text = "Configuration updated successfully (written to App_Data/appSettings.xml)";
                lblResult.ForeColor = System.Drawing.Color.Green;
                
                Log.Info("API key updated");
            }
            catch (Exception ex)
            {
                Log.Error("Error updating configuration", ex);
                lblResult.Text = "Error: " + ex.Message;
                lblResult.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}
