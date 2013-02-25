Hackathon2013
=============

Tufts University Hackathon 2013
Riley Wood and Alex Daniels

parseDeptCourses.rb's parseCourses function processes HTML retrieved from the Tufts University Course Lookup form located at https://webcenter.studentservices.tufts.edu/coursedesc/course_desc_by_dept.aspx
courses.html is a local save of the Africa in the New World Dept's courses which can be passed into parseDeptCourses.rb's
parseCourses function to return an array of the information presented in the page.

The script makes use of the Nokogiri HTML parsing library for Ruby, and
regular expressions (lots and lots) to parse the page's English sentences into an array.

The script was created during the Tufts University 2013 Hackathon for use with RaptorScheme, our main project for the event (http://sethdrew.com/alex).
RaptorScheme (whose name is inspired by http://raptorattack.com/) is a site used to organize Tufts courses visually to show which classes are prerequisites for other classes and
help students plan out their majors and course distribution. This script is run to scrape the department semi-regularly
and parse the information into an array which is later made into a JSON format. This is used on the webpage to
dynamically render courses. In essence, our script keeps the cached set of courses up to date.
