create procedure [dbo].[sp_MSins_dboAccount]
    @c1 nvarchar(18),
    @c2 nvarchar(18),
    @c3 nvarchar(18),
    @c4 nvarchar(80),
    @c5 nvarchar(80),
    @c6 nvarchar(80),
    @c7 bit,
    @c8 nvarchar(18),
    @c9 datetime,
    @c10 nvarchar(18),
    @c11 datetime
as
begin
	insert into [dbo].[Account] (
		[Id],
		[PersonContactId],
		[RecordTypeId],
		[AccountNumber],
		[FirstName],
		[LastName],
		[IsDeleted],
		[CreatedById],
		[CreatedDate],
		[LastModifiedById],
		[LastModifiedDate]
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
