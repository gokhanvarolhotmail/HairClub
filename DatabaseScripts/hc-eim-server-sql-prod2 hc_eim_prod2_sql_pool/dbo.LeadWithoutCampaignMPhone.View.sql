/****** Object:  View [dbo].[LeadWithoutCampaignMPhone]    Script Date: 3/15/2022 2:11:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LeadWithoutCampaignMPhone]
AS WITH LeadWCampMem AS (
	SELECT DISTINCT L.[Id]
	FROM [ODS].[SF_Lead] L
	LEFT JOIN [ODS].[SF_CampaignMember] CM ON CM.[LeadId]  = L.[Id]
	WHERE CM.[LeadId] IS NULL
),LeadSCampaign AS (
	SELECT a.Id, A.Name, a.CreatedDate ,B.start_time
		,ABS(CAST( DATEDIFF(SECOND,a.CreatedDate,B.start_time) AS float) / CAST(60 AS float)) * -1 AS DifMin
		--,CAST( DATEDIFF(SECOND,a.CreatedDate,B.start_time) AS float) / CAST(60 AS float) AS SDFS
		,a.Status
		,a.MobilePhone
		,a.Phone
		,B.[from_phone]
		,B.[original_destination_phone]
		,B.[disposition]
		, NT.Name AS TOLL_FREE
		, ROW_NUMBER() OVER( partition by a.Id order by ABS(CAST( DATEDIFF(SECOND,a.CreatedDate,B.start_time) AS float) / CAST(60 AS float)) * -1  DESC) AS RowNum
	FROM [ODS].[SF_Lead] a
	INNER JOIN [ODS].[BP_CallDetail] b
		ON TRIM(REPLACE(REPLACE(REPLACE(REPLACE(A.MobilePhone, '(','') ,')',''), ' ', ''), '-','')) = substring([from_phone],2,len([from_phone]))
		and convert(date,start_time)=convert(date,A.CreatedDate)
	LEFT JOIN [ODS].[SF_TollFree] NT ON NT.Name = substring([original_destination_phone],2,len([original_destination_phone]))
	INNER JOIN LeadWCampMem LC ON LC.Id = a.Id
	WHERE
		convert(date,A.CreatedDate)>='2021-06-15'
		and convert(date,start_time)>='2021-06-15'
		AND ISNUMERIC(B.[from_phone]) = 1
		--AND a.Name != 'NewCaller'
	--ORDER BY A.Name
)SELECT *
FROM LeadSCampaign
WHERE RowNum = 1;
GO
