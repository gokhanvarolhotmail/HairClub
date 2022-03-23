/* CreateDate: 03/17/2022 11:57:03.607 , ModifyDate: 03/17/2022 11:57:03.607 */
GO
create procedure [sp_MSins_bief_dds_DBErrorLog]
    @c1 int,
    @c2 datetime,
    @c3 nvarchar(128),
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 nvarchar(126),
    @c8 int,
    @c9 nvarchar(4000),
    @c10 nvarchar(1000)
as
begin
	insert into [bief_dds].[_DBErrorLog] (
		[DBErrorLogID],
		[ErrorTime],
		[UserName],
		[ErrorNumber],
		[ErrorSeverity],
		[ErrorState],
		[ErrorProcedure],
		[ErrorLine],
		[ErrorMessage],
		[ErrorDetails]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10	)
end
GO
