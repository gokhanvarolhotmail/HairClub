create procedure [sp_MSins_dboEmail__c]
    @c1 nvarchar(18),
    @c2 nvarchar(18),
    @c3 nchar(10),
    @c4 nchar(10),
    @c5 nvarchar(100),
    @c6 bit,
    @c7 nvarchar(50),
    @c8 bit,
    @c9 nvarchar(18),
    @c10 datetime,
    @c11 nvarchar(18),
    @c12 datetime
as
begin
	insert into [dbo].[Email__c] (
		[Id],
		[Lead__c],
		[OncContactEmailID__c],
		[OncContactID__c],
		[Name],
		[Primary__c],
		[Status__c],
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
		@c11,
		@c12	)
end
