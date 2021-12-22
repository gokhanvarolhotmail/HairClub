/* CreateDate: 04/02/2014 16:54:31.437 , ModifyDate: 07/12/2014 04:23:14.297 */
GO
CREATE TABLE [dbo].[tmpReversals](
	[ReversalsID] [int] IDENTITY(1,1) NOT NULL,
	[CenterID] [int] NOT NULL,
	[PayCycleTransactionGUID] [uniqueidentifier] NULL,
	[PayCycleTransactionTypeID] [int] NULL,
	[SalesOrderGUID] [uniqueidentifier] NOT NULL,
	[MonetraTransactionID] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[ApprovalCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesOrderTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsMonetraReversed] [bit] NOT NULL,
	[ErrorMessage] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WarningMessage] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_Reversals] PRIMARY KEY CLUSTERED
(
	[ReversalsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
