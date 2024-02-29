import psycopg2
import json
import time

def connect_to_postgres():
    conn = psycopg2.connect(
        dbname="postgres",
        user="postgres",
        password="postgres",
        host="localhost",
        port="5432"
    )
    return conn

def start_replication(conn):
    cur = conn.cursor()
    cur.execute("SELECT pg_create_logical_replication_slot('my_slot', 'test_decoding');")
    conn.commit()
    cur.close()

def read_replication(conn):
    cur = conn.cursor()
    try:
        while True:
            cur.execute("SELECT * FROM pg_logical_slot_get_changes('my_slot', NULL, NULL);")
            for changes in cur:
                print(json.dumps(changes[1], indent=4))
            time.sleep(1)  # Adjust the interval as needed
    except KeyboardInterrupt:
        # Exit the loop gracefully if Ctrl+C is pressed
        pass
    finally:
        cur.close()

if __name__ == "__main__":
    try:
        connection = connect_to_postgres()
        start_replication(connection)
        read_replication(connection)
    except psycopg2.Error as e:
        print("Error:", e)
    finally:
        if connection:
            connection.close()