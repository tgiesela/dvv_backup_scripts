say() {
   MESSAGE="$1"
   TIMESTAMP=$(date +"%F %T")
   echo "$TIMESTAMP $MESSAGE"
   logger -t $0 "$MESSAGE" 
   pause
}

pause() {
   if [ -n "$debug" ]; then
       echo "Press Enter to execute this step..";
       read input;
   fi
}


ask() {
  PROMPT=$1
  DEFAULT=$2

  echo ""
  echo -n "$PROMPT [$DEFAULT] "
  read response

  if [ -z $response ]; then
    response=$DEFAULT
  fi
}

askstring() {
  PROMPT=$1
  DEFAULT=$2
  OPTIONS=$3

  while [ 1 ]; do

     ask "$PROMPT" "$DEFAULT"

     # conversie naar lowercase characters...
     if [ "${OPTIONS}" = "-lc" ]; then
         response=$(perl -e "print lc(\"$response\");")
     fi    
     if [ -z $response ]; then
       :
     else
       break
     fi
  done
}

askYN() {
  PROMPT=$1
  DEFAULT=$2

  if [ "x$DEFAULT" = "xyes" -o "x$DEFAULT" = "xYes" -o "x$DEFAULT" = "xy" -o "x$DEFAULT" = "xY" ]; then
    DEFAULT="Y"
  else
    DEFAULT="N"
  fi

  while [ 1 ]; do
    ask "$PROMPT" "$DEFAULT"

    #conversie naar lowercase characters
    response=$(perl -e "print lc(\"$response\");")
    if [ -z $response ]; then
      :
    else
      if [ $response = "yes" -o $response = "y" ]; then
        response="yes"
        break
      :
      else
        if [ $response = "no" -o $response = "n" ]; then
          response="no"
          break
        fi
      fi
    fi
    echo "A Yes/No answer is required"
  done
}

#askYN "Wil je doorgaan?" "No"
#askstring "Geef de naam van de SMTP-SERVER op: " "smtp.chello.nl"
