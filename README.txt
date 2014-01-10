University of California - Riverside
Computing and Communications Services

Wireless Status Web Bot
authored by: Ryan Watkins

Written in Ruby and using the Mechanize Library

OVERVIEW
------------------------------
--The web bot logs in to the Wireless Control System website with the given credencials
(USERNAME & PASSWORD)

--Then navigates to the page best for scraping information

--It stores data on the number of up vs down Wireless Access Points (AP), current clients
	and the buildings in which an AP is non operational

The intention is to then have this data accessable to UCR's Wireless Status Webpage.
The Webpage will display the data gathered from the web bot to UCR residents.

RUN INFO
-----------------------------
The web bot is written in Ruby using the Mechanize lib. which is currently not supported
on Windows 7 x64.
I wrote and compiled in Linux Ubuntu.

*********
For security reasons I ommited the website address, username and password
*********