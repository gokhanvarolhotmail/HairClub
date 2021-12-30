/* CreateDate: 05/05/2020 17:42:47.703 , ModifyDate: 05/05/2020 17:43:06.830 */
GO
CREATE TABLE [dbo].[datInterCompanyTransaction](
	[InterCompanyTransactionId] [int] NOT NULL,
	[CenterId] [int] NOT NULL,
	[ClientHomeCenterId] [int] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[IsClosed] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[SalesOrderGUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_datInterCompanyTransaction] PRIMARY KEY CLUSTERED
(
	[InterCompanyTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
