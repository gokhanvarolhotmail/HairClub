/* CreateDate: 05/05/2020 17:42:44.647 , ModifyDate: 05/05/2020 17:42:44.647 */
GO
create procedure [sp_MSins_dbocfgPostalCode]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nvarchar(10),
    @c4 nvarchar(10),
    @c5 int,
    @c6 nvarchar(10),
    @c7 int,
    @c8 int
as
begin
	insert into [dbo].[cfgPostalCode] (
		[zip_code],
		[city],
		[country_code],
		[state_code],
		[county_code],
		[facility_code],
		[StateID],
		[CountryID]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8	)
end
GO
