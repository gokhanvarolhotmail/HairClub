/* CreateDate: 10/24/2011 13:57:05.643 , ModifyDate: 04/11/2014 09:17:05.503 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactAppointmentDetail_DimSalesCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactAppointmentDetail_DimSalesCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactAppointmentDetail_DimSalesCode]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-24-11  KMurdoch     Initial Creation
--			04-11-14  KMurdoch     Changed to Left Join for speed
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, DimensionName varchar(150)
					, FieldName varchar(150)
					, FieldKey bigint
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table
			, @DimensionName			varchar(150)	-- Name of field
			, @FieldName				varchar(150)	-- Name of field

 	SET @TableName = N'[bi_cms_dds].[FactAppointmentDetail]'
  	SET @DimensionName = N'[bi_cms_dds].[DimSalesCode]'
	SET @FieldName = N'[SalesCodeKey]'


	INSERT INTO @tbl
		--SELECT --@TableName, @DimensionName, @FieldName,
		--	SalesCodeKey
		--FROM [bi_health].[synHC_DDS_FactAppointmentDetail]  WITH (NOLOCK)
		--WHERE SalesCodeKey NOT
		--IN (
		--		SELECT SRC.SalesCodeKey
		--		FROM [bi_health].[synHC_DDS_DimSalesCode] SRC WITH (NOLOCK)
		--	)

		SELECT @TableName, @DimensionName, @FieldName,
			DSC.SalesCodeKey
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail FAD  WITH (NOLOCK)
			LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
				ON DSC.SalesCodeKey = FAD.SalesCodeKey
		WHERE DSC.SalesCodeKey IS NULL

RETURN
END
GO
