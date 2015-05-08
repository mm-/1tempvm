#### Easily create DO droplets for testing

1tempvm(){
    key_id=''
    time_alive='2'
    client_id=''
    api_key=''
    ssh_host=''
    droplet_name=`openssl rand -base64 24 | md5 | cut -c 1-10`

    # Check if we supplied a custom time_alive value

    if [ -n "$1" ]
    then
	time_alive="$1"
    else
	echo "Custom time_alive not specified, using default ( $time_alive hours )"
    fi



    # Create droplet
    tugboat create $droplet_name -k $key_id
    tugboat wait $droplet_name --state active
    # Wait to make sure it's definitely up and running
    echo "Waiting 30 seconds for new droplet to settle"
    sleep 30

    droplet_id=`tugboat info $droplet_name | grep "^ID:" | grep -o "\ .*[0-9]$" | sed s/\ //g`


    # Display current
    echo ""
    echo "Current droplets:"
    echo ""
    tugboat droplets


    # Schedule destroy droplet
    ssh $ssh_host "echo "curl -s "'\"'https://api.digitalocean.com/v1/droplets/$droplet_id/destroy/?client_id=$client_id\&api_key=$api_key'\"'"" | at now + $time_alive hours"


    echo ""
    echo "== Droplet scheduled for deletion in $time_alive hours =="

    echo ""
    echo ""
    echo "Logging into droplet now ===>"

    tugboat ssh $droplet_name

    #DEBUG
    #echo "DEBUG"
    #echo "Droplet scheduled to be destroyed in $time_alive minutes"
    #echo "Waiting/checking to be sure"
    #sleep 80
    #tugboat droplets
    #sleep 30
    #tugboat droplets
    #sleep 30
    #tugboat droplets

    }
