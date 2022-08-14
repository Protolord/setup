if [[ ! $(which python3) ]]; then
  echo "No python3 was found on this machine, setup cancelled"
  exit 1
fi

python3 -m pip install --user ansible
