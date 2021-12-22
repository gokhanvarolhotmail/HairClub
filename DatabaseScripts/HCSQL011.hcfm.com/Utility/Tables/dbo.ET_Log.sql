/* CreateDate: 12/02/2014 11:25:41.417 , ModifyDate: 12/02/2014 11:25:41.417 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ET_Log](
	[RunDate] [datetime] NULL,
	[ProcName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[AppointmentDateTime] [datetime] NULL,
	[IsEmailUndeliverable] [bit] NULL,
	[IsAutoConfirmEmail] [bit] NULL
) ON [PRIMARY]
GO
