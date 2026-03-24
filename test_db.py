import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="fotbolldb"
)

cursor = db.cursor()

cursor.execute("CALL SpelarStatistik()")

for row in cursor:
    print(row)