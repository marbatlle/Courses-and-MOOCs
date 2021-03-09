-- SQLite

SELECT variant.variation_id, var_citations.citation_id, variant.gene_symbol
FROM variant
JOIN var_citations
ON variant.variation_id = var_citations.variation_id
WHERE variant.assembly = 'GRCh38'
AND var_citations.citation_source LIKE 'PubMed'
AND variant.phenotype_list LIKE '%Glioblastoma%'
LIMIT 15;

SELECT COUNT(*)
FROM variant 
JOIN var_citations
ON variant.variation_id = var_citations.variation_id
WHERE variant.assembly = 'GRCh38'
AND var_citations.citation_source LIKE 'PubMed'
AND variant.phenotype_list LIKE '%Glioblastoma%';

