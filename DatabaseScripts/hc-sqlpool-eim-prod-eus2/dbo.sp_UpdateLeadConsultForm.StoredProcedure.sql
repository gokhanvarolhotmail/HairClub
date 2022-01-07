/****** Object:  StoredProcedure [dbo].[sp_UpdateLeadConsultForm]    Script Date: 1/7/2022 4:05:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_UpdateLeadConsultForm] AS
BEGIN
    UPDATE [dbo].[DimLead]
    SET isconsultformcomplete = f.iscomplete
    FROM (
        SELECT *
        FROM (
            SELECT x.lead__c
                , sc.lastmodifieddate
                , sc.is__completed__c AS iscomplete
                , ROW_NUMBER() OVER (
                    PARTITION BY sc.Lead__c ORDER BY sc.LastModifiedDate DESC
                    ) AS 'RowID'
            FROM [ODS].[SFDC_ConsultationForm] sc
            INNER JOIN (
                SELECT LEad__c
                    , max(lastmodifieddate) AS modified
                FROM [ODS].[SFDC_ConsultationForm]
                GROUP BY lead__c
                    , lastmodifieddate
                ) AS x
                ON x.lead__c = sc.lead__c
                    AND sc.lastmodifieddate = x.modified
            WHERE is__completed__c = 1
            ) AS t
        WHERE t.rowid = 1
        ) AS f
    WHERE f.lead__c = LeadId
END
GO
