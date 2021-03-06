/* CreateDate: 10/30/2017 13:34:10.093 , ModifyDate: 10/30/2017 13:34:10.093 */
GO
CREATE TABLE [dbo].[HCM_SFDC_ErrorLog_LeadPhone](
	[leadtask_error_date] [datetime] NULL,
	[CONTACT_ID] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CST_DO_NOT_CALL] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CONTACT_PHONE_ID] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PHONE_TYPE_CODE] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[COUNTRY_CODE_PREFIX] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AREA_CODE] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PHONE_NUMBER] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXTENSION] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STATUS] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CREATION_DATE] [datetime] NULL,
	[UPDATED_DATE] [datetime] NULL,
	[PRIMARY_FLAG] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CST_VALID_FLAG] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CST_LAST_DNC_DATE] [datetime] NULL,
	[CST_FULL_PHONE_NUMBER] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DNC_FLAG] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EBR_DNC_FLAG] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EBR_DNC_DATE] [datetime] NULL,
	[error] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[CONTACT_PHONE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
