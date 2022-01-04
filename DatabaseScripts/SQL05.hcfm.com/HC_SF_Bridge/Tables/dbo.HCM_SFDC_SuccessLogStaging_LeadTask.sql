/* CreateDate: 11/10/2017 23:08:03.013 , ModifyDate: 11/10/2017 23:08:03.013 */
GO
CREATE TABLE [dbo].[HCM_SFDC_SuccessLogStaging_LeadTask](
	[placeholder] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder1] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder2] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CST_SFDC_LEAD_ID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder3] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[subject] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[placeholder4] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[action_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder5] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_activity_type_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder6] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[result_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder7] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder8] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[due_date] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder9] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder10] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[completion_date] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder11] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder12] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[usercode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder13] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sf_status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder14] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CREATEDBYL] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder15] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder16] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartTime] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder17] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ownerid] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder18] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sale_type_description] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder19] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[price_quoted] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder20] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sale_type_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder21] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Maritial_status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder22] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Occupation_status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder23] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder24] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[performer] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder25] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ludwig] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder26] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[norwood] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder27] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[disc_style] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder28] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[no_sale_reason] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder29] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[solution_offered] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder30] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lead] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder31] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Processed] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder32] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[placeholder34] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO