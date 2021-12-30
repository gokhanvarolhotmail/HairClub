/* CreateDate: 08/10/2006 14:37:17.370 , ModifyDate: 05/08/2010 02:30:04.627 */
GO
CREATE TABLE [dbo].[Appointments_Matrix](
	[MatrixId] [bigint] IDENTITY(1,1) NOT NULL,
	[Center] [int] NULL,
	[ApptDate] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ApptTime] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appts] [smallint] NULL,
 CONSTRAINT [PK_Appointments_Matrix] PRIMARY KEY CLUSTERED
(
	[MatrixId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
