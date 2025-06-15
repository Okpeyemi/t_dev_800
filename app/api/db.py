import secrets
import string
import sqlite3

from domain.action import Action


class ActionRepository:
    def __init__(self):
        self.db_path = "db.sqlite"
        self.connection = sqlite3.connect(self.db_path)

    def create_tables(self):
        query = """
        CREATE TABLE IF NOT EXISTS actions (
            id VARCHAR(24) PRIMARY KEY,
            action VARCHAR(10) NOT NULL,
            diagnosis VARCHAR(10) NOT NULL,
            image_path TEXT NOT NULL,
            probability NUMERIC(5, 2),
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        );
        """
        cur = self.connection.cursor()
        cur.execute(query)
        self.connection.commit()
        cur.close()

    def insert_action(self, action: Action):
        cur = self.connection.cursor()
        query = """
        INSERT INTO actions (id, action, diagnosis, image_path, probability, timestamp)
        VALUES (?, ?, ?, ?, ?, ?);
        """
        cur.execute(
            query,
            (
                action.id,
                action.kind,
                action.diagnosis,
                str(action.image_path),
                action.probability,
                action.timestamp,
            ),
        )
        cur.connection.commit()
        cur.close()

    def get_actions(self):
        cur = self.connection.cursor()
        query = "SELECT id, action, diagnosis, image_path, probability, timestamp FROM actions ORDER BY timestamp DESC;"
        cur.execute(query)
        rows = cur.fetchall()
        actions = [
            Action(
                id=row[0],
                kind=row[1],
                diagnosis=row[2],
                image_path=row[3],
                probability=row[4],
                timestamp=row[5],
            )
            for row in rows
        ]
        cur.close()
        return actions

    def next_id(self):
        return "".join(
            secrets.choice(string.ascii_letters + string.digits) for _ in range(24)
        )


repository = ActionRepository()
