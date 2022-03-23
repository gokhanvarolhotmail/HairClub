/* CreateDate: 03/17/2022 11:57:09.797 , ModifyDate: 03/17/2022 11:57:09.797 */
GO
CREATE PROCEDURE [bief_dds].[_DBErrorLog_RethrowError]
(
	@tagValueList nvarchar(1000)
)
AS

-----------------------------------------------------------------------
-- Create the stored procedure to generate an error using
-- RAISERROR. The original error information is used to
-- construct the msg_str for RAISERROR.
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  ------------------------------------
--  v1.0               RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN
    -- Return if there is no error information to retrieve.
    IF ERROR_NUMBER() IS NULL
        RETURN;

    DECLARE
			  @ErrorMessage		NVARCHAR(4000)
			, @ErrorNumber		INT
			, @ErrorSeverity	INT
			, @ErrorState		INT
			, @ErrorLine		INT
			, @ErrorProcedure	NVARCHAR(200);

    -- Assign variables to error-handling functions that
    -- capture information for RAISERROR.
    SELECT
          @ErrorNumber = ERROR_NUMBER()
        , @ErrorSeverity = ERROR_SEVERITY()
        , @ErrorState = ERROR_STATE()
        , @ErrorLine = ERROR_LINE()
        , @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

	IF ((@ErrorNumber > 50000) AND (@ErrorNumber < 2147483648))
		BEGIN
			-- Raise an error: @ErrorNumber contains the user-defined error
            -- being re-raised.
			RAISERROR
				(
				@ErrorNumber,
				@ErrorSeverity,
				1,
				@ErrorNumber,    -- parameter: original error number.
				@ErrorSeverity,  -- parameter: original error severity.
				@ErrorState,     -- parameter: original error state.
				@ErrorProcedure, -- parameter: original error procedure name.
				@ErrorLine,      -- parameter: original error line number.
				@tagValueList
				);
		END
	ELSE
		BEGIN
			-- Building the message string that will contain original
			-- error information.
			SELECT @ErrorMessage =
				N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' +
					'Message: '+ ERROR_MESSAGE() + ' Details: ' + @tagValueList;

			-- Raise an error: msg_str parameter of RAISERROR will contain
			-- the original error information.
			RAISERROR
				(
				  @ErrorMessage
				, @ErrorSeverity
				, 1
				, @ErrorNumber		-- parameter: original error number.
				, @ErrorSeverity	-- parameter: original error severity.
				, @ErrorState		-- parameter: original error state.
				, @ErrorProcedure	-- parameter: original error procedure name.
				, @ErrorLine		-- parameter: original error line number.
				);
		END
END;
GO
