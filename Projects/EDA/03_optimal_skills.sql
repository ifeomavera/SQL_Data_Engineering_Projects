/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/
SELECT 
    sd.skills,
    COUNT(jpf.*) AS demand_count,
    ROUND(MEDIAN(jpf.salary_year_avg),0 )AS median_salary,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    ROUND(MEDIAN(jpf.salary_year_avg) *  LN(COUNT(jpf.*)) /1_000_000, 2) AS multiplier
FROM    
    job_postings_fact AS jpf
INNER JOIN 
    skills_job_dim AS sjd
ON  
    jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd 
ON 
    sjd.skill_id = sd.skill_id
WHERE   
    jpf.job_title_short = 'Data Engineer'
AND
    jpf.job_work_from_home = 'true'
AND 
    jpf.salary_year_avg IS NOT NULL

GROUP BY 
    jpf.job_title_short,
    jpf.job_work_from_home,
    sd.skills
HAVING
    demand_count >= 100
ORDER BY 
    multiplier
DESC
LIMIT 
    25;


/*
┌────────────┬──────────────┬───────────────┬─────────────────┬────────────┐
│   skills   │ demand_count │ median_salary │ ln_demand_count │ multiplier │
│  varchar   │    int64     │    double     │     double      │   double   │
├────────────┼──────────────┼───────────────┼─────────────────┼────────────┤
│ terraform  │          193 │      184000.0 │             5.3 │       0.97 │
│ python     │         1133 │      135000.0 │             7.0 │       0.95 │
│ sql        │         1128 │      130000.0 │             7.0 │       0.91 │
│ aws        │          783 │      137320.0 │             6.7 │       0.91 │
│ airflow    │          386 │      150000.0 │             6.0 │       0.89 │
│ spark      │          503 │      140000.0 │             6.2 │       0.87 │
│ snowflake  │          438 │      135500.0 │             6.1 │       0.82 │
│ kafka      │          292 │      145000.0 │             5.7 │       0.82 │
│ azure      │          475 │      128000.0 │             6.2 │       0.79 │
│ java       │          303 │      135000.0 │             5.7 │       0.77 │
│ scala      │          247 │      137290.0 │             5.5 │       0.76 │
│ git        │          208 │      140000.0 │             5.3 │       0.75 │
│ kubernetes │          147 │      150500.0 │             5.0 │       0.75 │
│ databricks │          266 │      132750.0 │             5.6 │       0.74 │
│ redshift   │          274 │      130000.0 │             5.6 │       0.73 │
│ gcp        │          196 │      136000.0 │             5.3 │       0.72 │
│ nosql      │          193 │      134415.0 │             5.3 │       0.71 │
│ hadoop     │          198 │      135000.0 │             5.3 │       0.71 │
│ pyspark    │          152 │      140000.0 │             5.0 │        0.7 │
│ docker     │          144 │      135000.0 │             5.0 │       0.67 │
│ mongodb    │          136 │      135750.0 │             4.9 │       0.67 │
│ go         │          113 │      140000.0 │             4.7 │       0.66 │
│ r          │          133 │      134775.0 │             4.9 │       0.66 │
│ bigquery   │          123 │      135000.0 │             4.8 │       0.65 │
│ github     │          127 │      135000.0 │             4.8 │       0.65 │
└────────────┴──────────────┴───────────────┴─────────────────┴────────────┘
  25 rows                                                        5 columns


This dataset maps out a clear picture of the Data Engineering and DevOps landscape. Looking closely at the relationships between market demand, median salaries, and the scoring multiplier, three major strategic takeaways stand out.

1. The Premium Infrastructure Tier (High Pay, Specialized Demand)
    While languages like Python and SQL form the foundation of data jobs, they don't command the absolute highest salaries because their talent pool is massive. The top financial premiums belong to infrastructure, orchestration, and real-time streaming:

        Terraform leads the entire list with a massive median salary of $184,000, despite having a relatively low demand count (193).

        Kubernetes ($150,500), Airflow ($150,000), and Kafka ($145,000) round out this high-pay bracket.

    Takeaway: Companies are willing to pay an extreme premium for engineers who can securely manage infrastructure-as-code, deploy containerized environments, and orchestrate complex pipelines.

2. The Cloud Provider Hierarchy
    The demand distribution across the "Big Three" cloud platforms highlights a stark contrast in market share versus premium positioning:

        AWS: The undisputed king of volume with 783 mentions and a solid median salary of $137,320.

        Azure: High volume (475 mentions), but surprisingly holds the lowest median salary on the entire list at $128,000.

        GCP: Lower market volume (196 mentions), but commands a healthier premium at $136,000.

3. Core Foundations vs. Execution Layers
    We can group the remaining stack into clear baseline and processing buckets to see where the value settles:

    The Foundations (Python & SQL): These are mandatory prerequisites. Both have massive, near-identical market demand (1,133 vs. 1,128 job mentions). Python commands a slightly higher premium ($135,000) than SQL ($130,000), likely due to its applications in custom application code and machine learning pipelines.

    Big Data Processing (Spark vs. Legacy): Spark dominates data processing with 503 mentions and a strong $140,000 median salary (mirrored perfectly by its Python wrapper, PySpark, at $140,000). Meanwhile, Hadoop is showing its age—retaining a decent baseline demand (198) but lagging in compensation ($135,000).

    Modern Cloud Data Warehousing: Snowflake is beating out its direct cloud-native competitors in both volume and payout:

        Snowflake: 438 demand count | $135,500 median salary

        Redshift (AWS): 274 demand count | $130,000 median salary

        BigQuery (GCP): 123 demand count | $135,000 median salary
*/