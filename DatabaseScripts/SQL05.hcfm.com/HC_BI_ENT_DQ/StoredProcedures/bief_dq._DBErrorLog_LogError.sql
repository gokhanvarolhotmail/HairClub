/* CreateDate: 05/03/2010 12:09:07.070 , ModifyDate: 05/03/2010 12:09:07.070 */
GO
CREATE PROCEDURE [bief_dq].[_DBErrorLog_LogError]
(
      @DBErrorLogID		int = 0 OUTPUT -- contains the DBErrorLogID of the row inserted
	, @tagValueList		nvarchar(1000) = N''  -- Error details (ie. parms passed in)
)
AS
-----------------------------------------------------------------------
-- _DBErrorLog_LogError logs error information in the _DBErrorLog table
-- about the error that caused execution to jump to the CATCH block of a
-- TRY...CATCH construct. This should be executed from within the scope
-- of a CATCH block otherwise it will return without inserting error
-- information.
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------
BEGIN
    SET NOCOUNT ON;


    -- Output parameter value of 0 indicates that error
    -- information was not logged
    SET @DBErrorLogID = 0;

	-- Check if we should log the error
	DECLARE @IsErrorLoggingEnabled	bit
	SET @IsErrorLoggingEnabled = 1
	SET @IsErrorLoggingEnabled = (SELECT [bief_dq].[fn_IsErrorLoggingEnabled]())
	--PRINT @IsErrorLoggingEnabled

    BEGIN TRY
        -- Return if there is no error information to log
        IF ERROR_NUMBER() IS NULL
            RETURN;

        -- Return if inside an uncommittable transaction.
        -- Data insertion/modification is not allowed when
        -- a transaction is in an uncommittable state.
        IF XACT_STATE() = -1
        BEGIN
            PRINT 'Cannot log error since the current transaction is in an uncommittable state. '
                + 'Rollback the transaction before executing _DBErrorLog_LogError in order to successfully log error information.';
            RETURN;
        END

		IF (@IsErrorLoggingEnabled = 1)
			BEGIN
				INSERT [bief_dq].[_DBErrorLog]
					(
					  [UserName]
					, [ErrorNumber]
					, [ErrorSeverity]
					, [ErrorState]
					, [ErrorProcedure]
					, [ErrorLine]
					, [ErrorMessage]
					, [ErrorDetails]
					)
				VALUES
					(
					  CONVERT(sysname, CURRENT_USER)
					, ERROR_NUMBER()
					, ERROR_SEVERITY()
					, ERROR_STATE()
					, ERROR_PROCEDURE()
					, ERROR_LINE()
					, ERROR_MESSAGE()
					, @tagValueList
					);

				-- Pass back the DBErrorLogID of the row inserted
				SET @DBErrorLogID = @@IDENTITY;
			END
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred in stored procedure _DBErrorLog_LogError: ';
        EXECUTE [bief_dq].[_DBErrorLog_PrintError];
        RETURN -1;
    END CATCH
END;
GO
