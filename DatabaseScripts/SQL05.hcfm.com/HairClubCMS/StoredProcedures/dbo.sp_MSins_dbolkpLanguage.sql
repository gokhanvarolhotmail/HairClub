/* CreateDate: 05/05/2020 17:42:41.340 , ModifyDate: 05/05/2020 17:42:41.340 */
GO
create procedure [dbo].[sp_MSins_dbolkpLanguage]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 binary(8),
    @c11 nvarchar(10)
as
begin
	insert into [dbo].[lkpLanguage] (
		[LanguageID],
		[LanguageSortOrder],
		[LanguageDescription],
		[LanguageDescriptionShort],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[OnContactLanguageCode]
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
		@c11	)
end
GO
