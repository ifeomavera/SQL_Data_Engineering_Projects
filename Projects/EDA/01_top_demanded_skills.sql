/*
Question: What are the most in-demand skills for data engineers?
- Join job postings to inner join table similar to query 2
- Identify the top 10 in-demand skills for data engineers
- Focus on remote job postings
- Why? Retrieves the top 10 skills with the highest demand in the remote job market,
    providing insights into the most valuable skills for data engineers seeking remote work
*/

SELECT 
    sd.skills,
    COUNT(sd.skills) AS count_skills
FROM    
    job_postings_fact AS jpf
LEFT JOIN 
    skills_job_dim AS sjd
ON  
    jpf.job_id = sjd.job_id
LEFT JOIN
    skills_dim AS sd 
ON 
    sjd.skill_id = sd.skill_id
WHERE   
    jpf.job_title_short = 'Data Engineer'
AND
    sd.skills IS NOT NULL
AND
    jpf.job_work_from_home = 'true'
GROUP BY 
    jpf.job_title_short,
    jpf.job_work_from_home,
    sd.skills
ORDER BY 
    count_skills 
DESC
LIMIT 
    10;


/* 
┌────────────┬──────────────┐
│   skills   │ count_skills │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘
  10 rows         2 columns

This dataset gives us the raw, unadulterated reality of market volume. This is a list of the baseline prerequisites—the foundational skills that open the most doors in the data industry.

1. The Undisputed Core Duo
    SQL (29,221) and Python (28,776) form a clear tier of their own. They are nearly tied at the top, boasting more than 1.6x the volume of the next highest skill.

    The Reality: These aren't differentiating skills; they are baseline infrastructure. You don't get hired just because you know SQL or Python, but you are automatically filtered out without them.

2. The Cloud Infrastructure Split
    When we look at the cloud infrastructure platform adoption by volume:

        AWS (17,823) maintains a commanding 26% lead over Azure (14,143).

        GCP (6,446) trails significantly, showing roughly 36% of AWS's market volume.

    Interesting context: When we map this back to your previous datasets, remember that GCP actually commands a higher median salary ($136k) than Azure ($128k). This confirms a classic market trend: Azure has deep enterprise volume, but GCP talent is rarer and commands a premium.

3. Big Data Processing & Warehousing Heavyweights
    Spark (12,799): Confirms its status as the absolute standard for large-scale data transformation, out-pacing specialized platforms like Databricks.

    Airflow (9,996): Sitting right at the 10k mark, it remains the gold standard for orchestrating all these moving pieces.

    Snowflake (8,639) vs. Databricks (8,183): These two modern data platform giants are locked in a incredibly tight market share battle, separated by fewer than 500 job mentions.
*/