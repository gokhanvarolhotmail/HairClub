/* CreateDate: 04/26/2018 09:34:34.340 , ModifyDate: 04/26/2018 09:34:34.340 */
GO
create procedure [dbo].[sp_MSins_dboSolutionsOffered]     @c1 varchar(50),     @c2 varchar(50),     @c3 int,     @c4 int,     @c5 nvarchar(10) as begin   	insert into [dbo].[SolutionsOffered]( 		[SolutionsCode], 		[Description], 		[Active], 		[SortOrder], 		[BusinessUnitBrandDescriptionShort] 	) values (     @c1,     @c2,     @c3,     @c4,     @c5	)  end    --
GO
