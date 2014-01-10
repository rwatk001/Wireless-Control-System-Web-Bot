require 'rubygems'
require 'mechanize'
#require 'open-uri'

agent = Mechanize.new

############################
## Login Script
############################
page = agent.get('WWW.SOMEWEBSITE.COM')
form = page.forms.first
form['username'] = 'USERNAME'
form['password'] = 'PASSWORD'
page = agent.submit(form, form.buttons.first)

############################
## AP Up/Down Ratio
############################
# Follow Maps link
mapsPage = agent.page.link_with(:text => 'Maps').click

#-----------------
#- Get total APs
totalAPs = mapsPage.search('tr.list_odd:nth-child(7)>td:nth-child(4)').text
totalAPs = totalAPs.delete "\t\n"
puts totalAPs

#-----------------
#- Get total Critical Alarms
totalCAs = mapsPage.search('tr.list_odd:nth-child(7)>td:nth-child(7)').text
totalCAs = totalCAs.delete "\t\n"
puts totalCAs

#-----------------
#- Get total Clients
totalUser = mapsPage.search('tr.list_odd:nth-child(7)>td:nth-child(8)').text
totalUser = totalUser.delete "\t\n"
puts totalUser

#-----------------
#- Get total AP up/down ratio
UpDown = 100 - totalCAs.to_f / totalAPs.to_f
puts UpDown

############################
## Find Down APs
############################
noMoreBuildings = false
buildName = Array.new
critAlarms = Array.new
buildID = 8                 #- Variable that tracks the depth (the table has 51 rows)

#-----------------
#- Using two while loops because the table is split into odd/even
#- sections. First pass scans even and the second scans odd
while buildID < 50 do
  #- Get the column cell for area type (looking for type 'Building')
  isBuilding = mapsPage.search("tr.list_even:nth-child(#{buildID})>td:nth-child(3)").text
  isBuilding = isBuilding.delete "\t\n"
  #- Check that we found a Building type
  #- and if so we check the 'Alarm Status' column cell
  if isBuilding.to_s == "Building"
     isCrit = mapsPage.search("tr.list_even:nth-child(#{buildID}) > td:nth-child(7)").text
     isCrit = isCrit.delete "\t\n"
    #- If the 'Alarm Status' show 'Critical' then we record the 
    #- number of 'Critical AP's and the 'Building Name'    
    if isCrit.to_i > 0 
      critAlarms << isCrit.to_i
      bname = mapsPage.search("tr.list_even:nth-child(#{buildID}) > td:nth-child(2)").text
      bname = bname.delete "\t\n"
      buildName << bname       
    end 
  elsif isBuilding.to_s == "Floor Area"
    puts "end of buildings"
  end
  buildID += 1
end
#- Follows same procedure as above on odd section of table
buildID = 9                 #- Reset depth
while buildID < 50 do
  isBuilding = mapsPage.search("tr.list_odd:nth-child(#{buildID})>td:nth-child(3)").text
  isBuilding = isBuilding.delete "\t\n"

  if isBuilding.to_s == "Building"
     isCrit = mapsPage.search("tr.list_odd:nth-child(#{buildID}) > td:nth-child(7)").text
     isCrit = isCrit.delete "\t\n"

     if isCrit.to_i > 0 
       critAlarms << isCrit.to_i
       bname = mapsPage.search("tr.list_odd:nth-child(#{buildID}) > td:nth-child(2)").text
       bname = bname.delete "\t\n"
       buildName << bname
     end
  elsif isBuilding.to_s == "Floor Area"
    puts "end of buildings"
  end
  buildID += 1
end
#mapsPage = agent.page.link_with(:text => "\n        2").click

pp critAlarms
pp buildName
#mapsPage.links.each do |link|
#  pp link.text
#end

