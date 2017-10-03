from sqlalchemy import create_engine
import os


# some of the codes are from the tasks sample and re-implemented

class DBconnection:
    def __init__(self):
        engine = create_engine("postgres://postgres:postgres@127.0.0.1:5432/COEData", echo=False)
        self.conn = engine.connect()
        self.trans = self.conn.begin()

    def getcursor(self):
        cursor = self.conn.connection.cursor()
        return cursor

    def dbcommit(self):
        self.trans.commit()
