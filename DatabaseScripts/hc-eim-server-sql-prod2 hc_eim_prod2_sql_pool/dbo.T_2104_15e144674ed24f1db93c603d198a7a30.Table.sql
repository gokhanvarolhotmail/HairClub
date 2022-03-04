/****** Object:  Table [dbo].[T_2104_15e144674ed24f1db93c603d198a7a30]    Script Date: 3/4/2022 8:28:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2104_15e144674ed24f1db93c603d198a7a30]
(
	[ChannelName] [nvarchar](50) NULL,
	[Hash] [nvarchar](256) NULL,
	[DWH_LastUpdateDate] [datetime2](7) NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [nvarchar](50) NULL,
	[r1571a2238c604c88896aef8eb1788684] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
