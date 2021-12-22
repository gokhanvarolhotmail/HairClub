create procedure [sp_MSins_dboSaleTypeCode__c]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nvarchar(50),
    @c4 int,
    @c5 bit,
    @c6 nvarchar(18),
    @c7 datetime,
    @c8 nvarchar(18),
    @c9 datetime
as
begin
	insert into [dbo].[SaleTypeCode__c] (
		[Id],
		[SaleTypeCode__c],
		[SaleTypeDescription__c],
		[SortOrder],
		[IsActiveFlag],
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
		@c9	)
end
