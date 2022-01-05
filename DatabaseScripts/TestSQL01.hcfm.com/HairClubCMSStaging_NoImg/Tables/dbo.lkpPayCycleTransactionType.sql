/* CreateDate: 05/14/2012 17:33:38.470 , ModifyDate: 01/04/2022 10:56:36.720 */
GO
CREATE TABLE [dbo].[lkpPayCycleTransactionType](
	[PayCycleTransactionTypeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PayCycleTransactionTypeSortOrder] [int] NOT NULL,
	[PayCycleTransactionTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PayCycleTransactionTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpPayCycleTransactionType] PRIMARY KEY CLUSTERED
(
	[PayCycleTransactionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
