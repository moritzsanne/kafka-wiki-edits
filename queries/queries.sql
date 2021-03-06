CREATE STREAM wiki_edits 
    (Id int, server_name string) 
     WITH (kafka_topic='wiki_edits_raw', value_format='json', partitions=1);

CREATE STREAM wiki_edits_foo
    WITH (KAFKA_TOPIC='wiki_edits_foo', PARTITIONS=1, REPLICAS=1) 
    AS SELECT 1 AS FOO, * FROM WIKI_EDITS EMIT CHANGES; 


CREATE TABLE DE_EDIT_COUNT 
    WITH (KAFKA_TOPIC='de_edit_counter', PARTITIONS=1, REPLICAS=1) 
    AS SELECT   WIKI_EDITS.SERVER_NAME SERVER_NAME,   COUNT(*) edit_count 
    FROM WIKI_EDITS WINDOW TUMBLING ( SIZE 60 SECONDS )  WHERE (WIKI_EDITS.SERVER_NAME = 'de.wikipedia.org') 
    GROUP BY WIKI_EDITS.SERVER_NAME EMIT CHANGES; 


CREATE TABLE GLOBAL_COUNT 
    WITH (KAFKA_TOPIC='global_count', PARTITIONS=1, REPLICAS=1) 
    AS SELECT   wiki_edits_foo.FOO AS FOO,   COUNT(*) edit_count 
    FROM wiki_edits_foo WINDOW TUMBLING ( SIZE 60 SECONDS )  
    GROUP BY FOO EMIT CHANGES;   


