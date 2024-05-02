--2. Create tables for Companies, Jobs, Applicants and Applications.
-- Table: Companies
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY,
    CompanyName VARCHAR(255),
    Location VARCHAR(255)
);

-- Table: Jobs
CREATE TABLE Jobs (
    JobID INT PRIMARY KEY,
    CompanyID INT,
    JobTitle VARCHAR(255),
    JobDescription TEXT,
    JobLocation VARCHAR(255),
    Salary DECIMAL,
    JobType VARCHAR(50),
    PostedDate DATETIME,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- Table: Applicants
CREATE TABLE Applicants (
    ApplicantID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    Resume TEXT
);

-- Table: Applications
CREATE TABLE Applications (
    ApplicationID INT PRIMARY KEY,
    JobID INT,
    ApplicantID INT,
    ApplicationDate DATETIME,
    CoverLetter TEXT,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID)
);

-- Inserting Values 
INSERT INTO Companies (CompanyID, CompanyName, Location) VALUES
(1,'Tech Innovations', 'San Francisco'),
(2,'Data Driven Inc', 'New York'),
(3,'GreenTech Solutions', 'Austin'),
(4,'CodeCrafters', 'Boston'),
(5,'HexaWare Technologies', 'Chennai');


INSERT INTO Jobs (JobID,CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate) VALUES
(1 ,1, 'Frontend Developer', 'Develop user-facing features', 'San Francisco', 75000, 'Full-time', '2023-01-10'),
(2 ,2, 'Data Analyst', 'Interpret data models', 'New York', 68000, 'Full-time', '2023-02-20'),
(3 ,3, 'Environmental Engineer', 'Develop environmental solutions', 'Austin', 85000, 'Full-time', '2023-03-15'),
(4 ,1, 'Backend Developer', 'Handle server-side logic', 'Remote', 77000, 'Full-time', '2023-04-05'),
(5 ,4, 'Software Engineer', 'Develop and test software systems', 'Boston', 90000, 'Full-time', '2023-01-18'),
(6 ,5, 'HR Coordinator', 'Manage hiring processes', 'Chennai', 45000, 'Contract', '2023-04-25'),
(7 ,2, 'Senior Data Analyst', 'Lead data strategies', 'New York', 95000, 'Full-time', '2023-01-22');


INSERT INTO Applicants (ApplicantID, FirstName, LastName, Email, Phone, Resume) VALUES
(1,'John', 'Doe', 'john.doe@example.com', '123-456-7890', 'Experienced web developer with 5 years of experience.'),
(2,'Jane', 'Smith', 'jane.smith@example.com', '234-567-8901', 'Data enthusiast with 3 years of experience in data analysis.'),
(3,'Alice', 'Johnson', 'alice.johnson@example.com', '345-678-9012', 'Environmental engineer with 4 years of field experience.'),
(4,'Bob', 'Brown', 'bob.brown@example.com', '456-789-0123', 'Seasoned software engineer with 8 years of experience.');


INSERT INTO Applications (ApplicationID, JobID, ApplicantID, ApplicationDate, CoverLetter) VALUES
(1,1, 1, '2023-04-01', 'I am excited to apply for the Frontend Developer position.'),
(2,2, 2, '2023-04-02', 'I am interested in the Data Analyst position.'),
(3,3, 3, '2023-04-03', 'I am eager to bring my expertise to your team as an Environmental Engineer.'),
(4,4, 4, '2023-04-04', 'I am applying for the Backend Developer role to leverage my skills.'),
(5,5, 1, '2023-04-05', 'I am also interested in the Software Engineer position at CodeCrafters.');

--5. Write an SQL query to count the number of applications received for each job listing in the 
--"Jobs" table. Display the job title and the corresponding application count. Ensure that it lists all 
--jobs, even if they have no applications.SELECT Jobs.JobID, Jobs.JobTitle, COUNT(Applications.ApplicationID) AS ApplicationCount
FROM Jobs
LEFT JOIN Applications ON Jobs.JobID = Applications.JobID
GROUP BY Jobs.JobID, Jobs.JobTitle;

--6. Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary 
--range. Allow parameters for the minimum and maximum salary values. Display the job title, 
--company name, location, and salary for each matching job.

SELECT Jobs.JobTitle, Companies.CompanyName, Jobs.JobLocation, Jobs.Salary
FROM Jobs
INNER JOIN Companies ON Jobs.CompanyID = Companies.CompanyID
WHERE Jobs.Salary BETWEEN 50000 AND 60000;

--7. Write an SQL query that retrieves the job application history for a specific applicant. Allow a 
--parameter for the ApplicantID, and return a result set with the job titles, company names, and 
--application dates for all the jobs the applicant has applied to

SELECT Jobs.JobTitle, Companies.CompanyName, Applications.JobID
FROM Applications
INNER JOIN Jobs ON Applications.JobID = Jobs.JobID
INNER JOIN Companies ON Jobs.CompanyID = Companies.CompanyID
WHERE Applications.ApplicantID = 101;

