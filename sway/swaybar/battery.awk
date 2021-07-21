BEGIN {FS=","; OFS=","; green="#00ff00"; red="#ff0000"; yellow="#ffff00"}

{
    if ($1 == "Battery 0: Charging") {
        status = $2" ";
        color = green;
    }
    else {
        if (int($2) <= 10) {
            status = $2" ";
            color = red;
        }

        else if (10 < int($2) && int($2) <= 25) {
            status = $2" ";
            color  = yellow;
        }

        else if (25 < int($2) && int($2) <= 75) {
            status = $2" ";
            color = green;
        }

        else if (75 < int($2) && int($2) <= 99) {
            status = $2" ";
            color = green;
        }
        
        else {
            status = $2" ";
            color = green;
        }
    }
}

END {print status, color}
