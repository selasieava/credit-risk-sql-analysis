use credit_score

-- 1. Preview the Data
select * from cstraining

-- 2. checking inbalance in dataset
select SeriousDlqin2yrs ,count(*) count from cstraining
group by SeriousDlqin2yrs


select SeriousDlqin2yrs ,count(*) count,
ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
from cstraining
group by SeriousDlqin2yrs
 

  3.
 select
	sum(case when MonthlyIncome is null then 1 else 0 end) as missing_MonthlyIncome,
	sum(case when age is null then 1 else 0 end) as missing_age,
	sum(case when NumberOfDependents is null then 1 else 0 end) as missing_dependents
from cstraining


4.
select 
	min(MonthlyIncome) 'min monthly income',max(MonthlyIncome) 'max monthly income',avg(MonthlyIncome) 'avg monthly income',
	min(age) 'min age',max(age) 'max age',avg(age) 'avg age',
	min(DebtRatio) 'min Debt Ratio',max(DebtRatio) 'max Debt Ratio',avg(DebtRatio) 'avg Debt Ratio'
from cstraining


5.
select
	age,count(*) count
from cstraining
where age < 18 or age > 100
group by age 
order by age

6.
select 
	case 
		when age < 30 then 'under 30'
		when age  between 30 and 45 then '30 - 45'
		when age  between 46 and 60 then '46 - 60'
		else 'over 60'  
		end as Age_Group,
	count(*) total_customers,
	sum(cast(SeriousDlqin2yrs as int)) Defaulted,
	round(100.0 * sum(cast(SeriousDlqin2yrs as int))/ count(*),2) defaulted_rate
from cstraining
group by 
	case 
		when age < 30 then 'under 30'
		when age  between 30 and 45 then '30 - 45'
		when age  between 46 and 60 then '46 - 60'
		else 'over 60'  
	end  
order by defaulted_rate



 7. 
select 
	case 
		 when DebtRatio < 0.3 then 'Low (> 0.3)'
		 when DebtRatio between 0.3 and 0.6 then 'Medium (0.3 - 0.6)'
		 when DebtRatio > 0.6 and DebtRatio <= 1 then 'High (0.6 - 1.0)'
		 else '( < 1) Very High'
		 end as Debt_bucket,
	count(*) total_customers,
	sum(cast(SeriousDlqin2yrs as int)) Defaulted,
	round(100.0 * sum(cast(SeriousDlqin2yrs as int))/ count(*),2) defaulted_rate
from cstraining
group by 
	case 
		 when DebtRatio < 0.3 then 'Low (> 0.3)'
		 when DebtRatio between 0.3 and 0.6 then 'Medium (0.3 - 0.6)'
		 when DebtRatio > 0.6 and DebtRatio <= 1 then 'High (0.6 - 1.0)'
		 else '( < 1) Very High'
		 end
order by defaulted_rate


  8.
select NumberOfOpenCreditLinesAndLoans ,count(*) count from cstraining
where SeriousDlqin2yrs = 1 and NumberOfOpenCreditLinesAndLoans > 3
group by NumberOfOpenCreditLinesAndLoans
order by count


  9.
select
	SeriousDlqin2yrs,
	round(avg(MonthlyIncome),2) Avg_Monthly_Income,
	count(*) count
from cstraining
where MonthlyIncome is not null
group by SeriousDlqin2yrs



  10.
select 
	case 
		when RevolvingUtilizationOfUnsecuredLines < 0.3 then 'Low > 0.3'
		when RevolvingUtilizationOfUnsecuredLines between 0.3 and 0.6 then 'Medium (0.3 - 0.6)'
		when RevolvingUtilizationOfUnsecuredLines between 0.6 and 1.0 then 'High (0.6 - 1.0)'
		else 'Very High > 1.0'
	end as UTILIZATION_BUCKET,
	count(*) Total,
	sum(cast(SeriousDlqin2yrs as int)) as Defaulted,
	round(100.0 * sum(cast(SeriousDlqin2yrs as int))/ count(*),2) as Defaulted_rate
