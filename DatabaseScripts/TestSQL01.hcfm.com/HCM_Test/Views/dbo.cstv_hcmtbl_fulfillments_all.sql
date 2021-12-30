/* CreateDate: 07/11/2012 12:01:44.853 , ModifyDate: 07/11/2012 12:01:44.853 */
GO
CREATE VIEW dbo.cstv_hcmtbl_fulfillments_all AS
SELECT
hcmtbl_fulfillments_all.[center address 1] AS [center_address_1],
hcmtbl_fulfillments_all.[center address 2] AS [center_address_2],
hcmtbl_fulfillments_all.[center city] AS [center_city],
hcmtbl_fulfillments_all.[center name] AS [center_name],
hcmtbl_fulfillments_all.[center number] AS [center_number],
hcmtbl_fulfillments_all.[center state] AS [center_state],
hcmtbl_fulfillments_all.[center zip] AS [center_zip],
hcmtbl_fulfillments_all.[contact address 1] AS [contact_address_1],
hcmtbl_fulfillments_all.[contact address 2] AS [contact_address_2],
hcmtbl_fulfillments_all.[contact city] AS [contact_city],
hcmtbl_fulfillments_all.[contact create date] AS [contact_create_date],
hcmtbl_fulfillments_all.[contact fname] AS [contact_fname],
hcmtbl_fulfillments_all.[contact lname] AS [contact_lname],
hcmtbl_fulfillments_all.[contact state] AS [contact_state],
hcmtbl_fulfillments_all.[contact zip] AS [contact_zip],
hcmtbl_fulfillments_all.[create by] AS [create_by],
hcmtbl_fulfillments_all.cst_gender AS [cst_gender],
hcmtbl_fulfillments_all.email AS [email],
hcmtbl_fulfillments_all.filename AS [filename],
hcmtbl_fulfillments_all.phone AS [phone],
hcmtbl_fulfillments_all.promo as [promo],
hcmtbl_fulfillments_all.promo2 as [promo2],
hcmtbl_fulfillments_all.recordid as [recordid],
hcmtbl_fulfillments_all.type as [type]
FROM hcmtbl_fulfillments_all
GO
