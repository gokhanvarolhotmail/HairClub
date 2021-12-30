/* CreateDate: 12/11/2012 14:57:18.917 , ModifyDate: 12/11/2012 14:57:18.917 */
GO
/***********************************************************************

PROCEDURE:				extTREConsultationUpdate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS & On Contact

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		9/24/09

LAST REVISION DATE: 	9/28/09 - PRM: Issue 535 - Wasn't able to get security to work correctly via the linked server
									so we're temporarily replacing logic with a table that can be polled by TRE periodically
						10/23/09 - PRM: Issue 566 - Don't create duplicate records in mtnTREBebackExport (duplicate being same day and same client)

--------------------------------------------------------------------------------------------------------
NOTES: 	Calls a stored procedure to update the On Conctact database via TRE system
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

	EXEC extTREConsultationUpdate '0F942549-7C08-40A2-8374-318683A5D799', 'username', 'SHOWSALE'

***********************************************************************/

CREATE PROCEDURE [dbo].[extTREConsultationUpdate]
	  @ClientMembershipGUID uniqueidentifier,
	  @CurrentUser nvarchar(50),
	  @Parameter nvarchar(50)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @SQL nvarchar(4000)

	DECLARE @CenterID int


	DECLARE @SHOWNOSHOWFLAG nvarchar(50)
	IF @Parameter = 'SHOWSALE'
	  BEGIN
		SET @SHOWNOSHOWFLAG = 'SHOWSALE'
	  END
	ELSE
	  BEGIN
		SET @SHOWNOSHOWFLAG = 'SHOWNOSALE'
	  END


	DECLARE @serverName varchar(50)
	DECLARE @Server nvarchar(50)
	SET @serverName = (CAST (SERVERPROPERTY ( 'ComputerNamePhysicalNetBIOS') as varchar(50)))

	IF (@serverName Like '%' + 'DEVDAT' + '%' OR @serverName Like '%' + 'STGWEB' + '%' OR @serverName Like '%' + 'STGDAT' + '%')
	  BEGIN
		SET @Server = 'HairClubOnContact..'
	  END
	ELSE
	  BEGIN
	    --production linked server
		SET @Server = '[HCSQL3\SQL2005].BOS.dbo.'
	  END


	DECLARE @ContactID nvarchar(50)
	SET @ContactID = NULL


	SELECT TOP 1 @ContactID = ContactID, @CenterID = ctr.ReportingCenterID
	FROM datClient c
		INNER JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID
		INNER JOIN cfgCenter ctr ON cm.CenterID = ctr.CenterID --use the non-surgery center id (reporting center)
	WHERE ClientMembershipGUID = @ClientMembershipGUID


	IF NOT @ContactID IS NULL
	  BEGIN
		DECLARE @BeginDate datetime
		DECLARE @EndDate datetime

		SET @BeginDate = CAST(CONVERT(varchar, GETUTCDATE(), 101) AS datetime)
		SET @EndDate = DATEADD(d, 1, @BeginDate)

		--@Parameter = SHOWSALE / SHOWNOSALE
		IF NOT EXISTS(SELECT 1 FROM mtnTREBebackExport WHERE ContactID = @ContactID AND ResultCode = @Parameter)
		  BEGIN

	   		--EXEC spApp_TREConsultations_CreateBeBackActivity 'JVIRBG2PV1', 212, 'schapman', 'SHOWNOSALE'

	   		--Comment this out since we can't get security access to work correctly from TRE server
			--SET @SQL = @Server + 'spApp_TREConsultations_CreateBeBackActivity ''' + @ContactID + ''', ' + CAST(@CenterID as nvarchar) + ', ''' + @CurrentUser + ''', ''' + @SHOWNOSHOWFLAG + ''''
			--EXEC(@SQL)

			--PRINT @SQL

			INSERT INTO mtnTREBebackExport (CenterID, ContactID, Performer, ResultCode, CreateDate, ProcessedDate, IsProcessedFlag) VALUES
				(@CenterID, @ContactID, @CurrentUser, @Parameter, GETUTCDATE(), NULL, 0)
		  END
	  END

END
GO
