import pandas as pd
from sqlalchemy import create_engine

db_url = 'postgresql://postgres:12345@localhost/painting'
engine = create_engine(db_url)

try:
    conn = engine.connect()
    print("connection successful")
except Exception as error:
    print(f"connection failed :{error}")

file_name = ['artist', 'canvas_size', 'image_link', 'museum',
             'museum_hours', 'product_size', 'subject', 'work']

for file in file_name:
    df = pd.read_csv(
        f'C:/Users/ELCOT/sql project - painting/archive/{file}.csv')
    df.to_sql(file, con=conn, if_exists='replace', index=False)
