#!/bin/bash

food=$1

echo "My favorite food is $food!"
echo 'But my favorite variable is $food'

if [[ "$food" == "pizza" || "$food" == "pie" ]]; then
	echo "$food has delicious crust!"
fi
