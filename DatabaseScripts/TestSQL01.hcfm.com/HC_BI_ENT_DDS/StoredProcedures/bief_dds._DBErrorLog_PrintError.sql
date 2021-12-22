/* CreateDate: 05/03/2010 12:08:53.377 , ModifyDate: 09/24/2014 11:41:44.827 */
GO
CREATE PROCEDURE [bief_dds].[_DBErrorLog_PrintError]
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
--  v1.0			  RLifke       Initial Creation
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
