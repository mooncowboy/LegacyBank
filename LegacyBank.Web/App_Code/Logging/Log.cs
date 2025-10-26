using System;
using log4net;

namespace LegacyBank.Web.Logging
{
    public static class Log
    {
        private static readonly ILog logger = LogManager.GetLogger("LegacyBank");

        public static void Info(string message)
        {
            logger.Info(message);
        }

        public static void Info(string message, Exception ex)
        {
            logger.Info(message, ex);
        }

        public static void Error(string message)
        {
            logger.Error(message);
        }

        public static void Error(string message, Exception ex)
        {
            logger.Error(message, ex);
        }

        public static void Warn(string message)
        {
            logger.Warn(message);
        }

        public static void Debug(string message)
        {
            logger.Debug(message);
        }
    }
}
