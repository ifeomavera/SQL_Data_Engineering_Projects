/*
Question: What are the highest-paying skills for data engineers?
- Calculate the median salary for each skill required in data engineer positions
- Focus on remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing 
    how common those skills are, providing a more complete picture for skill development priorities
*/

SELECT 
    sd.skills,
    COUNT(sd.skills) AS count_skills,
    ROUND(MEDIAN(jpf.salary_year_avg),0 )AS median_salary

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
GROUP BY 
    jpf.job_title_short,
    jpf.job_work_from_home,
    sd.skills
HAVING
    count_skills >= 100
ORDER BY 
    median_salary
DESC
LIMIT 
    25;

/*
┌────────────┬──────────────┬───────────────┐
│   skills   │ count_skills │ median_salary │
│  varchar   │    int64     │    double     │
├────────────┼──────────────┼───────────────┤
│ rust       │          232 │      210000.0 │
│ golang     │          912 │      184000.0 │
│ terraform  │         3248 │      184000.0 │
│ spring     │          364 │      175500.0 │
│ neo4j      │          277 │      170000.0 │
│ gdpr       │          582 │      169616.0 │
│ zoom       │          127 │      168438.0 │
│ graphql    │          445 │      167500.0 │
│ mongo      │          265 │      162250.0 │
│ fastapi    │          204 │      157500.0 │
│ django     │          265 │      155000.0 │
│ bitbucket  │          478 │      155000.0 │
│ crystal    │          129 │      154224.0 │
│ c          │          444 │      151500.0 │
│ atlassian  │          249 │      151500.0 │
│ typescript │          388 │      151000.0 │
│ kubernetes │         4202 │      150500.0 │
│ airflow    │         9996 │      150000.0 │
│ css        │          262 │      150000.0 │
│ node       │          179 │      150000.0 │
│ ruby       │          736 │      150000.0 │
│ redis      │          605 │      149000.0 │
│ ansible    │          475 │      148798.0 │
│ vmware     │          136 │      148798.0 │
│ jupyter    │          400 │      147500.0 │
└────────────┴──────────────┴───────────────┘
  25 rows                         3 columns



This dataset shifts focus toward Backend Engineering, Systems Programming, and High-Scale Infrastructure. By comparing the sheer volume of job listings (count_skills) against the median_salary, 
we can break down where the real leverage is in today’s market.

1. The High-Leverage Anomalies
    Two skills stand out for defying normal market dynamics by commanding massive premium compensation:

        Rust is a tier of its own: With a relatively low volume (232 openings), it commands a staggering median salary of $210,000. This reflects a highly specialized, highly defensive talent pool (often utilized in systems engineering, blockchain core development, and high-performance tooling).

        The Sweet Spot (Go & Terraform): Both command an identical $184,000 median salary, but their market realities are completely different. Go (Golang) sits at a modest 912 openings, making it a highly compensated backend language niche. Terraform, on the other hand, boasts a massive 3,248 openings—showing that cloud infrastructure automation is both a critical baseline requirement and a top-paying asset.

2. High-Volume Baseline Utilities
    On the right side of the volume axis, we see the true heavyweights of modern infrastructure pipelines. These skills form dense market clusters:

        Airflow (9,996 openings): Represents massive enterprise adoption for data orchestration. Despite being the most ubiquitous skill on the list, it holds its value remarkably well at a flat $150,000.

        Kubernetes (4,202 openings): The container standard matches Airflow's price point almost exactly at $150,500.

3. Backend Framework & Database Shakedown
    When choosing a modern web stack or database layer, the financial delta between frameworks is distinct:

        Java/Enterprise vs. Python/Modern: Spring (Java) sits comfortably near the top at $175,500, out-earning newer Python alternatives like FastAPI ($157,500) and traditional ones like Django ($155,000).

        Graph vs. Document Databases: Neo4j (Graph database) brings in a high-paying premium of $170,000 over standard NoSQL options like Mongo ($162,250) and caching layers like Redis ($149,000).
*/