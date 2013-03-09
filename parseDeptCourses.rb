#Run at command line with -rubygems parameter (make sure you have rubygems)
require 'open-uri'
require 'json'     #install with rubygems
require 'nokogiri' #install with rubygems

#Array of courses:
    #[n]
        #[0] dept
        #[1] name
        #[2] number
        #[3] descr
        #[4] prereqs
        #[5] prereq full
def parseCourses(toParse)
    @doc = Nokogiri::HTML(toParse)
    dept = @doc.at_css("table table font font")
    courses = @doc.css("table table table")
    numCourses = courses.length
    courseInfo=Array.new(numCourses) {Array.new(6)}
    i=0
    while i<numCourses
        courseInfo[i][0] = dept.to_s

        courseInfo[i][1] = courses[i].css("font")[0].to_s #name
        courseInfo[i][2] = courses[i].css("font")[1].to_s #number
        descr_prereqs = courses[i].css("font")[3].to_s #Descr and prereqs still combined, to be split up
        descr_prereqs_split = descr_prereqs.split("Prerequisites")
        courseInfo[i][3] = descr_prereqs_split[0].to_s #descr
        courseInfo[i][4] = descr_prereqs_split[1].to_s #prereqs
        courseInfo[i][5] = descr_prereqs_split[1].to_s #prereqs full, not changed later

        #Get rid of HTML
        courseInfo[i][0] = courseInfo[i][0].gsub!(%r{</?[^>]+?>}, '')
        courseInfo[i][1] = courseInfo[i][1].gsub!(%r{</?[^>]+?>}, '')
        courseInfo[i][2] = courseInfo[i][2].gsub!(%r{</?[^>]+?>}, '')
        courseInfo[i][3] = courseInfo[i][3].gsub!(%r{</?[^>]+?>}, '')
        courseInfo[i][4] = courseInfo[i][4].gsub!(%r{</?[^>]+?>}, '')
        #courseInfo[i][5] = courseInfo[i][5].gsub!(%r{</?[^>]+?>}, '')

        #Get rid of whitespace
        courseInfo[i][0] = courseInfo[i][0].strip!
        courseInfo[i][1] = courseInfo[i][1].strip!
        #courseInfo[i][2] = courseInfo[i][2].strip! Deletes number...
        courseInfo[i][3] = courseInfo[i][3].strip!
        courseInfo[i][4] = courseInfo[i][4].to_s.strip!
        #courseInfo[i][5] = courseInfo[i][5].to_s.strip!

        #Get rid of leading zeroes in course number
        def reformatCourseNum(edited)
            numbers = /\d+/.match(edited)
            letters = /[a-zA-Z]+/.match(edited)
            numbers = numbers.to_s.gsub!(/^#{'0'}+/,'')
            return letters.to_s+numbers.to_s
        end
        courseInfo[i][2] = reformatCourseNum(courseInfo[i][2])

        #Reformat prerequisites
        prerequisites = courseInfo[i][4].to_s
        prerequisites = prerequisites.to_s.gsub(/\(.*\)/,"")
        prerequisites = prerequisites.to_s.gsub(/(P|p)ermission of instructor/,"")
        prerequisites = prerequisites.to_s.gsub(/\./,"")
        ignored_words = ["and","or"]
        prerequisitesPieces = prerequisites.to_s.scan(/[^ 0-9]+\s*\d+/)

        #Identifying tags and putting them where they need to be
        k=0
        #puts prerequisitesPieces
        recenttag = ""
        while k < prerequisitesPieces.length
            numbers = /\d+/.match(prerequisitesPieces[k])
            letters = /[a-zA-Z]+/.match(prerequisitesPieces[k]).to_s
            #puts letters.to_s+numbers.to_s
         

            if letters=="and" || letters=="or" || letters.length==0
              letters = recenttag.to_s
            	#puts "1"+letters
            else
            	recenttag = letters.to_s
            	#puts "2" + recenttag
            end

        	prerequisitesPieces[k] = letters.to_s + numbers.to_s
        
        	k+=1

        end
        courseInfo[i][4] = prerequisitesPieces
        #puts prerequisitesPieces
        #puts ""
        i+=1
    end
    return courseInfo
end

#url = "courses.html"
#url_html = open(url)
#puts parseCourses(url_html)
