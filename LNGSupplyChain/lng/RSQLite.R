library(DBI)
mydb<- "null"
db.open <- function(dbName = "my-db.db") {
  #mydb <- dbConnect(RSQLite::SQLite(), "my-db.db")
  return<- dbConnect(RSQLite::SQLite(), dbName)  
}

db.select.all <- function(mydb) {
#dbGetQuery(mydb, 'SELECT * FROM t')
     result <- dbGetQuery(mydb, 'SELECT * FROM t')
}

db.close <- function(mydb) {
dbDisconnect(mydb)
}