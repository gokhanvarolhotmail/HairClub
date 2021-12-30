/* CreateDate: 10/04/2019 14:09:30.533 , ModifyDate: 10/04/2019 14:09:30.533 */
GO
create procedure [sp_MSins_dboUser]
    @c1 nvarchar(18),
    @c2 nvarchar(40),
    @c3 nvarchar(80),
    @c4 nvarchar(102),
    @c5 nvarchar(80),
    @c6 nvarchar(20),
    @c7 nvarchar(8),
    @c8 nvarchar(80),
    @c9 nvarchar(80),
    @c10 nvarchar(80),
    @c11 nvarchar(50),
    @c12 bit,
    @c13 nvarchar(18),
    @c14 datetime,
    @c15 nvarchar(18),
    @c16 datetime
as
begin
	insert into [dbo].[User] (
		[Id],
		[FirstName],
		[LastName],
		[Name],
		[Username],
		[UserCode__c],
		[Alias],
		[Title],
		[Department],
		[CompanyName],
		[Team],
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
		@c12,
		@c13,
		@c14,
		@c15,
		@c16	)
end
GO
