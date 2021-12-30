/* CreateDate: 12/11/2012 14:57:23.870 , ModifyDate: 12/11/2012 14:57:23.870 */
GO
CREATE VIEW [dbo].[vwCfgCurrencyExchangeRate]
AS
SELECT     cer.CurrencyExchangeRateID, lkpCT.CurrencyTypeDescription, cer.ExchangeRate, cer.BeginDate, cer.EndDate, cer.IsActiveFlag, cer.CreateDate,
                      cer.CreateUser, cer.LastUpdate, cer.LastUpdateUser, cer.UpdateStamp
FROM         dbo.cfgCurrencyExchangeRate AS cer LEFT OUTER JOIN
                      dbo.lkpCurrencyType AS lkpCT ON lkpCT.CurrencyTypeID = cer.CurrencyTypeID
GO
