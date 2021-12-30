/* CreateDate: 03/15/2021 09:16:05.557 , ModifyDate: 03/15/2021 09:16:05.557 */
GO
create procedure [sp_MSins_dbolkpRegion]     @c1 int,     @c2 int,     @c3 nvarchar(100),     @c4 nvarchar(10),     @c5 bit,     @c6 datetime,     @c7 nvarchar(25),     @c8 datetime,     @c9 nvarchar(25),     @c10 int,     @c11 uniqueidentifier,     @c12 int as begin   	insert into [dbo].[lkpRegion] ( 		[RegionID], 		[RegionSortOrder], 		[RegionDescription], 		[RegionDescriptionShort], 		[IsActiveFlag], 		[CreateDate], 		[CreateUser], 		[LastUpdate], 		[LastUpdateUser], 		[UpdateStamp], 		[RegionNumber], 		[RegionalVicePresidentGUID], 		[RegionLeadTime] 	) values ( 		@c1, 		@c2, 		@c3, 		@c4, 		@c5, 		@c6, 		@c7, 		@c8, 		@c9, 		default, 		@c10, 		@c11, 		@c12	)  end    --
GO
