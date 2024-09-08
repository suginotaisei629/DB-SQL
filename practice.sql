-- 問1
-- 国名を全て抽出してください。
USE world;
SELECT name FROM countries;

-- 問2
-- ヨーロッパに属する国をすべて抽出してください。
SELECT name 
FROM countries 
WHERE continent = 'Europe';


-- 問3
-- ヨーロッパ以外に属する国をすべて抽出してください。
SELECT name, continent 
FROM countries 
WHERE continent NOT IN ('Europe');


-- 問4
-- 人口が10万人以上の国をすべて抽出してください。
SELECT name
FROM countries
WHERE population >= 100000;


-- 問5
-- 平均寿命が56歳から76歳の国をすべて抽出してください。
SELECT name
FROM countries
WHERE life_expectancy BETWEEN 56 AND 76;


-- 問6
-- 国コードがNLB,ALB,DZAのもの市区町村をすべて抽出してください。
select name
from   cities
where country_code in ('NLB','ALB','DZA');

-- 問7
-- 独立独立記念日がない国をすべて抽出してください。
select name
from countries
where indep_year IS NULL ;

-- 問8
-- 独立独立記念日がある国をすべて抽出してください。
select name
from countries
where indep_year is not null;

-- 問9
-- 名前の末尾が「ia」で終わる国を抽出してください。
select name
from countries
where name like '%ia';

-- 問10
-- 名前の中に「st」が含まれる国を抽出してください。
select name 
from countries
where name like '%st%';

-- 問11
-- 名前が「an」で始まる国を抽出してください。
select name 
from countries
where name like 'an%';

-- 問12
-- 全国の中から独立記念日が1990年より前または人口が10万人より多い国を全て抽出してください。
select name 
from countries
where indep_year < 1990 or population > 100000;

-- 問13
-- コードがDZAもしくはALBかつ独立記念日が1990年より前の国を全て抽出してください。
select name 
from countries
where indep_year < 1990 and code in ('DZA','ALB');

-- 問14
-- 全ての地方をグループ化せずに表示してください。
select region
from countries;

-- 問15
-- 国名と人口を以下のように表示させてください。シングルクォートに注意してください。
-- 「Arubaの人口は103000人です」
select concat(name,'の人口は',population,'人です')
from countries ;

-- 問16
-- 平均寿命が短い順に国名を表示させてください。ただしNULLは表示させないでください。
select name 
from countries
where life_expectancy is not null
order by life_expectancy asc;

-- 問17
-- 平均寿命が長い順に国名を表示させてください。ただしNULLは表示させないでください。
select name 
from countries
where life_expectancy is not null
order by life_expectancy desc;

-- 問18
-- 平均寿命が長い順、独立記念日が新しい順に国を表示させてください。
select name 
from countries
order by life_expectancy desc,indep_year desc;


-- 問19
-- 全ての国の国コードの一文字目と国名を表示させてください。
select substring(code,1,1),name
from countries;

-- 問20
-- 国名が長いものから順に国名と国名の長さを出力してください。
select name,length(name)as name_la
from countries
order by name_la desc;

-- 問21
-- 全ての地方の平均寿命、平均人口を表示してください。(NULLも表示)
select region, 
       AVG(life_expectancy),
       AVG(population)
from countries
group by region;


-- 問22
-- 全ての地方の最長寿命、最大人口を表示してください。(NULLも表示)
select region,
       max(life_expectancy),
       max(population)
from countries
group by region;

-- 問23
-- アジア大陸の中で最小の表面積を表示してください
select name, surface_area
from countries
where continent = 'asia'
order by surface_area asc limit 1;

-- 問24
-- アジア大陸の表面積の合計を表示してください。
select sum(surface_area)
from countries
where continent = 'asia';


-- 問25
-- 全ての国と言語を表示してください。一つの国に複数言語があると思いますので同じ国名を言語数だけ出力してください。
select c.name
from countries c
join countrylanguages cl on c.code = cl.country_code;

-- 問26
-- 全ての国と言語と市区町村を表示してください。
select c.name, cl.language,ci.name
from countries c
join countrylanguages cl on c.code = cl.country_code
left join cities ci on c.code = ci.country_code
order by c.name, cl.language, ci.name;

-- 問27
-- 全ての有名人を出力してください。左側外部結合を使用して国名なし（country_codeがNULL）も表示してください。
select ce.name
from celebrities ce
left join countries c on ce.country_code = c.code;

-- 問28
-- 全ての有名人の名前,国名、第一言語を出力してください。
select ce.name,c.name,cl.language
from celebrities ce
left join countries c on ce.country_code = c.code
left join countrylanguages cl on c.code = cl.country_code and cl.is_official = 'T';

-- 問29
-- 全ての有名人の名前と国名をに出力してください。 ただしテーブル結合せずサブクエリを使用してください。
select ce.name,(select c.name from countries c where c.code =ce.country_code)
from celebrities ce;

-- 問30
-- 最年長が50歳以上かつ最年少が30歳以下の国を表示させてください。
select c.name AS country_name
from countries c
where c.code in (
    select country_code
    from celebrities
    group by country_code
    having MAX(age) >= 50 and MIN(age) <= 30);


-- 問31
-- 1991年生まれと、1981年生まれの有名人が何人いるか調べてください。ただし、日付関数は使用せず、UNION句を使用してください。
select '1991' as birth_year, COUNT(*) as number_of_celebrities
from celebrities
where year(birth) = 1991
union
select '1981' AS birth_year, COUNT(*) as number_of_celebrities
from celebrities
where year(birth) = 1981;


-- 問32
-- 有名人の出身国の平均年齢を高い方から順に表示してください。ただし、FROM句はcountriesテーブルとしてください。
select c.name as country_name,avg(ce.age) as average_age
from countries c
left join celebrities ce on c.code = ce.country_code
group by c.name
order by average_age desc;
