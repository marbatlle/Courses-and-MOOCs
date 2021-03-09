#!/usr/bin/env python3.8
# -*- coding: utf-8 -*-

import sys, os

import sqlite3

# For compressed input files
import gzip

import re

CLINVAR_TABLE_DEFS = [
"""
CREATE TABLE IF NOT EXISTS var_citations (
	entry_id INTEGER PRIMARY KEY AUTOINCREMENT,
	allele_id INTEGER NOT NULL,
	variation_id INTEGER NOT NULL,
	citation_source VARCHAR(64) NOT NULL,
	citation_id VARCHAR(64) NOT NULL
)
"""
]

def open_clinvar_db(db_file):
	
	db = sqlite3.connect(db_file)
	
	cur = db.cursor()
	try:
		cur.execute("PRAGMA FOREIGN_KEYS=ON")
		
		for tableDecl in CLINVAR_TABLE_DEFS:
			cur.execute(tableDecl)
	except sqlite3.Error as e:
		print("An error occurred: {}".format(e.args[0]), file=sys.stderr)
	finally:
		cur.close()
	
	return db
	
def store_clinvar_file(db,clinvar_file):
	with open(clinvar_file,"rt",encoding="utf-8") as cf:
		headerMapping = None
		known_genes = set()
		
		cur = db.cursor()
		
		with db:
			for line in cf:
				# First, let's remove the newline
				wline = line.rstrip("\n")
				
				# Now, detecting the header
				if (headerMapping is None) and (wline[0] == '#'):
					wline = wline.lstrip("#")
					columnNames = re.split(r"\t",wline)
					
					headerMapping = {}
					# And we are saving the correspondence of column name and id
					for columnId, columnName in enumerate(columnNames):
						headerMapping[columnName] = columnId
					
				else:	
					columnValues = re.split(r"\t",wline)
					
					for iCol, vCol in enumerate(columnValues):
						if len(vCol) == 0 or vCol == "-":
							columnValues[iCol] = None
					
					allele_id = int(columnValues[headerMapping["AlleleID"]])
					variation_id = int(columnValues[headerMapping["VariationID"]])
					citation_source = columnValues[headerMapping["citation_source"]]
					citation_id = columnValues[headerMapping["citation_id"]]
					
					cur.execute("""
						INSERT INTO var_citations(
							allele_id,
							variation_id,
							citation_source,
							citation_id)
						VALUES(?,?,?,?)
					""", (allele_id,variation_id,citation_source, citation_id))
					
					# The autoincremented value is got here
					ventry_id = cur.lastrowid
	
		
		cur.close()

if __name__ == '__main__':
	if len(sys.argv) < 3:
		print("Usage: {0} {{database_file}} {{compressed_clinvar_file}}".format(sys.argv[0]), file=sys.stderr)
		sys.exit(1)

	# Only the first and second parameters are considered
	db_file = sys.argv[1]
	clinvar_file = sys.argv[2]

	# First, let's create or open the database
	db = open_clinvar_db(db_file)

	# Second
	store_clinvar_file(db,clinvar_file)

	db.close()