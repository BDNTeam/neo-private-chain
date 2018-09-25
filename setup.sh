#!/usr/bin/env bash

# setting
node_ip_arr=("45.77.21.34" "45.77.131.223" "45.77.16.50" "139.180.194.93")

# ==============

neo_dir="/home/neo"

info () {
  echo -ne "\e[36m$1\e[0m"
}

err () {
  echo -ne "\e[91m$1\e[0m"
}

succeed () {
  echo -ne "\e[92m$1\e[0m"
}

ensure_base_cmd () {
  local base_cmd=("vim" "wget" "unzip" "expect" "uuidgen" "screen")
  local base_cmd_pkg=("vim" "wget" "unzip" "expect" "uuid-runtime" "screen")
  for i in ${!base_cmd[@]}; do
    local cmd=${base_cmd[$i]}
    if ! [ -x "$(command -v $cmd)" ]; then
      err "Error: ${cmd} is not installed. Trying to install...\n" >&2
      apt-get update
      apt-get install -y ${base_cmd_pkg[$i]}
    fi
  done
}

install () {

  info "Install NEO and it's deps? y|N: "
  read -n 1 c

  if [ "$c" != "y" ]; then
    err "\nuser abort.\n"
    return 0
  fi

  # install dotnet
  wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
  dpkg -i packages-microsoft-prod.deb
  apt-get install -y apt-transport-https
  apt-get update
  apt-get install -y aspnetcore-runtime-2.1

  mkdir -p $neo_dir

  local zip="/tmp/$(uuidgen)"
  wget -O $zip https://github.com/neo-project/neo-cli/releases/download/v2.9.0/neo-cli-linux-x64.zip

  local tmp="/tmp/$(uuidgen)"
  mkdir $tmp
  unzip -qq -o $zip -d $tmp
  cp -rf $tmp/neo-cli/* $neo_dir

  # install neo deps
  apt-get -y install libleveldb-dev sqlite3 libsqlite3-dev libunwind8-dev
}

find_node_idx () {
  local cur_ip=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')

  info "Resolved IP: ${cur_ip}, continue? y|N: "
  read -n 1 c

  if [ "$c" != "y" ]; then
    err "\nuser abort.\n"
    exit 0
  fi

  local idx=-1
  for i in ${!node_ip_arr[@]}; do
    local ip=${node_ip_arr[$i]}
    if [ "$ip" == "$cur_ip" ]; then
      idx=$i
      break
    fi
  done

  return $idx
}

prepare_cfg () {

  wallet1_addr="Ac74Lt2Q3bi8787kF4ajq9t7iEHYypNikj"
  wallet1_pubkey="02a176fd862e14b7751d1c83f68d4dfb9b828a61dd3cf00f56b4da3131cb58e6ae"
  wallet1_data=$(cat <<EOF
  {"name":null,"version":"1.0","scrypt":{"n":16384,"r":8,"p":8},"accounts":[{"address":"Ac74Lt2Q3bi8787kF4ajq9t7iEHYypNikj","label":null,"isDefault":false,"lock":false,"key":"6PYSxbuTTkeFgSRDViAW62tQ4YQ6bxD2wCGumzzYSkiJ7M7TqM84Lp3ykP","contract":{"script":"2102a176fd862e14b7751d1c83f68d4dfb9b828a61dd3cf00f56b4da3131cb58e6aeac","parameters":[{"name":"signature","type":"Signature"}],"deployed":false},"extra":null}],"extra":null}
EOF
  )

  wallet2_addr="Aa6TguZEmBhpDhWtXuwjEi4GBoghH2V7s1"
  wallet2_pubkey="02384a735afc365cfe01176fc36f6afb87d4164b91958f06fe7b8c0914cd154720"
  wallet2_data=$(cat <<EOF
  {"name":null,"version":"1.0","scrypt":{"n":16384,"r":8,"p":8},"accounts":[{"address":"Aa6TguZEmBhpDhWtXuwjEi4GBoghH2V7s1","label":null,"isDefault":false,"lock":false,"key":"6PYQALa9RJtnF89THKjy7r8rPG9Tu5Tj7umQcQXbgTBwmcULz2Qo8xKdQw","contract":{"script":"2102384a735afc365cfe01176fc36f6afb87d4164b91958f06fe7b8c0914cd154720ac","parameters":[{"name":"signature","type":"Signature"}],"deployed":false},"extra":null}],"extra":null}
EOF
  )

  wallet3_addr="AGmgX5YM8cCkwh7HDMv4N5mHgUVXpPYwdB"
  wallet3_pubkey="023fb7fb6db18f21c006f738b4d0daed18c5b7426a37a660ef6f7e83fc4f8adba7"
  wallet3_data=$(cat <<EOF
  {"name":null,"version":"1.0","scrypt":{"n":16384,"r":8,"p":8},"accounts":[{"address":"AGmgX5YM8cCkwh7HDMv4N5mHgUVXpPYwdB","label":null,"isDefault":false,"lock":false,"key":"6PYNsQsB28dtonzX4hQpGVqDRAqjbyWacF9ARoKUYpvqWbfnBeJRe4hhCX","contract":{"script":"21023fb7fb6db18f21c006f738b4d0daed18c5b7426a37a660ef6f7e83fc4f8adba7ac","parameters":[{"name":"signature","type":"Signature"}],"deployed":false},"extra":null}],"extra":null}
EOF
  )

  wallet4_addr="AKGziXJQdvqjbvmNG2uE4fSyXTm8m42n4d"
  wallet4_pubkey="03890dfefc41a980c9fe1c271203f30a0d4af2a909c317da9556048c00e3886ad7"
  wallet4_data=$(cat <<EOF
  {"name":null,"version":"1.0","scrypt":{"n":16384,"r":8,"p":8},"accounts":[{"address":"AKGziXJQdvqjbvmNG2uE4fSyXTm8m42n4d","label":null,"isDefault":false,"lock":false,"key":"6PYLN3rf8Y5DruQGqZ6bKwUaLjZcAK4TCR8691H1eaQ6xAkvRftKHUEQrC","contract":{"script":"2103890dfefc41a980c9fe1c271203f30a0d4af2a909c317da9556048c00e3886ad7ac","parameters":[{"name":"signature","type":"Signature"}],"deployed":false},"extra":null}],"extra":null}
EOF
  )

  pub_keys=("$wallet1_pubkey" "$wallet2_pubkey" "$wallet3_pubkey" "$wallet4_pubkey")
  wallet_data_arr=("$wallet1_data" "$wallet2_data" "$wallet3_data" "$wallet4_data")

  # generate protocol.json
  protocol_json=$(cat <<EOF
  {
    "ProtocolConfiguration": {
      "Magic": 123456,
      "AddressVersion": 23,
      "SecondsPerBlock": 15,
      "StandbyValidators": [
        "${pub_keys[0]}",
        "${pub_keys[1]}",
        "${pub_keys[2]}",
        "${pub_keys[3]}"
      ],
      "SeedList": [
        "${node_ip_arr[0]}:10333",
        "${node_ip_arr[1]}:10333",
        "${node_ip_arr[2]}:10333",
        "${node_ip_arr[3]}:10333"
      ],
      "SystemFee": {
        "EnrollmentTransaction": 10,
        "IssueTransaction": 5,
        "PublishTransaction": 5,
        "RegisterTransaction": 100
      }
    }
  }
EOF
  )

  echo "$protocol_json" > "$neo_dir/protocol.json"
  wallet_data=${wallet_data_arr[$node_idx]}
  echo "$wallet_data" > "$neo_dir/wallet.json"

  node_cfg=$(cat <<EOF
  {
    "ApplicationConfiguration": {
      "Paths": {
        "Chain": "Chain_{0}",
        "Index": "Index_{0}"
      },
      "P2P": {
        "Port": 10333,
        "WsPort": 10334
      },
      "RPC": {
        "Port": 10332,
        "SslCert": "",
        "SslCertPassword": ""
      },
      "UnlockWallet": {
        "Path": "$neo_dir/wallet.json",
        "Password": "123456",
        "StartConsensus": true,
        "IsActive": true
      }
    }
  }
EOF
  )

  echo "$node_cfg" > "$neo_dir/config.json"
}


ensure_base_cmd

find_node_idx
node_idx=$?

echo "Node idx: $node_idx"
if [ $node_idx -eq -1 ]; then
  err "Unable to assoc node idx"
  exit 1
fi

install

prepare_cfg

succeed "Done\n"