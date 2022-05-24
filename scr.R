library(RSelenium)

####run this in docker via powershell
### make sure that the destination folder is set here "~/Downloads/Selenium-Downloads/"; create a folder with this name in this path.
#docker run -d -v ~/Downloads/Selenium-Downloads/://home/seluser/Downloads -p 4445:4444 -p 5901:5900 selenium/standalone-firefox:2.53.0


# Firefox profile
fprof <- makeFirefoxProfile(list(browser.download.dir='/home/seluser/Downloads',
                                 browser.download.folderList=2L,
                                 browser.download.manager.showWhenStarting=FALSE,
                                 browser.helperApps.neverAsk.saveToDisk='text/csv;application/vnd.ms-excel;application/zip' 

                                 
                                 # This says if a CSV/XLS/XLSX/ZIP is encountered, then download file automatically into default download folder
                                 # See MIME Types here: https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
))

# Remote driver
remDr <- remoteDriver(browserName='firefox', 
                      port=4445L, 
                      extraCapabilities=fprof,
                      remoteServerAddr='localhost'
)

# URL
ssm_url <- 'https://www.calpassplus.org/LaunchBoard/Student-Success-Metrics.aspx'

remDr$open()

# Visit URL
remDr$navigate(ssm_url)

# Get title of page
remDr$getTitle()
## [1] "Cal-PASS Plus - Student-Success-Metrics"

# Get a screenshot of the current page, to confirm we are on the right page
remDr$screenshot(display=TRUE) # Running this should open up an image of the page in a browser

# Locate and click the "All Students" journey button
all_students_button_elem <- remDr$findElement(using='xpath', '//*[(@id = "journeyBox5")]')
all_students_button_elem$clickElement()

# Pause
Sys.sleep(5)

# Locate college radio button and click
college_button_elem <- remDr$findElement(using='xpath', '//*[(@id = "collegeFilterBtn")]')
college_button_elem$clickElement()

# Select View to refresh: defaults to All Students, Allan Hancock
view_button_elem <- remDr$findElement(using='xpath', '//*[(@id = "view")]')
view_button_elem$clickElement()

# Pause
Sys.sleep(5)

# Inspect
# remDr$screenshot(display=TRUE) # Running this should open up an image of the page in a browser

# Identify Export button
export_button_elem <- remDr$findElement(using='xpath', '//*[(@id = "export")]')
# export_button_elem$clickElement()

# Identify Journey Type
journey_dropdown_elem <- remDr$findElement(using='xpath', '//*[(@id = "select2-pgmDD-container")]')
# journey_dropdown_elem$clickElement()

# Identify College Dropdown
college_dropdown_elem <- remDr$findElement(using='xpath', '//*[(@id = "select2-schoolDD-container")]')
# college_dropdown_elem$clickElement()

# Obtain values in dropdown menus
# Grab ID's from previous: pgmDD (Journey Type) and schoolDD (College Dropdown)
journey_select_elem <- remDr$findElement(using='xpath', '//select[@id="pgmDD"]')
college_select_elem <- remDr$findElement(using='xpath', '//select[@id="schoolDD"]')

opts_journey <- journey_select_elem$selectTag()
opts_college <- college_select_elem$selectTag()

#test to make sure this works
# opts_journey$text
# opts_journey$value
# opts_college$text
# opts_college$value


for (i in seq_along(opts_college$text)) { ## use this for full run
#for (i in 1:2) { 
  ## use this to test first two colleges
  # for (i in 21:121) { 
  ## if process breaks in the middle, start with remDr$open() above, and re-run; 
  ## in this line, start with the college number that errored out to continue download
  cat('i: ', i, ', College: ', opts_college$text[i], '\n')
  # Select college
  opts_college$elements[[i]]$clickElement()
  Sys.sleep(1)
  for (j in seq_along(opts_journey$text)) {
    cat('j: ', j, ', Journey: ', opts_journey$text[j], '\n')
    # Select journey
    opts_journey$elements[[j]]$clickElement()
    Sys.sleep(1)
    
    # Click View button
    view_button_elem$clickElement()
    Sys.sleep(6)
    
    # Click Export button
    export_button_elem$clickElement()
    Sys.sleep(10)
  }
}