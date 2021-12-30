/* CreateDate: 10/04/2019 14:09:30.157 , ModifyDate: 10/04/2019 14:09:30.157 */
GO
create procedure [sp_MSins_dboAction__c]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nchar(10),
    @c4 bit,
    @c5 nvarchar(18),
    @c6 datetime,
    @c7 nvarchar(18),
    @c8 datetime,
    @c9 nvarchar(50)
as
begin
	insert into [dbo].[Action__c] (
		[Id],
		[Action__c],
		[ONC_ActionCode],
		[IsActiveFlag],
		[CreatedById],
		[CreatedDate],
		[LastModifiedById],
		[LastModifiedDate],
		[ONC_ActionCodeDescription]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9	)
end
GO
