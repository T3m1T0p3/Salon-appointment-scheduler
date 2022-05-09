#!/bin/bash
echo " ~~~~~ MY SALON ~~~~~ "
PSQL="psql --no-align --dbname=salon --username=freecodecamp --tuples-only -q -c"
SERVICES=$($PSQL "SELECT name FROM services")

showServices(){
  array=("$1")
  i=1
  for j in $array
  do
    echo "$i)" $j
    i=$(($i+1))
  done
  echo "Enter the service you would like to recieve"
}

showServices "$SERVICES"

read SERVICE_ID_SELECTED

while [[ $SERVICE_ID_SELECTED < 1 || $SERVICE_ID_SELECTED > 5 ]]
do
  echo "Not avalable. Please enter any one of the following:"
  showServices "$SERVICES"
  read SERVICE_ID_SELECTED
done

echo "What's your phone number?"

read CUSTOMER_PHONE
PHONE_QUERY=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
echo "$PHONE_QUERY"
if [[ -z $PHONE_QUERY ]]
then
    echo "No record found. Enter your name"
    read CUSTOMER_NAME
    $PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')"
    echo "Customer's service time?"
    read SERVICE_TIME;
    CUS_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUS_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    service=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
    echo "I have put you down for a $service at $SERVICE_TIME, $CUSTOMER_NAME."
else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  service=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  SERVICE_TIME=$($PSQL "SELECT time FROM appointments WHERE appointment_id='$SERVICE_ID_SELECTED'")
  echo "I have put you down for a $service at $SERVICE_TIME, $CUSTOMER_NAME."
fi