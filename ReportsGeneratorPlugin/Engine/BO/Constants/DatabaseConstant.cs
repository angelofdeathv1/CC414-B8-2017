namespace Engine.BO
{
    class DatabaseConstant
    {
        #region Schemas
        private const string SCHEMA_REPORTER = "REPORTER.";
        #endregion

        #region Packages
        private const string IA_RPT_CONFIGURATION_PKG = "IA_RPT_CONFIGURATION_PKG";
        #endregion

        #region Stored Procedures
        public const string GET_REPORT_CONFIGURATION = SCHEMA_REPORTER + IA_RPT_CONFIGURATION_PKG+ ".GET_REPORT_CONFIGURATION";
        #endregion
    }
}
