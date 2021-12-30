/* CreateDate: 05/08/2010 14:53:34.620 , ModifyDate: 04/10/2014 16:49:58.523 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimDate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransaction_DimDate]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransaction]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
--			04-10-14  KMurdoch	   Changed to Left outer join for Speed
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

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransaction]'
  	SET @DimensionName = N'[bief_dds].[DimDate]'
	SET @FieldName = N'[OrderDateKey]'


	INSERT INTO @tbl
		--SELECT @TableName, @DimensionName, @FieldName, OrderDateKey
		--FROM [bi_health].[synHC_DDS_FactSalesTransaction]  WITH (NOLOCK)
		--WHERE OrderDateKey NOT
		--IN (
		--		SELECT SRC.DateKey
		--		FROM [bi_health].[synHC_DDS_DimDate] SRC WITH (NOLOCK)
		--	)

		SELECT @TableName, @DimensionName, @FieldName, OrderDateKey
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH (NOLOCK)
			LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = DD.DateKey
		WHERE FST.OrderDateKey IS NULL

RETURN
END
GO
