/* CreateDate: 04/20/2020 15:23:18.373 , ModifyDate: 04/20/2020 15:23:18.373 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				extBosleyQueueSalesforceUpdate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Edmund Poillion

IMPLEMENTOR: 			Edmund Poillion

DATE IMPLEMENTED: 		04/17/2020

LAST REVISION DATE: 	04/17/2020

--------------------------------------------------------------------------------------------------------
NOTES: 	Queue up Salesforce updates from Bosley by inserting row into logBosleySalesforce table.  Called from [dbo].[extBosleyProcessTransactions].
	* 04/17/2020 EJP - Created
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyQueueSalesforceUpdate] @CurrentTransactionIdBeingProcessed = 91982

***********************************************************************/

CREATE   PROCEDURE [dbo].[extBosleyQueueSalesforceUpdate]
	  @CurrentTransactionIdBeingProcessed int  -- = 11092
AS
BEGIN

	SET NOCOUNT ON;

	WITH BosleyTransactionInfo AS
	(
		SELECT
			irl.BosleyRequestID AS [BosleyRequestID],
			COALESCE(irl.HCSalesforceLeadID, cli.SalesforceContactID) AS [HCSalesforceLeadID],
			ctr.CenterNumber AS [CenterID__c],
			N'Be Back' AS [Action__c],
			N'Internal' AS [ActivityType__c],
			ISNULL(irl.HCSalesforceLeadID, cli.SalesforceContactID) AS [WhoId],
			ISNULL(TreatmentPlanDate, GETDATE()) AS [AppointmentDate__c],
			ISNULL(TreatmentPlanDate, GETUTCDATE()) AS [CompletionDate__c],
			ISNULL(TreatmentPlanDate, GETUTCDATE()) AS [ActivityDate],
			ISNULL(TreatmentPlanDate, GETUTCDATE()) AS [StartTime__c],
			ISNULL(DATEADD(HOUR, 1, TreatmentPlanDate), GETUTCDATE()) AS [EndTime__c],
			N'4' AS [SaleTypeCode__c],
			N'Bosley Medical Services' AS [SaleTypeDescription__c],
			ISNULL(irl.TreatmentPlanContractAmount, 0) AS [PriceQuoted__c],
			emp.EmployeeFullNameCalc AS [Performer__c],
			N'Event' AS [Subject],
			N'Show Sale' AS [Result__c],
			CASE WHEN cli.GenderID = 1 THEN ns.NorwoodScaleDescription ELSE NULL END AS NorwoodScale__c,
			CASE WHEN cli.GenderID = 2 THEN ls.LudwigScaleDescription ELSE NULL END AS LudwigScale__c,
			occ.OccupationDescription AS Occupation__c,
			ms.MaritalStatusDescription AS MaritalStatus__c,
			ds.DISCStyleDescription AS DISC__c,
			irl.CreateDate AS [ReportCreateDate__c]
		FROM
			datIncomingRequestLog irl
		LEFT JOIN
			datEmployee emp ON emp.UserLogin = REPLACE(irl.ConsultantUserName, '_HAIRCLUB', '')
		LEFT JOIN
			datClient cli ON cli.ClientIdentifier = irl.ConectID
		LEFT JOIN
			datClientDemographic cd ON cd.ClientGUID = cli.ClientGUID
		LEFT JOIN
			lkpNorwoodScale ns ON ns.NorwoodScaleID = cd.NorwoodScaleID
		LEFT JOIN
			lkpLudwigScale ls ON ls.LudwigScaleID = cd.LudwigScaleID
		LEFT JOIN
			dbo.lkpOccupation occ ON occ.OccupationID = cd.OccupationID
		LEFT JOIN
			dbo.lkpMaritalStatus ms ON ms.MaritalStatusID = cd.MaritalStatusID
		LEFT JOIN
			dbo.lkpDISCStyle ds ON ds.DISCStyleID = cd.DISCStyleID
		LEFT JOIN
			cfgCenter ctr ON ctr.CenterID = cli.CenterID
		WHERE
			irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
	)
	INSERT INTO [dbo].[logBosleySalesforce]
		([BosleyRequestID]
		,[HCSalesforceLeadID]
		,[CenterID__c]
		,[Action__c]
		,[ActivityType__c]
		,[WhoId]
		,[AppointmentDate__c]
		,[CompletionDate__c]
		,[ActivityDate]
		,[StartTime__c]
		,[EndTime__c]
		,[SaleTypeCode__c]
		,[SaleTypeDescription__c]
		,[PriceQuoted__c]
		,[Performer__c]
		,[Result__c]
		,[LeadID]
		,[Status]
		,[FullName__c]
		,[CreateDate]
		,[Subject]
		,[NorwoodScale__c]
		,[LudwigScale__c]
		,[Occupation__c]
		,[MaritalStatus__c]
		,[DISC__c]
		,[ReportCreateDate__c]
		,[TaskID]
		,[IsProcessed]
		,[IsIgnore])
		SELECT
			[BosleyRequestID] AS [BosleyRequestID],
			[HCSalesforceLeadID] AS [HCSalesforceLeadID],
			[CenterID__c] AS [CenterID__c],
			[Action__c] AS [Action__c],
			[ActivityType__c] AS [ActivityType__c],
			[WhoId] AS [WhoId],
			[AppointmentDate__c] AS [AppointmentDate__c],
			[CompletionDate__c] AS [CompletionDate__c],
			[ActivityDate] AS [ActivityDate],
			CONVERT(nvarchar(5), TIMEFROMPARTS(DATEPART(HOUR, [StartTime__c]), 0, 0, 0, 0), 108) AS [StartTime__c],
			CONVERT(nvarchar(5), TIMEFROMPARTS(DATEPART(HOUR, [EndTime__c]), 0, 0, 0, 0), 108) AS [EndTime__c],
			[SaleTypeCode__c] AS [SaleTypeCode__c],
			[SaleTypeDescription__c] AS [SaleTypeDescription__c],
			[PriceQuoted__c] AS [PriceQuoted__c],
			[Performer__c] AS [Performer__c],
			[Result__c] AS [Result__c],
			NULL AS [LeadID],
			NULL AS [Status],
			NULL AS [FullName__c],
			GETDATE() AS [CreateDate],
			[Subject] AS [Subject],
			[NorwoodScale__c] AS [NorwoodScale__c],
			[LudwigScale__c] AS [LudwigScale__c],
			[Occupation__c] AS [Occupation__c],
			[MaritalStatus__c] AS [MaritalStatus__c],
			[DISC__c] AS [DISC__c],
			[ReportCreateDate__c] AS [ReportCreateDate__c],
			NULL AS [TaskID],
			0 AS [IsProcessed],
			0 AS [IsIgnore]
	FROM
		BosleyTransactionInfo;
END




-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-- Update extBosleyProcessTransactions stored procedure
--     - Replace calls to extBosleyUpdateSalesforce with calls to extBosleyQueueSalesforceUpdate
/****** Object:  StoredProcedure [dbo].[extBosleyProcessTransactions]    Script Date: 4/17/2020 11:58:06 AM ******/
SET ANSI_NULLS ON
GO
