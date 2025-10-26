using System;
using System.Web;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web
{
    public class Global : HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            Log.Info("LegacyBank application starting...");
        }

        protected void Application_End(object sender, EventArgs e)
        {
            Log.Info("LegacyBank application shutting down...");
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();
            Log.Error("Unhandled application error", ex);
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            Log.Debug("New session started: " + Session.SessionID);
        }

        protected void Session_End(object sender, EventArgs e)
        {
            Log.Debug("Session ended: " + Session.SessionID);
        }
    }
}
