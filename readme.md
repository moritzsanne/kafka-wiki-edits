# Data Engineering Challenge

# Ziel
Ziel war es eine Kafka Mockup Umgebung mit den folgenden Komponenten aufzusetzen:

- Kafka Producer: Emitiert mit Intervall zwischen 0 und 1s mockup Wikipedia Edits aus sample_data.csv
	- Umgesetzt mit python und kafka-python
- Kafka Consumer: Aggregation der Wikipedia edits in Zeitfenstern von einer Minute. Global und gefiltert für die deutsche Wikipedia.
	- Ich habe mich an dieser Stelle entschieden die Aggregationen mit kSQL umzusetzen um die Aggregationen über Zeitfenster nicht neu in Python implementieren zu müssen.
	

# How to setup:
### Kafka & Python Producer

```
#install python requirements:

pip install kafka-python, pandas
#spin up docker compose
docker compose up

#start producer:
python producer.py
```
### Aggregation mit ksql

bash into ksql_cli container:

`sudo docker exec -it ksqldb-cli ksql http://ksqldb-server:8088`

initiate ksql streams and aggregation queries:

`ksql> run script /app/queries/queries.sql;`

Die Ergebnisse der Echtzeit Aggregationen können wir dann wie folgt über ksql abgefragt werden:

#Globale Edits pro Minute
```ksql> SELECT TIMESTAMPTOSTRING(WINDOWSTART, 'yyyy-MM-dd HH:mm:ss') 
       AS window_start, EDIT_COUNT FROM GLOBAL_COUNT LIMIT 5;```

#Edits der deutschen Wikipedia pro Minute
```ksql> SELECT TIMESTAMPTOSTRING(WINDOWSTART, 'yyyy-MM-dd HH:mm:ss') 
       AS window_start, EDIT_COUNT FROM DE_EDIT_COUNT LIMIT 5;```

```
ksql> SELECT TIMESTAMPTOSTRING(WINDOWSTART, 'yyyy-MM-dd HH:mm:ss') AS window_start, EDIT_COUNT FROM GLOBAL_COUNT LIMIT 5;
```
```
+--------------------------------------------------------------------------+--------------------------------------------------------------------------+

|WINDOW_START                                                              |EDIT_COUNT                                                                |

+--------------------------------------------------------------------------+--------------------------------------------------------------------------+

|2022-06-28 20:44:00                                                       |12                                                                        |

|2022-06-28 20:45:00                                                       |122                                                                       |

|2022-06-28 20:46:00                                                       |101                                                                       |

|2022-06-28 20:47:00                                                       |114                                                                       |

|2022-06-28 20:48:00                                                       |114                                                                       |

Query terminated
```









