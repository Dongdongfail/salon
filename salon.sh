#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
SERVICES_OFFERED=$($PSQL "select service_id,name from services")


  echo -e "\n~~~~~ MY SALON ~~~~~\n"
  echo -e "\nWelcome to My Salon, how can I help you?\n"
  MAIN_MENU(){
  echo "$SERVICES_OFFERED" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  SERVICE_ID_AVAILABLE=$($PSQL "select * from services where service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_ID_AVAILABLE ]]
  then 
    MAIN_MENU "I could not find that service. What would you like today?"
  else 
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
      
    fi
    SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    INSERT_APPOINTMENTS_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}
MAIN_MENU 