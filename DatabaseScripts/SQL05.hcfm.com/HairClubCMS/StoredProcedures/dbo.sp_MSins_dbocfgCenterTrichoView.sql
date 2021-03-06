/* CreateDate: 05/05/2020 17:42:41.177 , ModifyDate: 05/05/2020 17:42:41.177 */
GO
create procedure [sp_MSins_dbocfgCenterTrichoView]
    @c1 int,
    @c2 int,
    @c3 bit,
    @c4 bit,
    @c5 bit,
    @c6 bit,
    @c7 bit,
    @c8 bit,
    @c9 bit,
    @c10 bit,
    @c11 bit,
    @c12 bit,
    @c13 datetime,
    @c14 nvarchar(25),
    @c15 datetime,
    @c16 nvarchar(25),
    @c17 bit,
    @c18 bit,
    @c19 bit,
    @c20 bit
as
begin
	insert into [dbo].[cfgCenterTrichoView] (
		[CenterTrichoViewID],
		[CenterID],
		[IsProfileAvailable],
		[IsScalpAvailable],
		[IsScopeAvailable],
		[IsDensityAvailable],
		[IsWidthAvailable],
		[IsScaleAvailable],
		[IsHealthAvailable],
		[IsHMIAvailable],
		[IsSurveyAvailable],
		[IsTrichoViewReportAvailable],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsImageEditorAvailable],
		[IsSebumAvailable],
		[IsScalpHealthAvailable],
		[IsHighResUploadAvailable]
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
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		default,
		@c17,
		@c18,
		@c19,
		@c20	)
end
GO
