# Data Engineering Challenge

# Ziel
Ziel der Aufgabe war es eine Kafka Mockup Umgebung mit den folgenden Komponenten aufzusetzen:

- Kafka Producer: Emitiert mit Intervall zwischen 0 und 1s mockup Wikipedia Edits aus sample_data.csv
	- Umgesetzt mit python und kafka-python
- Kafka Consumer: Aggregation der Wikipedia edits in Zeitfenstern von einer Minute. Global und gefiltert für die deutsche Wikipedia.
	- Ich habe mich an dieser Stelle entschieden die Aggregationen mit kSQL umzusetzen um die Aggregationen über Zeitfenster nicht neu in Python implementieren zu müssen.
	
# Architekturdiagram


# How to run:

python requirements:

```pip install kafka-python, pandas```
docker compose up

start producer:
'''python producer.py'''

bash into ksql_cli:

´´´sudo docker exec -it ksqldb-cli ksql http://ksqldb-server:8088´´´

run script /app/queries/queries.sql;

Die Ergebnisse der Echtzeit Aggregationen können dann wie folgt über ksql abgefragt werden:
#Globale Edits pro Minute
SELECT TIMESTAMPTOSTRING(WINDOWSTART, 'yyyy-MM-dd HH:mm:ss') AS window_start, EDIT_COUNT FROM GLOBAL_COUNT LIMIT 5;
#Edits der deutschen Wikipedia pro Minute
SELECT TIMESTAMPTOSTRING(WINDOWSTART, 'yyyy-MM-dd HH:mm:ss') AS window_start, EDIT_COUNT FROM DE_EDIT_COUNT LIMIT 5;








