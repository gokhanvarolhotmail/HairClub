/* CreateDate: 01/04/2007 10:34:34.140 , ModifyDate: 06/21/2012 10:11:08.857 */
GO
CREATE TABLE [dbo].[cstd_appointments_matrix](
	[MatrixId] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Center] [int] NULL,
	[ApptDate] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ApptTime] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appts] [smallint] NULL,
 CONSTRAINT [pk_cstd_appointments_matrix] PRIMARY KEY NONCLUSTERED
(
	[MatrixId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
