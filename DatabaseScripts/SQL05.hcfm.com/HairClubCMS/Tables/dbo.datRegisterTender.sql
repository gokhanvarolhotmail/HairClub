/* CreateDate: 05/05/2020 17:42:51.833 , ModifyDate: 05/05/2020 17:43:13.173 */
GO
CREATE TABLE [dbo].[datRegisterTender](
	[RegisterTenderGUID] [uniqueidentifier] NOT NULL,
	[RegisterLogGUID] [uniqueidentifier] NOT NULL,
	[TenderTypeID] [int] NOT NULL,
	[TenderQuantity] [int] NULL,
	[TenderTotal] [money] NULL,
	[RegisterQuantity] [int] NULL,
	[RegisterTotal] [money] NULL,
	[TotalVariance]  AS (isnull([TenderTotal],(0.00))-isnull([RegisterTotal],(0.00))),
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datRegisterTender] PRIMARY KEY CLUSTERED
(
	[RegisterTenderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
