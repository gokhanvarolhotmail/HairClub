/* CreateDate: 03/01/2021 17:56:32.880 , ModifyDate: 03/01/2021 17:56:32.880 */
GO
create procedure [dbo].[sp_MSins_dbodatHairSystemOrderScorecard]     @c1 int,     @c2 uniqueidentifier,     @c3 int,     @c4 datetime,     @c5 uniqueidentifier,     @c6 datetime,     @c7 nvarchar(25),     @c8 datetime,     @c9 nvarchar(25),     @c10 binary(8),     @c11 bit as begin   	insert into [dbo].[datHairSystemOrderScorecard] ( 		[HairSystemOrderScorecardID], 		[HairSystemOrderGUID], 		[ScorecardCategoryID], 		[CompleteDate], 		[CompletedByEmployeeGUID], 		[CreateDate], 		[CreateUser], 		[LastUpdate], 		[LastUpdateUser], 		[UpdateStamp], 		[IsFailProcess] 	) values ( 		@c1, 		@c2, 		@c3, 		@c4, 		@c5, 		@c6, 		@c7, 		@c8, 		@c9, 		@c10, 		@c11	)  end    --
GO
