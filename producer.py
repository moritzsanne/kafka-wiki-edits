import pandas as pd
import random
import time
import json
from kafka import KafkaProducer


df = pd.read_csv("sample_data.csv")
df = df.fillna('')
producer = KafkaProducer(bootstrap_servers=['127.0.0.1:29092'], 
    value_serializer=lambda v: json.dumps(v,allow_nan=False).encode('utf-8'))


if __name__ == "__main__":
    while True:
        for i, row in df.iterrows():
            time.sleep(random.random())
            data = row.to_dict()
            producer.send('wiki_edits_raw',data)
            print(data)
