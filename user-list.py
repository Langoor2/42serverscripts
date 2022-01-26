#!/usr/bin/python3

# Dit script wordt uitgevoerd na het user-files.py bestand
# Het neemt alle .txt files uit de folder en maakt er een
# .csv van die gebruikt kan worden voor het AD-systeem

import os.path
import csv

new_user = []

with open('user.txt') as userfile:
    for lines in userfile:
        user = lines.strip()
        if(os.path.exists(user + '.txt')):
            with open(user + '.txt') as singleuser:
                for line in singleuser:
                    if line.startswith('sn:'):
                        last_name = line.split('sn: ')[1].strip()
                        print(last_name)
                    if line.startswith('givenName:'):
                        first_name = line.split('givenName: ')[1].strip()

                    # Wanneer hij member is van moodle-manager, is hij/zij docent
                    if line.startswith('memberOf: CN=moodle-managers'):
                        role = 'docent'
                        new_user.append([first_name.strip(), last_name.strip(), role.strip()])
                        continue
                    # Wanneer object member is van student...
                    if line.startswith('memberOf: CN=Students'):
                        role = 'student'
                        new_user.append([first_name.strip(), last_name.strip(), role.strip()])
                        continue
                  
                    
# Voor elke lijn in de new_user file, schrijven we dit weg naar de CSV
# vb. Naam, Achternaam, docent
with open('bulk_user.csv', 'w', newline='') as outputfile:
    writer = csv.writer(outputfile)
    
    for x in new_user:
        writer.writerow(x)
