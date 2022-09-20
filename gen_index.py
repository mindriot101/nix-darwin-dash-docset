#!/usr/bin/env python3

import sqlite3
import argparse

from bs4 import BeautifulSoup


parser = argparse.ArgumentParser()
parser.add_argument("index")
parser.add_argument("-o", "--output", required=True)
args = parser.parse_args()

with open(args.index) as infile:
    contents = infile.read()

soup = BeautifulSoup(contents, "html.parser")

with sqlite3.connect(args.output) as conn:
    cursor = conn.cursor()

    # create table
    cursor.execute(
        """
        CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);
    """
    )
    cursor.execute(
        """
        CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);
    """
    )

    list = soup.select_one("dl.variablelist")
    titles = [every.text for every in list.select("dt > span > a.term > code.option")]
    paths = [every.attrs["href"] for every in list.select("dt > span.term > a.term")]
    for title, path in zip(titles, paths):
        cursor.execute(
            """
            INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?,?,?);
        """,
            (title, "Function", path),
        )

    conn.commit()
