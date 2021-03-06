/* CreateDate: 05/01/2010 23:05:35.627 , ModifyDate: 05/01/2010 23:05:35.627 */
GO
CREATE PROCEDURE [bief_config].[_DBErrorLog_PrintError]
AS

-----------------------------------------------------------------------
-- _DBErrorLog_PrintError prints error information about the error
-- that caused execution to jump to the CATCH block of a TRY...CATCH construct.
-- Should be executed from within the scope of a CATCH block otherwise
-- it will return without printing any error information.
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--
-----------------------------------------------------------------------

BEGIN
    SET NOCOUNT ON;

    -- Print error information.
    PRINT 'Error ' + CONVERT(varchar(50), ERROR_NUMBER())
          + ', Severity ' + CONVERT(varchar(5), ERROR_SEVERITY())
          + ', State ' + CONVERT(varchar(5), ERROR_STATE())
          + ', Procedure ' + ISNULL(ERROR_PROCEDURE(), '-')
          + ', Line ' + CONVERT(varchar(5), ERROR_LINE());
    PRINT ERROR_MESSAGE();
END;
GO
