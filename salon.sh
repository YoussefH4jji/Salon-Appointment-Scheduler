#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU(){
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
  CUSTOMER_EXISTS=$($PSQL "SELECT customer_id, name FROM customers WHERE phone='$CUSTOMER_PHONE' ")
  if [[ -z $CUSTOMER_EXISTS ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    ADD_CUST=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    CUST_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' AND phone='$CUSTOMER_PHONE'")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    SCHEDULE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUST_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

LIST_SERVICES(){
if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME 
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  SERVICE_AVAILABILITY=$($PSQL "SELECT service_id, name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_AVAILABILITY ]]
  then
    LIST_SERVICES "I could not find that service. What would you like today?"  
  else
    MAIN_MENU
  fi
}


LIST_SERVICES
