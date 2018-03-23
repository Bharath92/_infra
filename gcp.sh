#!/bin/bash -e
export ACTION="$1"
export BOOTSTRAP_ADMIRAL="bootstrap_admiral.sh"

bootstrap_startup_script() {
  echo "============= Bootstrapping startup script ==============="

  sed -i 's/{{ACCESS_KEY}}/"'$ACCESS_KEY'"/g' $BOOTSTRAP_ADMIRAL
  local escaped_secret_key=$(echo $SECRET_KEY | sed -e 's/[\/&]/\\&/g')
  sed -i 's/{{SECRET_KEY}}/"'$escaped_secret_key'"/g' $BOOTSTRAP_ADMIRAL
  sed -i 's/{{PASSWORD}}/"'$PASSWORD'"/g' $BOOTSTRAP_ADMIRAL

  echo "=========================================================="
}

create_instance() {
  echo "============= Creating instance ==============="
  gcloud config get-value project
  gcloud compute instances create $instance_name --image-project $image_project --image-family $image_family --boot-disk-size $boot_disk_size --tags=$tags --zone=$zone --metadata-from-file startup-script=$BOOTSTRAP_ADMIRAL
  echo "==============================================="
}

main() {
  if [ -z "$ACTION" ]; then
    echo "ACTION needs to be specified"
    exit 1
  elif [ "$ACTION" == "create" ]; then
    bootstrap_startup_script
    create_instance
  fi
}

main
