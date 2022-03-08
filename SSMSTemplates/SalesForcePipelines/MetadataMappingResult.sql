-- IF OBJECT_ID('[tempdb]..[##MappingResult]') IS NOT NULL DROP TABLE [##MappingResult]
GO
CREATE TABLE [##MappingResult] ( [ObjectName] nvarchar(128), [ColumnName] nvarchar(128), [ColumnId] int, [AllCnt] int, [NotNullCnt] int, [ExistingDataAllNulls] int, [CurrentlyUsed] int, [HC_BI_SFDC_ColumnDef] varchar(256), [SalesForceImport_ColumnDef] varchar(256) )
GO
SET XACT_ABORT ON
GO
SET NOCOUNT ON
GO
BEGIN TRANSACTION
GO
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Id', 1, 740265, 740265, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonContactId', 2, 740265, 740223, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'MasterRecordId', 3, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'RecordTypeId', 3, 740265, 740264, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'AccountNumber', 4, 740265, 40, 0, 1, 'nvarchar(80)', 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Name', 4, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'FirstName', 5, 740265, 740198, 0, 1, 'nvarchar(80)', 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'LastName', 6, 740265, 740223, 0, 1, 'nvarchar(80)', 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'IsDeleted', 7, 740265, 740265, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Salutation', 7, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'CreatedById', 8, 740265, 740265, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'MiddleName', 8, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'CreatedDate', 9, 740265, 740265, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Suffix', 9, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'LastModifiedById', 10, 740265, 740265, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Type', 10, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'LastModifiedDate', 11, 740265, 740265, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ParentId', 12, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'BillingStreet', 13, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'BillingCity', 14, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'BillingState', 15, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'BillingPostalCode', 16, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'BillingCountry', 17, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'BillingStateCode', 18, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'BillingCountryCode', 19, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'BillingLatitude', 20, NULL, NULL, NULL, 1, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'BillingLongitude', 21, NULL, NULL, NULL, 1, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'BillingGeocodeAccuracy', 22, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ShippingStreet', 23, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ShippingCity', 24, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ShippingState', 25, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ShippingPostalCode', 26, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ShippingCountry', 27, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ShippingStateCode', 28, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ShippingCountryCode', 29, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ShippingLatitude', 30, NULL, NULL, NULL, 1, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ShippingLongitude', 31, NULL, NULL, NULL, 1, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ShippingGeocodeAccuracy', 32, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Phone', 33, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Fax', 34, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Website', 36, NULL, NULL, NULL, 1, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PhotoUrl', 37, NULL, NULL, NULL, 1, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Sic', 38, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Industry', 39, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'AnnualRevenue', 40, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'NumberOfEmployees', 41, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Ownership', 42, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'TickerSymbol', 43, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Description', 44, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Rating', 45, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Site', 46, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'CurrencyIsoCode', 47, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'OwnerId', 48, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'SystemModstamp', 53, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'LastActivityDate', 54, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'LastViewedDate', 55, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'LastReferencedDate', 56, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'IsPersonAccount', 58, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonMailingStreet', 59, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonMailingCity', 60, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonMailingState', 61, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonMailingPostalCode', 62, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonMailingCountry', 63, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonMailingStateCode', 64, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonMailingCountryCode', 65, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonMailingLatitude', 66, NULL, NULL, NULL, 1, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonMailingLongitude', 67, NULL, NULL, NULL, 1, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonMailingGeocodeAccuracy', 68, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonMobilePhone', 69, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonHomePhone', 70, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonOtherPhone', 71, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonAssistantPhone', 72, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonEmail', 73, NULL, NULL, NULL, 1, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonTitle', 74, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonDepartment', 75, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonDoNotCall', 76, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonLastCURequestDate', 77, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonLastCUUpdateDate', 78, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonEmailBouncedReason', 79, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonEmailBouncedDate', 80, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Jigsaw', 81, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'JigsawCompanyId', 82, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'AccountSource', 83, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'SicDesc', 84, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'OperatingHoursId', 85, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Active__c', 86, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Company__c', 87, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ConectCreationDate__c', 88, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ConectLastUpdate__c', 89, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'External_Id__c', 90, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'PersonMobilePhone_Number_Normalized__c', 91, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Status__c', 92, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Count_Close_Won_Opportunities__c', 93, NULL, NULL, NULL, 1, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ClientIdentifier__c', 94, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Occupation__c', 95, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'AreaManager__c', 96, NULL, NULL, NULL, 1, NULL, 'varchar(100)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Area__c', 97, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'AssistantManager__c', 98, NULL, NULL, NULL, 1, NULL, 'varchar(100)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'BackLinePhone__c', 99, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'BestTressedOffered__c', 100, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'CenterAlert__c', 101, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'CenterOwner__c', 102, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'CenterType__c', 103, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'CompanyID__c', 104, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ConfirmationCallerIDEnglish__c', 105, NULL, NULL, NULL, 1, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ConfirmationCallerIDFrench__c', 106, NULL, NULL, NULL, 1, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ConfirmationCallerIDSpanish__c', 107, NULL, NULL, NULL, 1, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'CustomerServiceLine__c', 108, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Customer_Status__c', 109, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'DNCDateMobilePhone__c', 110, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'DNCDatePhone__c', 111, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'DNCValidationMobilePhone__c', 112, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'DNCValidationPhone__c', 113, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'DisplayName__c', 114, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ImageConsultant__c', 115, NULL, NULL, NULL, 1, NULL, 'varchar(100)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'MDPOffered__c', 116, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'MDPPerformed__c', 117, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ManagerName__c', 118, NULL, NULL, NULL, 1, NULL, 'varchar(100)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'MgrCellPhone__c', 119, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'OfferPRP__c', 120, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'OtherCallerIDEnglish__c', 121, NULL, NULL, NULL, 1, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'OtherCallerIDFrench__c', 122, NULL, NULL, NULL, 1, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'OtherCallerIDSpanish__c', 123, NULL, NULL, NULL, 1, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'OutboundDialingAllowed__c', 124, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ProfileCode__c', 125, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Region__c', 126, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Service_Territory__c', 127, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'SurgeryOffered__c', 128, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'TimeZone__c', 129, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Virtual__c', 130, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'WebPhone__c', 131, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'X1Apptperslot__c', 132, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ClientGUID__c', 133, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Goals_Expectations__c', 134, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'How_many_times_a_week_do_you_think__c', 135, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'How_much_time_a_week_do_you_spend__c', 136, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Other_Reason__c', 137, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'What_are_your_main_concerns_today__c', 138, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'What_else_would_be_helpful_for_your__c', 139, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'What_methods_have_you_used_or_currently__c', 140, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__ExemptionCertificate__c', 141, NULL, NULL, NULL, 1, NULL, 'varchar(25)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__IsBillingAddressValidated__c', 142, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__IsShippingAddressValidated__c', 143, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__MaterializedBillingAddressValidated__c', 144, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__MaterializedShippingAddressValidated__c', 145, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__OutputVatCode__c', 146, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__SalesTaxStatus__c', 147, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__TaxCode1__c', 148, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__TaxCode2__c', 149, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__TaxCode3__c', 150, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__TaxCountryCode__c', 151, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__ValidatedBillingCity__c', 152, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__ValidatedBillingCountry__c', 153, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__ValidatedBillingPostalCode__c', 154, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__ValidatedBillingState__c', 155, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__ValidatedBillingStreet__c', 156, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__ValidatedShippingCity__c', 157, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__ValidatedShippingCountry__c', 158, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__ValidatedShippingPostalCode__c', 159, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__ValidatedShippingState__c', 160, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__ValidatedShippingStreet__c', 161, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__VatRegistrationNumber__c', 162, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'fferpcore__VatStatus__c', 163, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ffbf__AccountParticulars__c', 164, NULL, NULL, NULL, 1, NULL, 'varchar(12)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ffbf__BankBIC__c', 165, NULL, NULL, NULL, 1, NULL, 'varchar(16)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ffbf__PaymentCode__c', 166, NULL, NULL, NULL, 1, NULL, 'varchar(12)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ffbf__PaymentCountryISO__c', 167, NULL, NULL, NULL, 1, NULL, 'varchar(2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ffbf__PaymentPriority__c', 168, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ffbf__PaymentRoutingMethod__c', 169, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'SCMFFA__Company_Name__c', 170, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'ffaci__CurrencyCulture__c', 171, NULL, NULL, NULL, 1, NULL, 'varchar(8)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Service_Territory_Time_Zone__c', 172, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'rh2__testCurrency__c', 173, NULL, NULL, NULL, 1, NULL, 'decimal(14, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Initial_Campaign_Source__c', 174, NULL, NULL, NULL, 1, NULL, 'varchar(8000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Landing_Page_Form_Submitted_Date__c', 175, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Age__pc', 176, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Birthdate__pc', 177, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'DoNotContact__pc', 178, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'DoNotEmail__pc', 179, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'DoNotMail__pc', 180, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'DoNotText__pc', 181, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Ethnicity__pc', 182, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Gender__pc', 183, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'HairLossExperience__pc', 184, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'HairLossFamily__pc', 185, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'HairLossOrVolume__pc', 186, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'HairLossProductOther__pc', 187, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'HairLossProductUsed__pc', 188, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'HairLossSpot__pc', 189, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'HardCopyPreferred__pc', 190, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Language__pc', 191, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'MaritalStatus__pc', 192, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Text_Reminder_Opt_In__pc', 193, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'rh2__Currency_Test__pc', 194, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'rh2__Describe__pc', 195, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'rh2__Formula_Test__pc', 196, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'rh2__Integer_Test__pc', 197, NULL, NULL, NULL, 1, NULL, 'decimal(3, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Next_Milestone_Event__pc', 198, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Next_Milestone_Event_Date__pc', 199, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Bosley_Center_Number__pc', 200, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Bosley_Client_Id__pc', 201, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Bosley_Legacy_Source_Code__pc', 202, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Bosley_Salesforce_Id__pc', 203, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Bosley_Siebel_Id__pc', 204, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Contact_ID_18_dig__pc', 205, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Account', N'Landing_Page_Form_Submitted_Date__pc', 206, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Action__c', N'Id', 1, 27, 27, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Action__c', N'Action__c', 2, 27, 27, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Action__c', N'ONC_ActionCode', 3, 27, 27, 0, 1, 'nchar(10)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Action__c', N'IsActiveFlag', 4, 27, 27, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Action__c', N'CreatedById', 5, 27, 27, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Action__c', N'CreatedDate', 6, 27, 27, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Action__c', N'LastModifiedById', 7, 27, 27, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Action__c', N'LastModifiedDate', 8, 27, 27, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Action__c', N'ONC_ActionCodeDescription', 9, 27, 27, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'Id', 1, 1938561, 1938561, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'Lead__c', 2, 1938561, 1937953, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'OncContactAddressID__c', 3, 1938561, 1857267, 0, 1, 'nchar(10)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'OncContactID__c', 4, 1938561, 1880886, 0, 1, 'nchar(10)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'Street__c', 5, 1938561, 1744155, 0, 1, 'nvarchar(250)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'Street2__c', 6, 1938561, 377137, 0, 1, 'nvarchar(250)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'Street3__c', 7, 1938561, 338, 0, 1, 'nvarchar(250)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'Street4__c', 8, 1938561, 8, 0, 1, 'nvarchar(250)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'City__c', 9, 1938561, 1779111, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'State__c', 10, 1938561, 1930617, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'Zip__c', 11, 1938561, 1934335, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'Country__c', 12, 1938561, 1938195, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'DoNotMail__c', 13, 1938561, 1938561, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'Primary__c', 14, 1938561, 1938561, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'Status__c', 15, 1938561, 1561712, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'IsDeleted', 16, 1938561, 1938561, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'CreatedById', 17, 1938561, 1938561, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'CreatedDate', 18, 1938561, 1938561, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'LastModifiedById', 19, 1938561, 1938561, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Address__c', N'LastModifiedDate', 20, 1938561, 1938561, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'AssignedResourceNumber', 3, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'CreatedDate', 4, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'CreatedById', 5, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'LastModifiedDate', 6, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'LastModifiedById', 7, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'SystemModstamp', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'ServiceAppointmentId', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'ServiceResourceId', 10, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'IsRequiredResource', 11, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'Role', 12, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'EventId', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'AssignedResource', N'ServiceResourceId__c', 14, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Id', 1, 25705, 25705, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Name', 2, 25705, 25705, 0, 1, 'nvarchar(80)', 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'IsActive', 3, 25705, 25705, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'ParentId', 4, 25705, 8843, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Type', 5, 25705, 25208, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'PromoCode__c', 6, 25705, 16023, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'RecordTypeId', 6, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Channel__c', 7, 25705, 25631, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'ShortcodeChannel__c', 8, 25705, 16035, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Language__c', 9, 25705, 25704, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'CurrencyIsoCode', 10, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Media__c', 10, 25705, 25619, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'ShortcodeMedia__c', 11, 25705, 16043, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Source__c', 12, 25705, 16047, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'ShortcodeOrigin__c', 13, 25705, 16043, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Format__c', 14, 25705, 25359, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'ShortcodeFormat__c', 15, 25705, 16042, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Goal__c', 16, 25705, 3, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'PromoCodeName__c', 17, 25705, 16023, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'SourceCodeNumber__c', 18, 25705, 16066, 0, 1, 'nvarchar(30)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Status', 19, 25705, 25705, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'StartDate', 20, 25705, 25135, 0, 1, 'datetime', 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'EndDate', 21, 25705, 25145, 0, 1, 'datetime', 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Gender__c', 22, 25705, 16029, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'CampaignType__c', 23, 25705, 16025, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'CommunicationType__c', 24, 25705, 11185, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'TollFreeName__c', 25, 25705, 13275, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'HierarchyNumberOfLeads', 26, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'TollFreeMobileName__c', 26, 25705, 2804, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'HierarchyNumberOfConvertedLeads', 27, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'URLDomain__c', 27, 25705, 2, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'GenerateCodes__c', 28, 25705, 16066, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'HierarchyNumberOfContacts', 28, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'HierarchyNumberOfResponses', 29, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'SourceCode_L__c', 29, 25705, 25690, 0, 1, 'nvarchar(50)', 'varchar(50)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'DPNCode__c', 30, 25705, 5225, 0, 1, 'nvarchar(50)', 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'HierarchyNumberOfOpportunities', 30, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'DWFCode__c', 31, 25705, 2879, 0, 1, 'nvarchar(50)', 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'HierarchyNumberOfWonOpportunities', 31, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'DWCCode__c', 32, 25705, 2855, 0, 1, 'nvarchar(50)', 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'HierarchyAmountAllOpportunities', 32, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'DNIS__c', 33, 25705, 13275, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'HierarchyAmountWonOpportunities', 33, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'DNISMobile__c', 34, 25705, 2804, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'HierarchyNumberSent', 34, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'HierarchyExpectedRevenue', 35, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Referrer__c', 35, 25705, 0, 1, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'HierarchyBudgetedCost', 36, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'SCNumber__c', 36, 25705, 16066, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'HierarchyActualCost', 37, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'MPNCode__c', 37, 25705, 2827, 0, 1, 'nvarchar(50)', 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'MWFCode__c', 38, 25705, 2877, 0, 1, 'nvarchar(50)', 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'OwnerId', 38, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'MWCCode__c', 39, 25705, 2855, 0, 1, 'nvarchar(50)', 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'ACE_Decription__c', 40, 25705, 16018, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Description', 41, 25705, 12711, 0, 1, 'nvarchar(255)', 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'WebCode__c', 42, 25705, 6341, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Location__c', 43, 25705, 25094, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'SystemModstamp', 43, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'LastActivityDate', 44, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'PromoCodeDisplay__c', 44, 25705, 16023, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'LastViewedDate', 45, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'NumberSent', 45, 25705, 25705, 0, 1, 'int', 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'ExpectedResponse', 46, 25705, 25705, 0, 1, 'float', 'decimal(8, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'LastReferencedDate', 46, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'BudgetedCost', 47, 25705, 0, 1, 1, 'money', 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'CampaignMemberRecordTypeId', 47, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'ActualCost', 48, 25705, 0, 1, 1, 'money', 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Company__c', 49, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'ExpectedRevenue', 49, 25705, 0, 1, 1, 'money', 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'External_Id__c', 50, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'NumberOfResponses', 50, 25705, 25705, 0, 1, 'int', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'NumberOfLeads', 51, 25705, 25705, 0, 1, 'int', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'NumberOfConvertedLeads', 52, 25705, 25705, 0, 1, 'int', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Priority__c', 52, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'NumberOfContacts', 53, 25705, 25705, 0, 1, 'int', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Promo_Code__c', 53, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'NumberOfOpportunities', 54, 25705, 25705, 0, 1, 'int', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'NumberOfWonOpportunities', 55, 25705, 25705, 0, 1, 'int', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'TollFreeNumber__c', 55, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'AmountAllOpportunities', 56, 25705, 25705, 0, 1, 'money', 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Audience__c', 56, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'AmountWonOpportunities', 57, 25705, 25705, 0, 1, 'money', 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Promo_Code_L__c', 58, 25705, 11192, 0, 1, 'nvarchar(100)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'SourceID_L__c', 59, 25705, 9914, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'SourceName_L__c', 60, 25705, 11146, 0, 1, 'nvarchar(100)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'IsInHouseSourceFlag_L__c', 61, 25705, 9730, 0, 1, 'nvarchar(10)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'PhoneID_L__c', 62, 25705, 10952, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Number_L__c', 63, 25705, 10964, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'NumberTypeID_L__c', 64, 25705, 9968, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'NumberType_L__c', 65, 25705, 15574, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Gleam_Id__c', 66, NULL, NULL, NULL, 1, NULL, 'varchar(50)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'MediaID_L__c', 66, 25705, 9955, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'DialerMiscCode__c', 67, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Media_L__c', 67, 25705, 11119, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'MediaCode_L__c', 68, 25705, 11109, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Origin__c', 68, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Dialer_Misc_Code__c', 69, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Notes_L__c', 69, 25705, 3008, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Campaign_Counter__c', 70, 25705, 16066, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Toll_Free_Desktop__c', 70, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Level02LocationCode_L__c', 71, 25705, 11146, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Toll_Free_Mobile__c', 71, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'DB_Campaign_Tactic__c', 72, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Level02Location_L__c', 72, 25705, 11149, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'CampaignSource__c', 73, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Level03ID_L__c', 73, 25705, 9889, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Level03LanguageCode_L__c', 74, 25705, 11145, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Level03Language_L__c', 75, 25705, 11153, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Level04ID_L__c', 76, 25705, 9886, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Level04FormatCode_L__c', 77, 25705, 9894, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Level04Format_L__c', 78, 25705, 11151, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Level05ID_L__c', 79, 25705, 9892, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Level05CreativeCode_L__c', 80, 25705, 9902, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'Level05Creative_L__c', 81, 25705, 11122, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'IsDeleted', 82, 25705, 25705, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'CreatedById', 83, 25705, 25705, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'CreatedDate', 84, 25705, 25705, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'LastModifiedById', 85, 25705, 25705, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Campaign', N'LastModifiedDate', 86, 25705, 25705, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'CampaignId', 3, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'LeadId', 4, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'ContactId', 5, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Status', 6, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'HasResponded', 7, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'CreatedDate', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'CreatedById', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'LastModifiedDate', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'LastModifiedById', 11, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'SystemModstamp', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'FirstRespondedDate', 13, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'CurrencyIsoCode', 14, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Salutation', 15, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Name', 16, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'FirstName', 17, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'LastName', 18, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Title', 19, NULL, NULL, NULL, 0, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Street', 20, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'City', 21, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'State', 22, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'PostalCode', 23, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Country', 24, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Email', 25, NULL, NULL, NULL, 0, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Phone', 26, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Fax', 27, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'MobilePhone', 28, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Description', 29, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'DoNotCall', 30, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'HasOptedOutOfEmail', 31, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'HasOptedOutOfFax', 32, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'LeadSource', 33, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'CompanyOrAccount', 34, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Type', 35, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'LeadOrContactId', 36, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'LeadOrContactOwnerId', 37, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Opportunity__c', 38, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'SourceCode__c', 39, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Device_Type__c', 40, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Do_Not_Call_from_Lead_Contact__c', 41, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Last_Activity_Date__c', 42, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Lead_Status__c', 43, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMember', N'Time_Zone__c', 44, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMemberStatus', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMemberStatus', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMemberStatus', N'CampaignId', 3, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMemberStatus', N'Label', 4, NULL, NULL, NULL, 0, NULL, 'varchar(765)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMemberStatus', N'SortOrder', 5, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMemberStatus', N'IsDefault', 6, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMemberStatus', N'HasResponded', 7, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMemberStatus', N'CreatedDate', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMemberStatus', N'CreatedById', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMemberStatus', N'LastModifiedDate', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMemberStatus', N'LastModifiedById', 11, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'CampaignMemberStatus', N'SystemModstamp', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'MasterRecordId', 3, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'CaseNumber', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'ContactId', 5, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'AccountId', 6, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'AssetId', 7, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'ProductId', 8, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'EntitlementId', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'SourceId', 10, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'BusinessHoursId', 11, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'ParentId', 12, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'SuppliedName', 13, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'SuppliedEmail', 14, NULL, NULL, NULL, 0, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'SuppliedPhone', 15, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'SuppliedCompany', 16, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Type', 17, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'RecordTypeId', 18, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Status', 19, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Reason', 20, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Origin', 21, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Language', 22, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Subject', 23, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Priority', 24, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Description', 25, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'IsClosed', 26, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'ClosedDate', 27, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'IsEscalated', 28, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'CurrencyIsoCode', 29, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'OwnerId', 30, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'IsClosedOnCreate', 31, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'SlaStartDate', 32, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'SlaExitDate', 33, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'IsStopped', 34, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'StopStartDate', 35, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'CreatedDate', 36, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'CreatedById', 37, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'LastModifiedDate', 38, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'LastModifiedById', 39, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'SystemModstamp', 40, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'ContactPhone', 41, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'ContactMobile', 42, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'ContactEmail', 43, NULL, NULL, NULL, 0, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'ContactFax', 44, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Comments', 45, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'LastViewedDate', 46, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'LastReferencedDate', 47, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'ServiceContractId', 48, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'MilestoneStatus', 49, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'External_Id__c', 50, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Accommodation__c', 51, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'AssignedTo__c', 52, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'CallType__c', 53, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Campaign__c', 54, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'CaseAltPhone__c', 55, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'CaseName__c', 56, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'CasePhone__c', 57, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Case_Source_Chat__c', 58, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Category__c', 59, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'CenterEmployee__c', 60, NULL, NULL, NULL, 0, NULL, 'varchar(50)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Center__c', 61, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Content__c', 62, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Courteous__c', 63, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'DateofAppointment__c', 64, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'DateofIncident__c', 65, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Didyousignup__c', 66, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Estimated_Completion_Date__c', 67, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'FeedbackType__c', 68, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'LeadEmail__c', 69, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'LeadId__c', 70, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'LeadPhone__c', 71, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'OptionOffered__c', 72, NULL, NULL, NULL, 0, NULL, 'varchar(50)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Points__c', 73, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'PricePlan__c', 74, NULL, NULL, NULL, 0, NULL, 'varchar(50)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Resolution__c', 75, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'SignIn__c', 76, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'TimeofIncident__c', 77, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Title__c', 78, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Case', N'Wereyouontime__c', 79, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ChangeLog', N'ChangeLogID', 1, 7372, 7372, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ChangeLog', N'SessionID', 2, 7372, 7372, 0, 1, 'uniqueidentifier', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ChangeLog', N'ObjectName', 4, 7372, 7372, 0, 1, 'nvarchar(80)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ChangeLog', N'ObjectKey', 5, 7372, 7372, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ChangeLog', N'ColumnName', 6, 7372, 7372, 0, 1, 'nvarchar(80)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ChangeLog', N'OldValue', 7, 7372, 7372, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ChangeLog', N'NewValue', 8, 7372, 7372, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ChangeLog', N'CreateDate', 9, 7372, 7372, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ChangeLog', N'CreateUser', 10, 7372, 7372, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ChangeLog', N'LastUpdate', 11, 7372, 7372, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ChangeLog', N'LastUpdateUser', 12, 7372, 7372, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'Name', 3, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'CurrencyIsoCode', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'CreatedDate', 5, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'CreatedById', 6, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'LastModifiedDate', 7, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'LastModifiedById', 8, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'SystemModstamp', 9, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'LastActivityDate', 10, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'LastViewedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'LastReferencedDate', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'Service_Appointment__c', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'ACE_Approved__c', 14, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'Comments__c', 15, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'Commission_To_Proposed_Change__c', 16, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'Commission_To__c', 17, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'Commissions_Logic_Details__c', 18, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'My_Commission_Log__c', 19, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'Related_Lead__c', 20, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'Related_Person_Account__c', 21, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'System_Generated__c', 22, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'Commission_To_Manager__c', 23, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Commissions_Log__c', N'Commission_To_Company__c', 24, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Id', 1, 23658, 23658, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'OwnerId', 2, 23658, 23658, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Name', 3, 23658, 23658, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'CenterName__c', 4, 23658, 23632, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'CenterID__c', 5, 23658, 23632, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Lead__c', 6, 23658, 23657, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'First_Name__c', 7, 23658, 23630, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Last_Name__c', 8, 23658, 23630, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Email__c', 9, 23658, 23631, 0, 1, 'nvarchar(100)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Birthdate__c', 10, 23658, 21631, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Gender__c', 11, 23658, 23631, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Martial_Status__c', 12, 23658, 21413, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Norwood_Scale__c', 13, 23658, 10, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Ludwig_Scale__c', 14, 23658, 5, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Mailing_Street__c', 15, 23658, 20571, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Mailing_City__c', 16, 23658, 21636, 0, 1, 'nvarchar(80)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Mailing_State__c', 17, 23658, 22979, 0, 1, 'nvarchar(80)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Mailing_Postal_Code__c', 18, 23658, 23460, 0, 1, 'nvarchar(80)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Mailing_Country__c', 19, 23658, 23616, 0, 1, 'nvarchar(80)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Country_Calling_Codes__c', 20, 23658, 0, 1, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Phone__c', 21, 23658, 19059, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Work_Phone__c', 22, 23658, 11530, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Contact_Information__c', 23, 23658, 0, 1, 1, 'nvarchar(175)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Communication_Preferences__c', 24, 23658, 16, 0, 1, 'nvarchar(175)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Marketing_Preference_Call__c', 25, 23658, 15538, 0, 1, 'nvarchar(500)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Transaction_Preference_Call__c', 26, 23658, 18008, 0, 1, 'nvarchar(500)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Personal_Information__c', 27, 23658, 0, 1, 1, 'nvarchar(175)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Additional_Information__c', 28, 23658, 0, 1, 1, 'nvarchar(175)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Other_Information__c', 29, 23658, 0, 1, 1, 'nvarchar(175)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Goal_Of_Visit_Other__c', 30, 23658, 1428, 0, 1, 'nvarchar(4000)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Goal_Of_Visit__c', 31, 23658, 20129, 0, 1, 'nvarchar(4000)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Hair_Loss_Effects_Other__c', 32, 23658, 1806, 0, 1, 'nvarchar(4000)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Hair_Loss_Effects__c', 33, 23658, 19557, 0, 1, 'nvarchar(4000)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Hair_Loss_Information__c', 34, 23658, 0, 1, 1, 'nvarchar(4000)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Head_Img_Name__c', 35, 23658, 23658, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'How_Long_Thinking__c', 36, 23658, 21078, 0, 1, 'nvarchar(4000)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'How_did_you_hear_about_Hair_Club__c', 37, 23658, 21423, 0, 1, 'nvarchar(4000)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'PDF_URL__c', 38, 23658, 23658, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'PdfPreview__c', 39, 23658, 23658, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Reason_For_Hair_Back__c', 40, 23658, 17895, 0, 1, 'nvarchar(4000)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Referred_By__c', 41, 23658, 2675, 0, 1, 'nvarchar(80)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Research_Done__c', 42, 23658, 16391, 0, 1, 'nvarchar(4000)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Scale_Hair_Restore__c', 43, 23658, 20965, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Signatue_Date__c', 44, 23658, 19178, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Signature_IP_Address__c', 45, 23658, 0, 1, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Signature__c', 46, 23658, 18726, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Special_Events_Impacted__c', 47, 23658, 16349, 0, 1, 'nvarchar(4000)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Steps_Taken__c', 48, 23658, 21076, 0, 1, 'nvarchar(4000)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Told_Who__c', 49, 23658, 9575, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Tell_Anyone__c', 50, 23658, 20122, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Attachment_Id__c', 51, 23658, 18524, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Last_Saved_Page_Number__c', 52, 23658, 23633, 0, 1, 'decimal(18, 0)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Date__c', 53, 23658, 19087, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Last_Modified_Online__c', 54, 23658, 23650, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'LastActivityDate', 55, 23658, 3, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'LastViewedDate', 56, 23658, 0, 1, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'LastReferencedDate', 57, 23658, 0, 1, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'Is_Completed__c', 58, 23658, 23658, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'IsDeleted', 59, 23658, 19579, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'CreatedDate', 60, 23658, 23658, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'CreatedById', 61, 23658, 23658, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'LastModifiedDate', 62, 23658, 23658, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Consultation_Form__c', N'LastModifiedById', 63, 23658, 23658, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MasterRecordId', 3, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'AccountId', 4, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'IsPersonAccount', 5, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'LastName', 6, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'FirstName', 7, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Salutation', 8, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MiddleName', 9, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Suffix', 10, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Name', 11, NULL, NULL, NULL, 0, NULL, 'varchar(121)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MailingStreet', 12, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MailingCity', 13, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MailingState', 14, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MailingPostalCode', 15, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MailingCountry', 16, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MailingStateCode', 17, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MailingCountryCode', 18, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MailingLatitude', 19, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MailingLongitude', 20, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MailingGeocodeAccuracy', 21, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Phone', 22, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Fax', 23, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MobilePhone', 24, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'HomePhone', 25, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'OtherPhone', 26, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'AssistantPhone', 27, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'ReportsToId', 28, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Email', 29, NULL, NULL, NULL, 0, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Title', 30, NULL, NULL, NULL, 0, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Department', 31, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'CurrencyIsoCode', 32, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'OwnerId', 33, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'CreatedDate', 34, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'CreatedById', 35, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'LastModifiedDate', 36, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'LastModifiedById', 37, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'SystemModstamp', 38, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'LastActivityDate', 39, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'LastCURequestDate', 40, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'LastCUUpdateDate', 41, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'LastViewedDate', 42, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'LastReferencedDate', 43, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'EmailBouncedReason', 44, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'EmailBouncedDate', 45, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'IsEmailBounced', 46, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'PhotoUrl', 47, NULL, NULL, NULL, 0, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Jigsaw', 48, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'JigsawContactId', 49, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Age__c', 50, NULL, NULL, NULL, 0, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Birthdate__c', 51, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'DoNotContact__c', 52, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'DoNotEmail__c', 53, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'DoNotMail__c', 54, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'DoNotText__c', 55, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Ethnicity__c', 56, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Gender__c', 57, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'HairLossExperience__c', 58, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'HairLossFamily__c', 59, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'HairLossOrVolume__c', 60, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'HairLossProductOther__c', 61, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'HairLossProductUsed__c', 62, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'HairLossSpot__c', 63, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'HardCopyPreferred__c', 64, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Language__c', 65, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'MaritalStatus__c', 66, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Text_Reminder_Opt_In__c', 67, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'rh2__Currency_Test__c', 68, NULL, NULL, NULL, 0, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'rh2__Describe__c', 69, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'rh2__Formula_Test__c', 70, NULL, NULL, NULL, 0, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'rh2__Integer_Test__c', 71, NULL, NULL, NULL, 0, NULL, 'decimal(3, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Next_Milestone_Event__c', 72, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Next_Milestone_Event_Date__c', 73, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Bosley_Center_Number__c', 74, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Bosley_Client_Id__c', 75, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Bosley_Legacy_Source_Code__c', 76, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Bosley_Salesforce_Id__c', 77, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Bosley_Siebel_Id__c', 78, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Contact_ID_18_dig__c', 79, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contact', N'Landing_Page_Form_Submitted_Date__c', 80, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'AccountId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'CurrencyIsoCode', 3, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'Pricebook2Id', 4, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'OwnerExpirationNotice', 5, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'StartDate', 6, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'EndDate', 7, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'BillingStreet', 8, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'BillingCity', 9, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'BillingState', 10, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'BillingPostalCode', 11, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'BillingCountry', 12, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'BillingStateCode', 13, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'BillingCountryCode', 14, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'BillingLatitude', 15, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'BillingLongitude', 16, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'BillingGeocodeAccuracy', 17, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'BillingAddress', 18, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ShippingStreet', 19, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ShippingCity', 20, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ShippingState', 21, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ShippingPostalCode', 22, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ShippingCountry', 23, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ShippingStateCode', 24, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ShippingCountryCode', 25, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ShippingLatitude', 26, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ShippingLongitude', 27, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ShippingGeocodeAccuracy', 28, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ShippingAddress', 29, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ContractTerm', 30, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'OwnerId', 31, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'Status', 32, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'CompanySignedId', 33, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'CompanySignedDate', 34, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'CustomerSignedId', 35, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'CustomerSignedTitle', 36, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'CustomerSignedDate', 37, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'SpecialTerms', 38, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ActivatedById', 39, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ActivatedDate', 40, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'StatusCode', 41, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'Description', 42, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'IsDeleted', 43, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'ContractNumber', 44, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'LastApprovedDate', 45, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'CreatedDate', 46, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'CreatedById', 47, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'LastModifiedDate', 48, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'LastModifiedById', 49, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'SystemModstamp', 50, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'LastActivityDate', 51, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'LastViewedDate', 52, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Contract', N'LastReferencedDate', 53, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'LineItemNumber', 3, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'CurrencyIsoCode', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'CreatedDate', 5, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'CreatedById', 6, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'LastModifiedDate', 7, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'LastModifiedById', 8, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'SystemModstamp', 9, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'LastViewedDate', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'LastReferencedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'ServiceContractId', 12, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'Product2Id', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'AssetId', 14, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'StartDate', 15, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'EndDate', 16, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'Description', 17, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'PricebookEntryId', 18, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'Quantity', 19, NULL, NULL, NULL, 0, NULL, 'decimal(10, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'UnitPrice', 20, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'Discount', 21, NULL, NULL, NULL, 0, NULL, 'decimal(3, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'ListPrice', 22, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'Subtotal', 23, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'TotalPrice', 24, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'Status', 25, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'ParentContractLineItemId', 26, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'RootContractLineItemId', 27, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ContractLineItem', N'LocationId', 28, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Email__c', N'Id', 1, 1397249, 1397249, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Email__c', N'Lead__c', 2, 1397249, 1396368, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Email__c', N'OncContactEmailID__c', 3, 1397249, 1052637, 0, 1, 'nchar(10)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Email__c', N'OncContactID__c', 4, 1397249, 1203918, 0, 1, 'nchar(10)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Email__c', N'Name', 5, 1397249, 1397249, 0, 1, 'nvarchar(100)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Email__c', N'Primary__c', 6, 1397249, 1397249, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Email__c', N'Status__c', 7, 1397249, 1397249, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Email__c', N'IsDeleted', 8, 1397249, 1397249, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Email__c', N'CreatedById', 9, 1397249, 1397249, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Email__c', N'CreatedDate', 10, 1397249, 1397249, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Email__c', N'LastModifiedById', 11, 1397249, 1397249, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Email__c', N'LastModifiedDate', 12, 1397249, 1397249, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'ParentId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'ActivityId', 3, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'CreatedById', 4, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'CreatedDate', 5, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'LastModifiedDate', 6, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'LastModifiedById', 7, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'SystemModstamp', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'TextBody', 9, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'HtmlBody', 10, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'Headers', 11, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'Subject', 12, NULL, NULL, NULL, 0, NULL, 'varchar(3000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'FromName', 13, NULL, NULL, NULL, 0, NULL, 'varchar(1000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'FromAddress', 14, NULL, NULL, NULL, 0, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'ValidatedFromAddress', 15, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'ToAddress', 16, NULL, NULL, NULL, 0, NULL, 'varchar(4000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'CcAddress', 17, NULL, NULL, NULL, 0, NULL, 'varchar(4000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'BccAddress', 18, NULL, NULL, NULL, 0, NULL, 'varchar(4000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'Incoming', 19, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'HasAttachment', 20, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'Status', 21, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'MessageDate', 22, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'IsDeleted', 23, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'ReplyToEmailMessageId', 24, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'IsExternallyVisible', 25, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'MessageIdentifier', 26, NULL, NULL, NULL, 0, NULL, 'varchar(765)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'ThreadIdentifier', 27, NULL, NULL, NULL, 0, NULL, 'varchar(765)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'IsClientManaged', 28, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'RelatedToId', 29, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'IsTracked', 30, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'IsOpened', 31, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'FirstOpenedDate', 32, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'LastOpenedDate', 33, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'IsBounced', 34, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'EmailTemplateId', 35, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'ContentDocumentIds', 36, NULL, NULL, NULL, 0, NULL, 'varchar(4000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'BccIds', 37, NULL, NULL, NULL, 0, NULL, 'varchar(4000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'CcIds', 38, NULL, NULL, NULL, 0, NULL, 'varchar(4000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'EmailMessage', N'ToIds', 39, NULL, NULL, NULL, 0, NULL, 'varchar(4000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'WhoId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'WhatId', 3, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'WhoCount', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'WhatCount', 5, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Subject', 6, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Location', 7, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'IsAllDayEvent', 8, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'ActivityDateTime', 9, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'ActivityDate', 10, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'DurationInMinutes', 11, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'StartDateTime', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'EndDateTime', 13, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'EndDate', 14, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Description', 15, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'AccountId', 16, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'OwnerId', 17, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'CurrencyIsoCode', 18, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Type', 19, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'IsPrivate', 20, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'ShowAs', 21, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'IsDeleted', 22, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'IsChild', 23, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'IsGroupEvent', 24, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'GroupEventType', 25, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'CreatedDate', 26, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'CreatedById', 27, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'LastModifiedDate', 28, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'LastModifiedById', 29, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'SystemModstamp', 30, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'IsArchived', 31, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'RecurrenceActivityId', 32, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'IsRecurrence', 33, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'RecurrenceStartDateTime', 34, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'RecurrenceEndDateOnly', 35, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'RecurrenceTimeZoneSidKey', 36, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'RecurrenceType', 37, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'RecurrenceInterval', 38, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'RecurrenceDayOfWeekMask', 39, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'RecurrenceDayOfMonth', 40, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'RecurrenceInstance', 41, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'RecurrenceMonthOfYear', 42, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'ReminderDateTime', 43, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'IsReminderSet', 44, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'EventSubtype', 45, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'IsRecurrence2Exclusion', 46, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Recurrence2PatternText', 47, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Recurrence2PatternVersion', 48, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'IsRecurrence2', 49, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'IsRecurrence2Exception', 50, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Recurrence2PatternStartDate', 51, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Recurrence2PatternTimeZone', 52, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'ServiceAppointmentId', 53, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'BrightPattern__SPRecordingOrTranscriptURL__c', 54, NULL, NULL, NULL, 0, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Center_Name__c', 55, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Completed_Date__c', 56, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'External_ID__c', 57, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Lead__c', 58, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Meeting_Platform_Id__c', 59, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Meeting_Platform__c', 60, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Person_Account__c', 61, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Recording_Link__c', 62, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Result__c', 63, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'SPRecordingOrTranscriptURL__c', 64, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Service_Appointment__c', 65, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Service_Territory_Caller_Id__c', 66, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Agent_Link__c', 67, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Guest_Link__c', 68, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Opportunity__c', 69, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Center_Phone__c', 70, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'DB_Activity_Type__c', 71, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'CallBackDueDate__c', 72, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'Invite__c', 73, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'AcceptedEventInviteeIds', 74, NULL, NULL, NULL, 0, NULL, 'varchar(500)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'DeclinedEventInviteeIds', 75, NULL, NULL, NULL, 0, NULL, 'varchar(500)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'EventWhoIds', 76, NULL, NULL, NULL, 0, NULL, 'varchar(500)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Event', N'UndecidedEventInviteeIds', 77, NULL, NULL, NULL, 0, NULL, 'varchar(500)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'Id', 1, 152154, 152154, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'SessionID', 2, 152154, 152154, 0, 1, 'uniqueidentifier', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'OwnerId', 3, 152154, 152154, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'IsDeleted', 4, 152154, 152154, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'Name', 5, 152154, 152154, 0, 1, 'nvarchar(80)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'CreatedDate', 6, 152154, 152154, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'CreatedById', 7, 152154, 152154, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'LastModifiedDate', 8, 152154, 152154, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'LastModifiedById', 9, 152154, 152154, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'ObjectName__c', 10, 152154, 152154, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'DeletedId__c', 11, 152154, 152154, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'DeletedById__c', 12, 152154, 152154, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'MasterRecordId__c', 13, 152154, 35577, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'ToBeProcessed__c', 14, 152154, 152154, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'IsProcessed', 15, 152154, 152154, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'IsError', 16, 152154, 152154, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'ErrorMessage', 17, 152154, 9669, 0, 1, 'nvarchar(2000)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'HCDeletionTracker__c', N'LastProcessedDate__c', 18, 152154, 152154, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Id', 1, 3726155, 3726155, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'ContactID__c', 2, 3726155, 3045990, 0, 1, 'nchar(10)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'CenterNumber__c', 3, 3726155, 3401563, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'MasterRecordId', 3, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'CenterID__c', 4, 3726155, 3401834, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'FirstName', 5, 3726155, 3334182, 0, 1, 'nvarchar(50)', 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'LastName', 6, 3726155, 3726092, 0, 1, 'nvarchar(80)', 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Salutation', 6, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Age__c', 7, 3726155, 2791195, 0, 1, 'int', 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'MiddleName', 7, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'AgeRange__c', 8, 3726155, 2413821, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Suffix', 8, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Birthday__c', 9, 3726155, 2252296, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Name', 9, NULL, NULL, NULL, 1, NULL, 'varchar(121)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Gender__c', 10, 3726155, 3425016, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'RecordTypeId', 10, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Language__c', 11, 3726155, 3715364, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Title', 11, NULL, NULL, NULL, 1, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Company', 12, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Ethnicity__c', 12, 3726155, 158137, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'MaritalStatus__c', 13, 3726155, 19300, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Occupation__c', 14, 3726155, 19229, 0, 1, 'nvarchar(250)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'DISC__c', 15, 3726155, 190476, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'NorwoodScale__c', 16, 3726155, 13437, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'LudwigScale__c', 17, 3726155, 5824, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'SolutionOffered__c', 18, 3726155, 15697, 0, 1, 'nvarchar(250)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'HairLossExperience__c', 19, 3726155, 2815503, 0, 1, 'nvarchar(100)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'HairLossFamily__c', 20, 3726155, 2796621, 0, 1, 'nvarchar(100)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Latitude', 20, NULL, NULL, NULL, 1, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'HairLossProductOther__c', 21, 3726155, 2635551, 0, 1, 'nvarchar(150)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Longitude', 21, NULL, NULL, NULL, 1, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'GeocodeAccuracy', 22, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'HairLossProductUsed__c', 22, 3726155, 2106067, 0, 1, 'nvarchar(100)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'HairLossSpot__c', 23, 3726155, 2828196, 0, 1, 'nvarchar(100)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'OriginalCampaignID__c', 24, 3726155, 2979639, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Fax', 25, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'RecentCampaignID__c', 25, 3726155, 3205243, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Source_Code_Legacy__c', 26, 3726155, 3401932, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Promo_Code_Legacy__c', 27, 3726155, 3380333, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Website', 27, NULL, NULL, NULL, 1, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'DoNotContact__c', 28, 3726155, 3726155, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'PhotoUrl', 28, NULL, NULL, NULL, 1, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Description', 29, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'DoNotCall', 29, 3726155, 3726155, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'DoNotEmail__c', 30, 3726155, 3726155, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'DoNotMail__c', 31, 3726155, 3726155, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'DoNotText__c', 32, 3726155, 3726155, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Industry', 32, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Rating', 33, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'SiebelID__c', 33, 3726155, 24672, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'CurrencyIsoCode', 34, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'GCLID__c', 34, 3726155, 149894, 0, 1, 'nvarchar(4000)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'AnnualRevenue', 35, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'OnCAffiliateID__c', 35, 3726155, 11654, 0, 1, 'nvarchar(150)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'IsConverted', 36, 3726155, 3726155, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'NumberOfEmployees', 36, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'ContactStatus__c', 37, 3726155, 3403216, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'OwnerId', 37, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'HasOptedOutOfEmail', 38, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Status', 38, 3726155, 3726155, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'IsDeleted', 39, 3726155, 3726155, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'ConvertedDate', 40, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'OnCtCreatedDate__c', 40, 3726155, 2648491, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'ReportCreateDate__c', 41, 3726155, 3403725, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'CreatedById', 42, 3726155, 3726155, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'CreatedDate', 43, 3726155, 3726155, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'IsUnreadByOwner', 44, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'LastModifiedById', 44, 3726155, 3726155, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'LastModifiedDate', 45, 3726155, 3726155, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'ReferralCode__c', 46, 3726155, 4881, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'ReferralCodeExpireDate__c', 47, 3726155, 4758, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'HardCopyPreferred__c', 48, 3726155, 3707691, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'RecentSourceCode__c', 49, 3726155, 3317168, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'SystemModstamp', 49, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'LastActivityDate', 50, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'ZipCode__c', 50, 3726155, 1887100, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Street', 51, 3726155, 2810958, 0, 1, 'nvarchar(255)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'City', 52, 3726155, 2869152, 0, 1, 'nvarchar(50)', 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'HasOptedOutOfFax', 52, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'LastViewedDate', 53, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'State', 53, 3726155, 2950860, 0, 1, 'nvarchar(80)', 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'LastReferencedDate', 54, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'StateCode', 54, 3726155, 2950860, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Country', 55, 3726155, 3703336, 0, 1, 'nvarchar(80)', 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'LastTransferDate', 55, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'CountryCode', 56, 3726155, 3703336, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Jigsaw', 56, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'JigsawContactId', 57, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'PostalCode', 57, 3726155, 3142260, 0, 1, 'nvarchar(20)', 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'EmailBouncedReason', 58, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'HTTPReferrer__c', 58, 3726155, 238929, 0, 1, 'ntext', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'ConvertedAccountId', 59, 3726155, 302233, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'EmailBouncedDate', 59, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'ConvertedContactId', 60, 3726155, 302233, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'et4ae5__HasOptedOutOfMobile__c', 60, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'ConvertedOpportunityId', 61, 3726155, 18751, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'et4ae5__Mobile_Country_Code__c', 61, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Lead_Activity_Status__c', 62, 3726155, 3375205, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Birthdate__c', 63, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'LeadSource', 63, 3726155, 998042, 0, 1, 'nvarchar(80)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Cancellation_Reason__c', 64, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Email', 64, 3726155, 1432489, 0, 1, 'nvarchar(105)', 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Phone', 65, 3726155, 2409401, 0, 1, 'nvarchar(80)', 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'MobilePhone', 66, 3726155, 955676, 0, 1, 'nvarchar(80)', 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'BosleySFID__c', 67, 3726155, 1525, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'IsDuplicateByEmail', 68, 3726155, 322428, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'IsDuplicateByName', 69, 3726155, 322428, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'External_Id__c', 70, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'HairLossOrVolume__c', 74, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Lead_Qualifier__c', 80, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Lead_Rescheduler__c', 81, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'MobilePhone_Number_Normalized__c', 84, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Promo_Code__c', 86, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Referral_Code_Expiration_Date__c', 87, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Referral_Code__c', 88, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Service_Territory__c', 89, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Text_Reminer_Opt_In__c', 91, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Ammount__c', 93, NULL, NULL, NULL, 1, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'DNCDateMobilePhone__c', 94, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'DNCDatePhone__c', 95, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'DNCValidationMobilePhone__c', 96, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'DNCValidationPhone__c', 97, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Goals_Expectations__c', 99, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'How_many_times_a_week_do_you_think__c', 100, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'How_much_time_a_week_do_you_spend__c', 101, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Other_Reason__c', 102, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'What_are_your_main_concerns_today__c', 103, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'What_else_would_be_helpful_for_your__c', 104, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'What_methods_have_you_used_or_currently__c', 105, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'RefersionLogId__c', 106, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Service_Territory_Time_Zone__c', 107, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'DB_Created_Date_without_Time__c', 108, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'DB_Lead_Age__c', 109, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'RecordTypeDeveloperName__c', 110, NULL, NULL, NULL, 1, NULL, 'varchar(50)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Service_Territory_Area__c', 111, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Lead_Owner_Division__c', 112, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Service_Territory_Center_Type__c', 113, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Service_Territory_Center_Number__c', 114, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'No_Lead__c', 115, NULL, NULL, NULL, 1, NULL, 'decimal(18, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'HCUID__c', 116, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'GCID__c', 117, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'MSCLKID__c', 118, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'FBCLID__c', 119, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'KUID__c', 120, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Campaign_Source_Code__c', 121, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Service_Territory_Number__c', 122, NULL, NULL, NULL, 1, NULL, 'varchar(4)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Bosley_Center_Number__c', 123, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Bosley_Client_Id__c', 124, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Bosley_Country_Description__c', 125, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Bosley_Gender_Description__c', 126, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Bosley_Legacy_Source_Code__c', 127, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Bosley_Salesforce_Id__c', 128, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Bosley_Siebel_Id__c', 129, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Next_Milestone_Event__c', 130, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Next_Milestone_Event_Date__c', 131, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Service_Territory_Center_Owner__c', 132, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Warm_Welcome_Call__c', 133, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Lead_ID_18_dig__c', 134, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Initial_Campaign_Source__c', 135, NULL, NULL, NULL, 1, NULL, 'varchar(8000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Lead', N'Landing_Page_Form_Submitted_Date__c', 136, NULL, NULL, NULL, 1, NULL, 'varchar(8000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'OwnerId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'IsDeleted', 3, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'Name', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'CurrencyIsoCode', 5, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'CreatedDate', 6, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'CreatedById', 7, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'LastModifiedDate', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'LastModifiedById', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'SystemModstamp', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'LastViewedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'LastReferencedDate', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'LocationType', 13, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'Latitude', 14, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'Longitude', 15, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'Location', 16, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'Description', 17, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'DrivingDirections', 18, NULL, NULL, NULL, 0, NULL, 'varchar(1000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'TimeZone', 19, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'ParentLocationId', 20, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'PossessionDate', 21, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'ConstructionStartDate', 22, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'ConstructionEndDate', 23, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'OpenDate', 24, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'CloseDate', 25, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'RemodelStartDate', 26, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'RemodelEndDate', 27, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'IsMobile', 28, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'IsInventoryLocation', 29, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'RootLocationId', 30, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'LocationLevel', 31, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'ExternalReference', 32, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Location', N'LogoId', 33, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'AccountId', 3, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'RecordTypeId', 4, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'IsPrivate', 5, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Name', 6, NULL, NULL, NULL, 0, NULL, 'varchar(120)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Description', 7, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'StageName', 8, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Amount', 9, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Probability', 10, NULL, NULL, NULL, 0, NULL, 'decimal(3, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'ExpectedRevenue', 11, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'TotalOpportunityQuantity', 12, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'CloseDate', 13, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Type', 14, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'NextStep', 15, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'LeadSource', 16, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'IsClosed', 17, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'IsWon', 18, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'ForecastCategory', 19, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'ForecastCategoryName', 20, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'CurrencyIsoCode', 21, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'CampaignId', 22, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'HasOpportunityLineItem', 23, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Pricebook2Id', 24, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'OwnerId', 25, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Territory2Id', 26, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'IsExcludedFromTerritory2Filter', 27, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'CreatedDate', 28, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'CreatedById', 29, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'LastModifiedDate', 30, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'LastModifiedById', 31, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'SystemModstamp', 32, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'LastActivityDate', 33, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'PushCount', 34, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'LastStageChangeDate', 35, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'FiscalQuarter', 36, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'FiscalYear', 37, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Fiscal', 38, NULL, NULL, NULL, 0, NULL, 'varchar(6)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'ContactId', 39, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'LastViewedDate', 40, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'LastReferencedDate', 41, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'SyncedQuoteId', 42, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'ContractId', 43, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'HasOpenActivity', 44, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'HasOverdueTask', 45, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'IqScore', 46, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'LastAmountChangedHistoryId', 47, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'LastCloseDateChangedHistoryId', 48, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Budget_Confirmed__c', 49, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Discovery_Completed__c', 50, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'ROI_Analysis_Completed__c', 51, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Appointment_Source__c', 52, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Loss_Reason__c', 53, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Cancellation_Reason__c', 54, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Hair_Loss_Experience__c', 55, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Hair_Loss_Family__c', 56, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Hair_Loss_Or_Volume__c', 57, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Hair_Loss_Product_Other__c', 58, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Hair_Loss_Product_Used__c', 59, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Hair_Loss_Spot__c', 60, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'IP_Address__c', 61, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Ludwig_Scale__c', 62, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Norwood_Scale__c', 63, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Referral_Code_Expiration_Date__c', 64, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Referral_Code__c', 65, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Service_Territory__c', 66, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'DB_Competitor__c', 67, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Source_Code__c', 68, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Submitted_for_Approval__c', 69, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Ammount__c', 70, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'GCLID__c', 71, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Promo_Code__c', 72, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'SolutionOffered__c', 73, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Approver__c', 74, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Email__c', 75, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Goals_Expectations__c', 76, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'How_many_times_a_week_do_you_think__c', 77, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'How_much_time_a_week_do_you_spend__c', 78, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Mobile__c', 79, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Opportunity_Owner__c', 80, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Other_Reason__c', 81, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Owner__c', 82, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Phone__c', 83, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'What_are_your_main_concerns_today__c', 84, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'What_else_would_be_helpful_for_your__c', 85, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'What_methods_have_you_used_or_currently__c', 86, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'RefersionLogId__c', 87, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Commission_Paid__c', 88, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Owner_Division__c', 89, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Service_Territory_Number__c', 90, NULL, NULL, NULL, 0, NULL, 'varchar(4)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Opportunity', N'Commission_Override__c', 91, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityContactRole', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityContactRole', N'OpportunityId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityContactRole', N'ContactId', 3, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityContactRole', N'Role', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityContactRole', N'IsPrimary', 5, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityContactRole', N'CreatedDate', 6, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityContactRole', N'CreatedById', 7, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityContactRole', N'LastModifiedDate', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityContactRole', N'LastModifiedById', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityContactRole', N'SystemModstamp', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityContactRole', N'IsDeleted', 11, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityContactRole', N'CurrencyIsoCode', 12, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'OpportunityId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'SortOrder', 3, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'PricebookEntryId', 4, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'Product2Id', 5, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'ProductCode', 6, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'Name', 7, NULL, NULL, NULL, 0, NULL, 'varchar(376)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'CurrencyIsoCode', 8, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'Quantity', 9, NULL, NULL, NULL, 0, NULL, 'decimal(10, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'TotalPrice', 10, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'UnitPrice', 11, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'ListPrice', 12, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'ServiceDate', 13, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'HasRevenueSchedule', 14, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'HasQuantitySchedule', 15, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'Description', 16, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'HasSchedule', 17, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'CanUseQuantitySchedule', 18, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'CanUseRevenueSchedule', 19, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'CreatedDate', 20, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'CreatedById', 21, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'LastModifiedDate', 22, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'LastModifiedById', 23, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'SystemModstamp', 24, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'IsDeleted', 25, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'LastViewedDate', 26, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItem', N'LastReferencedDate', 27, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'OpportunityLineItemId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'Type', 3, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'Revenue', 4, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'Quantity', 5, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'Description', 6, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'ScheduleDate', 7, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'CurrencyIsoCode', 8, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'CreatedById', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'CreatedDate', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'LastModifiedById', 11, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'LastModifiedDate', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'SystemModstamp', 13, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityLineItemSchedule', N'IsDeleted', 14, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'OpportunityId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'UserId', 3, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'Name', 4, NULL, NULL, NULL, 0, NULL, 'varchar(361)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'PhotoUrl', 5, NULL, NULL, NULL, 0, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'Title', 6, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'TeamMemberRole', 7, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'OpportunityAccessLevel', 8, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'CurrencyIsoCode', 9, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'CreatedDate', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'CreatedById', 11, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'LastModifiedDate', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'LastModifiedById', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'SystemModstamp', 14, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OpportunityTeamMember', N'IsDeleted', 15, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'OwnerId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ContractId', 3, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'AccountId', 4, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'Pricebook2Id', 5, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'OriginalOrderId', 6, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'EffectiveDate', 7, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'EndDate', 8, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'IsReductionOrder', 9, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'Status', 10, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'Description', 11, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'CustomerAuthorizedById', 12, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'CompanyAuthorizedById', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'Type', 14, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'BillingStreet', 15, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'BillingCity', 16, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'BillingState', 17, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'BillingPostalCode', 18, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'BillingCountry', 19, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'BillingStateCode', 20, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'BillingCountryCode', 21, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'BillingLatitude', 22, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'BillingLongitude', 23, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'BillingGeocodeAccuracy', 24, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'BillingAddress', 25, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ShippingStreet', 26, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ShippingCity', 27, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ShippingState', 28, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ShippingPostalCode', 29, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ShippingCountry', 30, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ShippingStateCode', 31, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ShippingCountryCode', 32, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ShippingLatitude', 33, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ShippingLongitude', 34, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ShippingGeocodeAccuracy', 35, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ShippingAddress', 36, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ActivatedDate', 37, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'ActivatedById', 38, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'StatusCode', 39, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'CurrencyIsoCode', 40, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'OrderNumber', 41, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'TotalAmount', 42, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'CreatedDate', 43, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'CreatedById', 44, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'LastModifiedDate', 45, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'LastModifiedById', 46, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'IsDeleted', 47, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'SystemModstamp', 48, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'LastViewedDate', 49, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Order', N'LastReferencedDate', 50, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'Product2Id', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'IsDeleted', 3, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'OrderId', 4, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'PricebookEntryId', 5, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'OriginalOrderItemId', 6, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'AvailableQuantity', 7, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'Quantity', 8, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'CurrencyIsoCode', 9, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'UnitPrice', 10, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'ListPrice', 11, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'TotalPrice', 12, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'ServiceDate', 13, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'EndDate', 14, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'Description', 15, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'CreatedDate', 16, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'CreatedById', 17, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'LastModifiedDate', 18, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'LastModifiedById', 19, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'SystemModstamp', 20, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'OrderItem', N'OrderItemNumber', 21, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'Id', 1, 2536126, 2536126, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'Lead__c', 2, 2536126, 2535543, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'ContactPhoneID__c', 3, 2536126, 2204486, 0, 1, 'nchar(10)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'OncContactID__c', 4, 2536126, 2207815, 0, 1, 'nchar(10)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'Name', 5, 2536126, 2536126, 0, 1, 'nvarchar(80)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'PhoneAbr__c', 6, 2536126, 2536126, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'DoNotCall__c', 7, 2536126, 2536126, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'DoNotText__c', 8, 2536126, 2536126, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'DNCFlag__c', 9, 2536126, 2536126, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'EBRDNC__c', 10, 2536126, 2536126, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'EBRDNCDate__c', 11, 2536126, 2079679, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'Wireless__c', 12, 2536126, 2536126, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'Primary__c', 13, 2536126, 2536126, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'SortOrder__c', 14, 2536126, 1767572, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'Status__c', 15, 2536126, 2466974, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'ValidFlag__c', 16, 2536126, 2536126, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'Type__c', 17, 2536126, 2535996, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'IsDeleted', 18, 2536126, 2536126, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'CreatedById', 19, 2536126, 2536126, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'CreatedDate', 20, 2536126, 2536126, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'LastModifiedById', 21, 2536126, 2536126, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Phone__c', N'LastModifiedDate', 22, 2536126, 2536126, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'Id', 1, 15993295, 15993295, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'Name', 2, 15993295, 15993295, 0, 1, 'nvarchar(80)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'Batch__c', 3, 15993295, 15993295, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'Status__c', 4, 15993295, 15993295, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'ExportDatetime__c', 5, 15993295, 15993295, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'ImportDatetime__c', 6, 15993295, 15993295, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'ProcessDate__c', 7, 15993295, 15993295, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'DoNotCall__c', 8, 15993295, 15993295, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'Wireless__c', 9, 15993295, 15993295, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'EBRDate__c', 10, 15993295, 15993295, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'DoNotCodes__c', 11, 15993295, 5545235, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'WirelessCodes__c', 12, 15993295, 8854061, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'Phone__c', 13, 15993295, 15993295, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'IsDeleted', 14, 15993295, 15993295, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'CreatedById', 15, 15993295, 15993295, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'CreatedDate', 16, 15993295, 15993295, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'LastModifiedById', 17, 15993295, 15993295, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PhoneScrub__c', N'LastModifiedDate', 18, 15993295, 15993295, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'Id', 1, 555, 555, 0, 1, 'int', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'OwnerId', 2, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'PromoCode__c', 2, 555, 555, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'IsDeleted', 3, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'PromoCodeDescription__c', 3, 555, 555, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'IsActiveFlag', 4, 555, 555, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'Name', 4, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'CreatedById', 5, 555, 555, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'CurrencyIsoCode', 5, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'CreatedDate', 6, 555, 555, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'LastModifiedById', 7, 555, 555, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'LastModifiedDate', 8, 555, 555, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'SystemModstamp', 10, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'LastActivityDate', 11, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'LastViewedDate', 12, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'LastReferencedDate', 13, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'Active__c', 14, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'DiscountType__c', 15, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'EndDate__c', 16, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'NCCAvailable__c', 17, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'PromoCodeDisplay__c', 18, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'PromoCodeSort__c', 19, NULL, NULL, NULL, 1, NULL, 'decimal(10, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'StartDate__c', 20, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'PromoCode__c', N'External_Id__c', 21, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'OwnerId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'IsDeleted', 3, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'Name', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'CurrencyIsoCode', 5, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'CreatedDate', 6, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'CreatedById', 7, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'LastModifiedDate', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'LastModifiedById', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'SystemModstamp', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'LastViewedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'LastReferencedDate', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'OpportunityId', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'Pricebook2Id', 14, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ContactId', 15, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteNumber', 16, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'IsSyncing', 17, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingHandling', 18, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'Tax', 19, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'Status', 20, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ExpirationDate', 21, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'Description', 22, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'Subtotal', 23, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'TotalPrice', 24, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'LineItemCount', 25, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'BillingStreet', 26, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'BillingCity', 27, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'BillingState', 28, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'BillingPostalCode', 29, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'BillingCountry', 30, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'BillingStateCode', 31, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'BillingCountryCode', 32, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'BillingLatitude', 33, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'BillingLongitude', 34, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'BillingGeocodeAccuracy', 35, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'BillingAddress', 36, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingStreet', 37, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingCity', 38, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingState', 39, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingPostalCode', 40, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingCountry', 41, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingStateCode', 42, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingCountryCode', 43, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingLatitude', 44, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingLongitude', 45, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingGeocodeAccuracy', 46, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingAddress', 47, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteToStreet', 48, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteToCity', 49, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteToState', 50, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteToPostalCode', 51, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteToCountry', 52, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteToStateCode', 53, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteToCountryCode', 54, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteToLatitude', 55, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteToLongitude', 56, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteToGeocodeAccuracy', 57, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteToAddress', 58, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AdditionalStreet', 59, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AdditionalCity', 60, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AdditionalState', 61, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AdditionalPostalCode', 62, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AdditionalCountry', 63, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AdditionalStateCode', 64, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AdditionalCountryCode', 65, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AdditionalLatitude', 66, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AdditionalLongitude', 67, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AdditionalGeocodeAccuracy', 68, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AdditionalAddress', 69, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'BillingName', 70, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ShippingName', 71, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'QuoteToName', 72, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AdditionalName', 73, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'Email', 74, NULL, NULL, NULL, 0, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'Phone', 75, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'Fax', 76, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'ContractId', 77, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'AccountId', 78, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'Discount', 79, NULL, NULL, NULL, 0, NULL, 'decimal(3, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'GrandTotal', 80, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Quote', N'CanCreateQuoteLineItems', 81, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Result__c', N'Id', 1, 35, 35, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Result__c', N'Result__c', 2, 35, 35, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Result__c', N'ONC_ResultCode', 3, 35, 35, 0, 1, 'nchar(10)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Result__c', N'IsActiveFlag', 4, 35, 35, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Result__c', N'CreatedById', 5, 35, 35, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Result__c', N'CreatedDate', 6, 35, 35, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Result__c', N'LastModifiedById', 7, 35, 35, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Result__c', N'LastModifiedDate', 8, 35, 35, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Result__c', N'ONC_ResultCodeDescription', 9, 35, 35, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'SaleTypeCode__c', N'Id', 1, 25, 25, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'SaleTypeCode__c', N'SaleTypeCode__c', 2, 25, 25, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'SaleTypeCode__c', N'SaleTypeDescription__c', 3, 25, 25, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'SaleTypeCode__c', N'SortOrder', 4, 25, 25, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'SaleTypeCode__c', N'IsActiveFlag', 5, 25, 25, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'SaleTypeCode__c', N'CreatedById', 6, 25, 25, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'SaleTypeCode__c', N'CreatedDate', 7, 25, 25, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'SaleTypeCode__c', N'LastModifiedById', 8, 25, 25, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'SaleTypeCode__c', N'LastModifiedDate', 9, 25, 25, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'OwnerId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'IsDeleted', 3, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'AppointmentNumber', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'CurrencyIsoCode', 5, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'CreatedDate', 6, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'CreatedById', 7, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'LastModifiedDate', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'LastModifiedById', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'SystemModstamp', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'LastViewedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'LastReferencedDate', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'ParentRecordId', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'ParentRecordType', 14, NULL, NULL, NULL, 0, NULL, 'varchar(50)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'AccountId', 15, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'WorkTypeId', 16, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'ContactId', 17, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Street', 18, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'City', 19, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'State', 20, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'PostalCode', 21, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Country', 22, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'StateCode', 23, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'CountryCode', 24, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Latitude', 25, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Longitude', 26, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'GeocodeAccuracy', 27, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Address', 28, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Description', 29, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'EarliestStartTime', 30, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'DueDate', 31, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Duration', 32, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'ArrivalWindowStartTime', 33, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'ArrivalWindowEndTime', 34, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Status', 35, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'SchedStartTime', 36, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'SchedEndTime', 37, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'ActualStartTime', 38, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'ActualEndTime', 39, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'ActualDuration', 40, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'DurationType', 41, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'DurationInMinutes', 42, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'ServiceTerritoryId', 43, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Subject', 44, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'ParentRecordStatusCategory', 45, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'StatusCategory', 46, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'ServiceNote', 47, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'AppointmentType', 48, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Email', 49, NULL, NULL, NULL, 0, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Phone', 50, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'CancellationReason', 51, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'AdditionalInformation', 52, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Comments', 53, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'IsAnonymousBooking', 54, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'IsOffsiteAppointment', 55, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'ApptBookingInfoUrl', 56, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Confirmer_User__c', 57, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'External_Id__c', 58, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Meeting_Platform_Id__c', 59, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Meeting_Platform__c', 60, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Service_Appointment__c', 61, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Work_Type_Group__c', 62, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Appointment_Type__c', 63, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Scheduled_End_Text__c', 64, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Scheduled_Start_Text__c', 65, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Agent_Appointment_Link__c', 66, NULL, NULL, NULL, 0, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Automatic_Trigger__c', 67, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Guest_Appointment_Link__c', 68, NULL, NULL, NULL, 0, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Meeting_Point__c', 69, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Video_Session_Mode__c', 70, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Agent_Link__c', 71, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Guest_Link__c', 72, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Is_Video_Appointment__c', 73, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Sightcall_Appointment__c', 74, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Test_date__c', 75, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Are_you_sure_confirm__c', 76, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Appointment_Start_Date__c', 77, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Appointment_End_Date__c', 78, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Lead__c', 79, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Person_Account__c', 80, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Parent_Record_Type__c', 81, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Scheduled_Start_Date_Value__c', 82, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Service_Territory_Number__c', 83, NULL, NULL, NULL, 0, NULL, 'varchar(4)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Result__c', 84, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Created_By_Title__c', 85, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Bosley_Center_Number__c', 86, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Gender__c', 87, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceAppointment', N'Previous_Appt_Same_Day__c', 88, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'OwnerId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'IsDeleted', 3, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'Name', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'CurrencyIsoCode', 5, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'CreatedDate', 6, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'CreatedById', 7, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'LastModifiedDate', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'LastModifiedById', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'SystemModstamp', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'LastViewedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'LastReferencedDate', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'AccountId', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ContactId', 14, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'Term', 15, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'StartDate', 16, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'EndDate', 17, NULL, NULL, NULL, 0, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ActivationDate', 18, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ApprovalStatus', 19, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'Description', 20, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'BillingStreet', 21, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'BillingCity', 22, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'BillingState', 23, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'BillingPostalCode', 24, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'BillingCountry', 25, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'BillingStateCode', 26, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'BillingCountryCode', 27, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'BillingLatitude', 28, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'BillingLongitude', 29, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'BillingGeocodeAccuracy', 30, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'BillingAddress', 31, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ShippingStreet', 32, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ShippingCity', 33, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ShippingState', 34, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ShippingPostalCode', 35, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ShippingCountry', 36, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ShippingStateCode', 37, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ShippingCountryCode', 38, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ShippingLatitude', 39, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ShippingLongitude', 40, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ShippingGeocodeAccuracy', 41, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ShippingAddress', 42, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'Pricebook2Id', 43, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ShippingHandling', 44, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'Tax', 45, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'Subtotal', 46, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'TotalPrice', 47, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'LineItemCount', 48, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ContractNumber', 49, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'SpecialTerms', 50, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'Discount', 51, NULL, NULL, NULL, 0, NULL, 'decimal(3, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'GrandTotal', 52, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'Status', 53, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'ParentServiceContractId', 54, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceContract', N'RootServiceContractId', 55, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'OwnerId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'Name', 3, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'CurrencyIsoCode', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'CreatedDate', 5, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'CreatedById', 6, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'LastModifiedDate', 7, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'LastModifiedById', 8, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'SystemModstamp', 9, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'LastViewedDate', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'LastReferencedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'RelatedRecordId', 12, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'ResourceType', 13, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'Description', 14, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'IsActive', 15, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'LocationId', 16, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'AccountId', 17, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResource', N'External_Id__c', 18, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'SkillNumber', 3, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'CurrencyIsoCode', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'CreatedDate', 5, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'CreatedById', 6, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'LastModifiedDate', 7, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'LastModifiedById', 8, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'SystemModstamp', 9, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'LastViewedDate', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'LastReferencedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'ServiceResourceId', 12, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'SkillId', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'SkillLevel', 14, NULL, NULL, NULL, 0, NULL, 'decimal(2, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'EffectiveStartDate', 15, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'EffectiveEndDate', 16, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceResourceSkill', N'External_Id__c', 17, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'OwnerId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'IsDeleted', 3, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Name', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'CurrencyIsoCode', 5, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'CreatedDate', 6, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'CreatedById', 7, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'LastModifiedDate', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'LastModifiedById', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'SystemModstamp', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'LastViewedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'LastReferencedDate', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'ParentTerritoryId', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'TopLevelTerritoryId', 14, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Description', 15, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'OperatingHoursId', 16, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Street', 17, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'City', 18, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'State', 19, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'PostalCode', 20, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Country', 21, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'StateCode', 22, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'CountryCode', 23, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Latitude', 24, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Longitude', 25, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'GeocodeAccuracy', 26, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Address', 27, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'IsActive', 28, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'TypicalInTerritoryTravelTime', 29, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Alternative_Phone__c', 30, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'AreaManager__c', 31, NULL, NULL, NULL, 0, NULL, 'varchar(100)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Area__c', 32, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'AssistantManager__c', 33, NULL, NULL, NULL, 0, NULL, 'varchar(100)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'BackLinePhone__c', 34, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'BestTressedOffered__c', 35, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Caller_Id__c', 36, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'CenterAlert__c', 37, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'CenterNumber__c', 38, NULL, NULL, NULL, 0, NULL, 'varchar(3)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'CenterOwner__c', 39, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'CenterType__c', 40, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'CompanyID__c', 41, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Company__c', 42, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'ConfirmationCallerIDEnglish__c', 43, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'ConfirmationCallerIDFrench__c', 44, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'ConfirmationCallerIDSpanish__c', 45, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'CustomerServiceLine__c', 46, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'DisplayName__c', 47, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'External_Id__c', 48, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'ImageConsultant__c', 49, NULL, NULL, NULL, 0, NULL, 'varchar(100)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'MDPOffered__c', 50, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'MDPPerformed__c', 51, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Main_Phone__c', 52, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'ManagerName__c', 53, NULL, NULL, NULL, 0, NULL, 'varchar(100)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Map_Short_Link__c', 54, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'MgrCellPhone__c', 55, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'OfferPRP__c', 56, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'OtherCallerIDEnglish__c', 57, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'OtherCallerIDFrench__c', 58, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'OtherCallerIDSpanish__c', 59, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'OutboundDialingAllowed__c', 60, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'ProfileCode__c', 61, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Region__c', 62, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Status__c', 63, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Supported_Appointment_Types__c', 64, NULL, NULL, NULL, 0, NULL, 'varchar(1000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'SurgeryOffered__c', 65, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'TimeZone__c', 66, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Type__c', 67, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'WebPhone__c', 68, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Web_Phone__c', 69, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'X1Apptperslot__c', 70, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'English_Directions__c', 71, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'French_Directions__c', 72, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Spanish_Directions__c', 73, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Virtual__c', 74, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'English_Cross_Streets__c', 75, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'French_Cross_Streets__c', 76, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Spanish_Cross_Streets__c', 77, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory', N'Business_Hours__c', 78, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'Name', 3, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'CurrencyIsoCode', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'CreatedDate', 5, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'CreatedById', 6, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'LastModifiedDate', 7, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'LastModifiedById', 8, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'SystemModstamp', 9, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'LastViewedDate', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'LastReferencedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'Zip_Code_Center__c', 12, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'External_Id__c', 13, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritory_ZipCode__c', N'Service_Territory__c', 14, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'MemberNumber', 3, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'CurrencyIsoCode', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'CreatedDate', 5, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'CreatedById', 6, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'LastModifiedDate', 7, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'LastModifiedById', 8, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'SystemModstamp', 9, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'LastViewedDate', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'LastReferencedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'ServiceTerritoryId', 12, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'ServiceResourceId', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'TerritoryType', 14, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'EffectiveStartDate', 15, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'EffectiveEndDate', 16, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'Street', 17, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'City', 18, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'State', 19, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'PostalCode', 20, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'Country', 21, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'StateCode', 22, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'CountryCode', 23, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'Latitude', 24, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'Longitude', 25, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'GeocodeAccuracy', 26, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'Address', 27, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'OperatingHoursId', 28, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryMember', N'Role', 29, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'Name', 3, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'CurrencyIsoCode', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'CreatedDate', 5, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'CreatedById', 6, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'LastModifiedDate', 7, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'LastModifiedById', 8, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'SystemModstamp', 9, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'LastViewedDate', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'LastReferencedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'WorkTypeId', 12, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'ServiceTerritoryId', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'External_Id__c', 14, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ServiceTerritoryWorkType', N'Work_Type_Appointment_Type__c', 15, NULL, NULL, NULL, 0, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Id', 1, 49233, 49233, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Lead__c', 2, 49233, 49227, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Lead_Id__c', 3, 49233, 49227, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Contact__c', 4, 49233, 0, 1, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Contact_Id__c', 5, 49233, 0, 1, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'First_Name__c', 6, 49233, 49223, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Last_Name__c', 7, 49233, 49233, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Email__c', 8, 49233, 49233, 0, 1, 'nvarchar(105)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'City__c', 9, 49233, 42551, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Postal_Code__c', 10, 49233, 48846, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Region_Code__c', 11, 49233, 49233, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Region_Name__c', 12, 49233, 49233, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Country_Code__c', 13, 49233, 49227, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Country_Name__c', 14, 49233, 49227, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Survey_Name__c', 15, 49233, 49233, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Name', 16, 49233, 49233, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Full_Text__c', 17, 49233, 863, 0, 1, 'ntext', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Trigger_Task_Id__c', 18, 49233, 49233, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'OwnerId', 19, 49233, 49233, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'RecordTypeId', 20, 49233, 49233, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Start_Time__c', 21, 49233, 863, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Completion_Time__c', 22, 49233, 733, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Status__c', 23, 49233, 49233, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Review_Status__c', 24, 49233, 49233, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Reviewed_By__c', 25, 49233, 0, 1, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'API_ID__c', 26, 49233, 863, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Case__c', 27, 49233, 0, 1, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Case_Id__c', 28, 49233, 0, 1, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Chat_Transcript__c', 29, 49233, 0, 1, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Chat_Transcript_Id__c', 30, 49233, 0, 1, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF1_10__c', 31, 49233, 358, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF1_20__c', 32, 49233, 327, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF1_30__c', 33, 49233, 312, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF1_40__c', 34, 49233, 303, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF1_50__c', 35, 49233, 293, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF1_60__c', 36, 49233, 295, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF1_70__c', 37, 49233, 292, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF1_80__c', 38, 49233, 227, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF1_90__c', 39, 49233, 281, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF1_100__c', 40, 49233, 269, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF2_10__c', 41, 49233, 182, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF2_20__c', 42, 49233, 182, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF2_30__c', 43, 49233, 182, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF2_40__c', 44, 49233, 182, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF2_50__c', 45, 49233, 182, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF2_60__c', 46, 49233, 182, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF2_70__c', 47, 49233, 180, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF2_80__c', 48, 49233, 182, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF2_90__c', 49, 49233, 179, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF310__c', 50, 49233, 234, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3100__c', 51, 49233, 22, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3110__c', 52, 49233, 22, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3120__c', 53, 49233, 101, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3130__c', 54, 49233, 102, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3140__c', 55, 49233, 0, 1, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3150__c', 56, 49233, 0, 1, 1, 'ntext', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3160__c', 57, 49233, 0, 1, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3170__c', 58, 49233, 8, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3180__c', 59, 49233, 28, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3190__c', 60, 49233, 226, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF320__c', 61, 49233, 231, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3200__c', 62, 49233, 225, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3210__c', 63, 49233, 233, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3220__c', 64, 49233, 234, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF3230__c', 65, 49233, 232, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF330__c', 66, 49233, 233, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF340__c', 67, 49233, 234, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF350__c', 68, 49233, 234, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF360__c', 69, 49233, 226, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF370__c', 70, 49233, 73, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF380__c', 71, 49233, 74, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF390__c', 72, 49233, 20, 0, 1, 'ntext', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF410__c', 73, 49233, 42, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4100__c', 74, 49233, 18, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4110__c', 75, 49233, 18, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4120__c', 76, 49233, 5, 0, 1, 'ntext', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4130__c', 77, 49233, 4, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4140__c', 78, 49233, 4, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4150__c', 79, 49233, 9, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4160__c', 80, 49233, 10, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4170__c', 81, 49233, 0, 1, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4180__c', 82, 49233, 0, 1, 1, 'ntext', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4190__c', 83, 49233, 0, 1, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF420__c', 84, 49233, 42, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4200__c', 85, 49233, 1, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4210__c', 86, 49233, 0, 1, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4220__c', 87, 49233, 33, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4230__c', 88, 49233, 33, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4240__c', 89, 49233, 33, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4250__c', 90, 49233, 33, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4260__c', 91, 49233, 33, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4270__c', 92, 49233, 33, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4280__c', 93, 49233, 33, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4290__c', 94, 49233, 33, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF430__c', 95, 49233, 42, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4300__c', 96, 49233, 31, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4310__c', 97, 49233, 32, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF4320__c', 98, 49233, 32, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF440__c', 99, 49233, 42, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF450__c', 100, 49233, 0, 1, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF460__c', 101, 49233, 42, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF470__c', 102, 49233, 41, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF480__c', 103, 49233, 42, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'GF490__c', 104, 49233, 41, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'gf_id__c', 105, 49233, 0, 1, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'gf_unique__c', 106, 49233, 0, 1, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'IP_Address__c', 107, 49233, 853, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Language__c', 108, 49233, 49233, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Link_to_Response__c', 109, 49233, 863, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'Link_to_Summary_Report__c', 110, 49233, 863, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'CreatedById', 111, 49233, 49233, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'CreatedDate', 112, 49233, 49233, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'LastModifiedById', 113, 49233, 49233, 0, 1, 'nvarchar(18)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Survey_Response__c', N'LastModifiedDate', 114, 49233, 49233, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Id', 1, 11816098, 11816098, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'RecordTypeId', 2, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'WhoId', 2, 11816098, 10559702, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'ActivityID__c', 3, 11816098, 9034501, 0, 1, 'nchar(10)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'LeadOncContactID__c', 4, 11816098, 7931157, 0, 1, 'nchar(10)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'WhatId', 4, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'CenterNumber__c', 5, 11816098, 10014734, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'WhoCount', 5, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'CenterID__c', 6, 11816098, 1337319, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'WhatCount', 6, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Action__c', 7, 11816098, 10125470, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Subject', 7, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Result__c', 8, 11816098, 9593929, 0, 1, 'nvarchar(50)', 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'ActivityType__c', 9, 11816098, 10130515, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Status', 9, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'ActivityDate', 10, 11816098, 11349667, 0, 1, 'datetime', 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Priority', 10, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'IsHighPriority', 11, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'StartTime__c', 11, 11816098, 2494974, 0, 1, 'time(7)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'CompletionDate__c', 12, 11816098, 9076470, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Description', 13, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'EndTime__c', 13, 11816098, 884864, 0, 1, 'time(7)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'CurrencyIsoCode', 14, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'OwnerId', 14, 11816098, 11816098, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'LeadOncGender__c', 15, 11816098, 8887106, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Type', 15, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'LeadOncBirthday__c', 16, 11816098, 6207479, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'AccountId', 17, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Occupation__c', 17, 11816098, 236281, 0, 1, 'nvarchar(100)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'IsClosed', 18, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'LeadOncEthnicity__c', 18, 11816098, 1278811, 0, 1, 'nvarchar(100)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'MaritalStatus__c', 19, 11816098, 236280, 0, 1, 'nvarchar(100)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'NorwoodScale__c', 20, 11816098, 180219, 0, 1, 'nvarchar(100)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'LudwigScale__c', 21, 11816098, 132418, 0, 1, 'nvarchar(100)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'LeadOncAge__c', 22, 11816098, 10277965, 0, 1, 'int', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Performer__c', 23, 11816098, 251258, 0, 1, 'nvarchar(102)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'SystemModstamp', 23, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'PriceQuoted__c', 24, 11816098, 664261, 0, 1, 'decimal(18, 2)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'CallDurationInSeconds', 25, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'SolutionOffered__c', 25, 11816098, 184045, 0, 1, 'nvarchar(100)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'CallType', 26, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'NoSaleReason__c', 26, 11816098, 184046, 0, 1, 'nvarchar(200)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'CallDisposition', 27, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'DISC__c', 27, 11816098, 236267, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'CallObject', 28, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'SaleTypeCode__c', 28, 11816098, 150571, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'ReminderDateTime', 29, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'SaleTypeDescription__c', 29, 11816098, 141555, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'IsReminderSet', 30, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'SourceCode__c', 30, 11816098, 9674591, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'PromoCode__c', 31, 11816098, 6105817, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'RecurrenceActivityId', 31, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'IsRecurrence', 32, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'TimeZone__c', 32, 11816098, 8968027, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'OncCreatedDate__c', 33, 11816098, 5949227, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'RecurrenceStartDateOnly', 33, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'RecurrenceEndDateOnly', 34, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'ReportCreateDate__c', 34, 11816098, 10481186, 0, 1, 'datetime', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'IsDeleted', 35, 11816098, 11816098, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'RecurrenceTimeZoneSidKey', 35, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'RecurrenceType', 36, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'CreatedById', 37, 11816098, 11816098, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'RecurrenceInterval', 37, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'CreatedDate', 38, 11816098, 11816098, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'RecurrenceDayOfWeekMask', 38, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'LastModifiedById', 39, 11816098, 11816098, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'RecurrenceDayOfMonth', 39, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'LastModifiedDate', 40, 11816098, 11816098, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'RecurrenceInstance', 40, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'IsArchived', 41, 11816098, 11816098, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'RecurrenceMonthOfYear', 41, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'ReceiveBrochure__c', 42, 11816098, 5367751, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'RecurrenceRegeneratedType', 42, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'ReferralCode__c', 43, 11816098, 14387, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'TaskSubtype', 43, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Accommodation__c', 44, 11816098, 561018, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'CompletedDateTime', 44, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'BrightPattern__SPRecordingOrTranscriptURL__c', 45, NULL, NULL, NULL, 1, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Center_Name__c', 46, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Completed_Date__c', 47, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'External_ID__c', 48, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Lead__c', 49, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Meeting_Platform_Id__c', 50, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Meeting_Platform__c', 51, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Person_Account__c', 52, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Recording_Link__c', 53, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'SPRecordingOrTranscriptURL__c', 55, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Service_Appointment__c', 56, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Service_Territory_Caller_Id__c', 57, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Agent_Link__c', 58, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Guest_Link__c', 59, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Opportunity__c', 60, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Center_Phone__c', 61, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'DB_Activity_Type__c', 62, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'CallBackDueDate__c', 63, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'Invite__c', 64, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'Task', N'TaskWhoIds', 65, NULL, NULL, NULL, 1, NULL, 'varchar(500)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Id', 1, 1951, 1951, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'FirstName', 2, 1951, 1934, 0, 1, 'nvarchar(40)', 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'LastName', 3, 1951, 1951, 0, 1, 'nvarchar(80)', 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Name', 4, 1951, 1951, 0, 1, 'nvarchar(102)', 'varchar(121)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'MiddleName', 5, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Username', 5, 1951, 1951, 0, 1, 'nvarchar(80)', 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Suffix', 6, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserCode__c', 6, 1951, 956, 0, 1, 'nvarchar(20)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Alias', 7, 1951, 1951, 0, 1, 'nvarchar(8)', 'varchar(8)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Title', 8, 1951, 1485, 0, 1, 'nvarchar(80)', 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Department', 9, 1951, 1456, 0, 1, 'nvarchar(80)', 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Division', 9, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'CompanyName', 10, 1951, 1549, 0, 1, 'nvarchar(80)', 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Team', 11, 1951, 938, 0, 1, 'nvarchar(50)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'IsDeleted', 12, 1951, 1951, 0, 1, 'bit', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Street', 12, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'City', 13, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'CreatedById', 13, 1951, 1951, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'CreatedDate', 14, 1951, 1951, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'State', 14, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'LastModifiedById', 15, 1951, 1951, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'PostalCode', 15, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Country', 16, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'LastModifiedDate', 16, 1951, 1951, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'StateCode', 17, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'CountryCode', 18, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Latitude', 19, NULL, NULL, NULL, 1, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Longitude', 20, NULL, NULL, NULL, 1, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'GeocodeAccuracy', 21, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Address', 22, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Email', 23, NULL, NULL, NULL, 1, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'EmailPreferencesAutoBcc', 24, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'EmailPreferencesAutoBccStayInTouch', 25, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'EmailPreferencesStayInTouchReminder', 26, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'SenderEmail', 27, NULL, NULL, NULL, 1, NULL, 'varchar(128)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'SenderName', 28, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Signature', 29, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'StayInTouchSubject', 30, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'StayInTouchSignature', 31, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'StayInTouchNote', 32, NULL, NULL, NULL, 1, NULL, 'varchar(512)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Phone', 33, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Fax', 34, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'MobilePhone', 35, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'CommunityNickname', 37, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'BadgeText', 38, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'IsActive', 39, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'TimeZoneSidKey', 40, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserRoleId', 41, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'LocaleSidKey', 42, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'ReceivesInfoEmails', 43, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'ReceivesAdminInfoEmails', 44, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'EmailEncodingKey', 45, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'DefaultCurrencyIsoCode', 46, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'CurrencyIsoCode', 47, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'ProfileId', 48, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserType', 49, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'LanguageLocaleKey', 50, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'EmployeeNumber', 51, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'DelegatedApproverId', 52, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'ManagerId', 53, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'LastLoginDate', 54, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'LastPasswordChangeDate', 55, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'SystemModstamp', 60, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'NumberOfFailedLogins', 61, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'OfflineTrialExpirationDate', 62, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'OfflinePdaTrialExpirationDate', 63, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPermissionsMarketingUser', 64, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPermissionsOfflineUser', 65, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPermissionsAvantgoUser', 66, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPermissionsCallCenterAutoLogin', 67, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPermissionsSFContentUser', 68, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPermissionsKnowledgeUser', 69, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPermissionsInteractionUser', 70, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPermissionsSupportUser', 71, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPermissionsLiveAgentUser', 72, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'ForecastEnabled', 73, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesActivityRemindersPopup', 74, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesEventRemindersCheckboxDefault', 75, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesTaskRemindersCheckboxDefault', 76, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesReminderSoundOff', 77, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisableAllFeedsEmail', 78, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisableFollowersEmail', 79, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisableProfilePostEmail', 80, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisableChangeCommentEmail', 81, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisableLaterCommentEmail', 82, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisProfPostCommentEmail', 83, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesApexPagesDeveloperMode', 84, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesReceiveNoNotificationsAsApprover', 85, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesReceiveNotificationsAsDelegatedApprover', 86, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideCSNGetChatterMobileTask', 87, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisableMentionsPostEmail', 88, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisMentionsCommentEmail', 89, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideCSNDesktopTask', 90, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideChatterOnboardingSplash', 91, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideSecondChatterOnboardingSplash', 92, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisCommentAfterLikeEmail', 93, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisableLikeEmail', 94, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesSortFeedByComment', 95, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisableMessageEmail', 96, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisableBookmarkEmail', 97, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisableSharePostEmail', 98, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesEnableAutoSubForFeeds', 99, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisableFileShareNotificationsForApi', 100, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowTitleToExternalUsers', 101, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowManagerToExternalUsers', 102, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowEmailToExternalUsers', 103, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowWorkPhoneToExternalUsers', 104, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowMobilePhoneToExternalUsers', 105, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowFaxToExternalUsers', 106, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowStreetAddressToExternalUsers', 107, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowCityToExternalUsers', 108, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowStateToExternalUsers', 109, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowPostalCodeToExternalUsers', 110, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowCountryToExternalUsers', 111, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowProfilePicToGuestUsers', 112, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowTitleToGuestUsers', 113, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowCityToGuestUsers', 114, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowStateToGuestUsers', 115, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowPostalCodeToGuestUsers', 116, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowCountryToGuestUsers', 117, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideInvoicesRedirectConfirmation', 118, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideStatementsRedirectConfirmation', 119, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideS1BrowserUI', 120, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesDisableEndorsementEmail', 121, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesPathAssistantCollapsed', 122, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesCacheDiagnostics', 123, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowEmailToGuestUsers', 124, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowManagerToGuestUsers', 125, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowWorkPhoneToGuestUsers', 126, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowMobilePhoneToGuestUsers', 127, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowFaxToGuestUsers', 128, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowStreetAddressToGuestUsers', 129, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesLightningExperiencePreferred', 130, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesPreviewLightning', 131, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideEndUserOnboardingAssistantModal', 132, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideLightningMigrationModal', 133, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideSfxWelcomeMat', 134, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideBiggerPhotoCallout', 135, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesGlobalNavBarWTShown', 136, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesGlobalNavGridMenuWTShown', 137, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesCreateLEXAppsWTShown', 138, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesFavoritesWTShown', 139, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesRecordHomeSectionCollapseWTShown', 140, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesRecordHomeReservedWTShown', 141, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesFavoritesShowTopFavorites', 142, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesExcludeMailAppAttachments', 143, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesSuppressTaskSFXReminders', 144, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesSuppressEventSFXReminders', 145, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesPreviewCustomTheme', 146, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHasCelebrationBadge', 147, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesUserDebugModePref', 148, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesSRHOverrideActivities', 149, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesNewLightningReportRunPageEnabled', 150, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesReverseOpenActivitiesView', 151, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesShowTerritoryTimeZoneShifts', 152, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesNativeEmailClient', 153, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideBrowseProductRedirectConfirmation', 154, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserPreferencesHideOnlineSalesAppWelcomeMat', 155, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'ContactId', 156, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'AccountId', 157, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'CallCenterId', 158, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Extension', 159, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'FederationIdentifier', 160, NULL, NULL, NULL, 1, NULL, 'varchar(512)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'AboutMe', 161, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'FullPhotoUrl', 162, NULL, NULL, NULL, 1, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'SmallPhotoUrl', 163, NULL, NULL, NULL, 1, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'IsExtIndicatorVisible', 164, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'OutOfOfficeMessage', 165, NULL, NULL, NULL, 1, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'MediumPhotoUrl', 166, NULL, NULL, NULL, 1, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'DigestFrequency', 167, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'DefaultGroupNotificationFrequency', 168, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'LastViewedDate', 169, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'LastReferencedDate', 170, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'BannerPhotoUrl', 171, NULL, NULL, NULL, 1, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'SmallBannerPhotoUrl', 172, NULL, NULL, NULL, 1, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'MediumBannerPhotoUrl', 173, NULL, NULL, NULL, 1, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'IsProfilePhotoActive', 174, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'et4ae5__Default_ET_Page__c', 175, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'et4ae5__Default_MID__c', 176, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'et4ae5__ExactTargetForAppExchangeAdmin__c', 177, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'et4ae5__ExactTargetForAppExchangeUser__c', 178, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'et4ae5__ExactTargetUsername__c', 179, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'et4ae5__ExactTarget_OAuth_Token__c', 180, NULL, NULL, NULL, 1, NULL, 'varchar(175)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'et4ae5__ValidExactTargetAdmin__c', 181, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'et4ae5__ValidExactTargetUser__c', 182, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Chat_Display_Name__c', 183, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Chat_Photo_Small__c', 184, NULL, NULL, NULL, 1, NULL, 'varchar(1024)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'DialerID__c', 185, NULL, NULL, NULL, 1, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'External_Id__c', 186, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'SightCall_UseCase_Id__c', 187, NULL, NULL, NULL, 1, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Mobile_Agent_Login__c', 188, NULL, NULL, NULL, 1, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'approver__c', 189, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'DB_Region__c', 190, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'Full_Name__c', 191, NULL, NULL, NULL, 1, NULL, 'varchar(1300)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'User_Deactivation_Details__c', 192, NULL, NULL, NULL, 1, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'BannerPhotoId', 193, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'EndDay', 194, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'WorkspaceId', 195, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'UserSubtype', 196, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'IsSystemControlled', 197, NULL, NULL, NULL, 1, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'PasswordResetAttempt', 198, NULL, NULL, NULL, 1, NULL, 'decimal(9, 0)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'PasswordResetLockoutDate', 199, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'User', N'StartDay', 200, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'OwnerId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'IsDeleted', 3, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'WorkOrderNumber', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'CurrencyIsoCode', 5, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'CreatedDate', 6, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'CreatedById', 7, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'LastModifiedDate', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'LastModifiedById', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'SystemModstamp', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'LastViewedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'LastReferencedDate', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'AccountId', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'ContactId', 14, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'CaseId', 15, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'EntitlementId', 16, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'ServiceContractId', 17, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'AssetId', 18, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Street', 19, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'City', 20, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'State', 21, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'PostalCode', 22, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Country', 23, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'StateCode', 24, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'CountryCode', 25, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Latitude', 26, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Longitude', 27, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'GeocodeAccuracy', 28, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Address', 29, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Description', 30, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'StartDate', 31, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'EndDate', 32, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Subject', 33, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'RootWorkOrderId', 34, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Status', 35, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Priority', 36, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Tax', 37, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Subtotal', 38, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'TotalPrice', 39, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'LineItemCount', 40, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Pricebook2Id', 41, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Discount', 42, NULL, NULL, NULL, 0, NULL, 'decimal(3, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'GrandTotal', 43, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'ParentWorkOrderId', 44, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'IsClosed', 45, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'IsStopped', 46, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'StopStartDate', 47, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'SlaStartDate', 48, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'SlaExitDate', 49, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'BusinessHoursId', 50, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'MilestoneStatus', 51, NULL, NULL, NULL, 0, NULL, 'varchar(30)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'Duration', 52, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'DurationType', 53, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'DurationInMinutes', 54, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'ServiceAppointmentCount', 55, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'WorkTypeId', 56, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'ServiceTerritoryId', 57, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'StatusCategory', 58, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrder', N'LocationId', 59, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'IsDeleted', 2, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'LineItemNumber', 3, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'CurrencyIsoCode', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'CreatedDate', 5, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'CreatedById', 6, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'LastModifiedDate', 7, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'LastModifiedById', 8, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'SystemModstamp', 9, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'LastViewedDate', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'LastReferencedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'WorkOrderId', 12, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'ParentWorkOrderLineItemId', 13, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Product2Id', 14, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'AssetId', 15, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'OrderId', 16, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'RootWorkOrderLineItemId', 17, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Description', 18, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'StartDate', 19, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'EndDate', 20, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Status', 21, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'PricebookEntryId', 22, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Quantity', 23, NULL, NULL, NULL, 0, NULL, 'decimal(10, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'UnitPrice', 24, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Discount', 25, NULL, NULL, NULL, 0, NULL, 'decimal(3, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'ListPrice', 26, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Subtotal', 27, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'TotalPrice', 28, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Duration', 29, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'DurationType', 30, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'DurationInMinutes', 31, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'WorkTypeId', 32, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Street', 33, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'City', 34, NULL, NULL, NULL, 0, NULL, 'varchar(40)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'State', 35, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'PostalCode', 36, NULL, NULL, NULL, 0, NULL, 'varchar(20)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Country', 37, NULL, NULL, NULL, 0, NULL, 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'StateCode', 38, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'CountryCode', 39, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Latitude', 40, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Longitude', 41, NULL, NULL, NULL, 0, NULL, 'decimal(25, 15)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'GeocodeAccuracy', 42, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Address', 43, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'ServiceTerritoryId', 44, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Subject', 45, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'StatusCategory', 46, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'IsClosed', 47, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'Priority', 48, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'ServiceAppointmentCount', 49, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkOrderLineItem', N'LocationId', 50, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'OwnerId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'IsDeleted', 3, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'Name', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'CurrencyIsoCode', 5, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'CreatedDate', 6, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'CreatedById', 7, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'LastModifiedDate', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'LastModifiedById', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'SystemModstamp', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'LastViewedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'LastReferencedDate', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'Description', 13, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'EstimatedDuration', 14, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'DurationType', 15, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'DurationInMinutes', 16, NULL, NULL, NULL, 0, NULL, 'decimal(16, 2)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'TimeframeStart', 17, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'TimeframeEnd', 18, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'BlockTimeBeforeAppointment', 19, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'BlockTimeAfterAppointment', 20, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'DefaultAppointmentType', 21, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'TimeFrameStartUnit', 22, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'TimeFrameEndUnit', 23, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'BlockTimeBeforeUnit', 24, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'BlockTimeAfterUnit', 25, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'OperatingHoursId', 26, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkType', N'External_Id__c', 27, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'Id', 1, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'OwnerId', 2, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'IsDeleted', 3, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'Name', 4, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'CurrencyIsoCode', 5, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'CreatedDate', 6, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'CreatedById', 7, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'LastModifiedDate', 8, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'LastModifiedById', 9, NULL, NULL, NULL, 0, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'SystemModstamp', 10, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'LastViewedDate', 11, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'LastReferencedDate', 12, NULL, NULL, NULL, 0, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'Description', 13, NULL, NULL, NULL, 0, NULL, 'varchar(MAX)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'GroupType', 14, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'IsActive', 15, NULL, NULL, NULL, 0, NULL, 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'AdditionalInformation', 16, NULL, NULL, NULL, 0, NULL, 'varchar(1000)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'External_Id__c', 17, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'WorkTypeGroup', N'Language__c', 18, NULL, NULL, NULL, 0, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'Id', 1, 1033984, 1033984, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'City__c', 2, 1033984, 1033982, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'OwnerId', 2, NULL, NULL, NULL, 1, NULL, 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'State__c', 3, 1033984, 1033982, 0, 1, 'nchar(4)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'County__c', 4, 1033984, 973542, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'CurrencyIsoCode', 5, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'Name', 5, 1033984, 1033984, 0, 1, 'nvarchar(80)', 'varchar(80)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'Country__c', 6, 1033984, 1033982, 0, 1, 'nchar(4)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'DMA__c', 7, 1033984, 41283, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'Timezone__c', 8, 1033984, 996626, 0, 1, 'nvarchar(255)', NULL )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'IsDeleted', 9, 1033984, 1033984, 0, 1, 'bit', 'bit' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'CreatedById', 10, 1033984, 1033984, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'SystemModstamp', 10, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'CreatedDate', 11, 1033984, 1033984, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'LastActivityDate', 11, NULL, NULL, NULL, 1, NULL, 'date' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'LastModifiedById', 12, 1033984, 1033984, 0, 1, 'nvarchar(18)', 'varchar(18)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'LastViewedDate', 12, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'LastModifiedDate', 13, 1033984, 1033984, 0, 1, 'datetime', 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'LastReferencedDate', 13, NULL, NULL, NULL, 1, NULL, 'datetime2(7)' )
INSERT INTO [##MappingResult] ([ObjectName], [ColumnName], [ColumnId], [AllCnt], [NotNullCnt], [ExistingDataAllNulls], [CurrentlyUsed], [HC_BI_SFDC_ColumnDef], [SalesForceImport_ColumnDef])
VALUES
( N'ZipCode__c', N'External_Id__c', 14, NULL, NULL, NULL, 1, NULL, 'varchar(255)' )
GO
COMMIT
