sqoop import --connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username root --password cloudera \
--table orders -m '4' --as-avrodatafile --warehouse-dir . \
--split-by order_id --fields-terminated-by '|' \
--lines-terminated-by '\n'

sqoop import --connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username root --password cloudera --as-sequencefile \
--target-dir /user/cloudera/department_seq \
-e 'select department_id, department_name from departments where $CONDITIONS' \
--boundary-query 'SELECT MIN(department_id), MAX(department_id) FROM departments AS t1' \
--where "department_id > 4" -z --fields-terminated-by "|" \
--lines-terminated-by '\n' --split-by 'department_id'

sqoop export --connect jdbc:mysql://quickstart.cloudera:3306/pravin \
--username root --password cloudera \
--export-dir /user/cloudera/department_seq \
-m '4' --table departments --input-fields-terminated-by "|" \
--input-lines-terminated-by '\n'


sqoop import --connect jdbc:mysql://quickstart.cloudera:3306/retail_db \
--username root --password cloudera --as-sequencefile \
--target-dir /user/cloudera/department_seq \
-table departments \
-z 

sqoop export --connect jdbc:mysql://quickstart.cloudera:3306/pravin \
--username root --password cloudera \
--export-dir /user/cloudera/department_seq \
--table departments 