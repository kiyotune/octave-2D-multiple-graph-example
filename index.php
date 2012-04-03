<?php

system('./graph.m ./osaka2011.csv');
list($w, $h) = getimagesize('./osaka2011.png');
$w = round($w * 0.8);
$h = round($h * 0.8);
?>

<img src='./osaka2011.png' alt='2011年大阪' width=<?php echo $w; ?> height=<?php echo $h; ?>>
