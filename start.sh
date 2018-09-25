#!/usr/bin/env bash

neo_dir="/home/neo"

screen -dmS neo bash -c "dotnet $neo_dir/neo-cli.dll --rpc"