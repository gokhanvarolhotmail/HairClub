/* CreateDate: 10/26/2017 10:47:46.540 , ModifyDate: 10/26/2017 20:43:53.453 */
GO
CREATE TABLE [dbo].[HCM_SFDC_Client](
	[cst_sfdc_client_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Client_id] [int] NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
PRIMARY KEY CLUSTERED
(
	[cst_sfdc_client_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
