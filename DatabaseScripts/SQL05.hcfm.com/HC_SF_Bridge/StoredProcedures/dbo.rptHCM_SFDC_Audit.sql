/* CreateDate: 11/20/2017 12:01:30.617 , ModifyDate: 11/29/2017 09:39:32.090 */
GO
/*======================================================================================================
-- Author:		Daniel Polania
-- Create date: 11/20/2017
-- Description:	Gets counts of leads created
--				in OnContact by pagelinxs or a center
--				and checks against the bridge table to
--				confirm what was added to SFDC
=======================================================================================================
CHANGE HISTORY:
11/29/2017 - RH - Added 'Client' as ContactStatusDescription when pulling data from DimContact
=======================================================================================================

EXEC [rptHCM_SFDC_Audit] '11/21/2017','11/21/2017'
-- ===================================================================================================*/

CREATE PROCEDURE [dbo].[rptHCM_SFDC_Audit]
    -- Add the parameters for the stored procedure here
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    SET @EndDate = @EndDate + '23:59.000';


    -- Insert statements for procedure here
    DECLARE @OncPagelinxLeads INT;
    DECLARE @SFPagelinxLeads INT;
    DECLARE @SFNONPagelinxLeads INT;
    DECLARE @BiLeads INT;
    DECLARE @OncPagelinxTask INT;
    DECLARE @SFPagelinxTask INT;
    DECLARE @SFNONPagelinxTask INT;
    DECLARE @BiTask INT;


    --Create Audit Table
    CREATE TABLE #SFDC_HCM_Audit
    (
        ObjectType VARCHAR(50),
        StartDate DATE,
        EndDate DATE,
        Onc_Pagelinx INT,
        SF_Pagelinx INT,
        SF_NotPagelinx INT,
        PagelinxTotal INT,
        BI INT
    );

    /*************** LEADS ***************************************************/

    --Get Count of Leads Added to SFDC - Pagelinx or Center
    SELECT @SFPagelinxLeads = COUNT(DISTINCT cst_sfdc_lead_id)
    FROM [HC_SF_Bridge].[dbo].[HCM_SFDC_SuccessLog_Lead] WITH (NOLOCK)
    WHERE create_date
    BETWEEN @StartDate AND @EndDate;

    --Get Count of Leads from Salesforce, but not from Pagelinx or Center
    SET @SFNONPagelinxLeads =
    (
        SELECT COUNT(DISTINCT OC.cst_sfdc_lead_id)
        FROM HCM.dbo.oncd_contact AS OC
        WHERE (OC.created_by_user_code <> 'TM 600')
              AND OC.creation_date
              BETWEEN @StartDate AND @EndDate
    );

    --Get Count of Leads Created in OnContact by Pagelinx or Center
    SELECT @OncPagelinxLeads = COUNT(DISTINCT OC.contact_id)
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
            ON OAC.contact_id = OC.contact_id
    WHERE (
              OC.created_by_user_code = 'TM 600'
              OR OC.created_by_user_code LIKE '[1-9]%'
          )
          AND OC.creation_date
          BETWEEN @StartDate AND @EndDate;

    --Find Leads in DimContact
    SELECT CON.[ContactSSID],
           CON.CreationDate
    INTO #Contacts
    FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimContact] CON WITH (NOLOCK)
    WHERE CreationDate
          BETWEEN @StartDate AND @EndDate
          AND ContactStatusDescription IN ( 'Lead', 'Client' )
	GROUP BY CON.ContactSSID
           , CON.CreationDate;

    SET @BiLeads =
    (
        SELECT COUNT(ContactSSID) FROM #Contacts
    );



    --Insert Lead Counts into Audit Table
    INSERT INTO #SFDC_HCM_Audit
    (
        ObjectType,
        StartDate,
        EndDate,
        Onc_Pagelinx,
        SF_Pagelinx,
        SF_NotPagelinx,
        BI
    )
    VALUES
    (   'Leads',                      -- ObjectType - varchar(50)
        CAST(@StartDate AS DATETIME), -- CreatedDate - date
        CAST(@EndDate AS DATETIME),   -- CreatedDate - date
        @OncPagelinxLeads,            -- Oncontact - int
        @SFPagelinxLeads,             -- Salesforce - int
        @SFNONPagelinxLeads,          -- Salesforce_NON Pagelinx
        @BiLeads                      -- BI - int
    );


    /******************* TASKS ************************************************/

    --Get Count of Tasks Added to SFDC
    SELECT @SFPagelinxTask = COUNT(DISTINCT HSSLLT.cst_sfdc_task_id)
    FROM [HC_SF_Bridge].[dbo].[HCM_SFDC_SuccessLog_LeadTask] AS [HSSLLT] WITH (NOLOCK)
    WHERE HSSLLT.create_date
    BETWEEN @StartDate AND @EndDate;



    -- Get Count of Tasks Created in OnContact by Pagelinx or Center
    SELECT @OncPagelinxTask = COUNT(DISTINCT OA.activity_id)
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
            ON OAC.contact_id = OC.contact_id
        INNER JOIN HCM.dbo.oncd_activity AS OA WITH (NOLOCK)
            ON OA.activity_id = OAC.activity_id
    WHERE (
              OA.created_by_user_code = 'TM 600'
              OR OA.created_by_user_code LIKE '[1-9]%'
          )
          AND OA.creation_date
          BETWEEN @StartDate AND @EndDate
          AND (
                  OA.cst_import_note != 'Activity created by Trigger'
                  OR OA.cst_import_note IS NULL
              );

    -- Get Count of Tasks NOT Created in OnContact by Pagelinx or Center
    SELECT @SFNONPagelinxTask = COUNT(DISTINCT OA.activity_id)
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
            ON OAC.contact_id = OC.contact_id
        INNER JOIN HCM.dbo.oncd_activity AS OA WITH (NOLOCK)
            ON OA.activity_id = OAC.activity_id
    WHERE (OA.created_by_user_code <> 'TM 600')
          AND OA.creation_date
          BETWEEN @StartDate AND @EndDate
          AND OA.cst_import_note != 'Activity created by Trigger';


    SELECT AC.activity_id
    INTO #TriggerTask
    FROM HCM.dbo.oncd_activity AS AC WITH (NOLOCK)
    WHERE AC.creation_date
          BETWEEN @StartDate AND @EndDate
          AND cst_do_not_export = 'Y'
          AND (
                  cst_import_note IS NULL
                  OR cst_import_note = 'Activity created by Trigger'
              )
	GROUP BY AC.activity_id;


    --Find Activities from DimActivity
    SELECT ActivitySSID
    INTO #Activities
    FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivity] DA WITH (NOLOCK)
    WHERE DA.ActivitySSID IN (
                                 SELECT AC.activity_id
                                 FROM HCM.dbo.oncd_activity AS AC WITH (NOLOCK)
                                 WHERE AC.creation_date
                                 BETWEEN @StartDate AND @EndDate
                             )
          AND ActivitySSID NOT IN (
                                      SELECT activity_id FROM #TriggerTask
                                  )
	GROUP BY DA.ActivitySSID;

    SET @BiTask =
    (
        SELECT COUNT(DISTINCT ActivitySSID) FROM #Activities
    );

    --Insert Task Counts into Audit Table
    INSERT INTO #SFDC_HCM_Audit
    (
        ObjectType,
        StartDate,
        EndDate,
        Onc_Pagelinx,
        SF_Pagelinx,
        SF_NotPagelinx,
        BI
    )
    VALUES
    (   'Task',           -- ObjectType - varchar(50)
        CAST(@StartDate AS DATETIME),
        CAST(@EndDate AS DATETIME),
        @OncPagelinxTask, -- Oncontact - int
        @SFPagelinxTask,  -- Salesforce - int
        @SFNONPagelinxTask,
        @BiTask           -- BI - int
    );

    /************** FINAL SELECT Statement *****************************/

    SELECT SHA.ObjectType,
           SHA.StartDate,
           SHA.EndDate,
           SHA.Onc_Pagelinx,
           SHA.SF_Pagelinx,
           SHA.SF_NotPagelinx,
           CAST((SHA.SF_Pagelinx + SHA.SF_NotPagelinx) AS INT) AS 'Total',
           SHA.BI,
           CAST((SHA.BI - (SHA.SF_Pagelinx + SHA.SF_NotPagelinx)) AS INT) AS 'BI Difference',
           CAST((SHA.Onc_Pagelinx - SHA.SF_Pagelinx) AS INT) AS 'OnContact to SFDC Difference'
    FROM #SFDC_HCM_Audit AS SHA;

    DROP TABLE #SFDC_HCM_Audit;

END;
GO
