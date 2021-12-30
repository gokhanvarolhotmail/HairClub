/* CreateDate: 05/05/2020 17:42:41.487 , ModifyDate: 05/05/2020 17:42:41.487 */
GO
create procedure [sp_MSins_dbocfgConfigurationEmployee]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 nvarchar(50),
    @c4 datetime,
    @c5 nvarchar(25),
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 nvarchar(50),
    @c9 int,
    @c10 nvarchar(50)
as
begin
	insert into [dbo].[cfgConfigurationEmployee] (
		[ConfigurationEmployeeID],
		[EmployeeGUID],
		[NotificationSoundFileName],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[NotificationSoundFileName2],
		[LanguageID],
		[ScanSuccessSoundFileName]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		default,
		@c8,
		@c9,
		@c10	)
end
GO
