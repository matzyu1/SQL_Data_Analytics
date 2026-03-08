COPY transactions
FROM 'C:\SQL_Data_Analytics\SQL_Data_Analytics\Dataset\transactions_test.csv'
DELIMITER ','
CSV HEADER;

COPY transactions
FROM 'C:\SQL_Data_Analytics\SQL_Data_Analytics\Dataset\transactions_train.csv'
DELIMITER ','
CSV HEADER;