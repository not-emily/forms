#!/bin/bash                    

echo "-----------------------------------------------------"
echo " Building Container "   
echo "-----------------------------------------------------"
docker compose build


echo "-----------------------------------------------------"
echo " Set up APP database "   
echo "-----------------------------------------------------"
docker compose run web rake db:drop
docker compose run web rake db:create
docker compose run web rake db:migrate
docker compose run web rake db:seed


echo -e "

+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo " Setup completed "
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"

