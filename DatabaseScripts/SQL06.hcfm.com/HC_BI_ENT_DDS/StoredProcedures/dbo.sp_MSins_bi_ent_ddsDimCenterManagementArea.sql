/* CreateDate: 01/08/2021 15:21:53.520 , ModifyDate: 01/08/2021 15:21:53.520 */
GO
create procedure [dbo].[sp_MSins_bi_ent_ddsDimCenterManagementArea]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 nvarchar(100),
    @c5 nvarchar(10),
    @c6 uniqueidentifier,
    @c7 nchar(1)
as
begin
	insert into [bi_ent_dds].[DimCenterManagementArea] (
		[CenterManagementAreaKey],
		[CenterManagementAreaSSID],
		[CenterManagementAreaSortOrder],
		[CenterManagementAreaDescription],
		[CenterManagementAreaDescriptionShort],
		[OperationsManagerSSID],
		[Active]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7	)
end
GO
