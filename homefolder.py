import os
import subprocess
import csv

# Dit script leest alle folders uit de huidige directory
# Op basis van de naam die voor @ijselu.local staat
# wordt de naam omgezet naar het formaat dat we gebruiken
# binnen Windows AD

result = subprocess.run(['ls'], stdout=subprocess.PIPE).stdout.decode('utf-8').split('\n')
all_dirs = [x for x in result if x.endswith('.local')]

for person in all_dirs:

    # Split op voornaam en potentiele 'tussennaam'
    first_name = person.split('@ijselu.local')[0][:-1:1].capitalize()
    last_name = person.split('@ijselu.local')[0][-1].capitalize()
    potential_sur = person.split('@ijselu.local')[0][:-2].capitalize()

    # Open bulk_users.csv, de file die meegegeven wordt
    # na user_list.py. Deze check de namen en potentiele
    # tussennamen en vind associatie met de bulk_user file

    with open('bulk_user.csv', 'r') as userfile:
        reader = csv.reader(userfile)
        
        for entry in reader:          
            if first_name == entry[0]:

                # Hernoem directory op basis van alleen voornaam
                print(f'User found... renaming directory to: {entry[0].lower()}.{entry[1].lower()}')
                os.system(f'sudo mv {person} {entry[0].lower()}.{entry[1].lower()}')
                
                #if entry[1].startswith(potential_sur) and entry[1].endswith(last_name):
                #    last_name = str(entry[1].replace(' ','.'))
                #    print(f'User found... renaming directory to: {entry[0].lower()}{last_name}')

            # Hernoem directory op basis van voornaam + tussennaam
            if potential_sur == entry[0]:
                new_last_name = entry[1].lower().replace(' ','.')
                print(f'User found... renaming directory to: {entry[0].lower()}.{new_last_name}')
                os.system(f'sudo mv {person} {entry[0].lower()}.{new_last_name}')
                

            
        

new_result = subprocess.run(['ls'], stdout=subprocess.PIPE).stdout.decode('utf-8').split('\n')
new_all_dirs = [x for x in new_result if x.endswith('.local')]


# Print gebruikers waarvan het niet gelukt is om de homefolder om te zetten

not_added = [x for x in new_all_dirs if x in all_dirs]
print(f'Users not added:{not_added}')

#adri@ijselu.local
#samsonw@ijselu.local
#Voornaam + Eerste Tussennaam + Eerste Achternaam