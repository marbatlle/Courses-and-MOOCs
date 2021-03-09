#!/usr/bin/env python3.8
# -*- coding: utf-8 -*-

import sys, os

import sqlite3

# For compressed input files
import gzip

import re

CLINVAR_TABLE_DEFS = [
"""
CREATE TABLE IF NOT EXISTS gene_specific (
    gene_symbol VARCHAR(64) NOT NULL,
    gene_id INTEGER NOT NULL,
    total_submissions INTEGER NOT NULL,
    total_alleles INTEGER NOT NULL,
    submissions_gene INTEGER,
    allele_path INTEGER,
    gene_MIM INTEGER,
    number_uncertain INTEGER,
    number_conflicts INTEGER
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
    with gzip.open(clinvar_file,"rt",encoding="utf-8") as cf:
        headerMapping = None
        known_genes = set()
		
        cur = db.cursor()
			
        with db:
            for line in cf:
                wline = line.rstrip("\n")
				
                if (headerMapping is None) and (wline[0] == '#'):
                    wline = wline.lstrip("#")
                    columnNames = re.split(r"\t",wline)
					
                    headerMapping = {}

                    for columnId, columnName in enumerate(columnNames):
                        headerMapping[columnName] = columnId
					
                else:	
                    columnValues = re.split(r"\t",wline)
					
                    for iCol, vCol in enumerate(columnValues):
                        if len(vCol) == 0 or vCol == "-":
                            columnValues[iCol] = None

                    gene_symbol = columnValues[headerMapping["Symbol"]]
                    gene_id = int(columnValues[headerMapping["GeneID"]])
                    total_submissions = int(columnValues[headerMapping["Total_submissions"]])
                    total_alleles = int(columnValues[headerMapping["Total_alleles"]])
                    submissions_gene = columnValues[headerMapping["Submissions_reporting_this_gene"]]
                    allele_path = columnValues[headerMapping["Alleles_reported_Pathogenic_Likely_pathogenic"]]
                    gene_MIM = columnValues[headerMapping["Gene_MIM_number"]]
                    number_uncertain = columnValues[headerMapping["Number_uncertain"]]
                    number_conflicts  = columnValues[headerMapping["Number_with_conflicts"]]
				
                    cur.execute("""
						INSERT INTO gene_specific(
							gene_symbol,
							gene_id,
							total_submissions,
							total_alleles,
							submissions_gene,
							allele_path,
							gene_MIM,
							number_uncertain,
							number_conflicts)
						VALUES(?,?,?,?,?,?,?,?,?)
					""", (gene_symbol,gene_id,total_submissions,total_alleles,submissions_gene,allele_path,gene_MIM,number_uncertain,number_conflicts))

        cur.close()


if __name__ == '__main__':
	if len(sys.argv) < 3:
		print("Usage: {0} {{database_file}} {{compressed_clinvar_file}}".format(sys.argv[0]), file=sys.stderr)
		sys.exit(1)

	db_file = sys.argv[1]
	clinvar_file = sys.argv[2]

	db = open_clinvar_db(db_file)

	store_clinvar_file(db,clinvar_file)

	db.close()