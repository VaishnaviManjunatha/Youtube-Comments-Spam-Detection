Commands and Queries

//create a hive table by providing the location of the S3 bucket
CREATE EXTERNAL TABLE YTcomments_data (
    comment_id STRING,
    author STRING,
    commentDate DATE,
    content STRING,
    spamLabel INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION 's3://vaishnavisbucket'
TBLPROPERTIES('skip.header.line.count' = '1');

// Loading data into the table from the dataset in S3 bucket
LOAD DATA INPATH 's3://vaishnavisbucket/Youtube_Comments.csv' 
INTO TABLE YTcomments_data;

// Removed null values from table
CREATE TABLE YTcomments_Null_removed AS
SELECT
    author,
    LOWER(content) AS content, spamLabel
FROM YTcomments_data where content is not null and author is not null;

// Removed URL values from the table
CREATE TABLE  YTcomments_url_removed AS
SELECT
    author,
    regexp_replace(content, 'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', '') AS content, spamLabel
FROM YTcomments_Null_removed;

// Removed HTML tags from the table
CREATE TABLE YTcomments_htmlTags_removed AS
SELECT
    author,
    regexp_replace(content, '<[^>]+>', '') AS content, spamLabel
FROM
    YTcomments_url_removed;	

// Removed special characters from the table
CREATE TABLE YTcomments_cleaned AS
SELECT
    author,
    REGEXP_REPLACE(content, '[^a-zA-Z0-9\\s]', '') AS content, spamLabel
FROM YTcomments_htmlTags_removed;

// The cleaned file is now saved to a text file
INSERT OVERWRITE LOCAL DIRECTORY 's3://vaishnavisbucket/directory/'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM YTcomments_cleaned;


// Created table for spam classification based on bag of words chosen
CREATE TABLE spam_accounts AS
SELECT
    author,content,
    CASE
        WHEN content LIKE '%subscribe%' OR
            content LIKE '%youtube%' OR
            content LIKE '%free%' OR
            content LIKE '%amazing%' OR
            content LIKE '%win%' OR
            content LIKE '%my channel%' OR
            content LIKE '%click here%' OR
            content LIKE '%check%' OR
            content LIKE '%limited time offer%' OR
            content LIKE '%promo%' OR
            content LIKE '%url%' OR
            content LIKE '%warning%'
        THEN 1
        ELSE 0
    END AS is_spam
FROM YTcomments_cleaned;


// Picked and stored the ham data from the main dataset
CREATE TABLE ham_dataset AS
SELECT *
FROM spam_accounts
WHERE is_spam =0;

// Picked and stored the spam data from the main dataset
CREATE TABLE spam_dataset AS
SELECT *
FROM spam_accounts
WHERE is_spam =1;

// Selected the top 10 ham accounts
SELECT 
    author,COUNT(*) AS frequency
FROM
    ham_dataset
GROUP BY
    author
ORDER BY
    frequency DESC LIMIT 10;

// Selected the top 10 spam accounts
SELECT
    author,
    COUNT(*) AS frequency
FROM
    spam_dataset
GROUP BY
    author
ORDER BY
    frequency DESC LIMIT 10;





