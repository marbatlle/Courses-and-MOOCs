-- SQLite
SELECT COUNT(*) AS 'Num_A_to_G'
FROM variant
WHERE assembly = 'GRCh37' AND
    type = 'single nucleotide variant' AND
    ref_allele = 'A' AND
    alt_allele = 'G';

SELECT COUNT(*) AS 'Num_T_to_G'
FROM variant
WHERE assembly = 'GRCh37' AND
    type = 'single nucleotide variant' AND
    ref_allele = 'T' AND
    alt_allele = 'G';


