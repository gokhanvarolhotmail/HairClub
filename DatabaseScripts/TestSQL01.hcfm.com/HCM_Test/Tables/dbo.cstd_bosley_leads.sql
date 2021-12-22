/* CreateDate: 09/17/2015 09:41:54.507 , ModifyDate: 09/17/2015 09:41:54.507 */
GO
CREATE TABLE [dbo].[cstd_bosley_leads](
	[ContactOrigin] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InquireDate] [datetime] NULL,
	[MostRecentActivityDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MostRecentActivityType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PtID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FST_NAME] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LAST_NAME] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Initial_SC] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PRIMARY_SC] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Contact_SC_Priority] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CELL_PH_NUM] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HOME_PH_NUM] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WORK_PH_NUM] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EMAIL_ADDR] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DNE] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CNE] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PTStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address_1] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address_2] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address_3] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NoMail] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanNotMail] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NoFurtherContact] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
