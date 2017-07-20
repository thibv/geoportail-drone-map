#! /bin/bash

# TODO : Add a function to convert lat/lon to geoportail row/col
row_start=11620
row_stop=11623
col_start=16795
col_stop=16800

# TODO : Add a parameter to define the folder
DATA_DIR="data/"

let col=col_start
let row=row_start

# Check if data folder exists
if [ ! -d "$DATA_DIR" ]; then
	mkdir "$DATA_DIR"
fi


# TODO : Check key
#link="https://wxs.ign.fr/an7nvfzojv5wa96dsga5nk8w/geoportail/wmts?layer=GEOGRAPHICALGRIDSYSTEMS.MAPS.SCAN25TOUR&style=normal&tilematrixset=PM&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image/jpeg&TileMatrix=16&TileCol=33621&TileRow=23318"

link_cst="https://wxs.ign.fr/an7nvfzojv5wa96dsga5nk8w/geoportail/wmts?layer=GEOGRAPHICALGRIDSYSTEMS.MAPS.SCAN25TOUR&style=normal&tilematrixset=PM&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image/jpeg&TileMatrix=15&"

merge_row=""
merge_col=""

while [  $col -lt $col_stop ]; do
	# TODO : Use a parameter to define whether print info or not
	echo Colonne $(($col-$col_start+1))"/"$(($col_stop-$col_start))
	while [ $row -lt $row_stop ]; do
		echo Ligne $(($row-$row_start+1))"/"$(($row_stop-$row_start))
		name=$DATA_DIR"img_"$col"_"$row".jpg"
		link=$link_cst"TileCol="$col"&TileRow="$row
		wget -q -O $name $link
		#echo $name
		merge_row=$merge_row" "$name
		let row=row+1
	done

	name_col=$DATA_DIR$col".jpg"
	convert -append $merge_row $name_col
	merge_row=""
	merge_col=$merge_col" "$name_col
	let col=col+1
	let row=row_start
done

convert +append $merge_col output_layer.jpg






let col=col_start
let row=row_start


link_cst="https://wxs.ign.fr/an7nvfzojv5wa96dsga5nk8w/geoportail/wmts?layer=TRANSPORTS.DRONES.RESTRICTIONS&style=normal&tilematrixset=PM&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image/png&TileMatrix=15&"

merge_row=""
merge_col=""

while [  $col -lt $col_stop ]; do
	echo Colonne $(($col-$col_start+1))"/"$(($col_stop-$col_start))
	while [ $row -lt $row_stop ]; do
		echo Ligne $(($row-$row_start+1))"/"$(($row_stop-$row_start))
		name=$DATA_DIR"img_"$col"_"$row".jpg"
		link=$link_cst"TileCol="$col"&TileRow="$row
		wget -q -O $name $link
		#echo $name
		merge_row=$merge_row" "$name
		let row=row+1
	done

	name_col=$DATA_DIR$col".jpg"
	convert -append $merge_row $name_col
	merge_row=""
	merge_col=$merge_col" "$name_col
	let col=col+1
	let row=row_start
done

convert +append $merge_col output_drone.jpg

rm -r $DATA_DIR

# TODO : Add a line to merge images, with transparency on drone layer
