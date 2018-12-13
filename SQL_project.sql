/* This file contains the solutions to the Springboard SQL mini project. This
project uses data from Springboard's online SQL platform. The data is called
"country_club". */

/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

/* code */
SELECT *
FROM  `Facilities`
WHERE membercost > 0

/* solution */
/* Tennis Court 1, Tennis Court 2, Massage Room 1, Massage Room 2, Squash Court */

/* Q2: How many facilities do not charge a fee to members? */

/* code */
SELECT *
FROM  `Facilities`
WHERE membercost = 0.0

/* solution */
/* Badminton Court, Table Tennis, Snooker Table, Pool Table. */

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

/* code */
SELECT facid,
       name,
       membercost,
       monthlymaintenance
FROM  `Facilities`
WHERE membercost < monthlymaintenance * 0.20

/* solution */
/* all rows */

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

/* code */
SELECT *
FROM  `Facilities`
WHERE facid IN('1', '5')

/* solution */
/* display of rows 1 and 5. */

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

/* code */
SELECT name,
       monthlymaintenance,
       CASE WHEN monthlymaintenance > 100 THEN "expensive"
       ELSE "cheap" END AS cost_category
FROM  `Facilities`

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

/* code */
SELECT surname,
       firstname
FROM  `Members`
WHERE joindate = (SELECT MAX(joindate) FROM Members)

/* solution */
/* Smith, Darren */

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. *

/* code */

SELECT full.name,
       CONCAT(members.firstname, ' ' , members.surname) AS name_of_member
FROM (SELECT bookings.facid,
             bookings.memid,
             facilities.name
        FROM `Bookings` bookings
   LEFT JOIN `Facilities` facilities
          ON bookings.facid = facilities.facid
       WHERE bookings.facid IN (0, 1)) full
LEFT JOIN `Members` members
       ON full.memid = members.memid
 GROUP BY name, name_of_member
 ORDER BY name_of_member


 /* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
 will cost the member (or guest) more than $30? Remember that guests have
 different costs to members (the listed costs are per half-hour 'slot'), and
 the guest user's ID is always 0. Include in your output the name of the
 facility, the name of the member formatted as a single column, and the cost.
 Order by descending cost, and do not use any subqueries. */

 /* code */

SELECT name,
        CONCAT(members.firstname, ' ' , members.surname) AS name_of_member,
        CASE WHEN members.memid > 0 THEN facilities.membercost * slots
        ELSE facilities.guestcost * slots END AS cost
    FROM `Facilities` facilities
LEFT JOIN `Bookings` bookings
      ON facilities.facid = bookings.facid
LEFT JOIN `Members` members
      ON bookings.memid = members.memid
  WHERE starttime BETWEEN '2012-09-14' and '2012-09-15'
ORDER BY cost DESC

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

/* code */

SELECT name,
        CONCAT(members.firstname, ' ' , members.surname) AS name_of_member,
        CASE WHEN members.memid > 0 THEN merged.membercost * slots
        ELSE merged.guestcost * slots END AS cost
    FROM (SELECT facilities.name,
                 bookings.memid,
                 facilities.membercost,
                 facilities.guestcost,
                 bookings.slots
            FROM `Facilities` facilities
       LEFT JOIN `Bookings` bookings
              ON facilities.facid = bookings.facid
            WHERE bookings.starttime BETWEEN '2012-09-14' and '2012-09-15') merged
  LEFT JOIN `Members` members
        ON members.memid = merged.memid
    ORDER BY cost DESC



/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* code */

SELECT name,
       revenue
  FROM (SELECT facilities.name,
               SUM(CASE WHEN bookings.memid > 0 THEN facilities.membercost * slots
               ELSE facilities.guestcost * slots END) AS revenue
          FROM `Facilities` facilities
     LEFT JOIN `Bookings` bookings
            ON facilities.facid = bookings.facid
      GROUP BY bookings.facid ) merged
  WHERE merged.revenue < 1000
  ORDER BY revenue 
