/* CreateDate: 08/10/2006 14:38:51.030 , ModifyDate: 05/08/2010 02:30:04.653 */
GO
CREATE TABLE [dbo].[Appointments_Special_Closings](
	[closingID] [int] IDENTITY(1,1) NOT NULL,
	[Center] [int] NULL,
	[CloseDate] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FromTime] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ToTime] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active] [bit] NULL,
	[TimeStamp] [datetime] NULL,
 CONSTRAINT [PK_Appointments_Special_Closings] PRIMARY KEY CLUSTERED
(
	[closingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Appointments_Special_Closings] ADD  CONSTRAINT [DF_Appointments_Special_Closings_TimeStamp]  DEFAULT (getdate()) FOR [TimeStamp]
GO