from cstraining
group by
		case 
			when RevolvingUtilizationOfUnsecuredLines < 0.3 then 'Low > 0.3'
			when RevolvingUtilizationOfUnsecuredLines between 0.3 and 0.6 then 'Medium (0.3 - 0.6)'
			when RevolvingUtilizationOfUnsecuredLines between 0.6 and 1.0 then 'High (0.6 - 1.0)'
			else 'Very High > 1.0'
		end
order by Defaulted_rate desc


  
--11.
select 
	case
		when MonthlyIncome is null then 'Missing Income'
		when MonthlyIncome < 3000 then 'Low (> 3K)'
		when MonthlyIncome between 3000 and 6000 then 'Medium (3k - 6k)'
		when MonthlyIncome between 6001 and 10000 then 'High (6k - 10k)'
		else 'Very High (> 10k)'
	end as Monthly_Income_Bucket,
	count(*) Total,
	sum(cast(SeriousDlqin2yrs as int)) as Defaulted,
	round(100.0 * sum(cast(SeriousDlqin2yrs as int))/ count(*),2) as Defaulted_rate
from cstraining
group by 
	case
		when MonthlyIncome is null then 'Missing Income'
		when MonthlyIncome < 3000 then 'Low (> 3K)'
		when MonthlyIncome between 3000 and 6000 then 'Medium (3k - 6k)'
		when MonthlyIncome between 6001 and 10000 then 'High (6k - 10k)'
		else 'Very High (> 10k)'
	end
Order by Defaulted_rate


  
--12.
select 
	case 
		when DebtRatio < 0.3 then 'Low > 0.3'
		when DebtRatio between 0.3 and 0.6 then 'Medium (0.3 - 0.6)'
		when DebtRatio between 0.6 and 1.0 then 'High (0.6 - 1.0)'
		else 'Very High > 1.0'
	end as Debt_Ratio_BUCKET,
	count(*) Total,
	sum(cast(SeriousDlqin2yrs as int)) as Defaulted,
	round(100.0 * sum(cast(SeriousDlqin2yrs as int))/ count(*),2) as Defaulted_rate
from cstraining
group by
		case 
		when DebtRatio < 0.3 then 'Low > 0.3'
		when DebtRatio between 0.3 and 0.6 then 'Medium (0.3 - 0.6)'
		when DebtRatio between 0.6 and 1.0 then 'High (0.6 - 1.0)'
		else 'Very High > 1.0'
	end
order by Defaulted_rate desc

--13.
SELECT
    NumberOfTime30_59DaysPastDueNotWorse,
    NumberOfTime60_89DaysPastDueNotWorse,
    NumberOfTimes90DaysLate,
    COUNT(*) AS total,
    SUM(CAST(SeriousDlqin2yrs AS INT)) AS defaulted,
    ROUND(100.0 * SUM(CAST(SeriousDlqin2yrs AS INT)) / COUNT(*), 2) AS default_rate
FROM cstraining
GROUP BY
    NumberOfTime30_59DaysPastDueNotWorse,
    NumberOfTime60_89DaysPastDueNotWorse,
    NumberOfTimes90DaysLate
ORDER BY default_rate DESC;


-- 14. Income bucket vs Utilization bucket
SELECT
    CASE
        WHEN MonthlyIncome IS NULL THEN 'Missing'
        WHEN MonthlyIncome < 3000 THEN 'Low (<3k)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium (3k-6k)'
        ELSE 'High (>6k)'
    END AS income_bucket,
    CASE
        WHEN RevolvingUtilizationOfUnsecuredLines < 0.3 THEN 'Low'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.3 AND 0.6 THEN 'Medium'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.6 AND 1.0 THEN 'High'
        ELSE 'Very High'
    END AS utilization_bucket,
    COUNT(*) AS total,
    SUM(CAST(SeriousDlqin2yrs AS INT)) AS defaulted,
    ROUND(100.0 * SUM(CAST(SeriousDlqin2yrs AS INT)) / COUNT(*), 2) AS default_rate
