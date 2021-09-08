terraform init

terraform plan

terraform apply -auto-approve

if [ $? -ne 0 ]
then
    terraform apply -auto-approve
    if [ $? -ne 0 ]
    then
        exit 1
    fi
fi

function ProgressBar {  
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    printf "\r[${_fill// /#}${_empty// /-}] ${_progress}%%"
}

function LaunchProgressBar {
    _start=0
    _end=60
    printf 'Waiting for 1 minute for VM provisioning to complete \n'
    for number in $(seq ${_start} ${_end})
    do
        sleep 1
        ProgressBar ${number} ${_end}
    done
    printf '\n\n'
}

LaunchProgressBar