/* CreateDate: 02/17/2022 13:35:43.150 , ModifyDate: 02/17/2022 13:35:43.150 */
GO
CREATE TABLE [dbo].[HCM_SFDC_Client](
	[cst_sfdc_client_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Client_id] [int] NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL
) ON [PRIMARY]
GO
