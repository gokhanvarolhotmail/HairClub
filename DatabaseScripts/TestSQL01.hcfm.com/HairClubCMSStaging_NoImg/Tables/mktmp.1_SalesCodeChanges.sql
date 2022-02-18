/* CreateDate: 02/15/2022 10:52:17.087 , ModifyDate: 02/15/2022 10:52:17.087 */
GO
CREATE TABLE [mktmp].[1_SalesCodeChanges](
	[SalesCodeID] [int] NULL,
	[SalesCodeDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[new_price] [money] NULL,
	[old_price] [money] NULL
) ON [PRIMARY]
GO
