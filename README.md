# My Notes

--==GIT COMMIT FORMAT==--
<type>[optional scope]: <description>

<type>
feat: (new feature for the user)
fix: (bug fix for the user, if bug was reported by customer include bug# in [optional scope])
docs: (changes to the documentation)
style: (formatting, missing semi colons, etc; no production code change)
refactor: (refactoring production code, eg. renaming a variable)
test: (adding missing tests, refactoring tests; no production code change)
chore: (updating grunt tasks etc; no production code change)
other: (other)

[optional scope]
BREACKING CHANGE: (warn user of changes to code that break previous features)

--==Common Shell Commands==--
C:\> robocopy "[Source Directory]" "[Destination Directory]" /e /w:5 /r:2 /COPY:DATSOU /DCOPY:DAT /MT
/e - Copy all folders including empty ones
/r - Retry times /r:0 means no retry on failed copy
/w - Wait time /w:0 means no wait between retry on failed copy
/COPYALL OR /COPY:DATSOU - Copy Data, Attributes, Timestamps, Security, Owner, and Auditing Info for files
/DCOPY:DAT - Copy Data,Attributes and Timestamps for Directories (Other Options are E=EAs-Extended Attributes, X=Skip alt data streams, but are almost never used)
/MT:n - Multithread transfer with n threads. Example /MT:4 - Use 4 threads to copy files. If no threads set, it will default to 8.
/MIR - Mirror Source to Destination - WARNING: WILL DELETE ANY FILES THAT DO NOT MATCH IN DESTINATION!
/MOVE - Moves from Source to Destination - WARNING: WILL DELETE ALL FILES FROM SOURCE AFTER COPY!
/LFSM:100M - Operate in Low Free Space Mode with 100 Megabytes. 10M = 10 Megabytes 1G = 1 Gigabyte
/RH:1700-0900 - Scheduled run between 5PM and 9AM and will pause if it is during “business hours of 9AM-5PM”
/LOG+:C:\robocopy.log - Outputs everything to C:\robocopy.log (Note: if NOT running as admin you need to put this in your user folder C:\Users\username\robocopy.log) the + adds to the file.
/TEE - If using LOG and you also want console output, put the /TEE option in.