FROM cstraining
GROUP BY
    CASE
        WHEN MonthlyIncome IS NULL THEN 'Missing'
        WHEN MonthlyIncome < 3000 THEN 'Low (<3k)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium (3k-6k)'
        ELSE 'High (>6k)'
    END,
    CASE
        WHEN RevolvingUtilizationOfUnsecuredLines < 0.3 THEN 'Low'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.3 AND 0.6 THEN 'Medium'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.6 AND 1.0 THEN 'High'
        ELSE 'Very High'
    END
ORDER BY default_rate DESC;

--15. risk score and level
SELECT
    risk_tier,
    COUNT(*) AS total,
    SUM(CAST(SeriousDlqin2yrs AS INT)) AS defaulted,
    ROUND(100.0 * SUM(CAST(SeriousDlqin2yrs AS INT)) / COUNT(*), 2) AS default_rate
FROM (
    SELECT *,
        CASE 
            WHEN risk_score >= 3 THEN 'High Risk'
            WHEN risk_score = 2 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_tier
    FROM (
        SELECT *,
            (CASE WHEN RevolvingUtilizationOfUnsecuredLines > 0.6 THEN 1 ELSE 0 END) +
            (CASE WHEN DebtRatio > 0.6 THEN 1 ELSE 0 END) +
            (CASE WHEN NumberOfTimes90DaysLate > 0 THEN 1 ELSE 0 END) +
            (CASE WHEN MonthlyIncome < 3000 OR MonthlyIncome IS NULL THEN 1 ELSE 0 END) +
            (CASE WHEN age < 30 THEN 1 ELSE 0 END)
            AS risk_score
        FROM cstraining
    ) AS scored
) AS tiered
GROUP BY risk_tier
ORDER BY default_rate DESC;




-- views
-- View 1: Utilization Analysis
CREATE or alter VIEW vw_utilization_analysis AS
SELECT
    CASE
        WHEN RevolvingUtilizationOfUnsecuredLines > 1.0 THEN 'Very High (>1.0)'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.6 AND 1.0 THEN 'High (0.6-1.0)'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.3 AND 0.6 THEN 'Medium (0.3-0.6)'
        ELSE 'Low (<0.3)'
    END AS utilization_bucket,
    COUNT(*) AS total,
    SUM(CAST(SeriousDlqin2yrs AS INT)) AS defaulted,
    ROUND(100.0 * SUM(CAST(SeriousDlqin2yrs AS INT)) / COUNT(*), 2) AS default_rate
FROM cstraining
GROUP BY
    CASE
        WHEN RevolvingUtilizationOfUnsecuredLines > 1.0 THEN 'Very High (>1.0)'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.6 AND 1.0 THEN 'High (0.6-1.0)'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.3 AND 0.6 THEN 'Medium (0.3-0.6)'
        ELSE 'Low (<0.3)'
    END;
GO

-- View 2: Income Analysis
CREATE or alter VIEW vw_income_analysis AS
SELECT
    CASE
        WHEN MonthlyIncome IS NULL THEN 'Missing'
        WHEN MonthlyIncome < 3000 THEN 'Low (<3k)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium (3k-6k)'
        WHEN MonthlyIncome BETWEEN 6001 AND 10000 THEN 'High (6k-10k)'
        ELSE 'Very High (>10k)'
    END AS income_bucket,
    COUNT(*) AS total,
    SUM(CAST(SeriousDlqin2yrs AS INT)) AS defaulted,
    ROUND(100.0 * SUM(CAST(SeriousDlqin2yrs AS INT)) / COUNT(*), 2) AS default_rate
FROM cstraining
GROUP BY
    CASE
        WHEN MonthlyIncome IS NULL THEN 'Missing'
        WHEN MonthlyIncome < 3000 THEN 'Low (<3k)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium (3k-6k)'
        WHEN MonthlyIncome BETWEEN 6001 AND 10000 THEN 'High (6k-10k)'
        ELSE 'Very High (>10k)'
    END;
