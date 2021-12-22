/* CreateDate: 01/26/2010 10:12:08.587 , ModifyDate: 01/26/2010 10:12:08.587 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.TempGetAppID
    @appName    tAppName,
    @appId      int OUTPUT
    AS
    SET @appName = LOWER(@appName)
    SET @appId = NULL

    SELECT @appId = AppId
    FROM [CMSSessionState].dbo.ASPStateTempApplications
    WHERE AppName = @appName

    IF @appId IS NULL BEGIN
        BEGIN TRAN        

        SELECT @appId = AppId
        FROM [CMSSessionState].dbo.ASPStateTempApplications WITH (TABLOCKX)
        WHERE AppName = @appName
        
        IF @appId IS NULL
        BEGIN
            EXEC GetHashCode @appName, @appId OUTPUT
            
            INSERT [CMSSessionState].dbo.ASPStateTempApplications
            VALUES
            (@appId, @appName)
            
            IF @@ERROR = 2627 
            BEGIN
                DECLARE @dupApp tAppName
            
                SELECT @dupApp = RTRIM(AppName)
                FROM [CMSSessionState].dbo.ASPStateTempApplications 
                WHERE AppId = @appId
                
                RAISERROR('SQL session state fatal error: hash-code collision between applications ''%s'' and ''%s''. Please rename the 1st application to resolve the problem.', 
                            18, 1, @appName, @dupApp)
            END
        END

        COMMIT
    END

    RETURN 0
GO
