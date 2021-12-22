create procedure [sp_MSins_dbodatOutgoingResponseLog]
    @c1 int,
    @c2 int,
    @c3 varchar(50),
    @c4 varchar(2000),
    @c5 varchar(2000),
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25)
as
begin
	insert into [dbo].[datOutgoingResponseLog](
		[OutgoingResponseID],
		[OutgoingRequestID],
		[SeibelID],
		[ErrorMessage],
		[ExceptionMessage],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp]
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
    default	)
end
