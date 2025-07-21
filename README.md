# 📦 YouTube Comments Spam Detection System

This project detects spam in YouTube comments using big data tools and a cloud-based architecture built on AWS.  
It includes dataset preparation, cleaning, and analysis using Apache Hive on an EMR cluster.

> **Author:** Vaishnavi Manjunatha  
> **Student ID:** 23260426  
> **Email:** vaishnavi.manjunatha2@mail.dcu.ie

---

## 🌥️ Cloud Infrastructure (AWS)

- **Amazon EMR Cluster** with:
  - Spark 3.4.1
  - Hadoop 3.3.3
  - JupyterEnterpriseGateway 2.6.0
  - Pig 0.17.0
  - Hive 3.1.3
- Cluster nodes: 1 primary, 1 core, 2 task nodes (`m4.large`)
- **AWS Cloud9** environment for SSH access and development
- Dataset stored securely in an **Amazon S3 bucket**

---

## 📊 Dataset

- **Source:** [YouTube Spam Collection Dataset on Kaggle](https://www.kaggle.com/datasets/lakshmi25npathi/images)
- **Content:**
  - `Comment_id`: Unique ID of the comment
  - `Author`: Username of commenter
  - `Date`: Date of comment
  - `Content`: Text of the comment
  - `Class`: Label (`ham` or `spam`)
- Combined from multiple CSV files and uploaded to S3

---

## 🧹 Data Cleaning & Processing (Hive)

Performed in Hive with the dataset loaded from S3:

- Removed:
  - Null values (`author`, `content`, `spam` label)
  - URLs
  - HTML tags
  - Special characters
- Saved cleaned data to a text file
- Divided final dataset into:
  - Ham data
  - Spam data

---

## 🕵️‍♀️ Spam & Ham Analysis

Used Hive queries to:
- Identify top 10 spam accounts
- Identify top 10 ham accounts
- Bag of words used for spam detection:
  - subscribe, youtube, free, amazing, win, my channel, click here, check, limited time offer, promo, url, warning

---
