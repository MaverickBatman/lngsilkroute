#install.packages('rsconnect')
#install.packages('shinywidets')

library(rsconnect)

rsconnect::setAccountInfo(name='lngsilkroute', token='AA065232712EB7DC8FBC2128D25A854E', secret='dWKIRgaEboxWnZ8WcHSQwhtpP9qjMPgvco7mlpDy')


# rsconnect::configureApp("LNGSilkRoute", size="small")
rsconnect::deployApp('draft')

warnings()

rsconnect::showLogs(appPath = 'draft')

#rsconnect::terminateApp('LNGSilkRoute')