--8. Create an SQL query that calculates and displays the average salary offered by all companies for 
--job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero.

SELECT AVG(Salary) AS AverageSalary
FROM Jobs
WHERE Salary > 0;

--9. Write an SQL query to identify the company that has posted the most job listings. Display the 
--company name along with the count of job listings they have posted. Handle ties if multiple 
--companies have the same maximum count.
SELECT TOP 1 Companies.CompanyName, COUNT(*) AS NumJobs
FROM Companies
JOIN Jobs ON Companies.CompanyID = Jobs.CompanyID
GROUP BY Companies.CompanyName
ORDER BY COUNT(*) DESC ;

SELECT CompanyName, c.CompanyID, COUNT(JobID) as NumJobs
FROM Companies c
INNER JOIN Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyID, CompanyName
HAVING COUNT(JobID) = (
    SELECT MAX(tcount)
    FROM (
        SELECT COUNT(JobID) AS tcount
        FROM Companies c
        INNER JOIN Jobs j ON c.CompanyID = j.CompanyID
        GROUP BY c.CompanyID, CompanyName
    ) a
);

--10. Find the applicants who have applied for positions in companies located in 'CityX' and have at 
--least 3 years of experience
SELECT DISTINCT Applicants.FirstName, Applicants.LastName
FROM Applicants
JOIN Applications ON Applicants.ApplicantID = Applications.ApplicantID
JOIN Jobs ON Applications.JobID = Jobs.JobID
JOIN Companies ON Jobs.CompanyID = Companies.CompanyID
WHERE Companies.Location = 'CityX'
AND Applicants.Resume LIKE '%[2-9] years%';

--11. Retrieve a list of distinct job titles with salaries between $60,000 and $80,000.SELECT DISTINCT JobTitle
FROM Jobs
WHERE Salary BETWEEN 60000 AND 80000;

--12. Find the jobs that have not received any applications.

SELECT *
FROM Jobs
WHERE JobID NOT IN (SELECT DISTINCT JobID FROM Applications);

--13. Retrieve a list of job applicants along with the companies they have applied to and the positions 
--they have applied for.

SELECT FirstName, LastName, CompanyName
FROM Applicants a
INNER JOIN Applications ap ON a.ApplicantID = ap.ApplicantID
INNER JOIN Jobs j ON j.JobID = ap.JobID
INNER JOIN Companies c ON j.CompanyID = c.CompanyID
GROUP BY FirstName, LastName, a.ApplicantID, ap.JobID, j.CompanyID, CompanyName;


--14. Retrieve a list of companies along with the count of jobs they have posted, even if they have not 
--received any applications.

SELECT CompanyName, COUNT(JobID) AS Count
FROM Companies c
LEFT JOIN Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyID, CompanyName;


--15. List all applicants along with the companies and positions they have applied for, including those 
--who have not applied.

SELECT FirstName, LastName, CompanyName, JobTitle
FROM Applicants a
LEFT JOIN Applications ap ON ap.ApplicantID = a.ApplicantID
LEFT JOIN Jobs j ON j.JobID = ap.JobID
LEFT JOIN Companies c ON c.CompanyID = j.CompanyID
GROUP BY FirstName, LastName, a.ApplicantID, CompanyName, JobTitle;


--16. Find companies that have posted jobs with a salary higher than the average salary of all jobs.SELECT DISTINCT CompanyName
FROM Companies c
INNER JOIN Jobs j ON c.CompanyID = j.CompanyID
WHERE Salary > (SELECT AVG(Salary) FROM Jobs);

--17. Display a list of applicants with their names and a concatenated string of their city and state.

SELECT FirstName, LastName, CONCAT(City, ', ', State) AS CityState
FROM Applicants;

--18. Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'.

SELECT *
FROM Jobs
WHERE JobTitle LIKE '%Developer%' OR JobTitle LIKE '%Engineer%';


--19. Retrieve a list of applicants and the jobs they have applied for, including those who have not 
--applied and jobs without applicants.

SELECT FirstName, LastName, JobTitle
FROM Applicants a
LEFT JOIN Applications ap ON ap.ApplicantID = a.ApplicantID
FULL JOIN Jobs j ON j.JobID = ap.JobID;


--20. List all combinations of applicants and companies where the company is in a specific city and the 
--applicant has more than 2 years of experience. For example: city=Chennai
SELECT c.CompanyName,
CONCAT(a.FirstName, ' ', a.LastName) AS ApplicantName
FROM  Companies c
JOIN Jobs j ON j.CompanyID = c.CompanyID
JOIN Applications app ON j.JobID = app.JobID
JOIN Applicants a ON app.ApplicantID = a.ApplicantID
WHERE 
c.Location = 'austin'
AND a.Resume LIKE '%[2-9] years%';
