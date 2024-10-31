### TASK 3

USE teamproject_1;

### Initialize an added column (id) to have an unique identifier in the dataset (Source: ChatGPD) --> use google instead
DESCRIBE studentdropout;

ALTER TABLE studentdropout
ADD COLUMN id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

#############################################################################################
#############################################################################################
### General Insights in order to understand the data (Just as an additional Information - NOT the final Queries):
# Check if the adding of the id-column as Student_ID worked and to review the dataset
select id as Student_ID, Age, Gender, Dropped_Out
from studentdropout;

# Average Finale Grades for all Students grouped by School and Gender
select School, Gender, avg(Final_Grade) as Average_Final_Grade
from studentdropout
group by School, Gender;

# Total Number of Students grouped by their School and Gender -> to have an idea how many students we have in general
select School, Gender, count(id) as NumerOFStudents
from studentdropout
group by School, Gender;

# Total Number of Students that dropped out of School grouped by Gender
select Gender, count(*) as Total_Dropouts
from studentdropout
where Dropped_Out = 'True'
group by Gender;

# Check wather the Job of the Parents influences the dropout of the students 
select  Mother_Job, Father_Job, count(id) as Number_of_Students
from studentdropout where Dropped_out= 'False'
group by Mother_Job, Father_Job
order by Number_of_Students desc;

#############################################################################################
#############################################################################################
### QUERIES

# QUERY 1
# observe if students with a higher absenteeism rank are more likely to have dropped out, 
# allowing to explore potential correlations between absenteeism and dropouts.
# Alcohol Consumption level (Weekdays and Weekend), scale from 1-5
# Level of Absences (scale: 1-10 = low, greater than 10 is high)
select id, Gender, School,
rank() Over (partition by School order by Number_of_Absences desc) as Absence_Rank, Dropped_Out,
case 
	when Weekend_Alcohol_Consumption > 3 then "High"
    else "Low"
end as Weekend_Alcohol_Consumption_Text,
case
	when Weekday_Alcohol_Consumption > 3 then "High"
    else "Low"
end as Weekday_Alcohol_Consumption_Text,
case
	when Number_of_Absences > 10 then "High"
    else "Low"
end as Level_of_Absences
from studentdropout
order by School, Absence_Rank;

# QUERY 2
# VIEW --> Average Level of the Parents Educational Level (scale: 0-4) + Final Grade of the Student
# Influence of the Educational Level of the Parents on the Dropp_Outs of the children
Create view V6 as
select (Mother_Education + Father_Education) / 2 as Avg_Education_Parents, id, Age, Gender, School, Dropped_Out,
Final_Grade
from studentdropout;

select id, Gender, Age, School, Dropped_Out, Final_Grade,
case
	when Avg_Education_Parents >= 3 then "High"
    else "Low"
end as Level_Education_Parents
from V6;