GO

-- View 3: Debt Ratio Analysis
CREATE or alter VIEW vw_debtratio_analysis AS
SELECT
    CASE
        WHEN DebtRatio > 1.0 THEN 'Very High (>1.0)'
        WHEN DebtRatio BETWEEN 0.6 AND 1.0 THEN 'High (0.6-1.0)'
        WHEN DebtRatio BETWEEN 0.3 AND 0.6 THEN 'Medium (0.3-0.6)'
        ELSE 'Low (<0.3)'
    END AS debt_bucket,
    COUNT(*) AS total,
    SUM(CAST(SeriousDlqin2yrs AS INT)) AS defaulted,
    ROUND(100.0 * SUM(CAST(SeriousDlqin2yrs AS INT)) / COUNT(*), 2) AS default_rate
FROM cstraining
GROUP BY
    CASE
        WHEN DebtRatio > 1.0 THEN 'Very High (>1.0)'
        WHEN DebtRatio BETWEEN 0.6 AND 1.0 THEN 'High (0.6-1.0)'
        WHEN DebtRatio BETWEEN 0.3 AND 0.6 THEN 'Medium (0.3-0.6)'
        ELSE 'Low (<0.3)'
    END;
GO

-- View 4: Risk Tier Summary
CREATE or alter VIEW vw_risk_tier_summary AS
SELECT
    risk_tier,
    COUNT(*) AS total,
    SUM(CAST(SeriousDlqin2yrs AS INT)) AS defaulted,
    ROUND(100.0 * SUM(CAST(SeriousDlqin2yrs AS INT)) / COUNT(*), 2) AS default_rate
FROM (
    SELECT *,
        CASE
            WHEN risk_score >= 3 THEN 'High Risk'
            WHEN risk_score = 2 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_tier
    FROM (
        SELECT *,
            (CASE WHEN RevolvingUtilizationOfUnsecuredLines > 0.6 THEN 1 ELSE 0 END) +
            (CASE WHEN DebtRatio > 0.6 THEN 1 ELSE 0 END) +
            (CASE WHEN NumberOfTimes90DaysLate > 0 THEN 1 ELSE 0 END) +
            (CASE WHEN MonthlyIncome < 3000 OR MonthlyIncome IS NULL THEN 1 ELSE 0 END) +
            (CASE WHEN age < 30 THEN 1 ELSE 0 END)
            AS risk_score
        FROM cstraining
    ) AS scored
) AS tiered
GROUP BY risk_tier;
GO

-- View 5: Income x Utilization Cross Analysis
CREATE or alter VIEW vw_income_utilization_cross AS
SELECT
    CASE
        WHEN MonthlyIncome IS NULL THEN 'Missing'
        WHEN MonthlyIncome < 3000 THEN 'Low (<3k)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium (3k-6k)'
        ELSE 'High (>6k)'
    END AS income_bucket,
    CASE
        WHEN RevolvingUtilizationOfUnsecuredLines > 1.0 THEN 'Very High'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.6 AND 1.0 THEN 'High'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.3 AND 0.6 THEN 'Medium'
        ELSE 'Low'
    END AS utilization_bucket,
    COUNT(*) AS total,
    SUM(CAST(SeriousDlqin2yrs AS INT)) AS defaulted,
    ROUND(100.0 * SUM(CAST(SeriousDlqin2yrs AS INT)) / COUNT(*), 2) AS default_rate
FROM cstraining
GROUP BY
    CASE
        WHEN MonthlyIncome IS NULL THEN 'Missing'
        WHEN MonthlyIncome < 3000 THEN 'Low (<3k)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium (3k-6k)'
        ELSE 'High (>6k)'
    END,
    CASE
        WHEN RevolvingUtilizationOfUnsecuredLines > 1.0 THEN 'Very High'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.6 AND 1.0 THEN 'High'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.3 AND 0.6 THEN 'Medium'
        ELSE 'Low'
    END;
GO
